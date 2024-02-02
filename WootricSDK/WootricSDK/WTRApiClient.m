//
//  WTRApiClient.m
//  WootricSDK
//
// Copyright (c) 2018 Wootric (https://wootric.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "WTRApiClient.h"
#import "WTRUtils.h"
#import "WTRLogger.h"
#import <CommonCrypto/CommonHMAC.h>

static NSString *const WTRSamplingRule = @"Wootric Sampling Rule";
static NSString *const WTRCustomEventName = @"custom_event_name";
static NSString *const WTRRegisterEventsEndpoint = @"/registered_events.json";
static NSString *const WTREligibleEndpoint = @"/eligible.json";
static NSString *const WTRResponsesEndpoint = @"responses";
static NSString *const WTRDeclinesEndpoint = @"declines";
static NSString *const WTREndUsersEndpoint = @"end_users";
static NSString *const WTRSurveyServerURL = @"eligibility.wootric.";
static NSString *const WTRBaseAPIURL = @"app.wootric.";
static NSString *const WTRAPIVersion = @"/api/v1";

static NSString *const WTRAccountTokenKey = @"account_token";
static NSString *const WTRClientIdKey = @"client_id";
static NSString *const WTREmailKey = @"email";
static NSString *const WTRExternalIdKey = @"external_id";
static NSString *const WTRPhoneNumberKey = @"phone_number";
static NSString *const WTRCreatedAtKey = @"external_created_at";
static NSString *const WTRSurveyImmediatelyKey = @"survey_immediately";
static NSString *const WTRPropertiesKey = @"properties";
static NSString *const WTRProductNameKey = @"product_name";
static NSString *const WTRAudienceTextKey = @"audience_text";
static NSString *const WTRRegisteredPercentKey = @"registered_percent";
static NSString *const WTRVisitorPercentKey = @"visitor_percent";
static NSString *const WTRResurveyThrottleKey = @"resurvey_throttle";
static NSString *const WTRDailyResponseCapKey = @"daily_response_cap";
static NSString *const WTREndUserCreatedAtKey = @"end_user_created_at";
static NSString *const WTRLanguageKey = @"language";
static NSString *const WTRLanguageCodeKey = @"code";
static NSString *const WTRFirstSurveyDelayKey = @"first_survey_delay";
static NSString *const WTREventNameKey = @"event_name";

static NSString *const WTROSNameKey = @"os_name";
static NSString *const WTRSDKVersionKey = @"sdk_version";
static NSString *const WTROSVersionKey = @"os_version";

@interface WTRApiClient ()

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSURLSession *wootricSession;
@property (nonatomic) NSInteger userID;
@property (nonatomic, strong) NSNumber *accountID;
@property (nonatomic, strong) NSString *uniqueLink;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, assign) BOOL endUserAlreadyUpdated;
@property (nonatomic, strong) NSString *eligibilitySamplingRule;
@property (nonatomic) int priority;

@end

@implementation WTRApiClient

+ (instancetype)sharedInstance {
  static WTRApiClient *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}

- (instancetype)init {
  if (self = [super init]) {
    _wootricSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _settings = [[WTRSettings alloc] init];
    _priority = 0;
    _osVersion = [self osVersion];
    _sdkVersion = [self sdkVersion];
  }
  return self;
}

- (void)resetVars {
  _priority = 0;
  _endUserAlreadyUpdated = NO;
  _eligibilitySamplingRule = nil;
  _uniqueLink = nil;
}

- (void)endUserDeclined {
  if (!self.userID) {
    [self getEndUserWithEmail:^(NSInteger endUserID) {
      self.userID = endUserID;
      [self createResponseForEndUser:self.userID withScore:-1 text:nil picklistAnswers:nil endpoint:WTRDeclinesEndpoint];
    }];
  } else {
    [self createResponseForEndUser:self.userID withScore:-1 text:nil picklistAnswers:nil endpoint:WTRDeclinesEndpoint];
  }
}

- (void)endUserVotedWithScore:(NSInteger)score andText:(NSString *)text picklistAnswers:(NSDictionary *)picklistAnswers {
  if (!self.userID) {
    [self getEndUserWithEmail:^(NSInteger endUserID) {
      self.userID = endUserID;
      [self createResponseForEndUser:self.userID withScore:score text:text picklistAnswers:picklistAnswers endpoint:WTRResponsesEndpoint];
    }];
  } else {
    [self createResponseForEndUser:self.userID withScore:score text:text picklistAnswers:picklistAnswers endpoint:WTRResponsesEndpoint];
  }
}

- (void)getEndUserWithEmail:(void (^)(NSInteger endUserID))endUserWithID {
  NSMutableURLRequest *urlRequest = [self requestWithHost:[self baseApiUrl] path:[NSString stringWithFormat:@"%@/%@", WTRAPIVersion, WTREndUsersEndpoint] HTTPMethod:nil queryItems:@[[self addEmailToURL]]];
  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      [WTRLogger logError:@"(GET end user): %@", error];
    } else {
      id responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      if ([responseJSON isKindOfClass:[NSArray class]]) {
        if ([responseJSON count] == 0) {
          [self createEndUser:^(NSInteger endUserID) {
            self.userID = (long)endUserID;
            endUserWithID(self.userID);
          }];
        } else {
          NSDictionary *endUser = responseJSON[0];
          
          if (endUser[@"id"]) {
            self.userID = [endUser[@"id"] integerValue];
            if (!self.endUserAlreadyUpdated) {
              [self updateExistingEndUser:self.userID];
            }
            endUserWithID(self.userID);
          }
        }
      } else {
        [WTRLogger logError:@"%@", responseJSON];
      }
    }
  }];
    
  [dataTask resume];
}

- (void)updateExistingEndUser:(NSInteger)endUserID {
  NSMutableArray *queryItems = [NSMutableArray new];
  [queryItems addObject:[self addEmailToURL]];

  if ([WTRUtils isValidString:_settings.productName]) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"properties[product_name]" value:_settings.productName]];
  }
  
  if ([WTRUtils isValidString:_settings.externalId]) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:WTRExternalIdKey value:_settings.externalId]];
  }
  
  if ([WTRUtils isValidString:_settings.phoneNumber]) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:WTRPhoneNumberKey value:_settings.phoneNumber]];
  }
  
  if ([WTRUtils isValidString:self.eligibilitySamplingRule]) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRPropertiesKey, WTRSamplingRule] value:self.eligibilitySamplingRule]];
  }
  
  if ([WTRUtils isValidString:_settings.eventName]) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRPropertiesKey, WTRCustomEventName] value:_settings.eventName]];
  }

  if (_settings.customProperties) {
    [queryItems addObjectsFromArray:[self addPropertiesToURL]];
  }

  if (queryItems.count > 1) {
    NSMutableURLRequest *urlRequest = [self requestWithHost:[self baseApiUrl] path:[NSString stringWithFormat:@"%@/%@/%ld", WTRAPIVersion, WTREndUsersEndpoint, (long)endUserID] HTTPMethod:@"PUT" queryItems:queryItems];

    NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error || data == nil) {
        [WTRLogger logError:@"(update end user): %@, %@", error, data];
        return;
      }

      id responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
      if (httpResponse.statusCode == 200) {
        [WTRLogger log:@"(update end user): user updated"];
        self->_endUserAlreadyUpdated = YES;
      } else {
        [WTRLogger logError:@"(update end user): %@", responseJSON];
      }
    }];
    
    [dataTask resume];
  }
}

- (void)createEndUser:(void (^)(NSInteger endUserID))endUserWithID {
  NSMutableArray *items = [NSMutableArray new];
  [items addObject:[NSURLQueryItem queryItemWithName:WTREmailKey value:[_settings getEndUserEmailOrUnknown]]];
    
  if ([WTRUtils isValidNumber:_settings.externalCreatedAt]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRCreatedAtKey value:[NSString stringWithFormat:@"%ld", (long)[_settings.externalCreatedAt integerValue]]]];
  }
  
  if ([WTRUtils isValidString:_settings.externalId]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRExternalIdKey value:_settings.externalId]];
  }
  
  if ([WTRUtils isValidString:_settings.phoneNumber]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRPhoneNumberKey value:_settings.phoneNumber]];
  }
    
  if ([WTRUtils isValidString:_settings.productName]) {
    [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRPropertiesKey, WTRProductNameKey] value:_settings.productName]];
  }
  
  if ([WTRUtils isValidString:self.eligibilitySamplingRule]) {
    [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRPropertiesKey, WTRSamplingRule] value:self.eligibilitySamplingRule]];
  }
  
  if ([WTRUtils isValidString:_settings.eventName]) {
    [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRPropertiesKey, WTRCustomEventName] value:_settings.eventName]];
  }
    
  if (_settings.customProperties) {
    for (NSString *key in _settings.customProperties) {
      [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRPropertiesKey, key] value:[_settings.customProperties objectForKey:key]]];
    }
  }
    
  NSMutableURLRequest *urlRequest = [self requestWithHost:[self baseApiUrl] path:[NSString stringWithFormat:@"%@/%@", WTRAPIVersion, WTREndUsersEndpoint] HTTPMethod:@"POST" queryItems:items];
  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      [WTRLogger logError:@"(create end user): %@", error];
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      [WTRLogger log:@"(create end user): %@", responseJSON];
      if (responseJSON) {
        NSInteger endUserID = [responseJSON[@"id"] integerValue];
        endUserWithID(endUserID);
      }
    }
  }];
    
  [dataTask resume];
}

- (void)createResponseForEndUser:(NSInteger)endUserID withScore:(NSInteger)score text:(NSString *)text picklistAnswers:(NSDictionary *)picklistAnswers endpoint:(NSString *)endpoint {
  NSArray *params = [self paramsWithScore:score endUserID:endUserID accountID:_accountID uniqueLink:_uniqueLink priority:_priority text:text picklistAnswers:picklistAnswers];
  
  NSMutableURLRequest *urlRequest = [self requestWithHost:[self baseApiUrl] path:[NSString stringWithFormat:@"%@/%@/%ld/%@", WTRAPIVersion, WTREndUsersEndpoint, (long)endUserID, endpoint] HTTPMethod:@"POST" queryItems:params];
  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      [WTRLogger logError:@"ResponseError: %@", error];
    } else {
      if ([endpoint containsString:@"response"]) {
        [WTRLogger log:@"Response added to queue"];
      } else {
        [WTRLogger log:@"Decline added to queue"];
      }
    }
  }];

  [dataTask resume];
}

- (void)getRegisteredEventList:(void (^)(NSArray *))events {
  NSString *baseURLString = [NSString stringWithFormat:@"https://%@%@?account_token=%@", [self eligibilityUrl], WTRRegisterEventsEndpoint, _accountToken];

  NSURL *url = [NSURL URLWithString:baseURLString];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setValue:@"Wootric-Mobile-SDK" forHTTPHeaderField:@"User-Agent"];

  [WTRLogger log:@"eligibility - %@", urlRequest];

  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      [WTRLogger logError:@"%@", error];
    } else {
      NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      if ([responseJSON isKindOfClass:[NSArray class]]) {
        if (responseJSON) {
          events(responseJSON);
        }
      } else {
        [WTRLogger logError:@"%@", responseJSON];
      }
    }
  }];

  [dataTask resume];
}

- (void)authenticate:(void (^)(BOOL))authenticated {
  NSMutableURLRequest *urlRequest = [self requestWithHost:[self baseApiUrl] path:@"/oauth/token" HTTPMethod:@"POST" queryItems:@[[NSURLQueryItem queryItemWithName:@"grant_type" value:@"client_credentials"], [NSURLQueryItem queryItemWithName:WTRClientIdKey value:_clientID]]];
  [urlRequest setValue:@"Wootric-Mobile-SDK" forHTTPHeaderField:@"User-Agent"];

  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      [WTRLogger logError:@"(authentication): %@", error];
      authenticated(NO);
      return;
    }
    
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [WTRLogger log:@"(authentication): %@", responseJSON];
    if (!responseJSON) {
      authenticated(NO);
      return;
    }
    
    NSString *accessToken = responseJSON[@"access_token"];
    if (!accessToken) {
      authenticated(NO);
      return;
    }
    
    self->_accessToken = accessToken;
    [self getEndUserWithEmail:^(NSInteger endUserID) {
      if (endUserID != 0) {
        self.userID = endUserID;
        authenticated(YES);
      } else {
        [WTRLogger logError:@"Error getting/creating End User"];
        authenticated(NO);
      }
    }];
  }];

  [dataTask resume];
}

- (void)checkEligibility:(void (^)(BOOL))eligible {
  if (self.settings.forceSurvey || [self needsSurvey]) {
    NSURLComponents *components = [NSURLComponents new];
    NSMutableArray *queryItems = [NSMutableArray new];
    components.scheme = @"https";
    components.host = [self eligibilityUrl];
    components.path = WTREligibleEndpoint;

    [queryItems addObject:[NSURLQueryItem queryItemWithName:WTRAccountTokenKey value:_accountToken]];
    [queryItems addObjectsFromArray:[self addVersionsToURL]];
    [queryItems addObject:[self addEmailToURL]];
    [queryItems addObjectsFromArray:[self addSurveyServerCustomSettingsToURL]];
    [queryItems addObjectsFromArray:[self addPropertiesToURL]];
    if ([WTRUtils isValidString:_settings.eventName]) {
      [queryItems addObject:[self addEventNameToURL]];
    }

    components.queryItems = queryItems;
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:components.URL];
    [urlRequest setValue:@"Wootric-Mobile-SDK" forHTTPHeaderField:@"User-Agent"];

    [WTRLogger log:@"eligibility - %@", urlRequest];

    NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        [WTRLogger logError:@"%@", error];
        eligible(NO);
      } else {
        [self resetVars];
        
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        if (responseJSON) {
          if ([responseJSON[@"eligible"] isEqual:@1]) {
            if (self->_settings.forceSurvey) {
              [WTRLogger logError:@"forced survey (remove for production!)"];
            };
            [WTRLogger log:@"User eligible. Code: %@. Description: %@.", responseJSON[@"details"][@"code"], responseJSON[@"details"][@"why"]];

            [self->_settings parseDataFromSurveyServer:responseJSON];
            self->_accountToken = responseJSON[@"settings"][WTRAccountTokenKey];
            self->_clientID = responseJSON[@"settings"][WTRClientIdKey];

            if (self->_accountToken == nil || self->_clientID == nil) {
              [WTRLogger logError:@"Error retreiving token."];
              eligible(NO);
            }

            if (responseJSON[@"settings"][@"end_user_id"] != [NSNull null]) {
              self.userID = [responseJSON[@"settings"][@"end_user_id"] integerValue];
            }
            
            if (responseJSON[@"sampling_rule"][@"name"]) {
              self.eligibilitySamplingRule = responseJSON[@"sampling_rule"][@"name"];
            }
            
            self->_uniqueLink = [self buildUniqueLinkAccountToken:self->_accountToken
                                                     endUserEmail:[self->_settings getEndUserEmailOrUnknown]
                                                             date:[[NSDate date] timeIntervalSince1970]
                                                     randomString:[self randomString]];
            
            if (responseJSON[@"settings"][@"account_id"] != nil) {
              self->_accountID = responseJSON[@"settings"][@"account_id"];
            }
            eligible(YES);
          } else {
            NSString *logString = @"User ineligible";
            if (responseJSON[@"error"]){
              logString = [NSString stringWithFormat:@"%@ - %@", logString, responseJSON[@"error"]];
              [WTRLogger logError:@"%@", logString];
            } else {
              [WTRLogger log:@"%@. Code: %@. Description: %@.", logString, responseJSON[@"details"][@"code"], responseJSON[@"details"][@"why"]];
            }
            eligible(NO);
          }
        }
      }
    }];

    [dataTask resume];
  } else {
    eligible(NO);
  }
}

- (NSMutableURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path HTTPMethod:(NSString *)httpMethod queryItems:(NSArray *)queryItems {
  NSURLComponents *components = [NSURLComponents new];
  components.scheme = @"https";
  components.host = host;
  components.path = path;

  components.queryItems = [queryItems arrayByAddingObjectsFromArray:[self addVersionsToURL]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:components.URL];

  [urlRequest setValue:@"Wootric-Mobile-SDK" forHTTPHeaderField:@"User-Agent"];
  
  if (httpMethod) {
    urlRequest.HTTPMethod = httpMethod;
  }

  if (_accessToken) {
    [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", _accessToken] forHTTPHeaderField:@"Authorization"];
  }

  return urlRequest;
}

- (NSURLQueryItem *)addEmailToURL {
  return [NSURLQueryItem queryItemWithName:WTREmailKey value:[_settings getEndUserEmailOrUnknown]];
}

- (NSArray *)addVersionsToURL {
  NSMutableArray *items = [NSMutableArray new];
  [items addObject:[NSURLQueryItem queryItemWithName:WTROSNameKey value:@"iOS"]];

  if ([WTRUtils isValidString:_sdkVersion]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRSDKVersionKey value:_sdkVersion]];
  }
  
  if ([WTRUtils isValidString:_osVersion]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTROSVersionKey value:_osVersion]];
  }
  
  return items;
}

- (NSArray *)addSurveyServerCustomSettingsToURL {
  NSMutableArray *items = [NSMutableArray new];
  if (_settings.surveyImmediately || _settings.forceSurvey) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRSurveyImmediatelyKey value:@"true"]];
  }

  if ([WTRUtils isValidNumber:_settings.registeredPercentage]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRRegisteredPercentKey value:[_settings.registeredPercentage stringValue]]];
  }

  if ([WTRUtils isValidNumber:_settings.visitorPercentage]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRVisitorPercentKey value:[_settings.visitorPercentage stringValue]]];
  }

  if ([WTRUtils isValidNumber:_settings.resurveyThrottle]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRResurveyThrottleKey value:[_settings.resurveyThrottle stringValue]]];
  }

  if ([WTRUtils isValidNumber:_settings.dailyResponseCap]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRDailyResponseCapKey value:[_settings.dailyResponseCap stringValue]]];
  }

  if ([WTRUtils isValidNumber:_settings.externalCreatedAt]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTREndUserCreatedAtKey value:[_settings.externalCreatedAt stringValue]]];
  }

  if ([WTRUtils isValidString:_settings.languageCode]) {
    [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRLanguageKey, WTRLanguageCodeKey] value:_settings.languageCode]];
  }

  if ([WTRUtils isValidString:_settings.customProductName]) {
    [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRLanguageKey, WTRProductNameKey] value:_settings.customProductName]];
  }

  if ([WTRUtils isValidString:_settings.customAudience]) {
    [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRLanguageKey, WTRAudienceTextKey] value:_settings.customAudience]];
  }

  // this value needs to be higher than 0
  if ([_settings.firstSurveyAfter intValue] > 0) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRFirstSurveyDelayKey value:[_settings.firstSurveyAfter stringValue]]];
  }
  
  if ([WTRUtils isValidString:_settings.externalId]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRExternalIdKey value:_settings.externalId]];
  }
  
  if ([WTRUtils isValidString:_settings.phoneNumber]) {
    [items addObject:[NSURLQueryItem queryItemWithName:WTRPhoneNumberKey value:_settings.phoneNumber]];
  }
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  double lastSeen = [defaults doubleForKey:@"lastSeenAt"];
  [items addObject:[NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:[NSString stringWithFormat:@"%.0f", lastSeen]]];

  return items;
}

- (NSArray *)addPropertiesToURL {
  NSMutableArray *items = [NSMutableArray new];
  if (_settings.customProperties) {
    for (NSString *key in _settings.customProperties) {
      [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]",WTRPropertiesKey, key] value:[NSString stringWithFormat:@"%@", [_settings.customProperties objectForKey:key]]]];
    }
  }
  return items;
}

- (NSURLQueryItem *)addEventNameToURL {
  return [NSURLQueryItem queryItemWithName:WTREventNameKey value:_settings.eventName];
}

- (NSArray *)paramsWithScore:(NSInteger)score endUserID:(long)endUserID accountID:(NSNumber *)accountID uniqueLink:(nonnull NSString *)uniqueLink priority:(int)priority text:(nullable NSString *)text picklistAnswers:(NSDictionary *)picklistAnswers {
  NSMutableArray *items = [NSMutableArray new];
  [items addObject:[NSURLQueryItem queryItemWithName:@"origin_url" value:_settings.originURL]];
  [items addObject:[NSURLQueryItem queryItemWithName:@"end_user[id]" value:[NSString stringWithFormat:@"%ld", endUserID]]];
  [items addObject:[NSURLQueryItem queryItemWithName:@"survey[channel]" value:@"mobile"]];
  [items addObject:[NSURLQueryItem queryItemWithName:@"survey[unique_link]" value:uniqueLink]];
  [items addObject:[NSURLQueryItem queryItemWithName:@"priority" value:[NSString stringWithFormat:@"%i", priority]]];
  [items addObject:[NSURLQueryItem queryItemWithName:@"metric_type" value:[_settings.surveyType lowercaseString]]];
  
  if ([WTRUtils isValidString:_settings.languageCode]) {
    [items addObject:[NSURLQueryItem queryItemWithName:@"survey[language]" value:_settings.languageCode]];
  }
  
  if ([WTRUtils isValidString:_settings.eventName]) {
    [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"%@[%@]", WTRPropertiesKey,WTRCustomEventName] value:_settings.eventName]];
  }
  
  for (NSString *key in picklistAnswers) {
    [items addObject:[NSURLQueryItem queryItemWithName:[NSString stringWithFormat:@"driver_picklist[%@]", key] value:picklistAnswers[key]]];
  }
  
  if (score > -1) {
    [items addObject:[NSURLQueryItem queryItemWithName:@"score" value:[NSString stringWithFormat:@"%ld", score]]];
    
    if (text) {
      [items addObject:[NSURLQueryItem queryItemWithName:@"text" value:text]];
    }
  }

  if (accountID != nil) {
    [items addObject:[NSURLQueryItem queryItemWithName:@"account_id" value:[NSString stringWithFormat:@"%ld", [accountID longValue]]]];
  }
  
  _priority++;
  
  return items;
}

- (NSString *)buildUniqueLinkAccountToken:(NSString *)accountToken endUserEmail:(NSString *)endUserEmail date:(NSTimeInterval)date randomString:(NSString *)randomString {
  const char* str = [[NSString stringWithFormat:@"%@%@%.0f%@", accountToken, endUserEmail, date, randomString] UTF8String];
  unsigned char result[CC_SHA256_DIGEST_LENGTH];
  CC_SHA256(str, (int) strlen(str), result);
  
  NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
  for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
    [hash appendFormat:@"%02x", result[i]];
  }
  return hash;
}

- (NSString *)randomString {
  NSMutableString *text = [NSMutableString string];
  static const NSString *POSSIBLE = @"abcdefghijklmnopqrstuvwxyz0123456789";
  int i = 0;
  while (i < 16) {
    [text appendString:[NSString stringWithFormat:@"%C", [POSSIBLE characterAtIndex:arc4random_uniform((int) POSSIBLE.length)]]];
    i++;
  }
  return text;
}

- (nullable NSString *)sdkVersion {
#ifdef SWIFTPM_MODULE_BUNDLE
  return [NSString stringWithFormat:@"ios-%@", [SWIFTPM_MODULE_BUNDLE objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
#else
  return [NSString stringWithFormat:@"ios-%@", [[NSBundle bundleForClass:[WTRApiClient class]] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
#endif
}

- (NSString *)osVersion {
  return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)baseApiUrl {
  return [NSString stringWithFormat:@"%@%@", WTRBaseAPIURL, [WTRUtils getTokenTLD:_accountToken]];
}

- (NSString *)eligibilityUrl {
  return [NSString stringWithFormat:@"%@%@", WTRSurveyServerURL, [WTRUtils getTokenTLD:_accountToken]];
}

- (BOOL)needsSurvey {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  if ([defaults boolForKey:@"surveyed"] && self.settings.setDefaultAfterSurvey) {
    NSInteger days;
    if ([defaults objectForKey:@"resurvey_days"]) {
      days = [defaults integerForKey:@"resurvey_days"];
    } else if([[defaults objectForKey:@"type"] isEqualToString:@"response"]){
      days = self.settings.surveyedDefaultDuration;
    } else {
      days = self.settings.surveyedDefaultDurationDecline;
    }
    [WTRLogger log:@"needsSurvey(NO) - Already surveyed in last %li days", (long)days];
    return NO;
  } else if (self.settings.surveyImmediately) {
    [WTRLogger log:@"needsSurvey(YES) - surveyImmediately"];
    return YES;
  } else if (self.settings.externalCreatedAt == nil) {
    [WTRLogger log:@"needsSurvey(YES) - no externalCreatedAt"];
    return YES;
  } else {
    if ([self.settings.firstSurveyAfter intValue] > 0) {
      NSInteger age = [[NSDate date] timeIntervalSince1970] - [self.settings.externalCreatedAt intValue];
      if (age > ([self.settings.firstSurveyAfter intValue] * 60 * 60 * 24)) {
        [WTRLogger log:@"needsSurvey(YES) - end user's account older than firstSurveyAfter value"];
        return YES;
      } else {
        if (([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"lastSeenAt"]) >= ([self.settings.firstSurveyAfter intValue] * 60 * 60 * 24)) {
          [WTRLogger log:@"needsSurvey(YES) - end user's lastSeenAt greater than or equal firstSurveyAfter value"];
          return YES;
        }
      }
    } else {
      [WTRLogger log:@"needsSurvey(YES) - firstSurveyAfter is set to less than or equal 0 in SDK (will be compared to admin panel value)"];
      return YES;
    }
  }
  [WTRLogger log:@"needsSurvey(NO) - No check passed"];
  return NO;
}

#pragma Getters

- (NSString *)getUniqueLink {
  if (!self.uniqueLink) {
    self.uniqueLink = [self buildUniqueLinkAccountToken:self.accountToken
                                           endUserEmail:[self.settings getEndUserEmailOrUnknown]
                                                   date:[[NSDate date] timeIntervalSince1970]
                                           randomString:[self randomString]];
  }
  return self.uniqueLink;
}

- (NSString *)getEndUserId {
  return [NSString stringWithFormat: @"%ld", (long)self.userID];
}

- (NSString *)getToken {
  return self.accessToken;
}

@end

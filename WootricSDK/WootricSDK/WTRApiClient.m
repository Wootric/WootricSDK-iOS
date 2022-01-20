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
#import "WTRPropertiesParser.h"
#import "WTRUtils.h"
#import "WTRLogger.h"
#import <CommonCrypto/CommonHMAC.h>

static NSString *const WTRSamplingRule = @"Wootric Sampling Rule";
static NSString *const WTRCustomEventName = @"custom_event_name";
static NSString *const WTRRegisterEventsEndpoint = @"/registered_events.json";
static NSString *const WTREligibleEndpoint = @"/eligible.json";
static NSString *const WTRSurveyServerURL = @"https://survey.wootric.com";
static NSString *const WTRBaseAPIURL = @"https://api.wootric.com";
static NSString *const WTRSurveyEUServerURL = @"https://eligibility.wootric.eu";
static NSString *const WTRBaseEUAPIURL = @"https://app.wootric.eu";
static NSString *const WTRAPIVersion = @"api/v1";

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
      [self createResponseForEndUser:self.userID withScore:-1 text:nil endpoint:@"declines"];
    }];
  } else {
    [self createResponseForEndUser:self.userID withScore:-1 text:nil endpoint:@"declines"];
  }
}

- (void)endUserVotedWithScore:(NSInteger)score andText:(NSString *)text {
  if (!self.userID) {
    [self getEndUserWithEmail:^(NSInteger endUserID) {
      self.userID = endUserID;
      [self createResponseForEndUser:self.userID withScore:score text:text endpoint:@"responses"];
    }];
  } else {
    [self createResponseForEndUser:self.userID withScore:score text:text endpoint:@"responses"];
  }
}

- (void)getEndUserWithEmail:(void (^)(NSInteger endUserID))endUserWithID {
  NSString *escapedEmail = [WTRUtils percentEscapeString:[_settings getEndUserEmailOrUnknown]];
  
  escapedEmail = [self addVersionsToURLString:escapedEmail];
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users?email=%@", [self baseApiUrl], WTRAPIVersion, escapedEmail]];
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:nil andHTTPBody:nil];
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
  BOOL needsUpdate = NO;
  NSString *escapedEmail = [WTRUtils percentEscapeString:[_settings getEndUserEmailOrUnknown]];
  NSString *params = [NSString stringWithFormat:@"email=%@", escapedEmail];

  if (_settings.productName) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&properties[product_name]=%@", params, [WTRUtils percentEscapeString:_settings.productName]];
  }
  
  if (_settings.externalId) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&external_id=%@", params, _settings.externalId];
  }
  
  if (_settings.phoneNumber) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&phone_number=%@", params, _settings.phoneNumber];
  }
  
  if (self.eligibilitySamplingRule) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&properties[%@]=%@", params, [WTRUtils percentEscapeString:WTRSamplingRule], [WTRUtils percentEscapeString:self.eligibilitySamplingRule]];
  }
  
  if (_settings.eventName) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&properties[%@]=%@", params, [WTRUtils percentEscapeString:WTRCustomEventName], [WTRUtils percentEscapeString:_settings.eventName]];
  }

  if (_settings.customProperties) {
    needsUpdate = YES;
    NSString *parsedProperties = [WTRPropertiesParser parseToStringFromDictionary:_settings.customProperties];
    params = [NSString stringWithFormat:@"%@%@", params, parsedProperties];
  }

  params = [self addVersionsToURLString:params];

  if (needsUpdate) {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld?%@", [self baseApiUrl], WTRAPIVersion, (long)endUserID, params]];
    NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"PUT" andHTTPBody:nil];

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
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users", [self baseApiUrl], WTRAPIVersion]];
  NSString *escapedEmail = [WTRUtils percentEscapeString:[_settings getEndUserEmailOrUnknown]];
  NSString *params = [NSString stringWithFormat:@"email=%@", escapedEmail];
    
  if (_settings.externalCreatedAt) {
    params = [NSString stringWithFormat:@"%@&external_created_at=%ld", params, (long)[_settings.externalCreatedAt integerValue]];
  }
  
  if (_settings.externalId) {
    params = [NSString stringWithFormat:@"%@&external_id=%@", params, _settings.externalId];
  }
  
  if (_settings.phoneNumber) {
    params = [NSString stringWithFormat:@"%@&phone_number=%@", params, _settings.phoneNumber];
  }
    
  if (_settings.productName) {
    params = [NSString stringWithFormat:@"%@&properties[product_name]=%@", params, _settings.productName];
  }
  
  if (self.eligibilitySamplingRule) {
    params = [NSString stringWithFormat:@"%@&properties[%@]=%@", params, [WTRUtils percentEscapeString:WTRSamplingRule], [WTRUtils percentEscapeString:self.eligibilitySamplingRule]];
  }
  
  if (_settings.eventName) {
    params = [NSString stringWithFormat:@"%@&properties[%@]=%@", params, [WTRUtils percentEscapeString:WTRCustomEventName], [WTRUtils percentEscapeString:_settings.eventName]];
  }
    
  if (_settings.customProperties) {
    NSString *parsedProperties = [WTRPropertiesParser parseToStringFromDictionary:_settings.customProperties];
    params = [NSString stringWithFormat:@"%@%@", params, parsedProperties];
  }
    
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"POST" andHTTPBody:params];

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

- (void)createResponseForEndUser:(NSInteger)endUserID withScore:(NSInteger)score text:(NSString *)text endpoint:(NSString *)endpoint {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld/%@", [self baseApiUrl], WTRAPIVersion, (long)endUserID, endpoint]];
  NSString *params = [self paramsWithScore:score endUserID:endUserID accountID:_accountID uniqueLink:_uniqueLink priority:_priority text:text];
  
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"POST" andHTTPBody:params];
  
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
  NSString *baseURLString = [NSString stringWithFormat:@"%@%@?account_token=%@", [self eligibilityUrl], WTRRegisterEventsEndpoint, _accountToken];

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
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/token", [self baseApiUrl]]];
  NSString *params = [NSString stringWithFormat:@"grant_type=client_credentials&client_id=%@", _clientID];
  params = [self addVersionsToURLString:params];

  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"POST" andHTTPBody:params];
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
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@?account_token=%@", [self eligibilityUrl], WTREligibleEndpoint, _accountToken];
    
    baseURLString = [self addVersionsToURLString:baseURLString];
    baseURLString = [self addEmailToURLString:baseURLString];
    baseURLString = [self addSurveyServerCustomSettingsToURLString:baseURLString];
    baseURLString = [self addPropertiesToURLString:baseURLString];
    baseURLString = [self addEventNameToURLString:baseURLString];

    NSURL *url = [NSURL URLWithString:baseURLString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
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
            self->_accountToken = responseJSON[@"settings"][@"account_token"];
            self->_clientID = responseJSON[@"settings"][@"client_id"];

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

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod andHTTPBody:(NSString *)httpBody {
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setValue:@"Wootric-Mobile-SDK" forHTTPHeaderField:@"User-Agent"];
  
  if (httpBody) {
    httpBody = [self addVersionsToURLString:httpBody];
    urlRequest.HTTPBody = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
  }

  if (httpMethod) {
    urlRequest.HTTPMethod = httpMethod;
  }

  if (_accessToken) {
    [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", _accessToken] forHTTPHeaderField:@"Authorization"];
  }

  return urlRequest;
}

- (NSString *)addEmailToURLString:(NSString *)baseURLString {
  NSString *endUserEmail = [_settings getEndUserEmailOrUnknown];

  if (![endUserEmail isEqual: @"Unknown"]) {
    baseURLString = [NSString stringWithFormat:@"%@&email=%@", baseURLString, [WTRUtils percentEscapeString:endUserEmail]];
  }

  return baseURLString;
}

- (NSString *)addVersionsToURLString:(NSString *)baseURLString {
  
  baseURLString = [NSString stringWithFormat:@"%@&os_name=iOS", baseURLString];
  
  if (_sdkVersion != nil) {
    baseURLString = [NSString stringWithFormat:@"%@&sdk_version=%@", baseURLString, _sdkVersion];
  }
  
  if (_osVersion != nil) {
    baseURLString = [NSString stringWithFormat:@"%@&os_version=%@", baseURLString, _osVersion];
  }
  
  return baseURLString;
}

- (NSString *)addSurveyServerCustomSettingsToURLString:(NSString *)baseURLString {
  if (_settings.surveyImmediately || _settings.forceSurvey) {
    baseURLString = [NSString stringWithFormat:@"%@&survey_immediately=%d",
                     baseURLString, YES];
  }

  if (_settings.registeredPercentage) {
    baseURLString = [NSString stringWithFormat:@"%@&registered_percent=%d",
                     baseURLString, [_settings.registeredPercentage intValue]];
  }

  if (_settings.visitorPercentage) {
    baseURLString = [NSString stringWithFormat:@"%@&visitor_percent=%d",
                     baseURLString, [_settings.visitorPercentage intValue]];
  }

  if (_settings.resurveyThrottle) {
    baseURLString = [NSString stringWithFormat:@"%@&resurvey_throttle=%d",
                     baseURLString, [_settings.resurveyThrottle intValue]];
  }

  if (_settings.dailyResponseCap) {
    baseURLString = [NSString stringWithFormat:@"%@&daily_response_cap=%d",
                     baseURLString, [_settings.dailyResponseCap intValue]];
  }

  if (_settings.externalCreatedAt) {
    baseURLString = [NSString stringWithFormat:@"%@&end_user_created_at=%ld",
                     baseURLString, (long)[_settings.externalCreatedAt integerValue]];
  }

  if (_settings.languageCode) {
    baseURLString = [NSString stringWithFormat:@"%@&language[code]=%@",
                     baseURLString, _settings.languageCode];
  }

  if (_settings.customProductName) {
    baseURLString = [NSString stringWithFormat:@"%@&language[product_name]=%@",
                     baseURLString, [WTRUtils percentEscapeString:_settings.customProductName]];
  }

  if (_settings.customAudience) {
    baseURLString = [NSString stringWithFormat:@"%@&language[audience_text]=%@",
                     baseURLString, [WTRUtils percentEscapeString:_settings.customAudience]];
  }

  if ([_settings.firstSurveyAfter intValue] > 0) {
    baseURLString = [NSString stringWithFormat:@"%@&first_survey_delay=%d",
                     baseURLString, [_settings.firstSurveyAfter intValue]];
  }
  
  if (_settings.externalId) {
    baseURLString = [NSString stringWithFormat:@"%@&external_id=%@",
                     baseURLString, _settings.externalId];
  }
  
  if (_settings.phoneNumber) {
    baseURLString = [NSString stringWithFormat:@"%@&phone_number=%@",
                     baseURLString, _settings.phoneNumber];
  }
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  double lastSeen = [defaults doubleForKey:@"lastSeenAt"];
  baseURLString = [NSString stringWithFormat:@"%@&end_user_last_seen=%.0f", baseURLString, lastSeen];

  return baseURLString;
}

- (NSString *)addPropertiesToURLString:(NSString *)baseURLString {
  if (_settings.customProperties) {
    NSString *parsedProperties = [WTRPropertiesParser parseToStringFromDictionary:_settings.customProperties];
    baseURLString = [NSString stringWithFormat:@"%@%@", baseURLString, parsedProperties];
    ;
  }
  return baseURLString;
}

- (NSString *)addEventNameToURLString:(NSString *)baseURLString {
  if (_settings.eventName) {
    baseURLString = [NSString stringWithFormat:@"%@&event_name=%@", baseURLString, [WTRUtils percentEscapeString:_settings.eventName]];
    ;
  }
  return baseURLString;
}

- (NSString *)paramsWithScore:(NSInteger)score endUserID:(long)endUserID accountID:(NSNumber *)accountID uniqueLink:(nonnull NSString *)uniqueLink priority:(int)priority text:(nullable NSString *)text {
  NSString *params = [NSString stringWithFormat:@"origin_url=%@&end_user[id]=%ld&survey[channel]=mobile&survey[unique_link]=%@&priority=%i&metric_type=%@", _settings.originURL, endUserID, uniqueLink, priority, [_settings.surveyType lowercaseString]];
  
  if (score > -1) {
    params = [NSString stringWithFormat:@"%@&score=%ld", params, (long) score];
    
    if (text) {
      NSString *escapedText = [WTRUtils percentEscapeString:text];
      params = [NSString stringWithFormat:@"%@&text=%@", params, escapedText];
    }
  }

  if (accountID != nil) {
    params = [NSString stringWithFormat:@"%@&account_id=%ld", params, [accountID longValue]];
  }
  
  _priority++;
  
  return params;
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
  return [NSString stringWithFormat:@"ios-%@", [SWIFTPM_MODULE_BUNDLE objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (NSString *)osVersion {
  return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)baseApiUrl {
  return [WTRUtils startsWithEU:_accountToken] ? WTRBaseEUAPIURL : WTRBaseAPIURL;
}

- (NSString *)eligibilityUrl {
  return [WTRUtils startsWithEU:_accountToken] ? WTRSurveyEUServerURL : WTRSurveyServerURL;
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
  } else if (!self.settings.externalCreatedAt) {
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

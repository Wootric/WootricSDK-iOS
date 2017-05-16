//
//  WTRApiClient.m
//  WootricSDK
//
// Copyright (c) 2015 Wootric (https://wootric.com)
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
#import <CommonCrypto/CommonHMAC.h>

@interface WTRApiClient ()

@property (nonatomic, strong) NSString *baseAPIURL;
@property (nonatomic, strong) NSString *surveyServerURL;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSURLSession *wootricSession;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *accountID;
@property (nonatomic, strong) NSString *uniqueLink;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, assign) BOOL endUserAlreadyUpdated;
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
    _baseAPIURL = @"https://api.wootric.com";
    _surveyServerURL = @"https://survey.wootric.com/eligible.json";
    _wootricSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _settings = [[WTRSettings alloc] init];
    _apiVersion = @"api/v1";
    _priority = 0;
    _osVersion = [self osVersion];
    _sdkVersion = [self sdkVersion];
  }
  return self;
}

- (BOOL)checkConfiguration {
  if ([_clientID length] != 0 &&
      [_clientSecret length] != 0 &&
      [_accountToken length] != 0) {
    return YES;
  }
  return NO;
}

- (void)endUserDeclined {
  [self getEndUserWithEmail:^(NSInteger endUserID) {
    [self createResponseForEndUser:endUserID withScore:-1 text:nil endpoint:@"declines"];
  }];
}

- (void)endUserVotedWithScore:(NSInteger)score andText:(NSString *)text {
  [self getEndUserWithEmail:^(NSInteger endUserID) {
    [self createResponseForEndUser:endUserID withScore:score text:text endpoint:@"responses"];
  }];
}

- (void)getEndUserWithEmail:(void (^)(NSInteger endUserID))endUserWithID {
  NSString *escapedEmail = [self percentEscapeString:[_settings getEndUserEmailOrUnknown]];
  
  escapedEmail = [self addVersionsToURLString:escapedEmail];
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users?email=%@", _baseAPIURL, _apiVersion, escapedEmail]];
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:nil andHTTPBody:nil];
  
  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"WootricSDK (GET end user): %@", error);
    } else {
      id responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      if ([responseJSON isKindOfClass:[NSArray class]]) {
        if ([responseJSON count] == 0) {
          [self createEndUser:^(NSInteger endUserID) {
            endUserWithID(endUserID);
          }];
        } else {
          NSDictionary *endUser = responseJSON[0];
          
          if (endUser[@"id"]) {
            NSInteger endUserID = [endUser[@"id"] integerValue];
            if (!_endUserAlreadyUpdated) {
              [self updateExistingEndUser:endUserID];
            }
            endUserWithID(endUserID);
          }
        }
      } else {
        NSLog(@"WootricSDK - Error: %@", responseJSON);
      }
    }
  }];
    
  [dataTask resume];
}

- (void)updateExistingEndUser:(NSInteger)endUserID {
  BOOL needsUpdate = NO;
  NSString *escapedEmail = [self percentEscapeString:[_settings getEndUserEmailOrUnknown]];
  NSString *params = [NSString stringWithFormat:@"email=%@", escapedEmail];

  if (_settings.productName) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&properties[product_name]=%@", params, _settings.productName];
  }
  
  if (_settings.externalId) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&external_id=%@", params, _settings.externalId];
  }
  
  if (_settings.phoneNumber) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&phone_number=%@", params, _settings.phoneNumber];
  }

  if (_settings.customProperties) {
    needsUpdate = YES;
    NSString *parsedProperties = [WTRPropertiesParser parseToStringFromDictionary:_settings.customProperties];
    params = [NSString stringWithFormat:@"%@%@", params, parsedProperties];
  }
  
  params = [self addVersionsToURLString:params];

  if (needsUpdate) {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld?%@", _baseAPIURL, _apiVersion, (long)endUserID, params]];
    NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"PUT" andHTTPBody:nil];

    NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"WootricSDK (update end user): %@", error);
      } else {
        NSLog(@"WootricSDK (update end user): user updated");
        _endUserAlreadyUpdated = YES;
      }
    }];
    
    [dataTask resume];
  }
}

- (void)createEndUser:(void (^)(NSInteger endUserID))endUserWithID {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users", _baseAPIURL, _apiVersion]];
  NSString *escapedEmail = [self percentEscapeString:[_settings getEndUserEmailOrUnknown]];
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
    
  if (_settings.customProperties) {
    NSString *parsedProperties = [WTRPropertiesParser parseToStringFromDictionary:_settings.customProperties];
    params = [NSString stringWithFormat:@"%@%@", params, parsedProperties];
  }
    
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"POST" andHTTPBody:params];

  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"WootricSDK (create end user): %@", error);
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSLog(@"WootricSDK (create end user): %@", responseJSON);
      if (responseJSON) {
        NSInteger endUserID = [responseJSON[@"id"] integerValue];
        endUserWithID(endUserID);
      }
    }
  }];
    
  [dataTask resume];
}

- (void)createResponseForEndUser:(NSInteger)endUserID withScore:(NSInteger)score text:(NSString *)text endpoint:(NSString *)endpoint {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld/%@", _baseAPIURL, _apiVersion, (long)endUserID, endpoint]];
  NSString *params = [self paramsWithScore:score endUserID:endUserID userID:_userID accountID:_accountID uniqueLink:_uniqueLink priority:_priority text:text];
  
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"POST" andHTTPBody:params];
  
  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"ResponseError: %@", error);
    } else {
      NSLog(@"Create response added to queue");
    }
  }];

  [dataTask resume];
}

- (void)authenticate:(void (^)())authenticated {
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/token", _baseAPIURL]];
  NSString *params = [NSString stringWithFormat:@"grant_type=client_credentials&client_id=%@&client_secret=%@", _clientID, _clientSecret];
  
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"POST" andHTTPBody:params];

  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"WootricSDK (authentication): %@", error);
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSLog(@"WootricSDK (authentication): %@", responseJSON);
      if (responseJSON) {
        NSString *accessToken = responseJSON[@"access_token"];
        if (accessToken) {
          _accessToken = accessToken;
          authenticated();
        }
      }
    }
  }];

  [dataTask resume];
}

- (void)checkEligibility:(void (^)())eligible {
  NSString *endUserEmail = [_settings getEndUserEmailOrUnknown];
  NSString *baseURLString = [NSString stringWithFormat:@"%@?account_token=%@",
                             _surveyServerURL, _accountToken];
  
  baseURLString = [self addVersionsToURLString:baseURLString];

  if (![endUserEmail isEqual: @"Unknown"]) {
    baseURLString = [NSString stringWithFormat:@"%@&email=%@", baseURLString, endUserEmail];
  }

  baseURLString = [self addSurveyServerCustomSettingsToURLString:baseURLString];

  NSURL *url = [NSURL URLWithString:baseURLString];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setValue:@"Wootric-Mobile-SDK" forHTTPHeaderField:@"User-Agent"];
  
  NSLog(@"WootricSDK: eligibility - %@", urlRequest);

  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"WootricSDK: %@", error);
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      if (responseJSON) {
        if ([responseJSON[@"eligible"] isEqual:@1]) {
          if (_settings.forceSurvey) NSLog(@"WootricSDK: forced survey (remove for production!)");
          NSLog(@"WootricSDK: User eligible");

          [_settings parseDataFromSurveyServer:responseJSON];
          _userID = responseJSON[@"settings"][@"user_id"];
          
          _uniqueLink = [self buildUniqueLinkAccountToken:_accountToken
                                             endUserEmail:[_settings getEndUserEmailOrUnknown]
                                                     date:[[NSDate date] timeIntervalSince1970]
                                             randomString:[self randomString]];
          
          if (responseJSON[@"settings"][@"account_id"] != nil) {
            _accountID = responseJSON[@"settings"][@"account_id"];
          }
          eligible();
        } else {
          NSString *logString = @"WootricSDK: User ineligible";
          if (responseJSON[@"error"]){
            logString = [NSString stringWithFormat:@"%@ - %@", logString, responseJSON[@"error"]];
          }
          NSLog(@"%@", logString);
        }
      }
    }
  }];

  [dataTask resume];
}

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod andHTTPBody:(NSString *)httpBody {
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  
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
                     baseURLString, [self percentEscapeString:_settings.customProductName]];
  }

  if (_settings.customAudience) {
    baseURLString = [NSString stringWithFormat:@"%@&language[audience_text]=%@",
                     baseURLString, [self percentEscapeString:_settings.customAudience]];
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

- (NSString *)paramsWithScore:(NSInteger)score endUserID:(long)endUserID userID:(NSNumber *)userID accountID:(NSNumber *)accountID uniqueLink:(nonnull NSString *)uniqueLink priority:(int)priority text:(nullable NSString *)text {
  
  NSString *params = [NSString stringWithFormat:@"origin_url=%@&end_user[id]=%ld&survey[channel]=mobile&survey[unique_link]=%@&priority=%i&metric_type=%@", _settings.originURL, endUserID, uniqueLink, priority, [_settings.surveyType lowercaseString]];
  
  if (score > -1) {
    params = [NSString stringWithFormat:@"%@&score=%ld", params, (long) score];
    
    if (text) {
      NSString *escapedText = [self percentEscapeString:text];
      params = [NSString stringWithFormat:@"%@&text=%@", params, escapedText];
    }
  }
  
  if (userID != nil) {
    params = [NSString stringWithFormat:@"%@&user_id=%ld", params, [userID longValue]];
  }
  
  if (accountID != nil) {
    params = [NSString stringWithFormat:@"%@&account_id=%ld", params, [accountID longValue]];
  }
  
  _priority++;
  
  return params;
}

- (NSString *)percentEscapeString:(NSString *)string {
  NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                               (CFStringRef)string,
                                                                               (CFStringRef)@" ",
                                                                               (CFStringRef)@":/?@!$&'()*+,;=",
                                                                               kCFStringEncodingUTF8));
  return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
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
  NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[WTRApiClient class]] URLForResource:@"WootricSDK" withExtension:@"bundle"]];
  return [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)osVersion {
  return [[UIDevice currentDevice] systemVersion];
}

@end

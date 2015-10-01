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

@interface WTRApiClient ()

@property (nonatomic, strong) NSString *baseAPIURL;
@property (nonatomic, strong) NSString *surveyServerURL;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSURLSession *wootricSession;
@property (nonatomic, assign) BOOL endUserAlreadyUpdated;

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
    _baseAPIURL = @"http://localhost:3001";//@"https://api.wootric.com";
    _surveyServerURL = @"http://localhost:9292/eligible.json";//@"http://wootric-eligibility.herokuapp.com/eligible.json";
    _wootricSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _settings = [[WTRSettings alloc] init];
    _apiVersion = @"api/v1";
  }
  return self;
}

- (BOOL)checkConfiguration {
  if ([_clientID length] != 0 &&
      [_clientSecret length] != 0 &&
      [_accountToken length] != 0 &&
      [self validEmailString:_settings.endUserEmail] &&
      [_settings.originURL length] != 0) {
    return YES;
  }
  return NO;
}

- (void)endUserDeclined {
  [self getEndUserWithEmail:^(NSInteger endUserID) {
    [self createDeclineForEndUser:endUserID];
  }];
}

- (void)endUserVotedWithScore:(NSInteger)score andText:(NSString *)text {
  [self getEndUserWithEmail:^(NSInteger endUserID) {
    [self createResponseForEndUser:endUserID withScore:score andText:text];
  }];
}

- (void)getEndUserWithEmail:(void (^)(NSInteger endUserID))endUserWithID {
  NSString *escapedEmail = [self percentEscapeString:_settings.endUserEmail];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users?email=%@", _baseAPIURL, _apiVersion, escapedEmail]];
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:nil andHTTPBody:nil];

  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"WootricSDK (GET end user): %@", error);
    } else {
      NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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
    }
  }];

  [dataTask resume];
}

- (void)updateExistingEndUser:(NSInteger)endUserID {
  BOOL needsUpdate = NO;
  NSString *escapedEmail = [self percentEscapeString:_settings.endUserEmail];
  NSString *params = [NSString stringWithFormat:@"email=%@", escapedEmail];

  if (_settings.productName) {
    needsUpdate = YES;
    params = [NSString stringWithFormat:@"%@&properties[product_name]=%@", params, _settings.productName];
  }

  if (_settings.customProperties) {
    needsUpdate = YES;
    NSString *parsedProperties = [WTRPropertiesParser parseToStringFromDictionary:_settings.customProperties];
    params = [NSString stringWithFormat:@"%@%@", params, parsedProperties];
  }

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
  NSString *escapedEmail = [self percentEscapeString:_settings.endUserEmail];
  NSString *params = [NSString stringWithFormat:@"email=%@", escapedEmail];

  if (_settings.externalCreatedAt != 0) {
    params = [NSString stringWithFormat:@"%@&external_created_at=%ld", params, (long)_settings.externalCreatedAt];
  }

  if (_settings.productName) {
    params = [NSString stringWithFormat:@"%@&properties[product_name]=%@", params, _settings.productName];
  }

  if (_settings.customProperties) {
    NSString *parsedProperties = [WTRPropertiesParser parseToStringFromDictionary:_settings.customProperties];;
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

- (void)createResponseForEndUser:(NSInteger)endUserID withScore:(NSInteger)score andText:(NSString *)text {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld/responses", _baseAPIURL, _apiVersion, (long)endUserID]];
  NSString *params = [NSString stringWithFormat:@"score=%ld&origin_url=%@&survey[channel]=mobile", (long)score, _settings.originURL];

  if (text) {
    NSString *escapedText = [self percentEscapeString:text];
    params = [NSString stringWithFormat:@"%@&text=%@", params, escapedText];
  }

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

- (void)createDeclineForEndUser:(NSInteger)endUserID {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld/declines", _baseAPIURL, _apiVersion, (long)endUserID]];
  NSString *params = [NSString stringWithFormat:@"origin_url=%@&survey[channel]=mobile", _settings.originURL];
  NSMutableURLRequest *urlRequest = [self requestWithURL:url HTTPMethod:@"POST" andHTTPBody:params];

  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"WootricSDK (decline): %@", error);
    } else {
      NSLog(@"WootricSDK (decline): Decline creation added to queue");
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
  NSString *baseURLString = [NSString stringWithFormat:@"%@?account_token=%@&email=%@",
                             _surveyServerURL, _accountToken, _settings.endUserEmail];

  baseURLString = [self addSurveyServerCustomSettingsToURLString:baseURLString];

  NSURL *url = [NSURL URLWithString:baseURLString];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setValue:@"Wootric-Mobile-SDK" forHTTPHeaderField:@"USER_AGENT"];

  NSURLSessionDataTask *dataTask = [_wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"WootricSDK: %@", error);
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      if (responseJSON) {
        NSLog(@"WootricSDK: %@", responseJSON);
        if ([responseJSON[@"eligible"] isEqual:@1] || _settings.forceSurvey) {
          if (_settings.forceSurvey) NSLog(@"WootricSDK: forced survey (remove for production!)");
          NSLog(@"WootricSDK: User eligible");
          [_settings parseDataFromSurveyServer:responseJSON];
          eligible();
        } else {
          NSLog(@"WootricSDK: User ineligible");
        }
      }
    }
  }];

  [dataTask resume];
}

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod andHTTPBody:(NSString *)httpBody {
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

  if (httpBody) {
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

- (BOOL)validEmailString:(NSString *)emailString {
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return !([[emailString stringByTrimmingCharactersInSet:set] length] == 0);
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

  return baseURLString;
}

- (NSString *)percentEscapeString:(NSString *)string {
  NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                               (CFStringRef)string,
                                                                               (CFStringRef)@" ",
                                                                               (CFStringRef)@":/?@!$&'()*+,;=",
                                                                               kCFStringEncodingUTF8));
  return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

@end

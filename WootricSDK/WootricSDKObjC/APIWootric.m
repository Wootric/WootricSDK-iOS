//
//  APIWootric.m
//  WootricSDKObjC
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

#import "APIWootric.h"

@implementation APIWootric
  NSString *baseAPIURL = @"https://api.wootric.com";
  NSString *eligibilityServerURL = @"http://wootric-eligibility.herokuapp.com/eligible.json";
  NSURLSession *wootricSession;

+ (instancetype)sharedInstance {
  static APIWootric *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}

- (instancetype)init {
  if (self = [super init]) {
    wootricSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _setDefaultAfterSurvey = YES;
    _surveyedDefaultDuration = 90;
    _firstSurveyAfter = 31;
    _apiVersion = @"v1";
  }
  return self;
}

- (BOOL)checkConfiguration {
  if ([_clientID length] != 0 &&
      [_clientSecret length] != 0 &&
      [_accountToken length] != 0 &&
      [self validEmailString:_endUserEmail] &&
      [_originURL length] != 0) {
    return YES;
  }
  return NO;
}

- (NSString *)parseCustomProperties {
  NSString *parsedProperties = @"";
  for (NSString *key in _customProperties) {
    NSString *escapedValue = [self percentEscapeString:[NSString stringWithFormat:@"%@", [_customProperties objectForKey:key]]];
    parsedProperties = [NSString stringWithFormat:@"%@&%@", parsedProperties, [NSString stringWithFormat:@"properties[%@]=%@", key, escapedValue]];
  }

  return parsedProperties;
}

- (void)voteWithScore:(NSInteger)score andText:(NSString *)text {
  [self getEndUserWithEmail:^(NSInteger endUserID) {
    [self createResponseForEndUser:endUserID withScore:score andText:text];
  }];
}

- (void)userDeclined {
  [self getEndUserWithEmail:^(NSInteger endUserID) {
    [self createDeclineForEndUser:endUserID];
  }];
}

- (void)getTrackingPixel {
  double rand = drand48();
  NSString *formattedRand = [NSString stringWithFormat:@"%.16f", rand];
  NSString *stringToFormat = @"https://d8myem934l1zi.cloudfront.net/pixel.gif?account_token=%@&email=%@&url=%@&random=%@";
  NSString *params = [NSString stringWithFormat:stringToFormat, _accountToken, _endUserEmail, _originURL, formattedRand];

  if (_externalCreatedAt != 0) {
    params = [NSString stringWithFormat:@"%@&created_at=%ld", params, (long)_externalCreatedAt];
  }

  NSURL *url = [NSURL URLWithString:params];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

  NSURLSessionDataTask *dataTask = [wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Tracking pixel error: %@", error);
    } else {
      NSLog(@"Tracking pixel GET success");
    }
  }];

  [dataTask resume];
}

- (void)createDeclineForEndUser:(NSInteger)endUserID {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld/declines", baseAPIURL, _apiVersion, (long)endUserID]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  NSString *params = [NSString stringWithFormat:@"origin_url=%@&survey[channel]=mobile", _originURL];

  [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", _accessToken] forHTTPHeaderField:@"Authorization"];
  urlRequest.HTTPMethod = @"POST";
  urlRequest.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];

  NSURLSessionDataTask *dataTask = [wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"DeclineError: %@", error);
    } else {
      NSLog(@"Create decline added to queue");
    }
  }];

  [dataTask resume];
}

- (void)createResponseForEndUser:(NSInteger)endUserID withScore:(NSInteger)score andText:(NSString *)text {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld/responses", baseAPIURL, _apiVersion, (long)endUserID]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  NSString *params = [NSString stringWithFormat:@"score=%ld&origin_url=%@&survey[channel]=mobile", (long)score, _originURL];

  if (text) {
    NSString *escapedText = [self percentEscapeString:text];
    params = [NSString stringWithFormat:@"%@&text=%@", params, escapedText];
  }

  [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", _accessToken] forHTTPHeaderField:@"Authorization"];
  urlRequest.HTTPMethod = @"POST";
  urlRequest.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];

  NSURLSessionDataTask *dataTask = [wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"ResponseError: %@", error);
    } else {
      NSLog(@"Create response added to queue");
    }
  }];

  [dataTask resume];
}

- (void)getEndUserWithEmail:(void (^)(NSInteger endUserID))endUserWithID {
  NSString *escapedEmail = [self percentEscapeString:_endUserEmail];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users?email=%@", baseAPIURL, _apiVersion, escapedEmail]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", _accessToken] forHTTPHeaderField:@"Authorization"];

  NSURLSessionDataTask *dataTask = [wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
    } else {
      NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      // If user is not found, create one
      if ([responseJSON count] == 0) {
        [self createEndUser:^(NSInteger endUserID) {
          endUserWithID(endUserID);
        }];
      } else {
        NSDictionary *endUser = responseJSON[0];
        if (endUser[@"id"]) {
          NSInteger endUserID = [endUser[@"id"] integerValue];
          endUserWithID(endUserID);
        }
      }
    }
  }];

  [dataTask resume];
}

- (void)createEndUser:(void (^)(NSInteger endUserID))endUserWithID {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users", baseAPIURL, _apiVersion]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  NSString *escapedEmail = [self percentEscapeString:_endUserEmail];
  NSString *params = [NSString stringWithFormat:@"email=%@", escapedEmail];

  if (_externalCreatedAt != 0) {
    params = [NSString stringWithFormat:@"%@&external_created_at=%ld", params, (long)_externalCreatedAt];
  }

  if (_productName) {
    params = [NSString stringWithFormat:@"%@&properties[product_name]=%@", params, _productName];
  }

  if (_customProperties) {
    NSString *parsedProperties = [self parseCustomProperties];
    params = [NSString stringWithFormat:@"%@%@", params, parsedProperties];
  }

  [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", _accessToken] forHTTPHeaderField:@"Authorization"];
  urlRequest.HTTPMethod = @"POST";
  urlRequest.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];

  NSURLSessionDataTask *dataTask = [wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSLog(@"%@", responseJSON);
      if (responseJSON) {
        NSInteger endUserID = [responseJSON[@"id"] integerValue];
        endUserWithID(endUserID);
      }
    }
  }];

  [dataTask resume];
}

- (void)checkEligibilityForEndUser:(void (^)())eligible {
  NSString *baseURLString = [NSString stringWithFormat:@"%@?account_token=%@&email=%@", eligibilityServerURL, _accountToken, _endUserEmail];

  if (_registeredPercent) {
    baseURLString = [NSString stringWithFormat:@"%@&registered_percent=%ld", baseURLString, (long)_registeredPercent.integerValue];
  }

  if (_visitorPercent) {
    baseURLString = [NSString stringWithFormat:@"%@&visitor_percent=%ld", baseURLString, (long)_visitorPercent.integerValue];
  }

  if (_resurveyThrottle) {
    baseURLString = [NSString stringWithFormat:@"%@&resurvey_throttle=%ld", baseURLString, (long)_resurveyThrottle.integerValue];
  }

  NSURL *url = [NSURL URLWithString:baseURLString];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setValue:@"Wootric-Mobile-SDK" forHTTPHeaderField:@"USER_AGENT"];

  NSURLSessionDataTask *dataTask = [wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      if (responseJSON) {
        if ([responseJSON[@"eligible"] isEqual:@1]) {
          NSLog(@"User eligible");
          eligible();
        } else {
          NSLog(@"User not eligible");
        }
      }
    }
  }];

  [dataTask resume];
}

- (void)authenticate:(void (^)())authenticated {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/token", baseAPIURL]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  NSString *params = [NSString stringWithFormat:@"grant_type=client_credentials&client_id=%@&client_secret=%@", _clientID, _clientSecret];
  urlRequest.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
  urlRequest.HTTPMethod = @"POST";

  NSURLSessionDataTask *dataTask = [wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSLog(@"%@", responseJSON);
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

- (void)surveyForEndUser:(void (^)())showSurvey {
  if (_forceSurvey) {
    [self authenticate:^{
      showSurvey();
    }];
  } else if ([self needsSurvey]) {
    if (_surveyImmediately) {
      [self authenticate:^{
        showSurvey();
      }];
    } else {
      [self checkEligibilityForEndUser:^{
        [self authenticate:^{
          showSurvey();
        }];
      }];
    }
  }
}

- (BOOL)needsSurvey {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults boolForKey:@"surveyed"]) {
    return NO;
  } else if (_surveyImmediately) {
    return YES;
  } else {
    NSInteger age = [[NSDate date] timeIntervalSince1970] - _externalCreatedAt;
    if (_firstSurveyAfter != 0) {
      if (age > (_firstSurveyAfter * 60 * 60 * 24)) {
        return YES;
      } else {
        if (([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"lastSeenAt"]) >= (_firstSurveyAfter * 60 * 60 * 24)) {
          return YES;
        }
      }
    } else {
      return YES;
    }
  }
  return NO;
}

- (BOOL)validEmailString:(NSString *)emailString {
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return !([[emailString stringByTrimmingCharactersInSet:set] length] == 0);
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

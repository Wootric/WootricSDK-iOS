//
//  APIWootric.m
//  WootricSDKObjC
//
//  Created by Łukasz Cichecki on 05/03/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import "APIWootric.h"

@implementation APIWootric
  NSString *baseAPIURL = @"https://api.wootric.com";
  NSString *eligibilityServerURL = @"http://wootric-eligibility.herokuapp.com/eligible.json";
  NSString *apiVersion = @"v1";
  NSURLSession *wootricSession;

+ (instancetype)sharedInstance {
  static APIWootric *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}

+ (void)initialize {
  wootricSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (BOOL)checkConfiguration {
  if (_clientID != nil && _clientSecret != nil && _accountToken != nil && _endUserEmail != nil && _originURL != nil) {
    return YES;
  }
  return NO;
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

- (void)createDeclineForEndUser:(NSInteger)endUserID {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld/declines", baseAPIURL, apiVersion, (long)endUserID]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

  [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", _accessToken] forHTTPHeaderField:@"Authorization"];
  urlRequest.HTTPMethod = @"POST";

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
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users/%ld/responses", baseAPIURL, apiVersion, (long)endUserID]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  NSString *params = [NSString stringWithFormat:@"score=%ld&origin_url=%@", (long)score, _originURL];

  if (text) {
    params = [NSString stringWithFormat:@"%@&text=%@", params, text];
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
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users?email=%@", baseAPIURL, apiVersion, _endUserEmail]];
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
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/end_users", baseAPIURL, apiVersion]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
  NSString *params = [NSString stringWithFormat:@"email=%@", _endUserEmail];

  [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", _accessToken] forHTTPHeaderField:@"Authorization"];
  urlRequest.HTTPMethod = @"POST";
  urlRequest.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];

  NSURLSessionDataTask *dataTask = [wootricSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
    } else {
      NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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

  if (_registeredPercent.integerValue) {
    baseURLString = [NSString stringWithFormat:@"%@&registered_percent=%ld", baseURLString, (long)_registeredPercent.integerValue];
  }

  if (_visitorPercent.integerValue) {
    baseURLString = [NSString stringWithFormat:@"%@&visitor_percent=%ld", baseURLString, (long)_visitorPercent.integerValue];
  }

  if (_resurveyThrottle.integerValue) {
    baseURLString = [NSString stringWithFormat:@"%@&resurvey_throttle=%ld", baseURLString, (long)_resurveyThrottle.integerValue];
  }

  NSURL *url = [NSURL URLWithString:baseURLString];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

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

@end

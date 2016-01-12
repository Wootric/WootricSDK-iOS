//
//  WTRTrackingPixel.m
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

#import "WTRTrackingPixel.h"
#import "WTRApiClient.h"

@implementation WTRTrackingPixel

+ (void)getPixel {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];

  double cacheRandom = drand48();
  NSString *formattedRandom = [NSString stringWithFormat:@"%.16f", cacheRandom];
  NSString *stringToFormat = @"https://d8myem934l1zi.cloudfront.net/pixel.gif?account_token=%@&email=%@&url=%@&random=%@";
  NSString *params = [NSString stringWithFormat:stringToFormat, apiClient.accountToken, apiClient.settings.endUserEmail, apiClient.settings.originURL, formattedRandom];

  if (apiClient.settings.externalCreatedAt) {
    NSLog(@"WootricSDK: externalCreatedAt: %ld", (long)[apiClient.settings.externalCreatedAt intValue]);
    params = [NSString stringWithFormat:@"%@&created_at=%ld", params, (long)[apiClient.settings.externalCreatedAt intValue]];
  }

  NSURL *pixelUrl = [NSURL URLWithString:params];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pixelUrl];
  NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

  NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"WootricSDK: tracking pixel error: %@", error);
    } else {
      NSLog(@"WootricSDK: tracking pixel GET success (with params: %@)", params);
    }
  }];

  [dataTask resume];
  [urlSession finishTasksAndInvalidate];
}

@end

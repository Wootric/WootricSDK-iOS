//
//  WootricSDK.m
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

#import "WootricSDK.h"
#import "WTRApiClient.h"
#import "WTRTrackingPixel.h"
#import "WTRSurvey.h"
#import "WTRDefaults.h"
#import "WTRSurveyViewController.h"

@implementation WootricSDK

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret andAccountToken:(NSString *)accountToken {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.clientID = clientID;
  apiClient.clientSecret = clientSecret;
  apiClient.accountToken = accountToken;
}

+ (void)setEndUserEmail:(NSString *)endUserEmail andCreatedAt:(NSInteger)externalCreatedAt {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.endUserEmail = endUserEmail;
  apiClient.settings.externalCreatedAt = externalCreatedAt;
}

+ (void)setOriginUrl:(NSString *)originUrl {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.originURL = originUrl;
}

+ (void)forceSurvey:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.forceSurvey = flag;
}

+ (void)showSurveyInViewController:(UIViewController *)viewController {
  if ([[WTRApiClient sharedInstance] checkConfiguration]) {
    [WTRTrackingPixel getPixel];
    [WTRDefaults setLastSeenAt];
    [WTRDefaults checkIfSurveyedDefaultExpired];
    WTRSurvey *surveyClient = [[WTRSurvey alloc] init];
    [surveyClient survey:^{
      NSLog(@"WootricSDK: presenting survey view");
      dispatch_async(dispatch_get_main_queue(), ^{
        [WootricSDK presentSurveyInViewController:viewController];
      });
    }];
  } else {
    NSLog(@"WootricSDK: Configure SDK first");
  }
}

+ (void)presentSurveyInViewController:(UIViewController *)viewController {
  WTRSettings *surveySettings = [WTRApiClient sharedInstance].settings;
  WTRSurveyViewController *surveyViewController = [[WTRSurveyViewController alloc] initWithSurveySettings:surveySettings];

  [viewController presentViewController:surveyViewController animated:YES completion:nil];
}

@end

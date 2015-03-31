//
//  WootricSDK.m
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

#import "WootricSDK.h"
#import <Foundation/Foundation.h>
#import "APIWootric.h"
#import "SurveyViewController.h"

@implementation WootricSDK

#pragma mark - Configuration

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret andAccountToken:(NSString *)accountToken {
  APIWootric *api = [APIWootric sharedInstance];
  api.clientID = clientID;
  api.clientSecret = clientSecret;
  api.accountToken = accountToken;
}

+ (void)setEndUserEmail:(NSString *)endUserEmail andOriginURL:(NSString *)originURL {
  APIWootric *api = [APIWootric sharedInstance];
  api.endUserEmail = endUserEmail;
  api.originURL = originURL;
}

+ (void)setApiVersion:(NSString *)apiVersion {
  APIWootric *api = [APIWootric sharedInstance];
  api.apiVersion = apiVersion;
}

+ (void)surveyImmediately:(BOOL)flag {
  APIWootric *api = [APIWootric sharedInstance];
  api.surveyImmediately = flag;
}

+ (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle visitorPercentage:(NSNumber *)visitorPercent andRegisteredPercentage:(NSNumber *)registeredPercent {
  APIWootric *api = [APIWootric sharedInstance];
  api.registeredPercent = registeredPercent;
  api.visitorPercent = visitorPercent;
  api.resurveyThrottle = resurveyThrottle;
}

+ (void)endUserCreatedAt:(NSInteger)externalCreatedAt {
  APIWootric *api = [APIWootric sharedInstance];
  api.externalCreatedAt = externalCreatedAt;
}

+ (void)productName:(NSString *)productName {
  APIWootric *api = [APIWootric sharedInstance];
  api.productName = productName;
}

+ (void)endUserProperties:(NSDictionary *)customProperties {
  APIWootric *api = [APIWootric sharedInstance];
  api.customProperties = customProperties;
}

+ (void)firstSurveyAfter:(NSUInteger)numberOfDays {
  APIWootric *api = [APIWootric sharedInstance];
  api.firstSurveyAfter = numberOfDays;
}

+ (void)setSurveyedDefaultAfterSurvey:(BOOL)flag withDuration:(NSUInteger)numberOfDays {
  APIWootric *api = [APIWootric sharedInstance];
  api.setDefaultAfterSurvey = flag;
  api.surveyedDefaultDuration = numberOfDays;
}

+ (void)setSurveyedDefaultAfterSurvey:(BOOL)flag {
  APIWootric *api = [APIWootric sharedInstance];
  [WootricSDK setSurveyedDefaultAfterSurvey:flag withDuration:api.surveyedDefaultDuration];
}

+ (void)setCustomDetractorQuestion:(NSString *)detractorQuestion passiveQuestion:(NSString *)passiveQuestion andPromoterQuestion:(NSString *)promoterQuestion {
  APIWootric *api = [APIWootric sharedInstance];
  api.detractorQuestion = detractorQuestion;
  api.passiveQuestion = passiveQuestion;
  api.promoterQuestion = promoterQuestion;
}

+ (void)setCustomDetractorPlaceholder:(NSString *)detractorPlaceholder passivePlaceholder:(NSString *)passivePlaceholder andPromoterPlaceholder:(NSString *)promoterPlaceholder {
  APIWootric *api = [APIWootric sharedInstance];
  api.detractorPlaceholder = detractorPlaceholder;
  api.passivePlaceholder = passivePlaceholder;
  api.promoterPlaceholder = promoterPlaceholder;
}

+ (void)setCustomWootricQuestion:(NSString *)wootricQuestion {
  APIWootric *api = [APIWootric sharedInstance];
  api.wootricQuestion = wootricQuestion;
}

#pragma mark - Survey methods

+ (void)voteWithScore:(NSInteger)score andText:(NSString *)text {
  [[APIWootric sharedInstance] voteWithScore:score andText:text];
  [WootricSDK setSurveyedInDefaults];
}

+ (void)userDeclined {
  [[APIWootric sharedInstance] userDeclined];
  [WootricSDK setSurveyedInDefaults];
}

+ (void)showSurveyInViewController:(UIViewController *)viewController {
  NSAssert([[APIWootric sharedInstance] checkConfiguration], @"Configure WootricSDK first");
  [WootricSDK setLastSeenAtInDefaults];
  [WootricSDK checkIfSurveyedDefaultExpired];
  [[APIWootric sharedInstance] surveyForEndUser:^{
    UIImage *imageToBlur = [WootricSDK imageToBlurFromViewController:viewController];
    dispatch_async(dispatch_get_main_queue(), ^{
      [WootricSDK setupAndShowSurveyForViewController:viewController withImageToBlur:imageToBlur];
    });
  }];
}

+ (void)setupAndShowSurveyForViewController:(UIViewController *)viewController withImageToBlur:(UIImage *)imageToBlur {
  APIWootric *api = [APIWootric sharedInstance];
  SurveyViewController *surveyViewController = [[SurveyViewController alloc] init];

  surveyViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  surveyViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  surveyViewController.imageToBlur = imageToBlur;

  surveyViewController.wootricQuestion = api.wootricQuestion;
  surveyViewController.detractorQuestion = api.detractorQuestion;
  surveyViewController.passiveQuestion = api.passiveQuestion;
  surveyViewController.promoterQuestion = api.promoterQuestion;

  surveyViewController.detractorPlaceholder = api.detractorPlaceholder;
  surveyViewController.passivePlaceholder= api.passivePlaceholder;
  surveyViewController.promoterPlaceholder = api.promoterPlaceholder;

  [viewController presentViewController:surveyViewController animated:YES completion:nil];
}

+ (UIImage *)imageToBlurFromViewController:(UIViewController *)viewController {
  UIGraphicsBeginImageContextWithOptions(viewController.view.bounds.size, YES, 1);
  [viewController.view drawViewHierarchyInRect:viewController.view.bounds afterScreenUpdates:NO];
  UIImage *imageToBlur = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return imageToBlur;
}

+ (void)setLastSeenAtInDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults doubleForKey:@"lastSeenAt"] == 0) {
    [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"lastSeenAt"];
  } else {
    double ninetyDaysTimestamp = 90 * 60 * 60 * 24;
    if ([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"lastSeenAt"] >= ninetyDaysTimestamp) {
      [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"lastSeenAt"];
    }
  }
}

+ (void)setSurveyedInDefaults {
  APIWootric *api = [APIWootric sharedInstance];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (api.setDefaultAfterSurvey) {
    [defaults setBool:YES forKey:@"surveyed"];
    [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"surveyedAt"];
  }
}

+ (void)checkIfSurveyedDefaultExpired {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  APIWootric *api = [APIWootric sharedInstance];
  if ([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"surveyedAt"] >= (api.surveyedDefaultDuration * 60 * 60 * 24)) {
    [defaults setBool:NO forKey:@"surveyed"];
  }
}

@end

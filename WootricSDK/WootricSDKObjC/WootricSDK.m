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
#import "WTRNetworkClient.h"
#import "WTRSettings.h"
#import "WTRSurveyViewController.h"

@implementation WootricSDK

#pragma mark - Configuration

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret andAccountToken:(NSString *)accountToken {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.clientID = clientID;
  api.clientSecret = clientSecret;
  api.accountToken = accountToken;
}

+ (void)setEndUserEmail:(NSString *)endUserEmail andOriginURL:(NSString *)originURL {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.endUserEmail = endUserEmail;
  api.originURL = originURL;
}

+ (void)setApiVersion:(NSString *)apiVersion {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.apiVersion = apiVersion;
}

+ (void)surveyImmediately:(BOOL)flag {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.surveyImmediately = flag;
}

+ (void)forceSurvey:(BOOL)flag {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.forceSurvey = flag;
}

+ (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle
                        visitorPercentage:(NSNumber *)visitorPercent
                     registeredPercentage:(NSNumber *)registeredPercent
                      andDailyResponseCap:(NSNumber *)dailyResponseCap {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.registeredPercent = registeredPercent;
  api.settings.visitorPercent = visitorPercent;
  api.settings.resurveyThrottle = resurveyThrottle;
  api.settings.dailyResponseCap = dailyResponseCap;
}

+ (void)endUserCreatedAt:(NSInteger)externalCreatedAt {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.externalCreatedAt = externalCreatedAt;
}

+ (void)productName:(NSString *)productName {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.productName = productName;
}

+ (void)endUserProperties:(NSDictionary *)customProperties {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.customProperties = customProperties;
}

+ (void)firstSurveyAfter:(NSUInteger)numberOfDays {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.firstSurveyAfter = numberOfDays;
}

+ (void)setSurveyedDefaultAfterSurvey:(BOOL)flag withDuration:(NSUInteger)numberOfDays {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.setDefaultAfterSurvey = flag;
  api.settings.surveyedDefaultDuration = numberOfDays;
}

+ (void)setSurveyedDefaultAfterSurvey:(BOOL)flag {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  [WootricSDK setSurveyedDefaultAfterSurvey:flag withDuration:api.settings.surveyedDefaultDuration];
}

+ (void)setCustomDetractorQuestion:(NSString *)detractorQuestion
                   passiveQuestion:(NSString *)passiveQuestion
               andPromoterQuestion:(NSString *)promoterQuestion {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.detractorQuestion = detractorQuestion;
  api.settings.passiveQuestion = passiveQuestion;
  api.settings.promoterQuestion = promoterQuestion;
}

+ (void)setCustomDetractorPlaceholder:(NSString *)detractorPlaceholder
                   passivePlaceholder:(NSString *)passivePlaceholder
               andPromoterPlaceholder:(NSString *)promoterPlaceholder {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.detractorPlaceholder = detractorPlaceholder;
  api.settings.passivePlaceholder = passivePlaceholder;
  api.settings.promoterPlaceholder = promoterPlaceholder;
}

+ (void)setCustomWootricRecommendTo:(NSString *)wootricRecommendTo {
  WTRNetworkClient *api = [WTRNetworkClient sharedInstance];
  api.settings.wootricRecommendTo = wootricRecommendTo;
}

+ (void)setCustomQuestion:(NSString *)customQuestion {
  [WTRNetworkClient sharedInstance].settings.customQuestion = customQuestion;
}

+ (void)setCustomPlaceholder:(NSString *)customPlaceholder {
  [WTRNetworkClient sharedInstance].settings.customPlaceholder = customPlaceholder;
}

+ (void)setCustomWootricRecommendProduct:(NSString *)wootricRecommendProduct{
  [WTRNetworkClient sharedInstance].settings.wootricRecommendProduct = wootricRecommendProduct;
}

#pragma mark - Survey methods

+ (void)voteWithScore:(NSInteger)score andText:(NSString *)text {
  [[WTRNetworkClient sharedInstance] voteWithScore:score andText:text];
  [WootricSDK setSurveyedInDefaults];
}

+ (void)userDeclined {
  [[WTRNetworkClient sharedInstance] userDeclined];
  [WootricSDK setSurveyedInDefaults];
}

+ (void)showSurveyInViewController:(UIViewController *)viewController {
  if ([[WTRNetworkClient sharedInstance] checkConfiguration]) {
    [[WTRNetworkClient sharedInstance] getTrackingPixel];
    [WootricSDK setLastSeenAtInDefaults];
    [WootricSDK checkIfSurveyedDefaultExpired];
    [[WTRNetworkClient sharedInstance] surveyForEndUser:^{
      UIImage *imageToBlur = [WootricSDK imageToBlurFromViewController:viewController];
      dispatch_async(dispatch_get_main_queue(), ^{
        [WootricSDK setupAndShowSurveyForViewController:viewController withImageToBlur:imageToBlur];
      });
    }];
  } else {
    NSLog(@"Configure WootricSDK first");
  }
}

+ (void)setupAndShowSurveyForViewController:(UIViewController *)viewController withImageToBlur:(UIImage *)imageToBlur {
  WTRSurveyViewController *surveyViewController = [[WTRSurveyViewController alloc] initWithSettings:[WTRNetworkClient sharedInstance].settings];

  surveyViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  surveyViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  surveyViewController.imageToBlur = imageToBlur;

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
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([WTRNetworkClient sharedInstance].settings.setDefaultAfterSurvey) {
    [defaults setBool:YES forKey:@"surveyed"];
    [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"surveyedAt"];
  }
}

+ (void)checkIfSurveyedDefaultExpired {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"surveyedAt"] >= ([WTRNetworkClient sharedInstance].settings.surveyedDefaultDuration * 60 * 60 * 24)) {
    [defaults setBool:NO forKey:@"surveyed"];
  }
}

@end

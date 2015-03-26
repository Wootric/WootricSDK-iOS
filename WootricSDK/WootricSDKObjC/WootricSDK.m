//
//  WootricSDK.m
//  WootricSDKObjC
//
//  Created by Łukasz Cichecki on 04/03/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

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
  api.surveyedDefaultTrottle = numberOfDays;
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
  SurveyViewController *surveyViewController = [[SurveyViewController alloc] init];

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
  if ([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"surveyedAt"] >= (api.surveyedDefaultTrottle * 60 * 60 * 24)) {
    [defaults setBool:NO forKey:@"surveyed"];
  }
}

@end

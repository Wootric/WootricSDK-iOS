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

+ (void)voteWithScore:(NSInteger)score andText:(NSString *)text {
  [[APIWootric sharedInstance] voteWithScore:score andText:text];
}

+ (void)userDeclined {
  [[APIWootric sharedInstance] userDeclined];
}

+ (void)showSurveyInViewController:(UIViewController *)viewController {
  NSAssert([[APIWootric sharedInstance] checkConfiguration], @"Configure WootricSDK first");
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

@end

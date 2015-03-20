//
//  WootricSDK.h
//  WootricSDKObjC
//
//  Created by Łukasz Cichecki on 04/03/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WootricSDK : NSObject

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret andAccountToken:(NSString *)accountToken;
+ (void)setEndUserEmail:(NSString *)endUserEmail andOriginURL:(NSString *)originURL;
+ (void)forceSurvey:(BOOL)flag;
+ (void)setApiVersion:(NSString *)apiVersion;
+ (void)voteWithScore:(NSInteger)score andText:(NSString *)text;
+ (void)userDeclined;
+ (void)showSurveyInViewController:(UIViewController *)viewController;
+ (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle visitorPercentage:(NSNumber *)visitorPercent andRegisteredPercentage:(NSNumber *)registeredPercent;
+ (UIImage *)imageToBlurFromViewController:(UIViewController *)viewController;

@end

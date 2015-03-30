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
+ (void)surveyImmediately:(BOOL)flag;
+ (void)setApiVersion:(NSString *)apiVersion;
+ (void)voteWithScore:(NSInteger)score andText:(NSString *)text;
+ (void)userDeclined;
+ (void)showSurveyInViewController:(UIViewController *)viewController;
+ (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle visitorPercentage:(NSNumber *)visitorPercent andRegisteredPercentage:(NSNumber *)registeredPercent;
+ (void)endUserCreatedAt:(NSInteger)externalCreatedAt;
+ (void)productName:(NSString *)productName;
+ (void)endUserProperties:(NSDictionary *)customProperties;
+ (void)firstSurveyAfter:(NSUInteger)numberOfDays;
+ (void)setSurveyedDefaultAfterSurvey:(BOOL)flag;
+ (void)setSurveyedDefaultAfterSurvey:(BOOL)flag withDuration:(NSUInteger)numberOfDays;
+ (void)setCustomDetractorQuestion:(NSString *)detractorQuestion passiveQuestion:(NSString *)passiveQuestion andPromoterQuestion:(NSString *)promoterQuestion;
+ (void)setCustomWootricQuestion:(NSString *)wootricQuestion;
+ (UIImage *)imageToBlurFromViewController:(UIViewController *)viewController;

@end

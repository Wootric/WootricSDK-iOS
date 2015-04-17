//
//  WootricSDK.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WootricSDK : NSObject

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret andAccountToken:(NSString *)accountToken;
+ (void)setEndUserEmail:(NSString *)endUserEmail andOriginURL:(NSString *)originURL;
+ (void)surveyImmediately:(BOOL)flag;
+ (void)forceSurvey:(BOOL)flag;
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
+ (void)setCustomDetractorPlaceholder:(NSString *)detractorPlaceholder passivePlaceholder:(NSString *)passivePlaceholder andPromoterPlaceholder:(NSString *)promoterPlaceholder;
+ (void)setCustomWootricRecommendTo:(NSString *)wootricRecommendTo;
+ (UIImage *)imageToBlurFromViewController:(UIViewController *)viewController;

@end

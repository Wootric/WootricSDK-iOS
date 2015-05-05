//
//  WTSettings.h
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

@interface WTSettings : NSObject

@property (nonatomic) UIColor *tintColorCircle;
@property (nonatomic) UIColor *tintColorSubmit;
@property (nonatomic) NSString *defaultWootricQuestion;
@property (nonatomic) NSString *defaultPlaceholderText;
@property (nonatomic) NSString *defaultResponseQuestion;
@property (nonatomic) NSString *productName;
@property (nonatomic) NSString *wootricRecommendProduct;
@property (nonatomic) NSString *customQuestion;
@property (nonatomic) NSString *customPlaceholder;
@property (nonatomic) NSString *wootricRecommendTo;
@property (nonatomic) NSString *detractorQuestion;
@property (nonatomic) NSString *passiveQuestion;
@property (nonatomic) NSString *promoterQuestion;
@property (nonatomic) NSString *detractorPlaceholder;
@property (nonatomic) NSString *passivePlaceholder;
@property (nonatomic) NSString *promoterPlaceholder;
@property (nonatomic) NSString *language;
@property (nonatomic) NSNumber *registeredPercent;
@property (nonatomic) NSNumber *visitorPercent;
@property (nonatomic) NSNumber *resurveyThrottle;
@property (nonatomic) NSNumber *dailyResponseCap;
@property (nonatomic) NSDictionary *customProperties;
@property (nonatomic) NSInteger externalCreatedAt;
@property (nonatomic) NSInteger firstSurveyAfter;
@property (nonatomic) NSInteger surveyedDefaultDuration;
@property (nonatomic) BOOL surveyImmediately;
@property (nonatomic) BOOL forceSurvey;
@property (nonatomic) BOOL setDefaultAfterSurvey;

- (void)modifyWithSettingsFromEligibility:(NSDictionary *)eligibilitySettings;

@end
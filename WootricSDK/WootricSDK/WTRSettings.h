//
//  WTRSettings.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WTRSettings : NSObject

@property (nonatomic, strong) NSString *endUserEmail;
@property (nonatomic, strong) NSString *originURL;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *twitterHandler;
@property (nonatomic, strong) NSString *customProductName;
@property (nonatomic, strong) NSString *languageCode;
@property (nonatomic, strong) NSString *surveyType;
@property (nonatomic, assign) NSInteger surveyTypeScale;
@property (nonatomic, strong) NSDictionary *scale;
@property (nonatomic, strong) NSString *customAudience;
@property (nonatomic, strong) NSString *customFinalThankYou;
@property (nonatomic, strong) NSString *customQuestion;
@property (nonatomic, strong) NSString *externalId;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSNumber *registeredPercentage;
@property (nonatomic, strong) NSNumber *visitorPercentage;
@property (nonatomic, strong) NSNumber *resurveyThrottle;
@property (nonatomic, strong) NSNumber *declineResurveyThrottle;
@property (nonatomic, strong) NSNumber *dailyResponseCap;
@property (nonatomic, strong) NSNumber *externalCreatedAt;
@property (nonatomic, strong) NSNumber *firstSurveyAfter;
@property (nonatomic, strong) NSURL *facebookPage;
@property (nonatomic, strong) NSDictionary *customProperties;
@property (nonatomic, assign) NSInteger surveyedDefaultDuration;
@property (nonatomic, assign) NSInteger surveyedDefaultDurationDecline;
@property (nonatomic, assign) NSInteger timeDelay;
@property (nonatomic, assign) BOOL surveyImmediately;
@property (nonatomic, assign) BOOL forceSurvey;
@property (nonatomic, assign) BOOL setDefaultAfterSurvey;
@property (nonatomic, assign) BOOL skipFeedbackScreen;
@property (nonatomic, assign) BOOL passScoreAndTextToURL;
@property (nonatomic, strong) UIColor *sendButtonBackgroundColor;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *socialSharingColor;

- (void)parseDataFromSurveyServer:(NSDictionary *)surveyServerSettings;
- (int)maximumScore;
- (int)minimumScore;
- (NSDictionary *)scoreRules;
- (NSString *)getEndUserEmailOrUnknown;

- (NSString *)followupQuestionTextForScore:(int)score;
- (NSString *)followupPlaceholderTextForScore:(int)score;
- (NSString *)questionText;
- (NSString *)likelyAnchorText;
- (NSString *)notLikelyAnchorText;
- (NSString *)finalThankYouText;
- (NSString *)sendButtonText;
- (NSString *)dismissButtonText;
- (NSString *)editScoreButtonText;
- (NSString *)socialShareQuestionText;
- (NSString *)socialShareDeclineText;


- (void)setThankYouButtonBackgroundColor:(UIColor *)thankYouButtonBackgroundColor;
- (UIColor *)thankYouButtonBackgroundColor;

- (void)setCustomFollowupPlaceholderForPromoter:(NSString *)promoterPlaceholder passive:(NSString *)passivePlaceholder detractor:(NSString *)detractorPlaceholder;
- (void)setCustomFollowupQuestionForPromoter:(NSString *)promoterQuestion passive:(NSString *)passiveQuestion detractor:(NSString *)detractorQuestion;

- (void)setThankYouMessage:(NSString *)thankYouMessage;
- (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage;
- (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage;
- (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage;
- (void)setThankYouLinkWithText:(NSString *)thankYouLinkText URL:(NSURL *)thankYouLinkURL;
- (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText URL:(NSURL *)detractorThankYouLinkURL;
- (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText URL:(NSURL *)passiveThankYouLinkURL;
- (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText URL:(NSURL *)promoterThankYouLinkURL;

- (NSString *)thankYouMessageDependingOnScore:(int)score;
- (NSString *)thankYouLinkTextDependingOnScore:(int)score;
- (NSURL *)thankYouLinkURLDependingOnScore:(int)score andText:(NSString *)text;
- (BOOL)thankYouLinkConfiguredForScore:(int)score;

- (BOOL)twitterHandlerSet;
- (BOOL)facebookPageSet;

- (void)setCustomResurveyThrottle:(NSNumber *)customResurveyThrottle;
- (void)setCustomVisitorPercentage:(NSNumber *)customVisitorPercentage;
- (void)setCustomRegisteredPercentage:(NSNumber *)customRegisteredPercentage;
- (void)setCustomDailyResponseCap:(NSNumber *)customDailyResponseCap;

@end

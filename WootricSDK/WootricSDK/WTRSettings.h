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

@interface WTRSettings : NSObject

@property (nonatomic, strong) NSString *endUserEmail;
@property (nonatomic, strong) NSString *originURL;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSDictionary *language;
@property (nonatomic, strong) NSDictionary *customProperties;
@property (nonatomic, assign) NSInteger externalCreatedAt;
@property (nonatomic, assign) NSInteger firstSurveyAfter;
@property (nonatomic, assign) NSInteger surveyedDefaultDuration;
@property (nonatomic, assign) BOOL surveyImmediately;
@property (nonatomic, assign) BOOL forceSurvey;
@property (nonatomic, assign) BOOL setDefaultAfterSurvey;

- (void)parseDataFromSurveyServer:(NSDictionary *)surveyServerSettings;

- (NSString *)followupQuestionTextForScore:(int)score;
- (NSString *)followupPlaceholderTextForScore:(int)score;
- (NSString *)npsQuestionText;
- (NSString *)likelyAnchorText;
- (NSString *)notLikelyAnchorText;
- (NSString *)finalThankYouText;
- (NSString *)sendButtonText;
- (NSString *)dismissButtonText;
- (NSString *)socialShareQuestionText;
- (NSString *)socialShareDeclineText;

- (void)setThankYouMessage:(NSString *)thankYouMessage;
- (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage;
- (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage;
- (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage;
- (void)setThankYouLinkWithText:(NSString *)thankYouLinkText andURL:(NSURL *)thankYouLinkURL;
- (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText andURL:(NSURL *)detractorThankYouLinkURL;
- (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText andURL:(NSURL *)passiveThankYouLinkURL;
- (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText andURL:(NSURL *)promoterThankYouLinkURL;

- (NSString *)thankYouMessageDependingOnScore:(int)score;
- (NSString *)thankYouLinkTextDependingOnScore:(int)score;
- (NSURL *)thankYouLinkURLDependingOnScore:(int)score;

@end
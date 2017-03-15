//
//  SEGWootric.m
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

#import "SEGWootric.h"
#import "Wootric.h"

@implementation SEGWootric

- (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret accountToken:(NSString *)accountToken {
  [Wootric configureWithClientID:clientID clientSecret:clientSecret accountToken:accountToken];
}

- (void)showSurveyInViewController:(UIViewController *)viewController {
  [Wootric showSurveyInViewController:viewController];
}

- (void)setEndUserCreatedAt:(NSNumber *)externalCreatedAt {
  [Wootric setEndUserCreatedAt:externalCreatedAt];
}

- (void)setEndUserEmail:(NSString *)endUserEmail {
  [Wootric setEndUserEmail:endUserEmail];
}

- (void)setProductNameForEndUser:(NSString *)productName {
  [Wootric setProductNameForEndUser:productName];
}

- (void)setCustomLanguage:(NSString *)languageCode {
  [Wootric setCustomLanguage:languageCode];
}

- (void)setCustomAudience:(NSString *)audience {
  [Wootric setCustomAudience:audience];
}

- (void)setCustomProductName:(NSString *)productName {
  [Wootric setCustomProductName:productName];
}

- (void)setCustomFinalThankYou:(NSString *)finalThankYou {
  [Wootric setCustomFinalThankYou:finalThankYou];
}

- (void)setCustomQuestion:(NSString *)question {
  [Wootric setCustomQuestion:question];
}

- (void)setEndUserProperties:(NSDictionary *)customProperties {
  [Wootric setEndUserProperties:customProperties];
}

- (NSDictionary *)endUserProperties {
  return [Wootric endUserProperties];
}

- (void)setFirstSurveyAfter:(NSNumber *)firstSurveyAfter {
  [Wootric setFirstSurveyAfter:firstSurveyAfter];
}

- (void)setSurveyedDefault:(BOOL)flag {
  [Wootric setSurveyedDefault:flag];
}

- (void)surveyImmediately:(BOOL)flag {
  [Wootric surveyImmediately:flag];
}

- (void)forceSurvey:(BOOL)flag {
  [Wootric forceSurvey:flag];
}

- (void)skipFeedbackScreenForPromoter:(BOOL)flag {
  [Wootric skipFeedbackScreenForPromoter:flag];
}

- (void)passScoreAndTextToURL:(BOOL)flag {
  [Wootric passScoreAndTextToURL:flag];
}

- (void)setFacebookPage:(NSURL *)facebookPage {
  [Wootric setFacebookPage:facebookPage];
}

- (void)setTwitterHandler:(NSString *)twitterHandler {
  [Wootric setTwitterHandler:twitterHandler];
}

- (void)setThankYouMessage:(NSString *)thankYouMessage {
  [Wootric setThankYouMessage:thankYouMessage];
}

- (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage {
  [Wootric setDetractorThankYouMessage:detractorThankYouMessage];
}

- (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage {
  [Wootric setPassiveThankYouMessage:passiveThankYouMessage];
}

- (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage {
  [Wootric setPromoterThankYouMessage:promoterThankYouMessage];
}

- (void)setThankYouLinkWithText:(NSString *)thankYouLinkText URL:(NSURL *)thankYouLinkURL {
  [Wootric setThankYouLinkWithText:thankYouLinkText URL:thankYouLinkURL];
}

- (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText URL:(NSURL *)detractorThankYouLinkURL {
  [Wootric setDetractorThankYouLinkWithText:detractorThankYouLinkText URL:detractorThankYouLinkURL];
}

- (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText URL:(NSURL *)passiveThankYouLinkURL {
  [Wootric setPassiveThankYouLinkWithText:passiveThankYouLinkText URL:passiveThankYouLinkURL];
}

- (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText URL:(NSURL *)promoterThankYouLinkURL {
  [Wootric setPromoterThankYouLinkWithText:promoterThankYouLinkText URL:promoterThankYouLinkURL];
}

- (void)setCustomFollowupPlaceholderForPromoter:(NSString *)promoterPlaceholder passive:(NSString *)passivePlaceholder detractor:(NSString *)detractorPlaceholder {
  [Wootric setCustomFollowupPlaceholderForPromoter:promoterPlaceholder passive:passivePlaceholder detractor:detractorPlaceholder];
}

- (void)setCustomFollowupQuestionForPromoter:(NSString *)promoterQuestion passive:(NSString *)passiveQuestion detractor:(NSString *)detractorQuestion {
  [Wootric setCustomFollowupPlaceholderForPromoter:promoterQuestion passive:passiveQuestion detractor:detractorQuestion];
}

#pragma mark - Custom Values For Eligibility

- (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle visitorPercentage:(NSNumber *)visitorPercentage registeredPercentage:(NSNumber *)registeredPercentage dailyResponseCap:(NSNumber *)dailyResponseCap {
  [Wootric setCustomValueForResurveyThrottle:resurveyThrottle visitorPercentage:visitorPercentage registeredPercentage:registeredPercentage dailyResponseCap:dailyResponseCap];
}

#pragma mark - Color Customization

- (void)setSendButtonBackgroundColor:(UIColor *)color {
  [Wootric setSendButtonBackgroundColor:color];
}

- (void)setSliderColor:(UIColor *)color {
  [Wootric setSliderColor:color];
}

- (void)setSocialSharingColor:(UIColor *)color {
  [Wootric setSocialSharingColor:color];
}

- (void)setThankYouButtonBackgroundColor:(UIColor *)color {
  [Wootric setThankYouButtonBackgroundColor:color];
}

@end

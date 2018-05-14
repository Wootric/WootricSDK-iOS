//
//  SEGWootric.h
//  WootricSDK
//
// Copyright (c) 2018 Wootric (https://wootric.com)
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

// This class sole purpose is to make accessing Wootric configuration from Segment-Wootric easier for user of the latter
// It is subject to change as the amount of code duplicated is making me sad, but hey, deadlines.

@interface SEGWootric : NSObject

/*!
 @brief It configures the SDK with required parameters.
 @param clientID Found in API section of the Wootric's admin panel.
 @param clientSecret Found in API section of the Wootric's admin panel.
 @param accountToken Found in Install section of the Wootric's admin panel.
 */
- (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret accountToken:(NSString *)accountToken;
/*!
 @brief It shows survey if end user is eligible.
 @param viewController View controller in which you would like to display the survey.
 */
- (void)showSurveyInViewController:(UIViewController *)viewController;
/*!
 @brief It sets end user's account creation date to provided value (UNIX Timestamp truncated to seconds).
 @param externalCreatedAt UNIX Timestamp truncated to seconds.
 */
- (void)setEndUserCreatedAt:(NSNumber *)externalCreatedAt;
- (void)setEndUserEmail:(NSString *)endUserEmail;
- (void)setProductNameForEndUser:(NSString *)productName;
- (void)setCustomLanguage:(NSString *)languageCode;
- (void)setCustomAudience:(NSString *)audience;
- (void)setCustomProductName:(NSString *)productName;
- (void)setCustomFinalThankYou:(NSString *)finalThankYou;
- (void)setCustomQuestion:(NSString *)question;
- (void)setEndUserProperties:(NSDictionary *)customProperties;
- (NSDictionary *)endUserProperties;
- (void)setFirstSurveyAfter:(NSNumber *)firstSurveyAfter;
- (void)setSurveyedDefault:(BOOL)flag;
- (void)surveyImmediately:(BOOL)flag;
- (void)forceSurvey:(BOOL)flag;
- (void)skipFeedbackScreenForPromoter:(BOOL)flag;
- (void)passScoreAndTextToURL:(BOOL)flag;

- (void)setFacebookPage:(NSURL *)facebookPage;
- (void)setTwitterHandler:(NSString *)twitterHandler;

- (void)setThankYouMessage:(NSString *)thankYouMessage;
- (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage;
- (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage;
- (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage;
- (void)setThankYouLinkWithText:(NSString *)thankYouLinkText URL:(NSURL *)thankYouLinkURL;
- (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText URL:(NSURL *)detractorThankYouLinkURL;
- (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText URL:(NSURL *)passiveThankYouLinkURL;
- (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText URL:(NSURL *)promoterThankYouLinkURL;

- (void)setCustomFollowupPlaceholderForPromoter:(NSString *)promoterPlaceholder passive:(NSString *)passivePlaceholder detractor:(NSString *)detractorPlaceholder;
- (void)setCustomFollowupQuestionForPromoter:(NSString *)promoterQuestion passive:(NSString *)passiveQuestion detractor:(NSString *)detractorQuestion;

- (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle visitorPercentage:(NSNumber *)visitorPercentage registeredPercentage:(NSNumber *)registeredPercentage dailyResponseCap:(NSNumber *)dailyResponseCap;

- (void)setSendButtonBackgroundColor:(UIColor *)color;
- (void)setSliderColor:(UIColor *)color;
- (void)setThankYouButtonBackgroundColor:(UIColor *)color;
- (void)setSocialSharingColor:(UIColor *)color;

- (void)setLogLevelNone;
- (void)setLogLevelError;
- (void)setLogLevelVerbose;
- (void)showOptOut:(BOOL)flag;

@end

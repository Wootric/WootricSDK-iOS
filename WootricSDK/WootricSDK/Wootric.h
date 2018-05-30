//
//  WootricSDK.h
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

@interface Wootric : NSObject

/**
 @discussion It configures the SDK with required parameters.
 @param clientID Found in API section of the Wootric's admin panel.
 @param clientSecret Found in API section of the Wootric's admin panel.
 @param accountToken Found in Install section of the Wootric's admin panel.
*/
+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret accountToken:(NSString *)accountToken;

/**
 @discussion It configures the SDK with required parameters.
 @param clientID Found in API section of the Wootric's admin panel.
 @param accountToken Found in Install section of the Wootric's admin panel.
 */
+ (void)configureWithClientID:(NSString *)clientID accountToken:(NSString *)accountToken;

/**
 @discussion It shows survey if end user is eligible.
 @param viewController View controller in which you would like to display the survey.
*/
+ (void)showSurveyInViewController:(UIViewController *)viewController;
/**
 @discussion It sets end user's account creation date to provided value (UNIX Timestamp truncated to seconds).
 @param externalCreatedAt UNIX Timestamp truncated to seconds.
*/
+ (void)setEndUserCreatedAt:(NSNumber *)externalCreatedAt;
/**
 @discussion It sets end user's email.
 @param endUserEmail NSString of the end user's email.
*/
+ (void)setEndUserEmail:(NSString *)endUserEmail;
/**
 @discussion It sets an end user's external id.
 @param externalId NSString of the end user's external id.
 */
+ (void)setEndUserExternalId:(NSString *)externalId;
/**
 @discussion It sets end user's phone number.
 @param phoneNumber NSString of the end user's phone number.
 */
+ (void)setEndUserPhoneNumber:(NSString *)phoneNumber;
/**
 @discussion Adds a product name to end user's properties.
 @param productName NSString of the end user's product name.
*/
+ (void)setProductNameForEndUser:(NSString *)productName;
/**
 @discussion It sets the language of the survey e.g. 'ES', 'FR', 'CN_S'.
 @see http://docs.wootric.com/install/#custom-language-setting for a complete list of supported languages and their codes.
 @param languageCode NSString of the language code.
*/
+ (void)setCustomLanguage:(NSString *)languageCode;
/**
 @discussion It sets the audience of the survey.
 e.g. How likely are you to recommend this product or service to customAudience?
 @param audience NSString of the custom audience.
*/
+ (void)setCustomAudience:(NSString *)audience;
/**
 @discussion It sets the product name for the end user. This will change the default question.
 e.g. How likely are you to recommend customProductName to a friend or co-worker?
 @param productName NSString of the product name to be shown to the end user.
*/
+ (void)setCustomProductName:(NSString *)productName;
/**
 @discussion It sets the final Thank You message shown at the end of the survey.
 The default Thank You message is "Thank you for yor response, and your feedback!"
 @param finalThankYou NSString of the custom final Thank You message.
*/
+ (void)setCustomFinalThankYou:(NSString *)finalThankYou;
/**
 @discussion It sets the question of the survey.
 @param question NSString of the custom question.
*/
+ (void)setCustomQuestion:(NSString *)question;
/**
 @discussion It sets an NSDictionary with properties to be added to the end user.
 An example of this would be to add a 'company' and 'type':
 @code NSDictionary *endUserProperties = @{@"company" : @"Wootric", @"type" : @"awesome"};
 [Wootric setEndUserProperties:endUserProperties];
 @param customProperties NSDictionary containing custom properties.
*/
+ (void)setEndUserProperties:(NSDictionary *)customProperties;
/**
 @discussion Returns an NSDictionary of the end user properties.
 @return NSDictionary of endUserProperties.
*/
+ (NSDictionary *)endUserProperties;
/**
 @discussion Used to check if end user was created/last seen earlier than ago and therefore if survey is required.
 @param firstSurveyAfter An NSNumber representing the days after the first survey should be shown.
*/
+ (void)setFirstSurveyAfter:(NSNumber *)firstSurveyAfter;
/**
 @discussion Right after a vote or dismiss we are setting a NSUserDefault that lasts for 90 days and indicates that end user was already surveyed on this device. We are doing this to lower the requests amount to our eligibility server. If your survey throttle is different than 90 days and/or you don't want to set the surveyed "cookie" you can set this option to NO.
 @param flag A boolean to set the surveyed default.
*/
+ (void)setSurveyedDefault:(BOOL)flag;
/**
 @discussion If surveyImmediately is set to YES and user wasn't surveyed yet - eligibility check will return "true" and survey will be displayed.
 @warning This shouldn't be used on production.
 @param flag A boolean to set if the end user should be surveyed immediately.
*/
+ (void)surveyImmediately:(BOOL)flag;
/**
 @discussion If forceSurvey is set to YES, the survey is displayed skipping eligibility check AND even if user was already surveyed.
 @warning This is for test purposes only as it will display the survey every time and for every user.
 @param flag A boolean to force the survey.
*/
+ (void)forceSurvey:(BOOL)flag;
/**
 @discussion With this option enabled, promoters (score 9-10) will be taken directly to third screen, skipping the second (feedback) one.
 @param flag A boolean to set if the feedback screen should be skipped.
*/
+ (void)skipFeedbackScreenForPromoter:(BOOL)flag;
/**
 @discussion If you enable this setting, score and feedback text will be added as wootric_score and wootric_text params to the "thank you" URL you have provided. (Check "Custom Thank You" section)
 @see setThankYouMessage
 @param flag A boolean to set if the score and text should be passed to the custom "thank you" URL
*/
+ (void)passScoreAndTextToURL:(BOOL)flag;

/**
 @discussion If configured, a third screen for promoters (score 9-10) will show a Facebook like (thumbs up) button and a share button
 @param facebookPage A NSURL to the Facebook page.
*/
+ (void)setFacebookPage:(NSURL *)facebookPage;
/**
 @discussion If configured, a third screen for promoters (score 9-10) will show a Twitter share button
 @param twitterHandler NSString with the Twitter handler.
*/
+ (void)setTwitterHandler:(NSString *)twitterHandler;

/**
 @discussion If configured, a default custom thank you message will display for any score.
 @param thankYouMessage NSString of thank you message.
*/
+ (void)setThankYouMessage:(NSString *)thankYouMessage;
/**
 @discussion If configured, a custom thank you message will display for detractors (score 0-6).
 @param detractorThankYouMessage NSString of thank you message for detractors.
*/
+ (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage;
/**
 @discussion If configured, a custom thank you message will display for passive end users (score 7-8).
 @param passiveThankYouMessage NSString of thank you message for passive end users.
*/
+ (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage;
/**
 @discussion If configured, a custom thank you message will display for promoters (score 9-10).
 @param promoterThankYouMessage NSString of thank you message for promoters.
*/
+ (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage;
/**
 @discussion If configured, a default custom thank you button will display for any score.
 @param thankYouLinkText NSString with the link text.
 @param thankYouLinkURL NSURL with the address to which the end user will be redirected.
*/
+ (void)setThankYouLinkWithText:(NSString *)thankYouLinkText URL:(NSURL *)thankYouLinkURL;
/**
 @discussion If configured, a custom thank you button will display detractors (score 0-6).
 @param detractorThankYouLinkText NSString with the detractor's link text.
 @param detractorThankYouLinkURL NSURL with the address to which the detractor end user will be redirected.
*/
+ (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText URL:(NSURL *)detractorThankYouLinkURL;
/**
 @discussion If configured, a custom thank you button will display passive end users (score 7-8).
 @param passiveThankYouLinkText NSString with the passive end user's link text.
 @param passiveThankYouLinkURL NSURL with the address to which the passive end user will be redirected.
*/
+ (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText URL:(NSURL *)passiveThankYouLinkURL;
/**
 @discussion If configured, a custom thank you button will display promoters (score 9-10).
 @param promoterThankYouLinkText NSString with the promoter's link text.
 @param promoterThankYouLinkURL NSURL with the address to which the promoter end user will be redirected.
*/
+ (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText URL:(NSURL *)promoterThankYouLinkURL;

/**
 @discussion This method allows you to set custom placeholder text in feedback text view for each type of end user. Be advised that this setting takes precedence over values set in Wootric's from admin panel.
 @param promoterPlaceholder NSString placeholder for promoters (score 9-10).
 @param passivePlaceholder NSString placeholder for passives (score 7-8).
 @param detractorPlaceholder NSString placeholder for detractors (score 0-6).
*/
+ (void)setCustomFollowupPlaceholderForPromoter:(NSString *)promoterPlaceholder passive:(NSString *)passivePlaceholder detractor:(NSString *)detractorPlaceholder;
/**
 @discussion This method allows you to set custom question for each type of end user (detractor, passive or promoter). Passing nil for any of the parameters will result in using defaults set in Wootric's admin panel for that type of end user.
 @param promoterQuestion NSString question for promoters (score 9-10).
 @param passiveQuestion NSString question for passives (score 7-8).
 @param detractorQuestion NSString question for detractors (score 0-6).
*/
+ (void)setCustomFollowupQuestionForPromoter:(NSString *)promoterQuestion passive:(NSString *)passiveQuestion detractor:(NSString *)detractorQuestion;

/**
 @discussion This method will alter the values of resurvey throttle, tested visitor, registered users percentage and daily response cap used for eligibility check.
 @param resurveyThrottle NSNumber representing number of days for resurvey throttle.
 @param visitorPercentage NSNumber from 0-100.
 @param registeredPercentage NSNumber from 0-100.
 @param dailyResponseCap NSNumber greater than 0.
*/
+ (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle visitorPercentage:(NSNumber *)visitorPercentage registeredPercentage:(NSNumber *)registeredPercentage dailyResponseCap:(NSNumber *)dailyResponseCap;

/**
 @discussion Change the time delay to show the survey (in seconds).
 @param customTimeDelay NSInteger representing number of seconds to show the survey.
 */
+ (void)setCustomTimeDelay:(NSInteger)customTimeDelay;

/**
 @discussion Changes the color of the Send button and the No thanks button on the sharing view.
 @param color UIColor for the Send button.
*/
+ (void)setSendButtonBackgroundColor:(UIColor *)color;
/**
 @discussion Changes the color of the score slider and the Edit Score button on the feedback view.
 @param color UIColor for the slider and Edit Score button.
*/
+ (void)setSliderColor:(UIColor *)color;
/**
 @discussion Changes the color of the Thank You button on the sharing view.
 @param color UIColor for the Thank You button.
*/
+ (void)setThankYouButtonBackgroundColor:(UIColor *)color;
/**
 @discussion Changes the color of Facebook, Twitter and Thumbs up button on the sharing view.
 @param color UIColor for social sharing buttons.
*/
+ (void)setSocialSharingColor:(UIColor *)color;
/**
 @discussion Set WTRLogger level to None i.e. it won't show any log from the WootricSDK.
 */
+ (void)setLogLevelNone;
/**
 @discussion Set WTRLogger level to Error i.e. it will only show error logs from the WootricSDK.
 */
+ (void)setLogLevelError;
/**
 @discussion Set WTRLogger level to Verbose i.e. it will show all logs from the WootricSDK.
 */
+ (void)setLogLevelVerbose;
/**
 @discussion If showOptOut is set to YES, it will show an option for the end user to opt out of being surveyed. Default value is NO.
 @param flag A boolean to show the opt out option.
 */
+ (void)showOptOut:(BOOL)flag;
/**
 @discussion Notification posted when the survey view is about to be presented.
 */
+ (NSNotificationName)surveyWillAppearNotification;
/**
 @discussion Notification posted when the survey view is about to be dismissed.
 */
+ (NSNotificationName)surveyWillDisappearNotification;
/**
 @discussion Notification posted when the survey view appears.
 */
+ (NSNotificationName)surveyDidAppearNotification;
/**
 @discussion Notification posted when the survey view disappears, with userInfo as follows: `score` The NPS score as a NSNumber. `voted` Boolean NSNumber indicating whether the user voted or not.
 */
+ (NSNotificationName)surveyDidDisappearNotification;
@end

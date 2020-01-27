//
//  WootricSDK.m
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

#import "Wootric.h"
#import "WTRSurvey.h"
#import "WTRSurveyViewController.h"
#import "WTRDefaultNotificationCenter.h"
#import "WTRiPADSurveyViewController.h"
#import "WTRApiClient.h"
#import "WTRLogger.h"
#import "WTRSurveyDelegate.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

static id<WTRSurveyDelegate> _delegate = nil;

@implementation Wootric

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret accountToken:(NSString *)accountToken {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.clientID = clientID;
  apiClient.clientSecret = clientSecret;
  apiClient.accountToken = accountToken;
}

+ (void)configureWithClientID:(NSString *)clientID accountToken:(NSString *)accountToken {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.clientID = clientID;
  apiClient.accountToken = accountToken;
}

+ (void)setEndUserEmail:(NSString *)endUserEmail {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.endUserEmail = endUserEmail;
}

+ (void)setEndUserCreatedAt:(NSNumber *)externalCreatedAt {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.externalCreatedAt = externalCreatedAt;
}

+ (void)setEndUserExternalId:(NSString *)externalId {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.externalId = externalId;
}

+ (void)setEndUserPhoneNumber:(NSString *)phoneNumber {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.phoneNumber = phoneNumber;
}

+ (void)setCustomAudience:(NSString *)audience {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.customAudience = audience;
}

+ (void)setCustomLanguage:(NSString *)languageCode {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.languageCode = languageCode;
}

+ (void)setCustomProductName:(NSString *)productName {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.customProductName = productName;
}

+ (void)setCustomFinalThankYou:(NSString *)finalThankYou {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.customFinalThankYou = finalThankYou;
}

+ (void)setCustomQuestion:(NSString *)question {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.customQuestion = question;
}

+ (void)setSurveyedDefault:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.setDefaultAfterSurvey = flag;
}

+ (void)forceSurvey:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.forceSurvey = flag;
}

+ (void)setSurveyTypeScale:(NSInteger)surveyTypeScale {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.surveyTypeScale = surveyTypeScale;
}

+ (void)showOptOut:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.showOptOut = flag;
}

+ (void)surveyImmediately:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.surveyImmediately = flag;
}

+ (void)setEndUserProperties:(NSDictionary *)customProperties {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.customProperties = [NSMutableDictionary dictionaryWithDictionary:customProperties];
}

+ (NSDictionary *)endUserProperties {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  return apiClient.settings.customProperties;
}

+ (void)setProductNameForEndUser:(NSString *)productName {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.productName = productName;
}

+ (void)setFirstSurveyAfter:(NSNumber *)firstSurveyAfter {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.firstSurveyAfter = firstSurveyAfter;
}

+ (void)skipFeedbackScreenForPromoter:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.skipFeedbackScreenForPromoter = flag;
}

+ (void)skipFeedbackScreen:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.skipFeedbackScreen = flag;
}

+ (void) passScoreAndTextToURL:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.passScoreAndTextToURL = flag;
}

+ (void)passEmailInURL:(BOOL)emailInURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  if (emailInURL) {
    [apiClient.settings setEmailInURL:1];
  } else {
    [apiClient.settings setEmailInURL:0];
  }
}

+ (void)passPromoterEmailInURL:(BOOL)promoterEmailInURL passiveEmailInURL:(BOOL)passiveEmailInURL detractorEmailInURL:(BOOL)detractorEmailInURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  int promoter = -1;
  int passive = -1;
  int detractor = -1;
  if (promoterEmailInURL) {
    promoter = 1;
  } else {
    promoter = 0;
  }
  if (passiveEmailInURL) {
    passive = 1;
  } else {
    passive = 0;
  }
  if (detractorEmailInURL) {
    detractor = 1;
  } else {
    detractor = 0;
  }
  
  [apiClient.settings setPromoterEmailInURL:promoter passiveEmailInURL:passive detractorEmailInURL:detractor];
}

+ (void)passScoreInURL:(BOOL)scoreInURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  if (scoreInURL) {
    [apiClient.settings setScoreInURL:1];
  } else {
    [apiClient.settings setScoreInURL:0];
  }
}

+ (void)passPromoterScoreInURL:(BOOL)promoterScoreInURL passiveScoreInURL:(BOOL)passiveScoreInURL detractorScoreInURL:(BOOL)detractorScoreInURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  int promoter = -1;
  int passive = -1;
  int detractor = -1;
  if (promoterScoreInURL) {
    promoter = 1;
  } else {
    promoter = 0;
  }
  if (passiveScoreInURL) {
    passive = 1;
  } else {
    passive = 0;
  }
  if (detractorScoreInURL) {
    detractor = 1;
  } else {
    detractor = 0;
  }
  
  [apiClient.settings setPromoterScoreInURL:promoter passiveScoreInURL:passive detractorScoreInURL:detractor];
}

+ (void)passCommentInURL:(BOOL)commentInURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  if (commentInURL) {
    [apiClient.settings setCommentInURL:1];
  } else {
    [apiClient.settings setCommentInURL:0];
  }
}

+ (void)passPromoterCommentInURL:(BOOL)promoterCommentInURL passiveCommentInURL:(BOOL)passiveCommentInURL detractorCommentInURL:(BOOL)detractorCommentInURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  int promoter = -1;
  int passive = -1;
  int detractor = -1;
  if (promoterCommentInURL) {
    promoter = 1;
  } else {
    promoter = 0;
  }
  if (passiveCommentInURL) {
    passive = 1;
  } else {
    passive = 0;
  }
  if (detractorCommentInURL) {
    detractor = 1;
  } else {
    detractor = 0;
  }
  
  [apiClient.settings setPromoterCommentInURL:promoter passiveCommentInURL:passive detractorCommentInURL:detractor];
}

+ (void)showSurveyInViewController:(UIViewController *)viewController {
    
  if ([[WTRApiClient sharedInstance] checkConfiguration]) {
    WTRSurvey *surveyClient = [[WTRSurvey alloc] init];
    [surveyClient survey:^{
      [WTRLogger log:@"presenting survey view"];
      WTRApiClient *apiClient = [WTRApiClient sharedInstance];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(presentSurveyInViewController:)
                   withObject:viewController
                   afterDelay:apiClient.settings.timeDelay];
      });
    }];
  } else {
    [WTRLogger log:@"Configure SDK first"];
  }
}

+ (void)presentSurveyInViewController:(UIViewController *)viewController {
  WTRSettings *surveySettings = [WTRApiClient sharedInstance].settings;
  
  if (IPAD) {
    WTRiPADSurveyViewController *surveyViewController = [[WTRiPADSurveyViewController alloc] initWithSurveySettings:surveySettings
                                                                                                 notificationCenter:[[WTRDefaultNotificationCenter alloc] initWithNotificationCenter:[NSNotificationCenter defaultCenter]]];
    [viewController presentViewController:surveyViewController animated:YES completion:nil];
  } else {
    WTRSurveyViewController *surveyViewController = [[WTRSurveyViewController alloc] initWithSurveySettings:surveySettings
                                                                                         notificationCenter:[[WTRDefaultNotificationCenter alloc] initWithNotificationCenter:[NSNotificationCenter defaultCenter]]];
    [viewController presentViewController:surveyViewController animated:YES completion:nil];
  }
}

#pragma mark - Social Share

+ (void)setTwitterHandler:(NSString *)twitterHandler {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setTwitterHandler:twitterHandler];
}

+ (void)setFacebookPage:(NSURL *)facebookPage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setFacebookPage:facebookPage];
}

#pragma mark - Custom Thanks

+ (void)setThankYouMessage:(NSString *)thankYouMessage {
  [self setThankYouMain:thankYouMessage];
}

+ (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage {
  [self setDetractorThankYouMain:detractorThankYouMessage];
}

+ (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage {
  [self setPassiveThankYouMain:passiveThankYouMessage];
}

+ (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage {
  [self setPromoterThankYouMain:promoterThankYouMessage];
}

+ (void)setThankYouMain:(NSString *)thankYouMain {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setThankYouMain:thankYouMain];
}

+ (void)setDetractorThankYouMain:(NSString *)detractorThankYouMain {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setDetractorThankYouMain:detractorThankYouMain];
}

+ (void)setPassiveThankYouMain:(NSString *)passiveThankYouMain {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPassiveThankYouMain:passiveThankYouMain];
}

+ (void)setPromoterThankYouMain:(NSString *)promoterThankYouMain {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPromoterThankYouMain:promoterThankYouMain];
}

+ (void)setThankYouLinkWithText:(NSString *)thankYouLinkText URL:(NSURL *)thankYouLinkURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setThankYouLinkWithText:thankYouLinkText URL:thankYouLinkURL];
}

+ (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText URL:(NSURL *)detractorThankYouLinkURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setDetractorThankYouLinkWithText:detractorThankYouLinkText URL:detractorThankYouLinkURL];
}

+ (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText URL:(NSURL *)passiveThankYouLinkURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPassiveThankYouLinkWithText:passiveThankYouLinkText URL:passiveThankYouLinkURL];
}

+ (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText URL:(NSURL *)promoterThankYouLinkURL {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPromoterThankYouLinkWithText:promoterThankYouLinkText URL:promoterThankYouLinkURL];
}

#pragma mark - Application Set Custom Messages

+ (void)setCustomFollowupPlaceholderForPromoter:(NSString *)promoterPlaceholder passive:(NSString *)passivePlaceholder detractor:(NSString *)detractorPlaceholder {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setCustomFollowupPlaceholderForPromoter:promoterPlaceholder passive:passivePlaceholder detractor:detractorPlaceholder];
}

+ (void)setCustomFollowupQuestionForPromoter:(NSString *)promoterQuestion passive:(NSString *)passiveQuestion detractor:(NSString *)detractorQuestion {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setCustomFollowupQuestionForPromoter:promoterQuestion passive:passiveQuestion detractor:detractorQuestion];
}

#pragma mark - Custom Values For Eligibility

+ (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle visitorPercentage:(NSNumber *)visitorPercentage registeredPercentage:(NSNumber *)registeredPercentage dailyResponseCap:(NSNumber *)dailyResponseCap {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setCustomResurveyThrottle:resurveyThrottle];
  [apiClient.settings setCustomVisitorPercentage:visitorPercentage];
  [apiClient.settings setCustomRegisteredPercentage:registeredPercentage];
  [apiClient.settings setCustomDailyResponseCap:dailyResponseCap];
}

+ (void)setCustomTimeDelay:(NSInteger)customTimeDelay {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setCustomTimeDelay:customTimeDelay];
}

#pragma mark - Color Customization

+ (void)setSendButtonBackgroundColor:(UIColor *)color {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setSendButtonBackgroundColor:color];
}

+ (void)setSliderColor:(UIColor *)color {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setSliderColor:color];
}

+ (void)setSocialSharingColor:(UIColor *)color {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setSocialSharingColor:color];
}

+ (void)setThankYouButtonBackgroundColor:(UIColor *)color {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setThankYouButtonBackgroundColor:color];
}

#pragma mark - WTRLogger setters

+ (void)setLogLevelNone {
  [WTRLogger setLogLevel:WTRLogLevelNone];
}

+ (void)setLogLevelError {
  [WTRLogger setLogLevel:WTRLogLevelError];
}

+ (void)setLogLevelVerbose {
  [WTRLogger setLogLevel:WTRLogLevelVerbose];
}

#pragma mark - Notifications

+ (NSNotificationName)surveyWillAppearNotification {
  return @"com.wootric.surveyWillAppearNotification";
}

+ (NSNotificationName)surveyWillDisappearNotification {
  return @"com.wootric.surveyWillDisappearNotification";
}

+ (NSNotificationName)surveyDidAppearNotification {
  return @"com.wootric.surveyDidAppearNotification";
}

+ (NSNotificationName)surveyDidDisappearNotification {
  return @"com.wootric.surveyDidDisappearNotification";
}

#pragma mark - Delegate

+ (void)setDelegate:(id<WTRSurveyDelegate>)delegate {
  _delegate = delegate;
}

+ (id<WTRSurveyDelegate>)delegate {
  return _delegate;
}

@end

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
#import "WTRLogger.h"
#import "WTRSurveyDelegate.h"

static id<WTRSurveyDelegate> _delegate = nil;
static UIViewController *_presentedViewController;
static WTRSettings *_presentedSettings;

@implementation Wootric

+ (void)configureWithAccountToken:(NSString *)accountToken {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.accountToken = accountToken;
}

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret accountToken:(NSString *)accountToken {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.clientID = clientID;
  surveyClient.clientSecret = clientSecret;
  surveyClient.accountToken = accountToken;
}

+ (void)configureWithClientID:(NSString *)clientID accountToken:(NSString *)accountToken {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.clientID = clientID;
  surveyClient.accountToken = accountToken;
}

+ (void)setEndUserEmail:(NSString *)endUserEmail {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.endUserEmail = endUserEmail;
}

+ (void)setEndUserCreatedAt:(NSNumber *)externalCreatedAt {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.externalCreatedAt = externalCreatedAt;
}

+ (void)setEndUserExternalId:(NSString *)externalId {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.externalId = externalId;
}

+ (void)setEndUserPhoneNumber:(NSString *)phoneNumber {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.phoneNumber = phoneNumber;
}

+ (void)setCustomAudience:(NSString *)audience {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.customAudience = audience;
}

+ (void)setCustomLanguage:(NSString *)languageCode {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.languageCode = languageCode;
}

+ (void)setCustomProductName:(NSString *)productName {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.customProductName = productName;
}

+ (void)setCustomFinalThankYou:(NSString *)finalThankYou {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.customFinalThankYou = finalThankYou;
}

+ (void)setCustomQuestion:(NSString *)question {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.customQuestion = question;
}

+ (void)setSurveyedDefault:(BOOL)flag {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.setDefaultAfterSurvey = flag;
}

+ (void)forceSurvey:(BOOL)flag {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.forceSurvey = flag;
}

+ (void)setSurveyTypeScale:(NSInteger)surveyTypeScale {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.surveyTypeScale = surveyTypeScale;
}

+ (void)showOptOut:(BOOL)flag {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.showOptOut = flag;
}

+ (void)surveyImmediately:(BOOL)flag {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.surveyImmediately = flag;
}

+ (void)setEndUserProperties:(NSDictionary *)customProperties {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.customProperties = [NSMutableDictionary dictionaryWithDictionary:customProperties];
}

+ (void)setEventName:(NSString *)eventName {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.eventName = eventName;
}

+ (NSDictionary *)endUserProperties {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  return surveyClient.settings.customProperties;
}

+ (void)setProductNameForEndUser:(NSString *)productName {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.productName = productName;
}

+ (void)setFirstSurveyAfter:(NSNumber *)firstSurveyAfter {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.firstSurveyAfter = firstSurveyAfter;
}

+ (void)skipFeedbackScreenForPromoter:(BOOL)flag {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.skipFeedbackScreenForPromoter = flag;
}

+ (void)skipFeedbackScreen:(BOOL)flag {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.skipFeedbackScreen = flag;
}

+ (void) passScoreAndTextToURL:(BOOL)flag {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  surveyClient.settings.passScoreAndTextToURL = flag;
}

+ (void)passEmailInURL:(BOOL)emailInURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  if (emailInURL) {
    [surveyClient.settings setEmailInURL:1];
  } else {
    [surveyClient.settings setEmailInURL:0];
  }
}

+ (void)passPromoterEmailInURL:(BOOL)promoterEmailInURL passiveEmailInURL:(BOOL)passiveEmailInURL detractorEmailInURL:(BOOL)detractorEmailInURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
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
  
  [surveyClient.settings setPromoterEmailInURL:promoter passiveEmailInURL:passive detractorEmailInURL:detractor];
}

+ (void)passScoreInURL:(BOOL)scoreInURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  if (scoreInURL) {
    [surveyClient.settings setScoreInURL:1];
  } else {
    [surveyClient.settings setScoreInURL:0];
  }
}

+ (void)passPromoterScoreInURL:(BOOL)promoterScoreInURL passiveScoreInURL:(BOOL)passiveScoreInURL detractorScoreInURL:(BOOL)detractorScoreInURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
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
  
  [surveyClient.settings setPromoterScoreInURL:promoter passiveScoreInURL:passive detractorScoreInURL:detractor];
}

+ (void)passCommentInURL:(BOOL)commentInURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  if (commentInURL) {
    [surveyClient.settings setCommentInURL:1];
  } else {
    [surveyClient.settings setCommentInURL:0];
  }
}

+ (void)passPromoterCommentInURL:(BOOL)promoterCommentInURL passiveCommentInURL:(BOOL)passiveCommentInURL detractorCommentInURL:(BOOL)detractorCommentInURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
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
  
  [surveyClient.settings setPromoterCommentInURL:promoter passiveCommentInURL:passive detractorCommentInURL:detractor];
}

+ (void)stop {
  if (_presentedViewController == nil || _presentedSettings == nil) {
    [WTRLogger log:@"No survey triggered."];
    return;
  }
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  
  [surveyClient stopSurvey];
  
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(presentSurveyInViewController:) object:@[_presentedViewController, _presentedSettings]];
  if (_presentedViewController != nil) {
    [_presentedViewController dismissViewControllerAnimated:YES completion:^{
      
    }];
  }
  
  [WTRLogger log:@"Stopping survey..."];
}

+ (void)showSurveyInViewController:(UIViewController *)viewController event:(NSString *)eventName {
  [self setEventName:eventName];
  [self showSurveyInViewController:viewController];
}

+ (void)showSurveyInViewController:(UIViewController *)viewController {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  if ([surveyClient checkConfiguration]) {
    [surveyClient survey:^(WTRSettings *settings){
      [WTRLogger log:@"presenting survey view"];
       
      _presentedViewController = viewController;
      _presentedSettings = settings;
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(presentSurveyInViewController:)
                   withObject:@[viewController, settings]
                   afterDelay:settings.timeDelay];
        
        [[[WTRDefaultNotificationCenter alloc] initWithNotificationCenter:[NSNotificationCenter defaultCenter]] postNotificationName:[Wootric surveyWillAppearNotification] object:self];
        [[Wootric delegate] willPresentSurvey];
      });
    }];
  } else {
    [WTRLogger log:@"Configure SDK first"];
  }
}

+ (void)presentSurveyInViewController:(NSArray *)objects {
  UIViewController *viewController = objects[0];
  WTRSettings *settings = objects[1];

  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    WTRiPADSurveyViewController *surveyViewController = [[WTRiPADSurveyViewController alloc] initWithSurveySettings:settings
                                                                                                 notificationCenter:[[WTRDefaultNotificationCenter alloc ]initWithNotificationCenter:[NSNotificationCenter defaultCenter]]];
    [viewController presentViewController:surveyViewController animated:YES completion:nil];
  } else {
    WTRSurveyViewController *surveyViewController = [[WTRSurveyViewController alloc] initWithSurveySettings:settings
                                                                                         notificationCenter:[[WTRDefaultNotificationCenter alloc]
                                                                                 initWithNotificationCenter:[NSNotificationCenter defaultCenter]]];
    [viewController presentViewController:surveyViewController animated:YES completion:nil];
  }
}

#pragma mark - Social Share

+ (void)setTwitterHandler:(NSString *)twitterHandler {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setTwitterHandler:twitterHandler];
}

+ (void)setFacebookPage:(NSURL *)facebookPage {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setFacebookPage:facebookPage];
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
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setThankYouMain:thankYouMain];
}

+ (void)setDetractorThankYouMain:(NSString *)detractorThankYouMain {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setDetractorThankYouMain:detractorThankYouMain];
}

+ (void)setPassiveThankYouMain:(NSString *)passiveThankYouMain {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setPassiveThankYouMain:passiveThankYouMain];
}

+ (void)setPromoterThankYouMain:(NSString *)promoterThankYouMain {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setPromoterThankYouMain:promoterThankYouMain];
}

+ (void)setThankYouLinkWithText:(NSString *)thankYouLinkText URL:(NSURL *)thankYouLinkURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setThankYouLinkWithText:thankYouLinkText URL:thankYouLinkURL];
}

+ (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText URL:(NSURL *)detractorThankYouLinkURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setDetractorThankYouLinkWithText:detractorThankYouLinkText URL:detractorThankYouLinkURL];
}

+ (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText URL:(NSURL *)passiveThankYouLinkURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setPassiveThankYouLinkWithText:passiveThankYouLinkText URL:passiveThankYouLinkURL];
}

+ (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText URL:(NSURL *)promoterThankYouLinkURL {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setPromoterThankYouLinkWithText:promoterThankYouLinkText URL:promoterThankYouLinkURL];
}

#pragma mark - Application Set Custom Messages

+ (void)setCustomFollowupPlaceholderForPromoter:(NSString *)promoterPlaceholder passive:(NSString *)passivePlaceholder detractor:(NSString *)detractorPlaceholder {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setCustomFollowupPlaceholderForPromoter:promoterPlaceholder passive:passivePlaceholder detractor:detractorPlaceholder];
}

+ (void)setCustomFollowupQuestionForPromoter:(NSString *)promoterQuestion passive:(NSString *)passiveQuestion detractor:(NSString *)detractorQuestion {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setCustomFollowupQuestionForPromoter:promoterQuestion passive:passiveQuestion detractor:detractorQuestion];
}

#pragma mark - Custom Values For Eligibility

+ (void)setCustomValueForResurveyThrottle:(NSNumber *)resurveyThrottle visitorPercentage:(NSNumber *)visitorPercentage registeredPercentage:(NSNumber *)registeredPercentage dailyResponseCap:(NSNumber *)dailyResponseCap {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setCustomResurveyThrottle:resurveyThrottle];
  [surveyClient.settings setCustomVisitorPercentage:visitorPercentage];
  [surveyClient.settings setCustomRegisteredPercentage:registeredPercentage];
  [surveyClient.settings setCustomDailyResponseCap:dailyResponseCap];
}

+ (void)setCustomTimeDelay:(NSInteger)customTimeDelay {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setCustomTimeDelay:customTimeDelay];
}

#pragma mark - Color Customization

+ (void)setSendButtonBackgroundColor:(UIColor *)color {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setSendButtonBackgroundColor:color];
}

+ (void)setSliderColor:(UIColor *)color {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setSliderColor:color];
}

+ (void)setSocialSharingColor:(UIColor *)color {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setSocialSharingColor:color];
}

+ (void)setThankYouButtonBackgroundColor:(UIColor *)color {
  WTRSurvey *surveyClient = [WTRSurvey sharedInstance];
  [surveyClient.settings setThankYouButtonBackgroundColor:color];
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

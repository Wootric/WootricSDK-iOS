//
//  WootricSDK.m
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

#import "Wootric.h"
#import "WTRTrackingPixel.h"
#import "WTRSurvey.h"
#import "WTRSurveyViewController.h"
#import "WTRiPADSurveyViewController.h"
#import "WTRApiClient.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@implementation Wootric

+ (void)configureWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret accountToken:(NSString *)accountToken {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.clientID = clientID;
  apiClient.clientSecret = clientSecret;
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

+ (void)surveyImmediately:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.surveyImmediately = flag;
}

+ (void)setEndUserProperties:(NSDictionary *)customProperties {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.customProperties = customProperties;
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
  apiClient.settings.skipFeedbackScreen = flag;
}

+ (void)passScoreAndTextToURL:(BOOL)flag {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.passScoreAndTextToURL = flag;
}

+ (void)showSurveyInViewController:(UIViewController *)viewController {
    
  if ([[WTRApiClient sharedInstance] checkConfiguration]) {
    
    [WTRTrackingPixel getPixel];
    
    WTRSurvey *surveyClient = [[WTRSurvey alloc] init];
    [surveyClient survey:^{
        
      NSLog(@"WootricSDK: presenting survey view");
      
      WTRApiClient *apiClient = [WTRApiClient sharedInstance];
      
      dispatch_async(dispatch_get_main_queue(), ^{

        [self performSelector:@selector(presentSurveyInViewController:)
                   withObject:viewController
                   afterDelay:apiClient.settings.timeDelay];
      });
        
    }];
  } else {
    NSLog(@"WootricSDK: Configure SDK first");
  }
}

+ (void)presentSurveyInViewController:(UIViewController *)viewController {
  WTRSettings *surveySettings = [WTRApiClient sharedInstance].settings;
  
  if (IPAD) {
    WTRiPADSurveyViewController *surveyViewController = [[WTRiPADSurveyViewController alloc] initWithSurveySettings:surveySettings];
    [viewController presentViewController:surveyViewController animated:YES completion:nil];
  } else {
    WTRSurveyViewController *surveyViewController = [[WTRSurveyViewController alloc] initWithSurveySettings:surveySettings];
    [viewController presentViewController:surveyViewController animated:YES completion:nil];
  }
}

#pragma mark - Social Share

+ (void)setTwitterHandler:(NSString *)twitterHandler {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.twitterHandler = twitterHandler;
}

+ (void)setFacebookPage:(NSURL *)facebookPage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.settings.facebookPage = facebookPage;
}

#pragma mark - Custom Thanks

+ (void)setThankYouMessage:(NSString *)thankYouMessage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setThankYouMessage:thankYouMessage];
}

+ (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setDetractorThankYouMessage:detractorThankYouMessage];
}

+ (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPassiveThankYouMessage:passiveThankYouMessage];
}

+ (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  [apiClient.settings setPromoterThankYouMessage:promoterThankYouMessage];
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

@end

//
//  WTRWootricTests.m
//  WootricSDKTests
//
//  Created by Admin on 8/6/19.
//  Copyright © 2019 Wootric. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WootricSDK/WootricSDK.h>
#import "WTRSurvey.h"

@interface WTRWootricTests : XCTestCase

@property (nonatomic, strong) WTRSurvey *surveyClient;
@property (nonatomic, strong) UIColor *color;

@end

@implementation WTRWootricTests

- (void)setUp {
  [Wootric configureWithClientID:@"NPS-abc123" accountToken:@"abcdefg12345677"];
  _surveyClient = [WTRSurvey sharedInstance];
  _color = [UIColor colorWithRed:0.1f green:0.2f blue:0.3f alpha:1.0f];
}

- (void)testSetEndUserCreatedAt {
  NSNumber *endUserCreatedAt = @123;
  [Wootric setEndUserCreatedAt:endUserCreatedAt];
  
  XCTAssertEqualObjects(_surveyClient.settings.externalCreatedAt, endUserCreatedAt, @"externalCreatedAt should be equal to 123");
}

- (void)testSetEndUserEmail {
  static NSString *endUserEmail = @"test@example.com";
  [Wootric setEndUserEmail:endUserEmail];
  
  XCTAssertEqualObjects(_surveyClient.settings.endUserEmail, endUserEmail, @"endUserEmail should be equal to test@example.com");
}

- (void)testSetProductNameForEndUser {
  static NSString *productName = @"Example";
  [Wootric setProductNameForEndUser:@"Example"];
  
  XCTAssertEqualObjects(_surveyClient.settings.productName, productName, @"productName should be equal to Example");
}

- (void)testSetCustomLanguage {
  static NSString *language = @"Epañol";
  [Wootric setCustomLanguage:language];
  
  XCTAssertEqualObjects(_surveyClient.settings.languageCode, language, @"languageCode should be equal to Español");
}

- (void)testSetCustomAudience {
  static NSString *audience = @"Custom audience";
  [Wootric setCustomAudience:audience];
  
  XCTAssertEqualObjects(_surveyClient.settings.customAudience, audience, @"customAudience should be equal to Custom audience");
}

- (void)testSetCustomProductName {
  static NSString *customProductName = @"Custom product";
  [Wootric setCustomProductName:customProductName];
  
  XCTAssertEqualObjects(_surveyClient.settings.customProductName, customProductName, @"customProductName should be equal to Custom product");
}

- (void)testSetCustomFinalThankYou {
  static NSString *customFinalThankYou = @"CustomFinalThankYou";
  [Wootric setCustomFinalThankYou:customFinalThankYou];
  XCTAssertEqualObjects(_surveyClient.settings.customFinalThankYou, customFinalThankYou, @"customFinalThankYou should be equal to CustomFinalThankYou");
}

- (void)testSetCustomQuestion {
  static NSString *customQuestion = @"Would you recommend this to a friend?";
  [Wootric setCustomQuestion:customQuestion];
  
  XCTAssertEqualObjects(_surveyClient.settings.customQuestion, customQuestion, @"customQuestion should be equal to Would you recommend this to a friend?");
}

- (void)testSetEndUserProperties {
  NSDictionary *endUserProperties = @{@"email": @"test@example.com"};
  [Wootric setEndUserProperties:endUserProperties];
  
  XCTAssertEqualObjects(_surveyClient.settings.customProperties, endUserProperties, @"customProperties should be equal to @{@\"email\": @\"test@example.com\"}");
  XCTAssertEqualObjects([_surveyClient.settings.customProperties objectForKey:@"email"], @"test@example.com", @"email should be equal to test@example.com");
}

- (void)testSetFirstSurveyAfter {
  [Wootric setFirstSurveyAfter:@0];
  XCTAssertEqualObjects(_surveyClient.settings.firstSurveyAfter, @0, @"firstSurveyAfter should be equal to 0");
  [Wootric setFirstSurveyAfter:@15];
  XCTAssertEqualObjects(_surveyClient.settings.firstSurveyAfter, @15, @"firstSurveyAfter should be equal to 15");
}

- (void)testSetSurveyedDefault {
  XCTAssertTrue(_surveyClient.settings.setDefaultAfterSurvey, @"setDefaultAfterSurvey should be true");
  [Wootric setSurveyedDefault:NO];
  XCTAssertFalse(_surveyClient.settings.setDefaultAfterSurvey, @"setDefaultAfterSurvey should be false");
}

- (void)testSurveyImmediately {
  [Wootric surveyImmediately:YES];
  XCTAssertTrue(_surveyClient.settings.surveyImmediately, @"surveyImmediately should be true");
  [Wootric surveyImmediately:NO];
  XCTAssertFalse(_surveyClient.settings.surveyImmediately, @"surveyImmediately should be false");
}

- (void)testForceSurvey {
  [Wootric forceSurvey:YES];
  
  XCTAssertTrue(_surveyClient.settings.forceSurvey, @"forceSurvey should be true");
}

- (void)testSkipFeedbackScreenForPromoter {
  [Wootric skipFeedbackScreenForPromoter:NO];
  XCTAssertFalse(_surveyClient.settings.skipFeedbackScreenForPromoter, @"skipFeedbackScreenForPromoter should be false");
  [Wootric skipFeedbackScreenForPromoter:YES];
  XCTAssertTrue(_surveyClient.settings.skipFeedbackScreenForPromoter, @"skipFeedbackScreenForPromoter should be true");
}

- (void)testSkipFeedbackScreen {
  [Wootric skipFeedbackScreen:NO];
  XCTAssertFalse(_surveyClient.settings.skipFeedbackScreen, @"skipFeedbackScreen should be false");
  [Wootric skipFeedbackScreen:YES];
  XCTAssertTrue(_surveyClient.settings.skipFeedbackScreen, @"skipFeedbackScreen should be true");
}

- (void)testPassScoreAndTextToURL {
  [Wootric passScoreAndTextToURL:NO];
  
  XCTAssertFalse(_surveyClient.settings.passScoreAndTextToURL, @"passScoreAndTextToURL should be false");
  
  [Wootric passScoreAndTextToURL:YES];
  
  XCTAssertTrue(_surveyClient.settings.passScoreAndTextToURL, @"passScoreAndTextToURL should be true");
}

- (void)testSetFacebookPage {
  NSURL *url = [NSURL URLWithString:@"facebook.com/test"];
  [Wootric setFacebookPage:url];
  
  XCTAssertEqualObjects(_surveyClient.settings.facebookPage, url, @"facebookPage should be facebook.com/test");
}

- (void)testSetTwitterHandler {
  static NSString *twitterHandler = @"twitter";
  [Wootric setTwitterHandler:twitterHandler];
  
  XCTAssertEqualObjects(_surveyClient.settings.twitterHandler, twitterHandler, @"twitterHandler should be twitter");
}

- (void)testSetSendButtonBackgroundColor {
  [Wootric setSendButtonBackgroundColor:_color];
  
  XCTAssertEqualObjects(_surveyClient.settings.sendButtonBackgroundColor, _color, @"sendButtonBackgroundColor should equal to color");
}

- (void)testSetSliderColor {
  [Wootric setSliderColor:_color];
  
  XCTAssertEqualObjects(_surveyClient.settings.sliderColor, _color, @"sliderColor should equal to color");
}

- (void)testSetThankYouButtonBackgroundColor {
  [Wootric setThankYouButtonBackgroundColor:_color];
  
  XCTAssertEqualObjects(_surveyClient.settings.thankYouButtonBackgroundColor, _color, @"thankYouButtonBackgroundColor should equal to color");
}

- (void)testSetSocialSharingColor {
  [Wootric setSocialSharingColor:_color];
  
  XCTAssertEqualObjects(_surveyClient.settings.socialSharingColor, _color, @"socialSharingColor should equal to color");
}

- (void)testShowOptOutDefaultNo {
  XCTAssertFalse(_surveyClient.settings.showOptOut, @"showOptOut default value should be NO");
}

- (void)testSetShowOptOut {
  [Wootric showOptOut:YES];
  
  XCTAssertTrue(_surveyClient.settings.showOptOut, @"showOptOut default value should be YES");
  _surveyClient.settings.showOptOut = NO;
}

@end

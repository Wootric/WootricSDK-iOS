//
//  SEGWootricTests.m
//  WootricSDKTests
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

#import <XCTest/XCTest.h>
#import "WTRApiClient.h"
#import "SEGWootric.h"

@interface SEGWootricTests : XCTestCase

@property (nonatomic, strong) WTRApiClient *apiClient;
@property (nonatomic, strong) SEGWootric *segWootric;
@property (nonatomic, strong) UIColor *color;

@end

@implementation SEGWootricTests

- (void)setUp {
  [super setUp];
  _apiClient = [WTRApiClient sharedInstance];
  _segWootric = [[SEGWootric alloc] init];
  _color = [UIColor colorWithRed:0.1f green:0.2f blue:0.3f alpha:1.0f];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testConfiguration {
  static NSString *clientId = @"testClientID";
  static NSString *clientSecret = @"testClientSecret";
  static NSString *accountToken = @"NP-Token";
  [_segWootric configureWithClientID:clientId clientSecret:clientSecret accountToken:accountToken];
  
  XCTAssertEqualObjects(_apiClient.clientID, clientId, @"clientID should be equal to testClientID");
  XCTAssertEqualObjects(_apiClient.clientSecret, clientSecret, @"clientSecret should be equal to testClientSecret");
  XCTAssertEqualObjects(_apiClient.accountToken, accountToken, @"accountToken should be equal to NP-Token");
  
  _apiClient.clientID = nil;
  _apiClient.clientSecret = nil;
  _apiClient.accountToken = nil;
}

- (void)testSetEndUserCreatedAt {
  NSNumber *endUserCreatedAt = @123;
  [_segWootric setEndUserCreatedAt:endUserCreatedAt];
  
  XCTAssertEqualObjects(_apiClient.settings.externalCreatedAt, endUserCreatedAt, @"externalCreatedAt should be equal to 123");
  
  _apiClient.settings.externalCreatedAt = nil;
}

- (void)testSetEndUserEmail {
  static NSString *endUserEmail = @"test@example.com";
  [_segWootric setEndUserEmail:endUserEmail];
  
  XCTAssertEqualObjects(_apiClient.settings.endUserEmail, endUserEmail, @"endUserEmail should be equal to test@example.com");
  
  _apiClient.settings.endUserEmail = nil;
}

- (void)testSetProductNameForEndUser {
  static NSString *productName = @"Example";
  [_segWootric setProductNameForEndUser:@"Example"];
  
  XCTAssertEqualObjects(_apiClient.settings.productName, productName, @"productName should be equal to Example");
  
  _apiClient.settings.productName = nil;
}

- (void)testSetCustomLanguage {
  static NSString *language = @"Epañol";
  [_segWootric setCustomLanguage:language];
  
  XCTAssertEqualObjects(_apiClient.settings.languageCode, language, @"languageCode should be equal to Español");
  
  _apiClient.settings.languageCode = nil;
}

- (void)testSetCustomAudience {
  static NSString *audience = @"Custom audience";
  [_segWootric setCustomAudience:audience];
  
  XCTAssertEqualObjects(_apiClient.settings.customAudience, audience, @"customAudience should be equal to Custom audience");
  
  _apiClient.settings.customAudience = nil;
}

- (void)testSetCustomProductName {
  static NSString *customProductName = @"Custom product";
  [_segWootric setCustomProductName:customProductName];
  
  XCTAssertEqualObjects(_apiClient.settings.customProductName, customProductName, @"customProductName should be equal to Custom product");
  
  _apiClient.settings.customProductName = nil;
}

- (void)testSetCustomFinalThankYou {
  static NSString *customFinalThankYou = @"CustomFinalThankYou";
  [_segWootric setCustomFinalThankYou:customFinalThankYou];
  
  XCTAssertEqualObjects(_apiClient.settings.customFinalThankYou, customFinalThankYou, @"customFinalThankYou should be equal to CustomFinalThankYou");
  
  _apiClient.settings.customFinalThankYou = nil;
}

- (void)testSetCustomQuestion {
  static NSString *customQuestion = @"Would you recommend this to a friend?";
  [_segWootric setCustomQuestion:customQuestion];
  
  XCTAssertEqualObjects(_apiClient.settings.customQuestion, customQuestion, @"customQuestion should be equal to Would you recommend this to a friend?");
  
  _apiClient.settings.customQuestion = nil;
}

- (void)testSetEndUserProperties {
  NSDictionary *endUserProperties = @{@"email": @"test@example.com"};
  [_segWootric setEndUserProperties:endUserProperties];

  XCTAssertEqualObjects(_apiClient.settings.customProperties, endUserProperties, @"customProperties should be equal to @{@\"email\": @\"test@example.com\"}");
  
  XCTAssertEqualObjects([_apiClient.settings.customProperties objectForKey:@"email"], @"test@example.com", @"email should be equal to test@example.com");
  
  _apiClient.settings.customProperties = nil;
  
}

- (void)testSetFirstSurveyAfter {
  XCTAssertEqualObjects(_apiClient.settings.firstSurveyAfter, @0, @"firstSurveyAfter should be equal to 0");
  
  [_segWootric setFirstSurveyAfter:@15];
  
  XCTAssertEqualObjects(_apiClient.settings.firstSurveyAfter, @15, @"firstSurveyAfter should be equal to 15");
  
  _apiClient.settings.firstSurveyAfter = nil;
  
}

- (void)testSetSurveyedDefault {
  XCTAssertTrue(_apiClient.settings.setDefaultAfterSurvey, @"setDefaultAfterSurvey should be true");
  
  [_segWootric setSurveyedDefault:NO];

  XCTAssertFalse(_apiClient.settings.setDefaultAfterSurvey, @"setDefaultAfterSurvey should be false");
  
  _apiClient.settings.setDefaultAfterSurvey = YES;
}

- (void)testSurveyImmediately {
  [_segWootric surveyImmediately:YES];
  
  XCTAssertTrue(_apiClient.settings.surveyImmediately, @"surveyImmediately should be true");
  
  [_segWootric surveyImmediately:NO];
  
  XCTAssertFalse(_apiClient.settings.surveyImmediately, @"surveyImmediately should be false");
}

- (void)testForceSurvey {
  [_segWootric forceSurvey:YES];
  
  XCTAssertTrue(_apiClient.settings.forceSurvey, @"forceSurvey should be true");
  
  _apiClient.settings.forceSurvey = NO;
}

- (void)testSkipFeedbackScreenForPromoter {
  [_segWootric skipFeedbackScreenForPromoter:NO];
  
  XCTAssertFalse(_apiClient.settings.skipFeedbackScreen, @"skipFeedbackScreen should be false");
  
  [_segWootric skipFeedbackScreenForPromoter:YES];
  
  XCTAssertTrue(_apiClient.settings.skipFeedbackScreen, @"skipFeedbackScreen should be true");
  
  _apiClient.settings.skipFeedbackScreen = NO;
  
}

- (void)testPassScoreAndTextToURL {
  [_segWootric passScoreAndTextToURL:NO];
  
  XCTAssertFalse(_apiClient.settings.passScoreAndTextToURL, @"passScoreAndTextToURL should be false");
  
  [_segWootric passScoreAndTextToURL:YES];
  
  XCTAssertTrue(_apiClient.settings.passScoreAndTextToURL, @"passScoreAndTextToURL should be true");
  
  _apiClient.settings.passScoreAndTextToURL = NO;
}

- (void)testSetFacebookPage {
  NSURL *url = [NSURL URLWithString:@"facebook.com/test"];
  [_segWootric setFacebookPage:url];
  
  XCTAssertEqualObjects(_apiClient.settings.facebookPage, url, @"facebookPage should be facebook.com/test");
  
  _apiClient.settings.facebookPage = nil;
}

- (void)testSetTwitterHandler {
  static NSString *twitterHandler = @"twitter";
  [_segWootric setTwitterHandler:twitterHandler];
  
  XCTAssertEqualObjects(_apiClient.settings.twitterHandler, twitterHandler, @"twitterHandler should be twitter");
  
  _apiClient.settings.twitterHandler = nil;
  
}

- (void)testSetSendButtonBackgroundColor {
  [_segWootric setSendButtonBackgroundColor:_color];
  
  XCTAssertEqualObjects(_apiClient.settings.sendButtonBackgroundColor, _color, @"sendButtonBackgroundColor should equal to color");
  
  _apiClient.settings.sendButtonBackgroundColor = nil;
}

- (void)testSetSliderColor {
  [_segWootric setSliderColor:_color];
  
  XCTAssertEqualObjects(_apiClient.settings.sliderColor, _color, @"sliderColor should equal to color");
  
  _apiClient.settings.sliderColor = nil;
}

- (void)testSetThankYouButtonBackgroundColor {
  
  [_segWootric setThankYouButtonBackgroundColor:_color];
  
  XCTAssertEqualObjects(_apiClient.settings.thankYouButtonBackgroundColor, _color, @"thankYouButtonBackgroundColor should equal to color");
  
  _apiClient.settings.thankYouButtonBackgroundColor = nil;
}

- (void)testSetSocialSharingColor {
  
  [_segWootric setSocialSharingColor:_color];
  
  XCTAssertEqualObjects(_apiClient.settings.socialSharingColor, _color, @"socialSharingColor should equal to color");
  
  _apiClient.settings.socialSharingColor = nil;
}

- (void)testShowOptOutDefaultNo {
  XCTAssertFalse(_apiClient.settings.showOptOut, @"showOptOut default value should be NO");
}

- (void)testSetShowOptOut {
  [_segWootric showOptOut:YES];

  XCTAssertTrue(_apiClient.settings.showOptOut, @"showOptOut default value should be YES");

  _apiClient.settings.showOptOut = NO;
}

@end

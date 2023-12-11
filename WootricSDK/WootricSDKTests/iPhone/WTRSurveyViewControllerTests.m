//
//  WTRSurveyControllerTests.m
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
#import "WTRSurveyViewController.h"
#import "WTRApiClient.h"
#import "Wootric.h"
#import "WTRSurveyDelegate.h"
#import "WTRDelegateMockViewController.h"
#import "WTRMockNotificationCenter.h"

@interface WTRSurveyViewControllerTests : XCTestCase
@property (nonatomic, strong) WTRSurveyViewController *viewController;
@property (nonatomic, strong) WTRDelegateMockViewController *testViewController;
@property (nonatomic, strong) WTRMockNotificationCenter *notificationCenter;
@property (nonatomic, strong) WTRApiClient *apiClient;
@property (nonatomic, strong) WTRSettings *settings;
@end

@interface WTRSurveyViewController (Tests)
@property (nonatomic, strong) NSString *accountToken;
- (NSURL *)optOutURL;
@end

@implementation WTRSurveyViewControllerTests

- (void)setUp {
  [super setUp];
  _apiClient = [WTRApiClient sharedInstance];
  _settings = [WTRSettings new];
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"NPS"]];
  [Wootric configureWithClientID:@"id123" accountToken:@"nps-test"];
  _testViewController = [[WTRDelegateMockViewController alloc] init];
  [Wootric setDelegate:_testViewController];
  _notificationCenter = [WTRMockNotificationCenter new];
  _viewController = [[WTRSurveyViewController alloc] initWithSurveySettings:_settings
                                                         notificationCenter:_notificationCenter];
}

- (void)tearDown {
  [super tearDown];
  _notificationCenter = nil;
  _viewController = nil;
  _testViewController = nil;
}

- (void)testViewWillDisappear {
  [_viewController viewWillDisappear:YES];
  XCTAssertEqual([Wootric surveyWillDisappearNotification], _notificationCenter.notifications.firstObject, @"notification not equal to 'com.wootric.surveyWillDisappearNotification'");
  XCTAssertTrue(_testViewController.willHideSurveyBool, @"willHideSurvey callback not executed");
}

- (void)testViewDidAppear {
  [_viewController viewDidAppear:YES];
  XCTAssertEqual([Wootric surveyDidAppearNotification], _notificationCenter.notifications.firstObject, @"notification not equal to 'com.wootric.surveyDidAppearNotification'");
  XCTAssertTrue(_testViewController.didPresentSurveyBool, @"didPresentSurvey callback not executed");
}

- (void)testViewDidDisappear {
  [_viewController viewDidDisappear:YES];
  XCTAssertEqual([Wootric surveyDidDisappearNotification], _notificationCenter.notifications.firstObject, @"notification not equal to 'com.wootric.surveyDidDisappearNotification'");
  XCTAssertTrue(_testViewController.didHideSurveyBool, @"didHideSurvey callback not executed");
}

- (void)testOptOutUrl {
  XCTAssertTrue([[[_viewController optOutURL] absoluteString] hasPrefix:@"https://app.wootric.com/"]);

  [_viewController setAccountToken:@"NPS-EU-"];

  XCTAssertTrue([[[_viewController optOutURL] absoluteString] hasPrefix:@"https://app.wootric.eu/"]);
  
  [_viewController setAccountToken:@"NPS-AU-"];

  XCTAssertTrue([[[_viewController optOutURL] absoluteString] hasPrefix:@"https://app.wootric.au/"]);
}

- (NSDictionary *)surveyServerSettingsForMode:(NSString *)mode {
  NSDictionary *settings = @{
    @"eligible": @1,
    @"settings": @{
      @"time_delay": @10,
      @"first_survey": @30,
      @"resurvey_throttle": @180,
      @"decline_resurvey_throttle": @30,
      @"survey_type": mode,
      @"localized_texts": @{
        @"nps_question": @"How likely are you to recommend Wootric to a friend or co-worker?",
        @"anchors": @{
          @"likely": @"Extremely likely",
          @"not_likely": @"Not at all likely"
        },
        @"ces_question": @"How easy was it for you to use Wootric?",
        @"ces_anchors": @{
          @"very_difficult": @"Very difficult",
          @"difficult": @"Difficult",
          @"somewhat_difficult": @"Somewhat difficult",
          @"neutral": @"Neutral",
          @"somewhat_easy": @"Somewhat easy",
          @"easy": @"Easy",
          @"very_easy": @"Very easy"
        },
        @"csat_question": @"How satisfied are you with Wootric?",
        @"csat_anchors": @{
          @"very_unsatisfied": @"Very unsatisfied",
          @"unsatisfied": @"Unsatisfied",
          @"neutral": @"Neutral",
          @"satisfied": @"Satisfied",
          @"very_satisfied": @"Very satisfied"
        },
        @"dismiss": @"dismiss",
        @"followup_placeholder": @"Help us by explaining your score.",
        @"followup_question": @"Thank you! Care to tell us why?",
        @"final_thank_you": @"Thank you for your response, and your feedback!",
        @"send": @"send",
        @"edit_score": @"edit",
        @"social_share": @{
          @"decline": @"No thanks...",
          @"question": @"Would you be willing to share your positive comments?"
        }
      },
      @"language": @"en"
    }
  };

  return settings;
}

@end

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
#import "WTRiPADSurveyViewController.h"
#import "WTRApiClient.h"
#import "Wootric.h"
#import "WTRSurveyDelegate.h"
#import "WTRDelegateMockViewController.h"
#import "WTRMockNotificationCenter.h"

@interface WTRiPADSurveyViewControllerTests : XCTestCase
@property (nonatomic, strong) WTRiPADSurveyViewController *viewController;
@property (nonatomic, strong) WTRDelegateMockViewController *testViewController;
@property (nonatomic, strong) WTRMockNotificationCenter *notificationCenter;
@end

@implementation WTRiPADSurveyViewControllerTests

- (void)setUp {
  [super setUp];
  _testViewController = [[WTRDelegateMockViewController alloc] init];
  [Wootric setDelegate:_testViewController];
  _notificationCenter = [WTRMockNotificationCenter new];
  _viewController = [[WTRiPADSurveyViewController alloc] initWithSurveySettings:[WTRApiClient sharedInstance].settings
                                                             notificationCenter:_notificationCenter];
}

- (void)tearDown {
  [super tearDown];
  _notificationCenter = nil;
  _viewController = nil;
  _testViewController = nil;
}

- (void)testViewWillAppear {
  [_viewController viewWillAppear:YES];
  XCTAssertEqual([Wootric surveyWillAppearNotification], _notificationCenter.notifications.firstObject, @"notification not equal to 'com.wootric.surveyWillAppearNotification'");
  XCTAssertTrue(_testViewController.willPresentSurveyBool, @"willPresentSurvey callback not executed");
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

@end

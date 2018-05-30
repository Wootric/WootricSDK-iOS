//
//  WTRSurveyTests.m
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
#import "WTRSurvey.h"
#import "WTRApiClient.h"
#import "WTRDefaults.h"

@interface WTRSurveyTests : XCTestCase

@property (nonatomic, strong) WTRApiClient *apiClient;
@property (nonatomic, strong) WTRSurvey *surveyClient;

@end

@interface WTRSurvey (Tests)

- (BOOL)needsSurvey;

@end

@implementation WTRSurveyTests

- (void)setUp {
  [super setUp];
  _apiClient = [WTRApiClient sharedInstance];
  _surveyClient = [[WTRSurvey alloc] init];
  _apiClient.settings.setDefaultAfterSurvey = YES;
}

- (void)tearDown {
  [super tearDown];
  _apiClient.settings.externalCreatedAt = nil;
  _apiClient.settings.surveyImmediately = NO;
  _apiClient.settings.firstSurveyAfter = @0;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"surveyed"];
  [defaults setDouble:0 forKey:@"lastSeenAt"];
  [defaults setObject:nil forKey:@"resurvey_days"];
}

// surveyImmediately = YES
- (void)testNeedsSurveyOne {
  _apiClient.settings.surveyImmediately = YES;
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// surveyImmediately = YES, surveyed = YES
- (void)testNeedsSurveyTwo {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  _apiClient.settings.surveyImmediately = YES;
  XCTAssertFalse([_surveyClient needsSurvey]);
}

// firstSurveyAfter = 31, externalCreatedAt = 32
- (void)testNeedsSurveyThree {
  _apiClient.settings.firstSurveyAfter = @31;
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:32]; // 32 days ago
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// firstSurveyAfter = 0, surveyed = N0
- (void)testNeedsSurveyFour {
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:32]; // 32 days ago
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// firstSurveyAfter = 0, surveyed = YES
- (void)testNeedsSurveyFive {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:32]; // 32 days ago
  XCTAssertFalse([_surveyClient needsSurvey]);
}

// surveyed > 90 days, surveyed = YES
- (void)testNeedsSurveySix {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setDouble:[[self createdDaysAgo:95] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// surveyed > 90 days, surveyed = YES, type = response
- (void)testNeedsSurveySeven {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setObject:@"response" forKey:@"type"];
  [defaults setDouble:[[self createdDaysAgo:95] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// surveyed < 90 days, surveyed = YES, type = response
- (void)testNeedsSurveyEight {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setObject:@"response" forKey:@"type"];
  [defaults setDouble:[[self createdDaysAgo:85] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_surveyClient needsSurvey]);
}

// surveyed > 30 days, surveyed = YES, type = decline
- (void)testNeedsSurveyNine {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setObject:@"decline" forKey:@"type"];
  [defaults setDouble:[[self createdDaysAgo:35] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// surveyed < 30 days, surveyed = YES, type = decline
- (void)testNeedsSurveyTen {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setObject:@"decline" forKey:@"type"];
  [defaults setDouble:[[self createdDaysAgo:25] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_surveyClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 60, externalCreatedAt = 20, lastSeenAt = 40
- (void)testNeedsSurveyEleven {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[self createdDaysAgo:40] doubleValue] forKey:@"lastSeenAt"];
  _apiClient.settings.firstSurveyAfter = @60;
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:20];
  XCTAssertFalse([_surveyClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 31, externalCreatedAt = 20, lastSeenAt = 40
- (void)testNeedsSurveyTwelve {
  _apiClient.settings.firstSurveyAfter = @31;
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:20];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[self createdDaysAgo:40] doubleValue] forKey:@"lastSeenAt"];
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 2, externalCreatedAt = 2, lastSeenAt = 4
- (void)testNeedsSurveyThirteen {
  _apiClient.settings.firstSurveyAfter = @2;
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:2];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[self createdDaysAgo:4] doubleValue] forKey:@"lastSeenAt"];
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// surveyed = YES, surveyImmediately = NO, firstSurveyAfter = 0, setDefaultAfterSurvey = YES
- (void)testNeedsSurveyFourteen {
  _apiClient.settings.firstSurveyAfter = @0;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  XCTAssertFalse([_surveyClient needsSurvey]);
}

// surveyed = YES, surveyImmediately = NO, firstSurveyAfter = 0, setDefaultAfterSurvey = NO
- (void)testNeedsSurveyFifteen {
  _apiClient.settings.firstSurveyAfter = @0;
  _apiClient.settings.setDefaultAfterSurvey = NO;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 0, setDefaultAfterSurvey = YES
- (void)testNeedsSurveySixteen {
  _apiClient.settings.firstSurveyAfter = @0;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"surveyed"];
  XCTAssertTrue([_surveyClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 0, setDefaultAfterSurvey = NO
- (void)testNeedsSurveySeventeen {
  _apiClient.settings.firstSurveyAfter = @0;
  _apiClient.settings.setDefaultAfterSurvey = NO;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"surveyed"];
  [defaults setDouble:[[self createdDaysAgo:4] doubleValue] forKey:@"lastSeenAt"];
  XCTAssertTrue([_surveyClient needsSurvey]);
}

- (NSNumber *)createdDaysAgo:(int)daysAgo {
  return [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] - (daysAgo * 60 * 60 * 24)];
}

@end

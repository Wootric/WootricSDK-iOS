//
//  WTRDefaultsTests.m
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
#import "WTRDefaults.h"
#import "WTRApiClient.h"

@interface WTRDefaultsTests : XCTestCase

@property (nonatomic, strong) WTRApiClient *apiClient;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation WTRDefaultsTests

- (void)setUp {
  [super setUp];
  _apiClient = [WTRApiClient sharedInstance];
  _defaults = [NSUserDefaults standardUserDefaults];
}

- (void)tearDown {
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setObject:nil forKey:@"surveyed"];
  [_defaults setObject:nil forKey:@"lastSeenAt"];
  [_defaults setObject:nil forKey:@"surveyedAt"];
  _apiClient.settings.surveyedDefaultDurationDecline = 30;
  _apiClient.settings.surveyedDefaultDuration = 90;

  [super tearDown];
}

- (void)testSetLastSeenAtNotSet {
  [_defaults setDouble:0.0f forKey:@"lastSeenAt"];
  [WTRDefaults setLastSeenAt];
  XCTAssertNotEqual(0.0f, [[_defaults objectForKey:@"lastSeenAt"] doubleValue]);
}

- (void)testSetLastSeenAtGreaterThanTimestamp {
  double oldDate = [[self createdDaysAgo:91] doubleValue];
  [_defaults setDouble:oldDate forKey:@"lastSeenAt"];
  [WTRDefaults setLastSeenAt];
  XCTAssertNotEqual(oldDate, [[_defaults objectForKey:@"lastSeenAt"] doubleValue]);
}

- (void)testSetLastSeenAtLessThanTimestamp {
  double oldDate = [[self createdDaysAgo:89] doubleValue];
  [_defaults setDouble:oldDate forKey:@"lastSeenAt"];
  [WTRDefaults setLastSeenAt];
  XCTAssertEqual(oldDate, [[_defaults objectForKey:@"lastSeenAt"] doubleValue]);
}

- (void)testCheckIfSurveyedDefaultExpiredResponseNotSet {
  [_defaults setBool:YES forKey:@"surveyed"];
  [_defaults setObject:@"" forKey:@"type"];
  
  [_defaults setDouble:[[self createdDaysAgo:1] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
  
  [_defaults setDouble:[[self createdDaysAgo:35] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
  
  [_defaults setDouble:[[self createdDaysAgo:91] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (void)testCheckIfSurveyedDefaultExpiredIsResponse {
  [_defaults setObject:@"response" forKey:@"type"];
  [_defaults setBool:YES forKey:@"surveyed"];
  
  [_defaults setDouble:[[self createdDaysAgo:1] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
  
  [_defaults setDouble:[[self createdDaysAgo:31] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
  
  [_defaults setDouble:[[self createdDaysAgo:91] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (void)testCheckIfSurveyedDefaultExpiredIsDecline {
  [_defaults setObject:@"decline" forKey:@"type"];
  [_defaults setBool:YES forKey:@"surveyed"];
  
  [_defaults setDouble:[[self createdDaysAgo:1] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
  
  [_defaults setDouble:[[self createdDaysAgo:31] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (void)testCheckIfSurveyedDefaultExpiredIsResponseAndCustomDuration {
  [_defaults setObject:@"response" forKey:@"type"];
  [_defaults setBool:YES forKey:@"surveyed"];
  _apiClient.settings.surveyedDefaultDuration = 10;
  
  [_defaults setDouble:[[self createdDaysAgo:1] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
  
  [_defaults setDouble:[[self createdDaysAgo:11] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (void)testCheckIfSurveyedDefaultExpiredIsDeclineAndCustomDuration {
  [_defaults setObject:@"decline" forKey:@"type"];
  [_defaults setBool:YES forKey:@"surveyed"];
  _apiClient.settings.surveyedDefaultDurationDecline = 20;
  
  [_defaults setDouble:[[self createdDaysAgo:1] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
  
  [_defaults setDouble:[[self createdDaysAgo:21] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (void)testSetSurveyedWithTypeResponseAndAfterSurveyYES {
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setBool:NO forKey:@"surveyed"];
  _apiClient.settings.setDefaultAfterSurvey = YES;
  
  [WTRDefaults setSurveyedWithType:@"response"];
  
  XCTAssertEqualObjects([_defaults objectForKey:@"type"], @"response");
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
}

- (void)testSetSurveyedWithTypeResponseAndAfterSurveyNO {
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setBool:NO forKey:@"surveyed"];
  _apiClient.settings.setDefaultAfterSurvey = NO;
  
  [WTRDefaults setSurveyedWithType:@"response"];
  
  XCTAssertNotEqualObjects([_defaults objectForKey:@"type"], @"response");
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (void)testSetSurveyedWithTypeDeclineAndAfterSurveyYES {
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setBool:NO forKey:@"surveyed"];
  _apiClient.settings.setDefaultAfterSurvey = YES;
  
  [WTRDefaults setSurveyedWithType:@"decline"];
  
  XCTAssertEqualObjects([_defaults objectForKey:@"type"], @"decline");
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
}

- (void)testSetSurveyedWithTypeDeclineAndAfterSurveyNO {
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setBool:NO forKey:@"surveyed"];
  _apiClient.settings.setDefaultAfterSurvey = NO;
  
  [WTRDefaults setSurveyedWithType:@"decline"];
  
  XCTAssertNotEqualObjects([_defaults objectForKey:@"type"], @"decline");
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (NSNumber *)createdDaysAgo:(int)daysAgo {
  return [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] - (daysAgo * 60 * 60 * 24)];
}

@end

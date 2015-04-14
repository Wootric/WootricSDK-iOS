//
//  APIWootricTests.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 13/04/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "APIWootric.h"

@interface APIWootricTests : XCTestCase

@property (nonatomic) APIWootric *api;

@end

@interface APIWootric (Tests)

- (BOOL)needsSurvey;

@end

@implementation APIWootricTests

- (void)setUp {
  [super setUp];
  self.api = [APIWootric sharedInstance];
}

- (void)tearDown {
  [super tearDown];
  _api.surveyImmediately = NO;
  _api.firstSurveyAfter = 31;
  _api.clientID = nil;
  _api.clientSecret = nil;
  _api.accountToken = nil;
  _api.endUserEmail = nil;

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:@"surveyed"];
  [defaults removeObjectForKey:@"lastSeenAt"];
}

// surveyed = NO, surveyImmediately = YES
- (void)testNeedsSurveyCaseOne {
  _api.surveyImmediately = YES;
  XCTAssertTrue(_api.needsSurvey);
}

// surveyed = YES, surveyImmediately = YES
- (void)testNeedsSurveyCaseTwo {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  _api.surveyImmediately = YES;
  XCTAssertFalse(_api.needsSurvey);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 31
- (void)testNeedsSurveyCaseThree {
  _api.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - (32 * 60 * 60 * 24); // 32 days ago
  XCTAssertTrue(_api.needsSurvey);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 31, lastSeenAt = 20
- (void)testNeedsSurveyCaseFour {
  _api.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - (20 * 60 * 60 * 24); // 20 days ago
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[NSDate date] timeIntervalSince1970] - (20 * 60 * 60 * 24) forKey:@"lastSeenAt"];
  XCTAssertFalse(_api.needsSurvey);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 31, externalCreatedAt = 20, lastSeenAt = 40
- (void)testNeedsSurveyCaseFive {
  _api.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - (20 * 60 * 60 * 24);
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[NSDate date] timeIntervalSince1970] - (40 * 60 * 60 * 24) forKey:@"lastSeenAt"];
  XCTAssertTrue(_api.needsSurvey);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 60, externalCreatedAt = 20, lastSeenAt = 40
- (void)testNeedsSurveyCaseSix {
  _api.firstSurveyAfter = 60;
  _api.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - (20 * 60 * 60 * 24);
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[NSDate date] timeIntervalSince1970] - (40 * 60 * 60 * 24) forKey:@"lastSeenAt"];
  XCTAssertFalse(_api.needsSurvey);
}

// firstSurveyAfter = 0
- (void)testNeedsSurveyCaseSeven {
  _api.firstSurveyAfter = 0;
  XCTAssertTrue(_api.needsSurvey);
}

// With one of the setting missing
- (void)testCheckConfigurationCaseOne {
  _api.clientID = @"clientID";
  _api.clientSecret = @"clientSecret";
  _api.accountToken = @"accountToken";
  _api.endUserEmail = @"endUserEmail";
  XCTAssertFalse(_api.checkConfiguration);
}

// All settings in place
- (void)testCheckConfigurationCaseTwo {
  _api.clientID = @"clientID";
  _api.clientSecret = @"clientSecret";
  _api.accountToken = @"accountToken";
  _api.endUserEmail = @"endUserEmail";
  _api.originURL = @"originURL";
  XCTAssertTrue(_api.checkConfiguration);
}

@end

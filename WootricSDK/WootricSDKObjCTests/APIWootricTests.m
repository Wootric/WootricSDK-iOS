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
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"surveyed"];
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
  _api.externalCreatedAt = [[NSDate date] timeIntervalSince1970] - 32; // 32 days ago
  XCTAssertTrue(_api.needsSurvey);
}

//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//if ([defaults boolForKey:@"surveyed"]) {
//  return NO;
//} else if (_surveyImmediately) {
//  return YES;
//} else {
//  NSInteger age = [[NSDate date] timeIntervalSince1970] - _externalCreatedAt;
//  if (_firstSurveyAfter != 0) {
//    if (age > (_firstSurveyAfter * 60 * 60 * 24)) {
//      return YES;
//    } else {
//      if (([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"lastSeenAt"]) >= (_firstSurveyAfter * 60 * 60 * 24)) {
//        return YES;
//      }
//    }
//  } else {
//    return YES;
//  }
//}
//return NO;

@end

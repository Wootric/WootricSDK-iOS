//
//  WootricSDKObjCTests.m
//  WootricSDKObjCTests
//
//  Created by Łukasz Cichecki on 04/03/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WootricSDK.h"

@interface WootricSDKTests : XCTestCase

@end

@interface WootricSDK (Tests)

+ (void)setSurveyedInDefaults;

@end

@implementation WootricSDKTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"surveyed"];
}

- (void)testsetSurveyedInDefaults {
  [WootricSDK setSurveyedInDefaults];

  XCTAssertTrue([[NSUserDefaults standardUserDefaults] boolForKey:@"surveyed"]);
}

@end

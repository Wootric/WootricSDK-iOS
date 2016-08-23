//
//  WTRDefaultsTests.m
//  WootricSDK
//
//  Created by Diego Serrano on 8/18/16.
//  Copyright © 2016 Wootric. All rights reserved.
//

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
  [super tearDown];
  
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setObject:nil forKey:@"surveyed"];
  [_defaults setObject:nil forKey:@"lastSeenAt"];
  [_defaults setObject:nil forKey:@"surveyedAt"];
  _apiClient.settings.surveyedDefaultDurationDecline = 30;
  _apiClient.settings.surveyedDefaultDuration = 90;
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
  
  XCTAssertEqual([_defaults objectForKey:@"type"], @"response");
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
}

- (void)testSetSurveyedWithTypeResponseAndAfterSurveyNO {
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setBool:NO forKey:@"surveyed"];
  _apiClient.settings.setDefaultAfterSurvey = NO;
  
  [WTRDefaults setSurveyedWithType:@"response"];
  
  XCTAssertNotEqual([_defaults objectForKey:@"type"], @"response");
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (void)testSetSurveyedWithTypeDeclineAndAfterSurveyYES {
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setBool:NO forKey:@"surveyed"];
  _apiClient.settings.setDefaultAfterSurvey = YES;
  
  [WTRDefaults setSurveyedWithType:@"decline"];
  
  XCTAssertEqual([_defaults objectForKey:@"type"], @"decline");
  XCTAssertTrue([_defaults boolForKey:@"surveyed"]);
}

- (void)testSetSurveyedWithTypeDeclineAndAfterSurveyNO {
  [_defaults setObject:nil forKey:@"type"];
  [_defaults setBool:NO forKey:@"surveyed"];
  _apiClient.settings.setDefaultAfterSurvey = NO;
  
  [WTRDefaults setSurveyedWithType:@"decline"];
  
  XCTAssertNotEqual([_defaults objectForKey:@"type"], @"decline");
  XCTAssertFalse([_defaults boolForKey:@"surveyed"]);
}

- (NSNumber *)createdDaysAgo:(int)daysAgo {
  return [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] - (daysAgo * 60 * 60 * 24)];
}

@end

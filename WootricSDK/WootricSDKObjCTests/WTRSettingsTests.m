//
//  WTRSettingsTests.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 06/05/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WTRSettings.h"

@interface WTRSettingsTests : XCTestCase

@property (nonatomic, strong) WTRSettings *settings;

@end

@interface WTRSettings (Tests)

- (NSString *)countryCodeFromLanguageNumber:(NSInteger)languageNumber;

@end

@implementation WTRSettingsTests

- (void)setUp {
  [super setUp];
  _settings = [[WTRSettings alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCountryCodeFromLanguageNumberCaseOne {
  NSString *countryCode = [_settings countryCodeFromLanguageNumber:3];

  XCTAssertEqualObjects(countryCode, @"en");
}

- (void)testCountryCodeFromLanguageNumberCaseTwo {
  NSString *countryCode = [_settings countryCodeFromLanguageNumber:100];

  XCTAssertEqualObjects(countryCode, @"en");
}

- (void)testCountryCodeFromLanguageNumberCaseThree {
  NSString *countryCode = [_settings countryCodeFromLanguageNumber:8];

  XCTAssertEqualObjects(countryCode, @"pl");
}

// No product name
- (void)testSettingFromEligibilityCaseOne {
  NSDictionary *eligibilitySettings = @{@"settings": @{@"product_name": @"testProduct"}};

  [_settings userSettingsFromEligibility:eligibilitySettings];

  XCTAssertEqualObjects(_settings.wootricRecommendProduct, @"testProduct");
}

// product name set in SDK
- (void)testSettingFromEligibilityCaseTwo {
  NSDictionary *eligibilitySettings = @{@"product_name": @"testProduct"};
  _settings.wootricRecommendProduct = @"existingTestProduct";

  [_settings userSettingsFromEligibility:eligibilitySettings];

  XCTAssertEqualObjects(_settings.wootricRecommendProduct, @"existingTestProduct");
}

@end
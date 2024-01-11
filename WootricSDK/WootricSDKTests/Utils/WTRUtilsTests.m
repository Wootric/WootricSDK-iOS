//
//  WTRUtilsTests.m
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
#import "WTRUtils.h"

@interface WTRUtilsTests : XCTestCase

@end

@implementation WTRUtilsTests

- (void)testGetTokenTDL {
  XCTAssertEqualObjects([WTRUtils getTokenTLD:@"NPS-EU-123456"], @"eu");
  XCTAssertEqualObjects([WTRUtils getTokenTLD:@"NPS-AU-A1B2C3"], @"au");
  XCTAssertEqualObjects([WTRUtils getTokenTLD:@"NPS-1234"], @"com");
  XCTAssertEqualObjects([WTRUtils getTokenTLD:@"whatever"], @"com");
  XCTAssertEqualObjects([WTRUtils getTokenTLD:@""], @"com");
  XCTAssertEqualObjects([WTRUtils getTokenTLD:@"EU"], @"com");
  XCTAssertEqualObjects([WTRUtils getTokenTLD:@"AU"], @"com");
  XCTAssertEqualObjects([WTRUtils getTokenTLD:@"NPS-US-EU"], @"com");
}

- (void)testIsValidString {
  XCTAssertTrue([WTRUtils isValidString:@"a"]);
  XCTAssertTrue([WTRUtils isValidString:@"very long text"]);
  XCTAssertFalse([WTRUtils isValidString:@""]);
  XCTAssertFalse([WTRUtils isValidString:nil]);
}

- (void)testIsValidNumber {
  XCTAssertTrue([WTRUtils isValidNumber:@1]);
  XCTAssertTrue([WTRUtils isValidNumber:@1.5]);
  XCTAssertTrue([WTRUtils isValidNumber:@0]);
  XCTAssertFalse([WTRUtils isValidNumber:nil]);
  XCTAssertFalse([WTRUtils isValidNumber:@-5]);
}
@end

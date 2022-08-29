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
#import <WootricSDK/WootricSDK.h>
#import "WTRSurvey.h"
#import "WTREvent.h"
#import "WTREventListOperation.h"

@interface WTRSurveyTests : XCTestCase

@property (nonatomic, strong) WTRSurvey *surveyClient;
@property (nonatomic, strong) UIViewController *testViewController;

@end

@interface WTRSurvey (Tests)

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@interface WTREvent (Tests)

@property (nonatomic, copy) void (^completion)(WTRSettings *settings);
@property (nonatomic, strong) NSDictionary *request;
@property (nonatomic, strong) NSArray *eventList;

@end

@implementation WTRSurveyTests

- (void)setUp {
  [super setUp];
  [Wootric configureWithClientID:@"NPS-abc123" accountToken:@"abcdefg12345677"];
  _testViewController = [[UIViewController alloc] init];
  _surveyClient = [WTRSurvey sharedInstance];
}

- (void)tearDown {
  [super tearDown];
  
  [[_surveyClient operationQueue] cancelAllOperations];
}

-(void)testInstance {
  XCTAssertNotNil(_surveyClient, "WTRSurvey instance should not have been nil.");
  
  XCTAssertNotNil(_surveyClient.operationQueue, "operationQueue should not have been nil.");
  
  XCTAssertEqual(_surveyClient.operationQueue.maxConcurrentOperationCount, 1, @"operationQueue maxConcurrentOperationCount should be 1");
}

- (void)testCheckConfiguration {
  _surveyClient.clientID = @"";
  _surveyClient.clientSecret = @"";
  _surveyClient.accountToken = @"";
  
  XCTAssertFalse([_surveyClient checkConfiguration]);
  
  _surveyClient.clientID = @"clientIDtestString";
  _surveyClient.clientSecret = @"clientSecretTestString";
  _surveyClient.accountToken = @"";
  XCTAssertFalse([_surveyClient checkConfiguration]);
  
  _surveyClient.clientID = @"";
  _surveyClient.clientSecret = @"clientSecretTestString";
  _surveyClient.accountToken = @"";
  XCTAssertFalse([_surveyClient checkConfiguration]);
  
  _surveyClient.clientID = @"";
  _surveyClient.clientSecret = @"";
  _surveyClient.accountToken = @"NPS-token";
  XCTAssertTrue([_surveyClient checkConfiguration]);
  
  _surveyClient.clientID = @"clientIDtestString";
  _surveyClient.clientSecret = @"clientSecretTestString";
  _surveyClient.accountToken = @"";
  XCTAssertFalse([_surveyClient checkConfiguration]);
  
  _surveyClient.clientID = @"";
  _surveyClient.clientSecret = @"clientSecretTestString";
  _surveyClient.accountToken = @"NPS-token";
  XCTAssertTrue([_surveyClient checkConfiguration]);
  
  _surveyClient.clientID = @"clientIDtestString";
  _surveyClient.clientSecret = @"";
  _surveyClient.accountToken = @"NPS-token";
  XCTAssertTrue([_surveyClient checkConfiguration]);

  _surveyClient.clientID = @"clientIDtestString";
  _surveyClient.clientSecret = @"clientSecretTestString";
  _surveyClient.accountToken = @"NPS-token";
  XCTAssertTrue([_surveyClient checkConfiguration]);
}

@end

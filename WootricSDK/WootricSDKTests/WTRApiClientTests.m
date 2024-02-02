//
//  WTRApiClientTests.m
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
#import "WTRApiClient.h"
#import "WTRDefaults.h"

static NSString *const WTRSamplingRule = @"Wootric Sampling Rule";
static NSString *const WTRRegisterEventsEndpoint = @"/registered_events.json";
static NSString *const WTREligibleEndpoint = @"/eligible.json";
static NSString *const WTRSurveyServerURL = @"eligibility.wootric.com";
static NSString *const WTRBaseAPIURL = @"app.wootric.com";
static NSString *const WTRSurveyEUServerURL = @"eligibility.wootric.eu";
static NSString *const WTRBaseEUAPIURL = @"app.wootric.eu";
static NSString *const WTRSurveyAUServerURL = @"eligibility.wootric.au";
static NSString *const WTRBaseAUAPIURL = @"app.wootric.au";
static NSString *const WTRAPIVersion = @"api/v1";

@interface WTRApiClientTests : XCTestCase

@property (nonatomic, strong) WTRApiClient *apiClient;

@end

@interface WTRApiClient (Tests)

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSURLSession *wootricSession;
@property (nonatomic) NSInteger userID;
@property (nonatomic, strong) NSNumber *accountID;
@property (nonatomic, strong) NSString *uniqueLink;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, assign) BOOL endUserAlreadyUpdated;
@property (nonatomic) int priority;

//- (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod andHTTPBody:(NSString *)httpBody;
- (NSMutableURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path HTTPMethod:(NSString *)httpMethod queryItems:(NSArray *)queryItems;
- (void)createEndUser:(void (^)(NSInteger endUserID))endUserWithID;
- (void)getEndUserWithEmail:(void (^)(NSInteger endUserID))endUserWithID;
- (void)authenticate:(void (^)(BOOL))authenticated;
- (NSString *)paramsWithScore:(NSInteger)score endUserID:(long)endUserID accountID:(NSNumber *)accountID uniqueLink:(nonnull NSString *)uniqueLink priority:(int)priority text:(nullable NSString *)text picklistAnswers:(NSDictionary *)picklistAnswers;
- (NSString *)randomString;
- (NSString *)buildUniqueLinkAccountToken:(NSString *)accountToken endUserEmail:(NSString *)endUserEmail date:(NSTimeInterval)date randomString:(NSString *)randomString;
- (NSArray *)addSurveyServerCustomSettingsToURL;
- (NSArray *)addVersionsToURL;
- (NSArray *)addPropertiesToURL;
- (NSURLQueryItem *)addEmailToURL;
- (BOOL)needsSurvey;
- (NSString *)baseApiUrl;
- (NSString *)eligibilityUrl;

@end

@implementation WTRApiClientTests

- (void)setUp {
  [super setUp];
  
  _apiClient = [WTRApiClient sharedInstance];
  _apiClient.settings.setDefaultAfterSurvey = YES;
}

- (void)tearDown {
  [super tearDown];
  _apiClient.settings.externalCreatedAt = nil;
  _apiClient.settings.surveyImmediately = NO;
  _apiClient.settings.firstSurveyAfter = @0;
  _apiClient.priority = 0;
  _apiClient.userID = 0;
  _apiClient.uniqueLink = nil;
  _apiClient.accessToken = nil;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"surveyed"];
  [defaults setDouble:0 forKey:@"lastSeenAt"];
  [defaults setObject:nil forKey:@"resurvey_days"];
}

-(void)testInstance {
  XCTAssertNotNil(_apiClient, "WTRApiClient instance should not have been nil.");
  
  XCTAssertNotNil(_apiClient.wootricSession, "wootricSession should not have been nil.");
  
  XCTAssertNotNil(_apiClient.settings, "settings should not have been nil.");
  
  XCTAssertEqual(_apiClient.priority, 0, @"priority should have been equal to 0");
}


- (void)testAddSurveyServerCustomSettingsToURL {
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], @[[NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]);
  
  _apiClient.settings.surveyImmediately = YES;
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.registeredPercentage = @50;
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.visitorPercentage = @50;
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.resurveyThrottle = @100;
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.dailyResponseCap = @25;
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"daily_response_cap" value:@"25"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.externalCreatedAt = @1234567890;
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"daily_response_cap" value:@"25"], [NSURLQueryItem queryItemWithName:@"end_user_created_at" value:@"1234567890"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.languageCode = @"ES";
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"daily_response_cap" value:@"25"], [NSURLQueryItem queryItemWithName:@"end_user_created_at" value:@"1234567890"], [NSURLQueryItem queryItemWithName:@"language[code]" value:@"ES"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.customProductName = @"productName";
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"daily_response_cap" value:@"25"], [NSURLQueryItem queryItemWithName:@"end_user_created_at" value:@"1234567890"], [NSURLQueryItem queryItemWithName:@"language[code]" value:@"ES"], [NSURLQueryItem queryItemWithName:@"language[product_name]" value:@"productName"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.customAudience = @"customAudience";
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"daily_response_cap" value:@"25"], [NSURLQueryItem queryItemWithName:@"end_user_created_at" value:@"1234567890"], [NSURLQueryItem queryItemWithName:@"language[code]" value:@"ES"], [NSURLQueryItem queryItemWithName:@"language[product_name]" value:@"productName"], [NSURLQueryItem queryItemWithName:@"language[audience_text]" value:@"customAudience"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.firstSurveyAfter = @1;
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"daily_response_cap" value:@"25"], [NSURLQueryItem queryItemWithName:@"end_user_created_at" value:@"1234567890"], [NSURLQueryItem queryItemWithName:@"language[code]" value:@"ES"], [NSURLQueryItem queryItemWithName:@"language[product_name]" value:@"productName"], [NSURLQueryItem queryItemWithName:@"language[audience_text]" value:@"customAudience"], [NSURLQueryItem queryItemWithName:@"first_survey_delay" value:@"1"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.externalId = @"a1b2c3d4";
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL], (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"daily_response_cap" value:@"25"], [NSURLQueryItem queryItemWithName:@"end_user_created_at" value:@"1234567890"], [NSURLQueryItem queryItemWithName:@"language[code]" value:@"ES"], [NSURLQueryItem queryItemWithName:@"language[product_name]" value:@"productName"], [NSURLQueryItem queryItemWithName:@"language[audience_text]" value:@"customAudience"], [NSURLQueryItem queryItemWithName:@"first_survey_delay" value:@"1"], [NSURLQueryItem queryItemWithName:@"external_id" value:@"a1b2c3d4"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
  
  _apiClient.settings.phoneNumber = @"+0123456789";
  XCTAssertEqualObjects([_apiClient addSurveyServerCustomSettingsToURL],  (@[[NSURLQueryItem queryItemWithName:@"survey_immediately" value:@"true"], [NSURLQueryItem queryItemWithName:@"registered_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"visitor_percent" value:@"50"], [NSURLQueryItem queryItemWithName:@"resurvey_throttle" value:@"100"], [NSURLQueryItem queryItemWithName:@"daily_response_cap" value:@"25"], [NSURLQueryItem queryItemWithName:@"end_user_created_at" value:@"1234567890"], [NSURLQueryItem queryItemWithName:@"language[code]" value:@"ES"], [NSURLQueryItem queryItemWithName:@"language[product_name]" value:@"productName"], [NSURLQueryItem queryItemWithName:@"language[audience_text]" value:@"customAudience"], [NSURLQueryItem queryItemWithName:@"first_survey_delay" value:@"1"], [NSURLQueryItem queryItemWithName:@"external_id" value:@"a1b2c3d4"], [NSURLQueryItem queryItemWithName:@"phone_number" value:@"+0123456789"], [NSURLQueryItem queryItemWithName:@"end_user_last_seen" value:@"0"]]));
}

- (void) testAddEmailToURL {
  XCTAssertEqualObjects([_apiClient addEmailToURL], [NSURLQueryItem queryItemWithName:@"email" value:@"Unknown"]);

  _apiClient.settings.endUserEmail = @"test@wootric.com";

  XCTAssertEqualObjects([_apiClient addEmailToURL], [NSURLQueryItem queryItemWithName:@"email" value:@"test@wootric.com"]);
}

- (void)testRequestURL {
  NSString *host = @"wootric.com";
  _apiClient.sdkVersion = @"0.6.0";
  _apiClient.osVersion = @"10.0";
  
  NSMutableURLRequest *urlRequest = [_apiClient requestWithHost:host path:@"/test" HTTPMethod:nil queryItems:nil];
  
  XCTAssertNil([urlRequest valueForHTTPHeaderField:@"Authorization"]);
  
  _apiClient.accessToken = @"accessToken";
  urlRequest = [_apiClient requestWithHost:host path:@"/test" HTTPMethod:nil queryItems:nil];
  XCTAssertEqualObjects([urlRequest valueForHTTPHeaderField:@"Authorization"], @"Bearer accessToken");
  XCTAssertEqualObjects([urlRequest valueForHTTPHeaderField:@"User-Agent"], @"Wootric-Mobile-SDK");
  
  NSString *httpBody = [[NSString alloc] initWithData:urlRequest.HTTPBody encoding:NSUTF8StringEncoding];
  XCTAssertEqualObjects(httpBody, @"");
  
  urlRequest = [_apiClient requestWithHost:host path:@"/test" HTTPMethod:nil queryItems:@[[NSURLQueryItem queryItemWithName:@"param" value:@"param value"]]];
  httpBody = [[NSString alloc] initWithData:urlRequest.HTTPBody encoding:NSUTF8StringEncoding];
  XCTAssertEqualObjects([urlRequest.URL absoluteString], @"https://wootric.com/test?param=param%20value&os_name=iOS&sdk_version=0.6.0&os_version=10.0");
}

- (void)testEligibilityURL {
  _apiClient.accountToken = @"NPS-EU-token";
  XCTAssertEqualObjects([_apiClient eligibilityUrl], WTRSurveyEUServerURL);
  
  _apiClient.accountToken = @"NPS-AU-token";
  XCTAssertEqualObjects([_apiClient eligibilityUrl], WTRSurveyAUServerURL);

  _apiClient.accountToken = @"NPS-token";
  XCTAssertEqualObjects([_apiClient eligibilityUrl], WTRSurveyServerURL);
}

- (void)testBaseApiURL {
  _apiClient.accountToken = @"NPS-EU-token";
  XCTAssertEqualObjects([_apiClient baseApiUrl], WTRBaseEUAPIURL);
  
  _apiClient.accountToken = @"NPS-AU-token";
  XCTAssertEqualObjects([_apiClient baseApiUrl], WTRBaseAUAPIURL);

  _apiClient.accountToken = @"NPS-token";
  XCTAssertEqualObjects([_apiClient baseApiUrl], WTRBaseAPIURL);
}

- (void)testAddVersionsToURLString {
  _apiClient.osVersion = nil;
  _apiClient.sdkVersion = nil;
  
  XCTAssertEqualObjects([_apiClient addVersionsToURL], (@[[NSURLQueryItem queryItemWithName:@"os_name" value:@"iOS"]]));
  
  _apiClient.sdkVersion = @"0.6.0";
  XCTAssertEqualObjects([_apiClient addVersionsToURL], (@[[NSURLQueryItem queryItemWithName:@"os_name" value:@"iOS"], [NSURLQueryItem queryItemWithName:@"sdk_version" value:@"0.6.0"]]));
  
  _apiClient.osVersion = @"10.0";
  XCTAssertEqualObjects([_apiClient addVersionsToURL], (@[[NSURLQueryItem queryItemWithName:@"os_name" value:@"iOS"], [NSURLQueryItem queryItemWithName:@"sdk_version" value:@"0.6.0"], [NSURLQueryItem queryItemWithName:@"os_version" value:@"10.0"]]));
  
  _apiClient.sdkVersion = nil;
  XCTAssertEqualObjects([_apiClient addVersionsToURL], (@[[NSURLQueryItem queryItemWithName:@"os_name" value:@"iOS"], [NSURLQueryItem queryItemWithName:@"os_version" value:@"10.0"]]));
}

- (void)testAddPropertiesToURLString {
  _apiClient.settings.customProperties = [NSMutableDictionary dictionaryWithDictionary:@{ @"pricing_plan": @"pro plan", @"age_amount": @21.5 }];
  XCTAssertEqualObjects([_apiClient addPropertiesToURL], (@[[NSURLQueryItem queryItemWithName:@"properties[age_amount]" value:@"21.5"], [NSURLQueryItem queryItemWithName:@"properties[pricing_plan]" value:@"pro plan"]]));
}

- (void)testRandomStringLength {
  XCTAssertEqual([[_apiClient randomString] length], 16);
}

- (void)testBuildUniqueLink {
  _apiClient.accountToken = @"testAccountToken";
  _apiClient.settings.endUserEmail = @"test@example.com";
  NSString *randomString = @"16charrandstring";
  NSTimeInterval date = 1234567890;
  
  XCTAssertEqualObjects([_apiClient buildUniqueLinkAccountToken:_apiClient.accountToken
                                                   endUserEmail:_apiClient.settings.endUserEmail
                                                           date:date
                                                   randomString:randomString], @"1ed9f1c96018e2d577b3f864dc59dffe2baccc7103f6dcdadc40c3b6ec98cb0b");
}

- (void)testResponseParams {
  _apiClient.settings.originURL = @"com.wootric.WootricSDK-Demo";
  _apiClient.settings.languageCode = nil;
  NSInteger score = 9;
  NSInteger endUserID = 12345678;
  NSNumber *accountID = nil;
  NSString *uniqueLink = @"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e";
  NSString *text = nil;
  int priority = 0;
  
  XCTAssertEqualObjects([_apiClient paramsWithScore:score endUserID:endUserID accountID:accountID uniqueLink:uniqueLink priority:priority text:nil picklistAnswers:@{@"Help & support": @"Ayuda & soporte"}], (@[
    [NSURLQueryItem queryItemWithName:@"origin_url" value:@"com.wootric.WootricSDK-Demo"],
    [NSURLQueryItem queryItemWithName:@"end_user[id]" value:@"12345678"],
    [NSURLQueryItem queryItemWithName:@"survey[channel]" value:@"mobile"],
    [NSURLQueryItem queryItemWithName:@"survey[unique_link]" value:@"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e"],
    [NSURLQueryItem queryItemWithName:@"priority" value:@"0"],
    [NSURLQueryItem queryItemWithName:@"metric_type" value:@"nps"],
    [NSURLQueryItem queryItemWithName:@"driver_picklist[Help & support]" value:@"Ayuda & soporte"],
    [NSURLQueryItem queryItemWithName:@"score" value:@"9"]
  ]), @"Should not have account_id nor text in params");
  
  accountID = @1234;
  _apiClient.settings.languageCode = @"ES";
  XCTAssertEqualObjects([_apiClient paramsWithScore:score endUserID:endUserID accountID:accountID uniqueLink:uniqueLink priority:priority text:text picklistAnswers:nil], (@[
    [NSURLQueryItem queryItemWithName:@"origin_url" value:@"com.wootric.WootricSDK-Demo"],
    [NSURLQueryItem queryItemWithName:@"end_user[id]" value:@"12345678"],
    [NSURLQueryItem queryItemWithName:@"survey[channel]" value:@"mobile"],
    [NSURLQueryItem queryItemWithName:@"survey[unique_link]" value:@"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e"],
    [NSURLQueryItem queryItemWithName:@"priority" value:@"0"],
    [NSURLQueryItem queryItemWithName:@"metric_type" value:@"nps"],
    [NSURLQueryItem queryItemWithName:@"survey[language]" value:@"ES"],
    [NSURLQueryItem queryItemWithName:@"score" value:@"9"],
    [NSURLQueryItem queryItemWithName:@"account_id" value:@"1234"]
  ]));
  
  text = @"test";
  XCTAssertEqualObjects([_apiClient paramsWithScore:score endUserID:endUserID accountID:accountID uniqueLink:uniqueLink priority:priority text:text picklistAnswers:nil], (@[
    [NSURLQueryItem queryItemWithName:@"origin_url" value:@"com.wootric.WootricSDK-Demo"],
    [NSURLQueryItem queryItemWithName:@"end_user[id]" value:@"12345678"],
    [NSURLQueryItem queryItemWithName:@"survey[channel]" value:@"mobile"],
    [NSURLQueryItem queryItemWithName:@"survey[unique_link]" value:@"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e"],
    [NSURLQueryItem queryItemWithName:@"priority" value:@"0"],
    [NSURLQueryItem queryItemWithName:@"metric_type" value:@"nps"],
    [NSURLQueryItem queryItemWithName:@"survey[language]" value:@"ES"],
    [NSURLQueryItem queryItemWithName:@"score" value:@"9"],
    [NSURLQueryItem queryItemWithName:@"text" value:@"test"],
    [NSURLQueryItem queryItemWithName:@"account_id" value:@"1234"]
  ]));
}

- (void)testDeclineParams {
  
  _apiClient.settings.originURL = @"com.wootric.WootricSDK-Demo";
  _apiClient.settings.languageCode = @"ES";
  NSInteger endUserID = 12345678;
  NSNumber *accountID = nil;
  NSString *uniqueLink = @"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e";
  int priority = 0;
  
  XCTAssertEqualObjects([_apiClient paramsWithScore:-1 endUserID:endUserID accountID:accountID uniqueLink:uniqueLink priority:priority text:nil picklistAnswers:nil], (@[
    [NSURLQueryItem queryItemWithName:@"origin_url" value:@"com.wootric.WootricSDK-Demo"],
    [NSURLQueryItem queryItemWithName:@"end_user[id]" value:@"12345678"],
    [NSURLQueryItem queryItemWithName:@"survey[channel]" value:@"mobile"],
    [NSURLQueryItem queryItemWithName:@"survey[unique_link]" value:@"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e"],
    [NSURLQueryItem queryItemWithName:@"priority" value:@"0"],
    [NSURLQueryItem queryItemWithName:@"metric_type" value:@"nps"],
    [NSURLQueryItem queryItemWithName:@"survey[language]" value:@"ES"]
  ]));
  
  accountID = @1234;
  XCTAssertEqualObjects([_apiClient paramsWithScore:-1 endUserID:endUserID accountID:accountID uniqueLink:uniqueLink priority:priority text:nil picklistAnswers:nil], (@[
    [NSURLQueryItem queryItemWithName:@"origin_url" value:@"com.wootric.WootricSDK-Demo"],
    [NSURLQueryItem queryItemWithName:@"end_user[id]" value:@"12345678"],
    [NSURLQueryItem queryItemWithName:@"survey[channel]" value:@"mobile"],
    [NSURLQueryItem queryItemWithName:@"survey[unique_link]" value:@"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e"],
    [NSURLQueryItem queryItemWithName:@"priority" value:@"0"],
    [NSURLQueryItem queryItemWithName:@"metric_type" value:@"nps"],
    [NSURLQueryItem queryItemWithName:@"survey[language]" value:@"ES"],
    [NSURLQueryItem queryItemWithName:@"account_id" value:@"1234"]
  ]));
}

- (void)testPriorityIncreases {
  _apiClient.settings.originURL = @"com.wootric.WootricSDK-Demo";
  NSInteger score = 9;
  NSInteger endUserID = 12345678;
  NSNumber *accountID = nil;
  NSString *uniqueLink = @"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e";
  _apiClient.priority = 0;
  
  NSString *params = [_apiClient paramsWithScore:score endUserID:endUserID accountID:accountID uniqueLink:uniqueLink priority:_apiClient.priority text:nil picklistAnswers:@{@"Price": @"Precio"}];
  XCTAssertEqual(_apiClient.priority, 1, "priority should be 1");
  params = [_apiClient paramsWithScore:score endUserID:endUserID accountID:accountID uniqueLink:uniqueLink priority:_apiClient.priority text:nil picklistAnswers:nil];
  params = [_apiClient paramsWithScore:score endUserID:endUserID accountID:accountID uniqueLink:uniqueLink priority:_apiClient.priority text:nil picklistAnswers:nil];
  XCTAssertEqual(_apiClient.priority, 3, "priority should be 3");
}

- (void)testGetUniqueLinkWhenUniqueLinkIsSet {
  NSString *uniqueLink = @"5d8220d5b96ec1e0c4389a0a5951c05c3b1b998e53abbb11b14b9da5c2c0a81e";
  _apiClient.uniqueLink = uniqueLink;

  XCTAssertEqualObjects([_apiClient getUniqueLink], uniqueLink, "uniqueLink not equal");
}

- (void)testGetUniqueLinkWhenUniqueLinkIsNotSet {
  _apiClient.uniqueLink = nil;

  XCTAssertNotNil([_apiClient getUniqueLink], "uniqueLink should not be nil");
}

- (void)testGetEndUserId {
  NSInteger userId = 12345;
  _apiClient.userID = userId;

  XCTAssertEqualObjects([_apiClient getEndUserId], @"12345", "userID not equal");
}

- (void)testGetToken {
  NSString *token = @"5d8220d5b96ec1e0c4";
  _apiClient.accessToken = token;

  XCTAssertEqualObjects([_apiClient getToken], token, "token not equal");
}

// surveyImmediately = YES
- (void)testNeedsSurveyOne {
  _apiClient.settings.surveyImmediately = YES;
  XCTAssertTrue([_apiClient needsSurvey]);
}

// surveyImmediately = YES, surveyed = YES
- (void)testNeedsSurveyTwo {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  _apiClient.settings.surveyImmediately = YES;
  XCTAssertFalse([_apiClient needsSurvey]);
}

// firstSurveyAfter = 31, externalCreatedAt = 32
- (void)testNeedsSurveyThree {
  _apiClient.settings.firstSurveyAfter = @31;
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:32]; // 32 days ago
  XCTAssertTrue([_apiClient needsSurvey]);
}

// firstSurveyAfter = 0, surveyed = N0
- (void)testNeedsSurveyFour {
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:32]; // 32 days ago
  XCTAssertTrue([_apiClient needsSurvey]);
}

// firstSurveyAfter = 0, surveyed = YES
- (void)testNeedsSurveyFive {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:32]; // 32 days ago
  XCTAssertFalse([_apiClient needsSurvey]);
}

// surveyed > 90 days, surveyed = YES
- (void)testNeedsSurveySix {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setDouble:[[self createdDaysAgo:95] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_apiClient needsSurvey]);
}

// surveyed > 90 days, surveyed = YES, type = response
- (void)testNeedsSurveySeven {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setObject:@"response" forKey:@"type"];
  [defaults setDouble:[[self createdDaysAgo:95] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_apiClient needsSurvey]);
}

// surveyed < 90 days, surveyed = YES, type = response
- (void)testNeedsSurveyEight {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setObject:@"response" forKey:@"type"];
  [defaults setDouble:[[self createdDaysAgo:85] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_apiClient needsSurvey]);
}

// surveyed > 30 days, surveyed = YES, type = decline
- (void)testNeedsSurveyNine {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setObject:@"decline" forKey:@"type"];
  [defaults setDouble:[[self createdDaysAgo:35] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertTrue([_apiClient needsSurvey]);
}

// surveyed < 30 days, surveyed = YES, type = decline
- (void)testNeedsSurveyTen {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  [defaults setObject:@"decline" forKey:@"type"];
  [defaults setDouble:[[self createdDaysAgo:25] doubleValue] forKey:@"surveyedAt"];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  XCTAssertFalse([_apiClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 60, externalCreatedAt = 20, lastSeenAt = 40
- (void)testNeedsSurveyEleven {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[self createdDaysAgo:40] doubleValue] forKey:@"lastSeenAt"];
  _apiClient.settings.firstSurveyAfter = @60;
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:20];
  XCTAssertFalse([_apiClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 31, externalCreatedAt = 20, lastSeenAt = 40
- (void)testNeedsSurveyTwelve {
  _apiClient.settings.firstSurveyAfter = @31;
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:20];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[self createdDaysAgo:40] doubleValue] forKey:@"lastSeenAt"];
  XCTAssertTrue([_apiClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 2, externalCreatedAt = 2, lastSeenAt = 4
- (void)testNeedsSurveyThirteen {
  _apiClient.settings.firstSurveyAfter = @2;
  _apiClient.settings.externalCreatedAt = [self createdDaysAgo:2];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setDouble:[[self createdDaysAgo:4] doubleValue] forKey:@"lastSeenAt"];
  XCTAssertTrue([_apiClient needsSurvey]);
}

// surveyed = YES, surveyImmediately = NO, firstSurveyAfter = 0, setDefaultAfterSurvey = YES
- (void)testNeedsSurveyFourteen {
  _apiClient.settings.firstSurveyAfter = @0;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  XCTAssertFalse([_apiClient needsSurvey]);
}

// surveyed = YES, surveyImmediately = NO, firstSurveyAfter = 0, setDefaultAfterSurvey = NO
- (void)testNeedsSurveyFifteen {
  _apiClient.settings.firstSurveyAfter = @0;
  _apiClient.settings.setDefaultAfterSurvey = NO;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"surveyed"];
  XCTAssertTrue([_apiClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 0, setDefaultAfterSurvey = YES
- (void)testNeedsSurveySixteen {
  _apiClient.settings.firstSurveyAfter = @0;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"surveyed"];
  XCTAssertTrue([_apiClient needsSurvey]);
}

// surveyed = NO, surveyImmediately = NO, firstSurveyAfter = 0, setDefaultAfterSurvey = NO
- (void)testNeedsSurveySeventeen {
  _apiClient.settings.firstSurveyAfter = @0;
  _apiClient.settings.setDefaultAfterSurvey = NO;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"surveyed"];
  [defaults setDouble:[[self createdDaysAgo:4] doubleValue] forKey:@"lastSeenAt"];
  XCTAssertTrue([_apiClient needsSurvey]);
}

- (NSNumber *)createdDaysAgo:(int)daysAgo {
  return [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] - (daysAgo * 60 * 60 * 24)];
}
@end

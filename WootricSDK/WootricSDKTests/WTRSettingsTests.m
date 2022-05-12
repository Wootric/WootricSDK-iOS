//
//  WTRSettingsTests.m
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
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"NPS"]];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testFollowupQuestion {
  NSString *followupQuestionDetractor = [_settings followupQuestionTextForScore:1];
  XCTAssertEqualObjects(followupQuestionDetractor, @"Thank you! Care to tell us why?");
  NSString *followupQuestionPassive = [_settings followupQuestionTextForScore:8];
  XCTAssertEqualObjects(followupQuestionPassive, @"Thank you! Care to tell us why?");
  NSString *followupQuestionPromoter = [_settings followupQuestionTextForScore:10];
  XCTAssertEqualObjects(followupQuestionPromoter, @"Thank you! Care to tell us why?");
}

- (void)testFollowupQuestionWithCustomMessage {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithMessages]];
  NSString *followupQuestionDetractor = [_settings followupQuestionTextForScore:1];
  XCTAssertEqualObjects(followupQuestionDetractor, @"Can you explain why?");
  NSString *followupQuestionPassive = [_settings followupQuestionTextForScore:8];
  XCTAssertEqualObjects(followupQuestionPassive, @"Can you explain why?");
  NSString *followupQuestionPromoter = [_settings followupQuestionTextForScore:10];
  XCTAssertEqualObjects(followupQuestionPromoter, @"Can you explain why?");
}

- (void)testFollowupQuestionForDetractor {
  [_settings setCustomFollowupQuestionForPromoter:nil passive:nil detractor:@"detractor question"];
  NSString *followupQuestion = [_settings followupQuestionTextForScore:1];
  XCTAssertEqualObjects(followupQuestion, @"detractor question");
}

- (void)testFollowupQuestionForPassive {
  [_settings setCustomFollowupQuestionForPromoter:nil passive:@"passive question" detractor:nil];
  NSString *followupQuestion = [_settings followupQuestionTextForScore:8];
  XCTAssertEqualObjects(followupQuestion, @"passive question");
}

- (void)testFollowupQuestionForPromoter {
  [_settings setCustomFollowupQuestionForPromoter:@"promoter question" passive:nil detractor:nil];
  NSString *followupQuestion = [_settings followupQuestionTextForScore:10];
  XCTAssertEqualObjects(followupQuestion, @"promoter question");
}

- (void)testThankYouLinkWithEmailScoreCommentForDetractor {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"detractor_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                      @"add_comment_param_to_url": @1,
                                                                                      @"add_email_param_to_url": @1,
                                                                                      @"add_score_param_to_url": @1
                                                                                      }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://detractor.com?wootric_email=testing@wootric.com&wootric_score=1&wootric_comment=Not%20good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 text:@"Not good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Detractor thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailScoreCommentForPassives {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"passive_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://passive.com?wootric_email=testing@wootric.com&wootric_score=8&wootric_comment=Good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:8];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8 text:@"Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Passive thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}


- (void)testThankYouLinkWithEmailScoreCommentForPromoters {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"promoter_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://promoter.com?wootric_email=testing@wootric.com&wootric_score=10&wootric_comment=Very%20Good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Very Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Promoter thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailScoreForDetractors {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"detractor_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @0,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://detractor.com?wootric_email=testing@wootric.com&wootric_score=1"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 text:@"Not good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Detractor thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailScoreForPassives {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"passive_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @0,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://passive.com?wootric_email=testing@wootric.com&wootric_score=8"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:8];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8 text:@"Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Passive thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailScoreForProtomer {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"promoter_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @0,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://promoter.com?wootric_email=testing@wootric.com&wootric_score=10"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Very Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Promoter thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailCommentForDetractor {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"detractor_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @0
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://detractor.com?wootric_email=testing@wootric.com&wootric_comment=Not%20good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 text:@"Not good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Detractor thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailCommentForPassive {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"passive_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @0
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://passive.com?wootric_email=testing@wootric.com&wootric_comment=Good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:8];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8 text:@"Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Passive thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailCommentForPromoter {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"promoter_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @0
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://promoter.com?wootric_email=testing@wootric.com&wootric_comment=Very%20Good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Very Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Promoter thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithScoreCommentForDetractor {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"detractor_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @0,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://detractor.com?wootric_score=1&wootric_comment=Not%20good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 text:@"Not good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Detractor thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithScoreCommentForPassive {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"passive_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @0,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://passive.com?wootric_score=8&wootric_comment=Good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:8];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8 text:@"Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Passive thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithScoreCommentForPromoter {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"promoter_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @0,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://promoter.com?wootric_score=10&wootric_comment=Very%20Good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Very Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Promoter thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmail {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"promoter_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @0,
                                                                                       @"add_email_param_to_url": @1,
                                                                                       @"add_score_param_to_url": @0
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://promoter.com?wootric_email=testing@wootric.com"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Very Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Promoter thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithScore {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"promoter_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @0,
                                                                                       @"add_email_param_to_url": @0,
                                                                                       @"add_score_param_to_url": @1
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://promoter.com?wootric_score=10"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Very Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Promoter thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithComment {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouWithKey:@"promoter_thank_you_link_url_settings"
                                                                          dictionary:@{
                                                                                       @"add_comment_param_to_url": @1,
                                                                                       @"add_email_param_to_url": @0,
                                                                                       @"add_score_param_to_url": @0
                                                                                       }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://promoter.com?wootric_comment=Very%20Good"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Very Good" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Promoter thank you link text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailScoreCommentForAllRespondents {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouLinkAllRespondentsWithDictionary:@{
                                                                                                     @"add_comment_param_to_url": @1,
                                                                                                     @"add_email_param_to_url": @1,
                                                                                                     @"add_score_param_to_url": @1
                                                                                                    }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://wootric.com?wootric_email=testing@wootric.com&wootric_score=10&wootric_comment=Bueno"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Bueno" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Button");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailScoreForAllRespondents {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouLinkAllRespondentsWithDictionary:@{
                                                                                                                @"add_comment_param_to_url": @0,
                                                                                                                @"add_email_param_to_url": @1,
                                                                                                                @"add_score_param_to_url": @1
                                                                                                                }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://wootric.com?wootric_email=testing@wootric.com&wootric_score=10"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Bueno" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Button");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailCommentForAllRespondents {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouLinkAllRespondentsWithDictionary:@{
                                                                                                                @"add_comment_param_to_url": @1,
                                                                                                                @"add_email_param_to_url": @1,
                                                                                                                @"add_score_param_to_url": @0
                                                                                                                }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://wootric.com?wootric_email=testing@wootric.com&wootric_comment=Bueno"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Bueno" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Button");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithScoreCommentForAllRespondents {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouLinkAllRespondentsWithDictionary:@{
                                                                                                                @"add_comment_param_to_url": @1,
                                                                                                                @"add_email_param_to_url": @0,
                                                                                                                @"add_score_param_to_url": @1
                                                                                                                }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://wootric.com?wootric_score=10&wootric_comment=Bueno"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Bueno" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Button");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithEmailForAllRespondents {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouLinkAllRespondentsWithDictionary:@{
                                                                                                                @"add_comment_param_to_url": @0,
                                                                                                                @"add_email_param_to_url": @1,
                                                                                                                @"add_score_param_to_url": @0
                                                                                                                }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://wootric.com?wootric_email=testing@wootric.com"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Bueno" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Button");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithScoreForAllRespondents {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouLinkAllRespondentsWithDictionary:@{
                                                                                                                @"add_comment_param_to_url": @0,
                                                                                                                @"add_email_param_to_url": @0,
                                                                                                                @"add_score_param_to_url": @1
                                                                                                                }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://wootric.com?wootric_score=10"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Bueno" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Button");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithCommentForAllRespondents {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithThankYouLinkAllRespondentsWithDictionary:@{
                                                                                                                @"add_comment_param_to_url": @1,
                                                                                                                @"add_email_param_to_url": @0,
                                                                                                                @"add_score_param_to_url": @0
                                                                                                                }]];
  
  NSURL *thankYouURL = [NSURL URLWithString:@"https://wootric.com?wootric_comment=Bueno"];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"Bueno" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"Button");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testFollowupPlaceholder {
  NSString *followupPlaceholderDetractor = [_settings followupPlaceholderTextForScore:1];
  XCTAssertEqualObjects(followupPlaceholderDetractor, @"Help us by explaining your score.");
  NSString *followupPlaceholderPassive = [_settings followupPlaceholderTextForScore:8];
  XCTAssertEqualObjects(followupPlaceholderPassive, @"Help us by explaining your score.");
  NSString *followupPlaceholderPromoter = [_settings followupPlaceholderTextForScore:10];
  XCTAssertEqualObjects(followupPlaceholderPromoter, @"Help us by explaining your score.");
}

- (void)testFollowupPlaceholderWithCustomMessage {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsWithMessages]];
  NSString *followupQuestionDetractor = [_settings followupPlaceholderTextForScore:1];
  XCTAssertEqualObjects(followupQuestionDetractor, @"Please, leave a feedback");
  NSString *followupQuestionPassive = [_settings followupPlaceholderTextForScore:8];
  XCTAssertEqualObjects(followupQuestionPassive, @"Please, leave a feedback");
  NSString *followupQuestionPromoter = [_settings followupPlaceholderTextForScore:10];
  XCTAssertEqualObjects(followupQuestionPromoter, @"Please, leave a feedback");
}

- (void)testFollowupPlaceholderForDetractor {
  [_settings setCustomFollowupPlaceholderForPromoter:nil passive:nil detractor:@"detractor placeholder"];
  NSString *followupPlaceholder = [_settings followupPlaceholderTextForScore:1];
  XCTAssertEqualObjects(followupPlaceholder, @"detractor placeholder");
}

- (void)testFollowupPlaceholderForPassive {
  [_settings setCustomFollowupPlaceholderForPromoter:nil passive:@"passive placeholder" detractor:nil];
  NSString *followupPlaceholder = [_settings followupPlaceholderTextForScore:8];
  XCTAssertEqualObjects(followupPlaceholder, @"passive placeholder");
}

- (void)testFollowupPlaceholderForPromoter {
  [_settings setCustomFollowupPlaceholderForPromoter:@"promoter placeholder" passive:nil detractor:nil];
  NSString *followupPlaceholder = [_settings followupPlaceholderTextForScore:10];
  XCTAssertEqualObjects(followupPlaceholder, @"promoter placeholder");
}

- (void)testQuestion {
  NSString *question = [_settings questionText];
  XCTAssertEqualObjects(question, @"How likely are you to recommend Wootric to a friend or co-worker?");
}

- (void)testCustomQuestion {
  [_settings setCustomQuestion:@"custom question"];
  NSString *question = [_settings questionText];
  XCTAssertEqualObjects(question, @"custom question");
}

- (void)testAnchors {
  NSString *likelyAnchor = [_settings likelyAnchorText];
  NSString *notLikelyAnchor = [_settings notLikelyAnchorText];
  XCTAssertEqualObjects(likelyAnchor, @"Extremely likely");
  XCTAssertEqualObjects(notLikelyAnchor, @"Not at all likely");
}

- (void)testFinalThankYouText {
  NSString *finalThankYou = [_settings finalThankYouText];
  XCTAssertEqualObjects(finalThankYou, @"Thank you for your response, and your feedback!");
}

- (void)testCustomFinalThankYouText {
  [_settings setCustomFinalThankYou:@"final thank you"];
  NSString *finalThankYou = [_settings finalThankYouText];
  XCTAssertEqualObjects(finalThankYou, @"final thank you");
}

- (void)testSendButtonTitle {
  NSString *sendButtonTitle = [_settings sendButtonText];
  XCTAssertEqualObjects(sendButtonTitle, @"send");
}

- (void)testDismissButtonTitle {
  NSString *dismissButtonTitle = [_settings dismissButtonText];
  XCTAssertEqualObjects(dismissButtonTitle, @"dismiss");
}

- (void)testEditScoreButtonTitle {
  NSString *editScoreButtonTitle = [_settings editScoreButtonText];
  XCTAssertEqualObjects(editScoreButtonTitle, @"edit");
}

- (void)testSocialShareDecline {
  NSString *socialShareDecline = [_settings socialShareDeclineText];
  XCTAssertEqualObjects(socialShareDecline, @"No thanks...");
}

- (void)testThankYouMain {
  [_settings setThankYouMain:@"thank you message"];
  NSString *thankYouMain = [_settings thankYouMainDependingOnScore:1];
  XCTAssertEqualObjects(thankYouMain, @"thank you message");
  NSString *thankYouMainTwo = [_settings thankYouMainDependingOnScore:8];
  XCTAssertEqualObjects(thankYouMainTwo, @"thank you message");
  NSString *thankYouMainThree = [_settings thankYouMainDependingOnScore:10];
  XCTAssertEqualObjects(thankYouMainThree, @"thank you message");
}

- (void)testThankYouMainDetractor {
  [_settings setThankYouMain:@"thank you message"];
  [_settings setDetractorThankYouMain:@"detractor thank you message"];
  NSString *thankYouMain = [_settings thankYouMainDependingOnScore:1];
  XCTAssertEqualObjects(thankYouMain, @"detractor thank you message");
}

- (void)testThankYouMainPassive {
  [_settings setThankYouMain:@"thank you message"];
  [_settings setPassiveThankYouMain:@"passive thank you message"];
  NSString *thankYouMain = [_settings thankYouMainDependingOnScore:8];
  XCTAssertEqualObjects(thankYouMain, @"passive thank you message");
}

- (void)testThankYouMainPromoter {
  [_settings setThankYouMain:@"thank you message"];
  [_settings setPromoterThankYouMain:@"promoter thank you message"];
  NSString *thankYouMain = [_settings thankYouMainDependingOnScore:10];
  XCTAssertEqualObjects(thankYouMain, @"promoter thank you message");
}

- (void)testThankYouLinkWithURL {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 text:@"" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"thank you text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithURLDetractor {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *detractorThankYouURL = [NSURL URLWithString:@"http://thankyoudetractor.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setDetractorThankYouLinkWithText:@"detractor thank you" URL:detractorThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 text:@"" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"detractor thank you");
  XCTAssertEqualObjects(thankYouLinkURL, detractorThankYouURL);
}

- (void)testThankYouLinkWithURLPassive {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *passiveThankYouURL = [NSURL URLWithString:@"http://thankyoudpassive.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setPassiveThankYouLinkWithText:@"passive thank you" URL:passiveThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:8];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8 text:@"" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"passive thank you");
  XCTAssertEqualObjects(thankYouLinkURL, passiveThankYouURL);
}

- (void)testThankYouLinkWithURLPromoter {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *promoterThankYouURL = [NSURL URLWithString:@"http://thankyoudpromoter.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setPromoterThankYouLinkWithText:@"promoter thank you" URL:promoterThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkText, @"promoter thank you");
  XCTAssertEqualObjects(thankYouLinkURL, promoterThankYouURL);
}

- (void)testThankYouLinkWithTextDependingOnScore {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setDetractorThankYouLinkWithText:@"detractor thank you" URL:thankYouURL];
  [_settings setPassiveThankYouLinkWithText:@"passive thank you" URL:thankYouURL];
  [_settings setPromoterThankYouLinkWithText:@"promoter thank you" URL:thankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  XCTAssertEqualObjects(thankYouLinkText, @"detractor thank you");
  thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:8];
  XCTAssertEqualObjects(thankYouLinkText, @"passive thank you");
  thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  XCTAssertEqualObjects(thankYouLinkText, @"promoter thank you");
}

- (void)testThankYouLinkWithURLDependingOnScore {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *detractorThankYouURL = [NSURL URLWithString:@"http://thankyoudetractor.com"];
  NSURL *passiveThankYouURL = [NSURL URLWithString:@"http://thankyoudpassive.com"];
  NSURL *promoterThankYouURL = [NSURL URLWithString:@"http://thankyoudpromoter.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setDetractorThankYouLinkWithText:@"detractor thank you" URL:detractorThankYouURL];
  [_settings setPassiveThankYouLinkWithText:@"passive thank you" URL:passiveThankYouURL];
  [_settings setPromoterThankYouLinkWithText:@"promoter thank you" URL:promoterThankYouURL];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 text:@"" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkURL, detractorThankYouURL);
  thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8 text:@"" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkURL, passiveThankYouURL);
  thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 text:@"" email:@"testing@wootric.com"];
  XCTAssertEqualObjects(thankYouLinkURL, promoterThankYouURL);
}

- (void)testThankYouLinkConfiguredForScoreOne {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  [_settings setThankYouLinkWithText:nil URL:thankYouURL];
  [_settings setDetractorThankYouLinkWithText:@"detractor thank you" URL:nil];
  BOOL flag = [_settings thankYouLinkConfiguredForScore:1];
  XCTAssertTrue(flag);
  flag = [_settings thankYouLinkConfiguredForScore:8];
  XCTAssertFalse(flag);
  flag = [_settings thankYouLinkConfiguredForScore:10];
  XCTAssertFalse(flag);
}

- (void)testThankYouLinkConfiguredForScoreTwo {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  [_settings setThankYouLinkWithText:nil URL:thankYouURL];
  [_settings setPromoterThankYouLinkWithText:@"thank you message" URL:nil];
  
  BOOL flag = [_settings thankYouLinkConfiguredForScore:1];
  XCTAssertFalse(flag);
  flag = [_settings thankYouLinkConfiguredForScore:8];
  XCTAssertFalse(flag);
  flag = [_settings thankYouLinkConfiguredForScore:10];
  XCTAssertTrue(flag);
}

- (void)testGetEndUserEmailOrUnknown {
  _settings.endUserEmail = @"   ";
  XCTAssertEqualObjects(@"Unknown", [_settings getEndUserEmailOrUnknown]);
  _settings.endUserEmail = nil;
  XCTAssertEqualObjects(@"Unknown", [_settings getEndUserEmailOrUnknown]);
  _settings.endUserEmail = @"mail@example.com";
  XCTAssertEqualObjects(@"mail@example.com", [_settings getEndUserEmailOrUnknown]);
}

- (void)testTimeDelay {
  NSInteger timeDelay = [_settings timeDelay];
  XCTAssertEqual(timeDelay, 10);
}

- (void)testScoreRulesForNPS {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"NPS"]];
  NSDictionary *scale = @{@"min": @0, @"max": @10, @"negative_type_max": @6, @"neutral_type_max": @8};
  XCTAssertEqualObjects(scale, _settings.scale);

  [_settings setSurveyTypeScale:1];
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"NPS"]];
  scale = @{@"min": @0, @"max": @10, @"negative_type_max": @6, @"neutral_type_max": @8};
  XCTAssertEqualObjects(scale, _settings.scale);

  [_settings setSurveyTypeScale:-1];
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"NPS"]];
  scale = @{@"min": @0, @"max": @10, @"negative_type_max": @6, @"neutral_type_max": @8};
  XCTAssertEqualObjects(scale, _settings.scale);
}

- (void)testScoreRulesForCES {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"CES"]];
  NSDictionary *scale = @{@"min": @1, @"max": @7, @"negative_type_max": @3, @"neutral_type_max": @5};
  XCTAssertEqualObjects(scale, _settings.scale);

  [_settings setSurveyTypeScale:1];
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"CES"]];
  scale = @{@"min": @1, @"max": @7, @"negative_type_max": @3, @"neutral_type_max": @5};
  XCTAssertEqualObjects(scale, _settings.scale);

  [_settings setSurveyTypeScale:-1];
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"CES"]];
  scale = @{@"min": @1, @"max": @7, @"negative_type_max": @3, @"neutral_type_max": @5};
  XCTAssertEqualObjects(scale, _settings.scale);
}

- (void)testScoreRulesForCSAT {
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"CSAT"]];
  NSDictionary *scale = @{@"min": @1, @"max": @5, @"negative_type_max": @2, @"neutral_type_max": @3};
  XCTAssertEqualObjects(scale, _settings.scale);

  [_settings setSurveyTypeScale:1];
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"CSAT"]];
  scale = @{@"min": @1, @"max": @10, @"negative_type_max": @6, @"neutral_type_max": @8};
  XCTAssertEqualObjects(scale, _settings.scale);

  [_settings setSurveyTypeScale:2];
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"CSAT"]];
  scale = @{@"min": @1, @"max": @5, @"negative_type_max": @2, @"neutral_type_max": @3};
  XCTAssertEqualObjects(scale, _settings.scale);

  [_settings setSurveyTypeScale:-1];
  [_settings parseDataFromSurveyServer:[self surveyServerSettingsForMode:@"CSAT"]];
  scale = @{@"min": @1, @"max": @5, @"negative_type_max": @2, @"neutral_type_max": @3};
  XCTAssertEqualObjects(scale, _settings.scale);
}

- (NSDictionary *)surveyServerSettingsForMode:(NSString *)mode {
  NSDictionary *settings = @{
    @"eligible": @1,
    @"settings": @{
      @"time_delay": @10,
      @"first_survey": @30,
      @"resurvey_throttle": @180,
      @"decline_resurvey_throttle": @30,
      @"survey_type": mode,
      @"localized_texts": @{
        @"nps_question": @"How likely are you to recommend Wootric to a friend or co-worker?",
        @"anchors": @{
          @"likely": @"Extremely likely",
          @"not_likely": @"Not at all likely"
        },
        @"ces_question": @"How easy was it for you to use Wootric?",
        @"ces_anchors": @{
          @"very_difficult": @"Very difficult",
          @"difficult": @"Difficult",
          @"somewhat_difficult": @"Somewhat difficult",
          @"neutral": @"Neutral",
          @"somewhat_easy": @"Somewhat easy",
          @"easy": @"Easy",
          @"very_easy": @"Very easy"
        },
        @"csat_question": @"How satisfied are you with Wootric?",
        @"csat_anchors": @{
          @"very_unsatisfied": @"Very unsatisfied",
          @"unsatisfied": @"Unsatisfied",
          @"neutral": @"Neutral",
          @"satisfied": @"Satisfied",
          @"very_satisfied": @"Very satisfied"
        },
        @"dismiss": @"dismiss",
        @"followup_placeholder": @"Help us by explaining your score.",
        @"followup_question": @"Thank you! Care to tell us why?",
        @"final_thank_you": @"Thank you for your response, and your feedback!",
        @"send": @"send",
        @"edit_score": @"edit",
        @"social_share": @{
          @"decline": @"No thanks...",
          @"question": @"Would you be willing to share your positive comments?"
        }
      }
    }
  };

  return settings;
}

- (NSDictionary *)surveyServerSettingsWithMessages {
  NSDictionary *settings = @{
    @"eligible": @1,
    @"settings": @{
      @"first_survey": @30,
      @"resurvey_throttle": @180,
      @"decline_resurvey_throttle": @30,
      @"survey_type": @"NPS",
      @"messages": @{
        @"followup_question": @"Can you explain why?",
        @"placeholder_text": @"Please, leave a feedback"
      },
      @"localized_texts": @{
        @"nps_question": @"How likely are you to recommend Wootric to a friend or co-worker?",
        @"anchors": @{
          @"likely": @"Extremely likely",
          @"not_likely": @"Not at all likely"
        },
        @"ces_question": @"How easy was it for you to use Wootric?",
        @"ces_anchors": @{
          @"very_difficult": @"Very difficult",
          @"difficult": @"Difficult",
          @"somewhat_difficult": @"Somewhat difficult",
          @"neutral": @"Neutral",
          @"somewhat_easy": @"Somewhat easy",
          @"easy": @"Easy",
          @"very_easy": @"Very easy"
        },
        @"csat_question": @"How satisfied are you with Wootric?",
        @"csat_anchors": @{
          @"very_unsatisfied": @"Very unsatisfied",
          @"unsatisfied": @"Unsatisfied",
          @"neutral": @"Neutral",
          @"satisfied": @"Satisfied",
          @"very_satisfied": @"Very satisfied"
        },
        @"dismiss": @"dismiss",
        @"followup_placeholder": @"Help us by explaining your score.",
        @"followup_question": @"Thank you! Care to tell us why?",
        @"final_thank_you": @"Thank you for your response, and your feedback!",
        @"send": @"send",
        @"edit_score": @"edit",
        @"social_share": @{
          @"decline": @"No thanks...",
          @"question": @"Would you be willing to share your positive comments?"
        }
      }
    }
  };

  return settings;
}

- (NSDictionary *)surveyServerSettingsWithThankYouLinkAllRespondentsWithDictionary:(NSDictionary *)dict {
  NSDictionary *settings = @{
                             @"eligible": @1,
                             @"settings": @{
                                 @"time_delay": @10,
                                 @"first_survey": @30,
                                 @"resurvey_throttle": @180,
                                 @"decline_resurvey_throttle": @30,
                                 @"custom_thank_you": @{
                                   @"thank_you_links": @{
                                     @"thank_you_link_text": @"Button",
                                     @"thank_you_link_url": @"https://wootric.com",
                                     @"thank_you_link_url_settings": dict
                                   }
                                 },
                                 @"survey_type": @"NPS",
                                 @"localized_texts": @{
                                     @"nps_question": @"How likely are you to recommend Wootric to a friend or co-worker?",
                                     @"anchors": @{
                                         @"likely": @"Extremely likely",
                                         @"not_likely": @"Not at all likely"
                                         },
                                     @"ces_question": @"How easy was it for you to use Wootric?",
                                     @"ces_anchors": @{
                                         @"very_difficult": @"Very difficult",
                                         @"difficult": @"Difficult",
                                         @"somewhat_difficult": @"Somewhat difficult",
                                         @"neutral": @"Neutral",
                                         @"somewhat_easy": @"Somewhat easy",
                                         @"easy": @"Easy",
                                         @"very_easy": @"Very easy"
                                         },
                                     @"csat_question": @"How satisfied are you with Wootric?",
                                     @"csat_anchors": @{
                                         @"very_unsatisfied": @"Very unsatisfied",
                                         @"unsatisfied": @"Unsatisfied",
                                         @"neutral": @"Neutral",
                                         @"satisfied": @"Satisfied",
                                         @"very_satisfied": @"Very satisfied"
                                         },
                                     @"dismiss": @"dismiss",
                                     @"followup_placeholder": @"Help us by explaining your score.",
                                     @"followup_question": @"Thank you! Care to tell us why?",
                                     @"final_thank_you": @"Thank you for your response, and your feedback!",
                                     @"send": @"send",
                                     @"edit_score": @"edit",
                                     @"social_share": @{
                                         @"decline": @"No thanks...",
                                         @"question": @"Would you be willing to share your positive comments?"
                                         }
                                     }
                                 }
                             };
  
  return settings;
}

- (NSDictionary *)surveyServerSettingsWithThankYouWithKey:(NSString *)key dictionary:(NSDictionary *)dict {
  NSDictionary *settings = @{
    @"eligible": @1,
    @"settings": @{
      @"account_id": @4321,
      @"account_token": @"NPS-abcd1234",
      @"ask_permission_to_share_feedback": @0,
      @"custom_thank_you": @{
        @"thank_you_links": @{
          @"thank_you_link_text_list": @{
            @"detractor_thank_you_link_text": @"Detractor thank you link text",
            @"passive_thank_you_link_text": @"Passive thank you link text",
            @"promoter_thank_you_link_text": @"Promoter thank you link text"
          },
          @"thank_you_link_url_list": @{
            @"detractor_thank_you_link_url": @"https://detractor.com",
            @"passive_thank_you_link_url": @"https://passive.com",
            @"promoter_thank_you_link_url": @"https://promoter.com"
          },
          @"thank_you_link_url_settings": @{
            @"add_comment_param_to_url": @0,
            @"add_email_param_to_url": @0,
            @"add_score_param_to_url": @0
          },
          @"thank_you_link_url_settings_list": @{ key: dict }
        }
      },
      @"decline_resurvey_throttle": @2,
      @"end_user_email": @"test@wootric.com",
      @"end_user_id": @1234567,
      @"first_screen_enabled": @1,
      @"first_survey": @1,
      @"localized_texts": @{
        @"anchors": @{
          @"likely": @"Extremely likely",
          @"not_likely": @"Not at all likely"
        },
        @"and": @"and",
        @"ask_permission_to_share_feedback": @"I give permission to contact me about sharing my feedback",
        @"ces_anchors": @{
          @"difficult": @"Difficult",
          @"easy": @"Easy",
          @"neutral": @"Neutral",
          @"somewhat_difficult": @"Somewhat difficult",
          @"somewhat_easy": @"Somewhat easy",
          @"very_difficult": @"Very difficult",
          @"very_easy": @"Very easy",
        },
        @"ces_question": @"How easy was it for you to Wootric?",
        @"csat_anchors": @{
          @"neutral": @"Neutral",
          @"satisfied": @"Satisfied",
          @"unsatisfied": @"Unsatisfied",
          @"very_satisfied": @"Completely satisfied",
          @"very_unsatisfied": @"Not at all satisfied",
        },
        @"csat_question": @"How satisfied are you with Wootric?",
        @"dir": @"ltr",
        @"dismiss": @"dismiss",
        @"edit_score": @"Edit score",
        @"email": @{
          @"already_answered": @"You have already answered this survey!",
        },
        @"final_thank_you": @"Thank you for your response, and your feedback!",
        @"followup_placeholder": @"Help us by explaining your score.",
        @"followup_question": @"Thank you! Care to tell us why?",
        @"nps_question": @"How likely are you to recommend Wootric to a friend or co-worker?",
        @"opt_out": @"Confirmed. You've been opted out of future surveys.",
        @"opt_out_button": @"opt out",
        @"score_message": @"Please reply with a score between",
        @"send": @"SEND",
        @"social_share": @{
          @"decline": @"No thanks...",
          @"question": @"Would you be willing to share your positive comments?",
        },
        @"unsubscribe": @{
          @"message": @"You have successfully unsubscribed from receiving this customer feedback survey in the future.",
          @"title": @"Unsubscribe",
        },
      },
      @"powered_by": @1,
      @"resurvey_throttle": @2,
      @"sampling_group": @{
        @"belongs_to_sampling_group": @0,
      },
      @"second_screen_enabled": @1,
      @"show_opt_out": @0,
      @"social": @{
        @"facebook_enabled": @0,
        @"twitter_enabled": @0,
      },
      @"survey_type": @"NPS",
      @"time_delay": @0
      }
    };
    
  return settings;
}

@end

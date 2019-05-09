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

- (void)testSocialShareQuestion {
  NSString *socialShareQuestion = [_settings socialShareQuestionText];
  XCTAssertEqualObjects(socialShareQuestion, @"Would you be willing to share your positive comments?");
}

- (void)testSocialShareDecline {
  NSString *socialShareDecline = [_settings socialShareDeclineText];
  XCTAssertEqualObjects(socialShareDecline, @"No thanks...");
}

- (void)testThankYouMessage {
  [_settings setThankYouMessage:@"thank you message"];
  NSString *thankYouMessage = [_settings thankYouMessageDependingOnScore:1];
  XCTAssertEqualObjects(thankYouMessage, @"thank you message");
  NSString *thankYouMessageTwo = [_settings thankYouMessageDependingOnScore:8];
  XCTAssertEqualObjects(thankYouMessageTwo, @"thank you message");
  NSString *thankYouMessageThree = [_settings thankYouMessageDependingOnScore:10];
  XCTAssertEqualObjects(thankYouMessageThree, @"thank you message");
}

- (void)testThankYouMessageDetractor {
  [_settings setThankYouMessage:@"thank you message"];
  [_settings setDetractorThankYouMessage:@"detractor thank you message"];
  NSString *thankYouMessage = [_settings thankYouMessageDependingOnScore:1];
  XCTAssertEqualObjects(thankYouMessage, @"detractor thank you message");
}

- (void)testThankYouMessagePassive {
  [_settings setThankYouMessage:@"thank you message"];
  [_settings setPassiveThankYouMessage:@"passive thank you message"];
  NSString *thankYouMessage = [_settings thankYouMessageDependingOnScore:8];
  XCTAssertEqualObjects(thankYouMessage, @"passive thank you message");
}

- (void)testThankYouMessagePromoter {
  [_settings setThankYouMessage:@"thank you message"];
  [_settings setPromoterThankYouMessage:@"promoter thank you message"];
  NSString *thankYouMessage = [_settings thankYouMessageDependingOnScore:10];
  XCTAssertEqualObjects(thankYouMessage, @"promoter thank you message");
}

- (void)testThankYouLinkWithURL {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 andText:@""];
  XCTAssertEqualObjects(thankYouLinkText, @"thank you text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithURLDetractor {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *detractorThankYouURL = [NSURL URLWithString:@"http://thankyoudetractor.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setDetractorThankYouLinkWithText:@"detractor thank you" URL:detractorThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 andText:@""];
  XCTAssertEqualObjects(thankYouLinkText, @"detractor thank you");
  XCTAssertEqualObjects(thankYouLinkURL, detractorThankYouURL);
}

- (void)testThankYouLinkWithURLPassive {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *passiveThankYouURL = [NSURL URLWithString:@"http://thankyoudpassive.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setPassiveThankYouLinkWithText:@"passive thank you" URL:passiveThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:8];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8 andText:@""];
  XCTAssertEqualObjects(thankYouLinkText, @"passive thank you");
  XCTAssertEqualObjects(thankYouLinkURL, passiveThankYouURL);
}

- (void)testThankYouLinkWithURLPromoter {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *promoterThankYouURL = [NSURL URLWithString:@"http://thankyoudpromoter.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setPromoterThankYouLinkWithText:@"promoter thank you" URL:promoterThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 andText:@""];
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
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1 andText:@""];
  XCTAssertEqualObjects(thankYouLinkURL, detractorThankYouURL);
  thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8 andText:@""];
  XCTAssertEqualObjects(thankYouLinkURL, passiveThankYouURL);
  thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10 andText:@""];
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
        @"dismiss": @"dismiss",
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
        @"dismiss": @"dismiss",
        @"social_share": @{
          @"decline": @"No thanks...",
          @"question": @"Would you be willing to share your positive comments?"
        }
      }
    }
  };

  return settings;
}

@end

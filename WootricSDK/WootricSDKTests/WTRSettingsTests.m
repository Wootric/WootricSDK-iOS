//
//  WTRSettingsTests.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 06/10/15.
//  Copyright © 2015 Wootric. All rights reserved.
//

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
  [_settings parseDataFromSurveyServer:[self surveyServerSettings]];
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

- (void)testNPSQuestion {
  NSString *npsQuestion = [_settings npsQuestionText];
  XCTAssertEqualObjects(npsQuestion, @"How likely are you to recommend Wootric to a friend or co-worker?");
}

- (void)testCustomNPSQuestion {
  [_settings setCustomNPSQuestion:@"custom nps question"];
  NSString *npsQuestion = [_settings npsQuestionText];
  XCTAssertEqualObjects(npsQuestion, @"custom nps question");
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
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1];
  XCTAssertEqualObjects(thankYouLinkText, @"thank you text");
  XCTAssertEqualObjects(thankYouURL, thankYouLinkURL);
}

- (void)testThankYouLinkWithURLDetractor {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *detractorThankYouURL = [NSURL URLWithString:@"http://thankyoudetractor.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setDetractorThankYouLinkWithText:@"detractor thank you" URL:detractorThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:1];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1];
  XCTAssertEqualObjects(thankYouLinkText, @"detractor thank you");
  XCTAssertEqualObjects(thankYouLinkURL, detractorThankYouURL);
}

- (void)testThankYouLinkWithURLPassive {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *passiveThankYouURL = [NSURL URLWithString:@"http://thankyoudpassive.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setPassiveThankYouLinkWithText:@"passive thank you" URL:passiveThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:8];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8];
  XCTAssertEqualObjects(thankYouLinkText, @"passive thank you");
  XCTAssertEqualObjects(thankYouLinkURL, passiveThankYouURL);
}

- (void)testThankYouLinkWithURLPromoter {
  NSURL *thankYouURL = [NSURL URLWithString:@"http://thankyou.com"];
  NSURL *promoterThankYouURL = [NSURL URLWithString:@"http://thankyoudpromoter.com"];
  [_settings setThankYouLinkWithText:@"thank you text" URL:thankYouURL];
  [_settings setPromoterThankYouLinkWithText:@"promoter thank you" URL:promoterThankYouURL];
  NSString *thankYouLinkText = [_settings thankYouLinkTextDependingOnScore:10];
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10];
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
  NSURL *thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:1];
  XCTAssertEqualObjects(thankYouLinkURL, detractorThankYouURL);
  thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:8];
  XCTAssertEqualObjects(thankYouLinkURL, passiveThankYouURL);
  thankYouLinkURL = [_settings thankYouLinkURLDependingOnScore:10];
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
  NSLog(@"%@", [_settings thankYouLinkURLDependingOnScore:1]);
  NSLog(@"%@", [_settings thankYouLinkTextDependingOnScore:1]);
  BOOL flag = [_settings thankYouLinkConfiguredForScore:1];
  XCTAssertFalse(flag);
  flag = [_settings thankYouLinkConfiguredForScore:8];
  XCTAssertFalse(flag);
  flag = [_settings thankYouLinkConfiguredForScore:10];
  XCTAssertTrue(flag);
}

- (NSDictionary *)surveyServerSettings {
  NSDictionary *settings = @{
    @"eligible": @1,
    @"settings": @{
       @"first_survey": @30,
       @"localized_texts": @{
           @"anchors": @{
               @"likely": @"Extremely likely",
               @"not_likely": @"Not at all likely"},
           @"dismiss": @"dismiss",
           @"final_thank_you": @"Thank you for your response, and your feedback!",
           @"followup_placeholder": @"Help us by explaining your score.",
           @"followup_question": @"Thank you! Care to tell us why?",
           @"nps_question": @"How likely are you to recommend Wootric to a friend or co-worker?",
           @"send": @"send",
           @"social_share": @{
               @"decline": @"No thanks...",
               @"question": @"Would you be willing to share your positive comments?"}}}};

  return settings;
}

@end

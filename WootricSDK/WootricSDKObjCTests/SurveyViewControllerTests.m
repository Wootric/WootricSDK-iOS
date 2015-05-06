//
//  SurveyViewControllerTests.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 14/04/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SurveyViewController.h"

@interface SurveyViewControllerTests : XCTestCase

@property (nonatomic) SurveyViewController *surveyVC;

@end

@interface SurveyViewController (Tests)

- (void)submitButtonPressed:(UIButton *)sender;
- (void)changeView;
- (void)showFinalView;

@end

@implementation SurveyViewControllerTests

- (void)setUp {
  [super setUp];
  WTSettings *settings = [[WTSettings alloc] init];
  self.surveyVC = [[SurveyViewController alloc] initWithSettings:settings];
  [self.surveyVC viewDidLoad];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testInit {
  XCTAssertNotNil(_surveyVC.scoreSlider);
  XCTAssertNotNil(_surveyVC.submitButton);
  XCTAssertNotNil(_surveyVC.sendFeedbackButton);
  XCTAssertNotNil(_surveyVC.dismissButton);
  XCTAssertNotNil(_surveyVC.backButton);
  XCTAssertNotNil(_surveyVC.commentTextView);
  XCTAssertNotNil(_surveyVC.scrollView);
  XCTAssertNotNil(_surveyVC.defaultWootricQuestion);
  XCTAssertNotNil(_surveyVC.defaultPlaceholderText);
  XCTAssertNotNil(_surveyVC.defaultResponseQuestion);
  XCTAssertNotNil(_surveyVC.backgroundImageView);
  XCTAssertNotNil(_surveyVC.dismissImageView);
  XCTAssertNotNil(_surveyVC.sliderBackgroundView);
  XCTAssertNotNil(_surveyVC.sliderCheckedBackgroundView);
  XCTAssertNotNil(_surveyVC.buttonIconCheck);
  XCTAssertNotNil(_surveyVC.buttonIconSend);
  XCTAssertNotNil(_surveyVC.scoreLabel);
  XCTAssertNotNil(_surveyVC.feedbackPlaceholder);
  XCTAssertNotNil(_surveyVC.dragToChangeLabel);
  XCTAssertNotNil(_surveyVC.poweredByWootricLabel);
  XCTAssertNotNil(_surveyVC.titleLabel);
  XCTAssertNotNil(_surveyVC.notLikelyLabel);
  XCTAssertNotNil(_surveyVC.extremelyLikelyLabel);
  XCTAssertNotNil(_surveyVC.scorePopoverLabel);
}

- (void)testLabelTextsFirstScreen {
  XCTAssertEqualObjects(_surveyVC.titleLabel.text, @"How likely are you to recommend us to a friend or co-worker?");
  XCTAssertEqualObjects(_surveyVC.notLikelyLabel.text, @"Not at all likely");
  XCTAssertEqualObjects(_surveyVC.extremelyLikelyLabel.text, @"Extremely likely");
}

- (void)testLabelTextsSecondScreen {
  _surveyVC.scoreSlider.value = 9;
  [_surveyVC submitButtonPressed:_surveyVC.submitButton];

  XCTAssertEqualObjects(_surveyVC.chosenScore.text, @"9");
  XCTAssertEqualObjects(_surveyVC.scoreLabel.text, @"Thank you! Care to tell us why?");
  XCTAssertEqualObjects(_surveyVC.feedbackPlaceholder.text, @"Help us by explaining your score.");
}

- (void)testCustomRecommendTo {
  WTSettings *settings = [[WTSettings alloc] init];
  self.surveyVC = [[SurveyViewController alloc] initWithSettings:settings];
  _surveyVC.settings.wootricRecommendTo = @"BFF";
  [self.surveyVC viewDidLoad];

  XCTAssertEqualObjects(_surveyVC.titleLabel.text, @"How likely are you to recommend us to a BFF?");
}

- (void)testLanguageSettings {
  WTSettings *settings = [[WTSettings alloc] init];
  settings.language = @"pl";
  self.surveyVC = [[SurveyViewController alloc] initWithSettings:settings];
  [self.surveyVC viewDidLoad];

  XCTAssertEqualObjects(_surveyVC.titleLabel.text, @"Czy poleciliby Państwo nas swojemu znajomemu lub koledze?");
  XCTAssertEqualObjects(_surveyVC.notLikelyLabel.text, @"Zdecydowanie nie");
  XCTAssertEqualObjects(_surveyVC.extremelyLikelyLabel.text, @"Zdecydowanie tak");
}

- (void)testLabelTextsThirdScreen {
  [_surveyVC changeView];
  [_surveyVC showFinalView];

  XCTAssertEqualObjects(_surveyVC.titleLabel.text, @"Thank you for your response, and for your feedback!");
}

@end

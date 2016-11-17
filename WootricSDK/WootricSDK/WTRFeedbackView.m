//
//  WTRFeedbackView.m
//  WootricSDK
//
// Copyright (c) 2015 Wootric (https://wootric.com)
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

#import "WTRFeedbackView.h"
#import "WTRColor.h"
#import "WTRSurveyViewController.h"
#import "SimpleConstraints.h"
#import "UIItems.h"

@interface WTRFeedbackView ()

@property (nonatomic, strong) UIButton *editScoreButton;
@property (nonatomic, strong) UILabel *followupLabel;
@property (nonatomic, strong) UILabel *feedbackPlaceholder;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) WTRSettings *settings;

@end

@implementation WTRFeedbackView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    _settings = settings;
    self.hidden = YES;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupEditScoreButtonWithViewController:viewController];
  [self setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController];
  [self setupFollowupLabel];
  [self setupFeedbackLabel];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupEditScoreButtonConstraints];
  [self setupFollowupLabelConstraints];
  [self setupFeedbackTextViewConstraints];
  [self setupFeedbackLabelConstraints];
}

- (void)setFollowupLabelTextBasedOnScore:(int)score {
  _followupLabel.text = [_settings followupQuestionTextForScore:score];
}

- (void)textViewResignFirstResponder {
  [_feedbackTextView resignFirstResponder];
}

- (void)showFeedbackPlaceholder:(BOOL)flag {
  _feedbackPlaceholder.hidden = !flag;
}

- (void)setFeedbackPlaceholderText:(NSString *)text {
  _feedbackPlaceholder.text = text;
}

- (NSString *)feedbackText {
  if ([self feedbackTextPresent]) {
    return _feedbackTextView.text;
  }
  return nil;
}

- (BOOL)feedbackTextPresent {
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return !([[_feedbackTextView.text stringByTrimmingCharactersInSet:set] length] == 0);
}

- (BOOL)isActive {
  return !self.hidden;
}

- (void)setupEditScoreButtonWithViewController:(UIViewController *)viewController {
  _editScoreButton = [[UIButton alloc] init];
  _editScoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  [_editScoreButton setTitle:[_settings editScoreButtonText].uppercaseString forState:UIControlStateNormal];
  [_editScoreButton setTitleColor:[_settings sliderColor] forState:UIControlStateNormal];
  [_editScoreButton addTarget:viewController
                       action:NSSelectorFromString(@"editScoreButtonPressed:")
             forControlEvents:UIControlEventTouchUpInside];
  [_editScoreButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController {
  _feedbackTextView = [UIItems feedbackTextViewWithBackgroundColor:[UIColor whiteColor]];
  _feedbackTextView.delegate = viewController;
}

- (void)setupFeedbackLabel {
  _feedbackPlaceholder = [UIItems feedbackPlaceholder];
}

- (void)setupFollowupLabel {
  _followupLabel = [UIItems followupLabelWithTextColor:[UIColor blackColor]];
}

- (void)addSubviews {
  [self addSubview:_editScoreButton];
  [self addSubview:_feedbackTextView];
  [self addSubview:_followupLabel];
  [self addSubview:_feedbackPlaceholder];
}

- (void)setupEditScoreButtonConstraints {
  [[[_editScoreButton wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_editScoreButton wtr_topConstraint] toSecondViewTop:self] withConstant:16] addToView:self];
}

- (void)setupFollowupLabelConstraints {
  [[[_followupLabel wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_followupLabel wtr_topConstraint] toSecondViewTop:self] withConstant:50] addToView:self];
  [[[[_followupLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_followupLabel wtr_rightConstraint] toSecondViewRight:self] withConstant:-16] addToView:self];
}

- (void)setupFeedbackTextViewConstraints {
  [[[[_feedbackTextView wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_feedbackTextView wtr_rightConstraint] toSecondViewRight:self] withConstant:-16] addToView:self];
  [[[[_feedbackTextView wtr_topConstraint] toSecondViewBottom:_followupLabel] withConstant:16] addToView:self];
  [[[_feedbackTextView wtr_bottomConstraint] toSecondViewBottom:self] addToView:self];
}

- (void)setupFeedbackLabelConstraints {
  [[[[_feedbackPlaceholder wtr_leftConstraint] toSecondViewLeft:_feedbackTextView] withConstant:20] addToView:self];
  [[[[_feedbackPlaceholder wtr_rightConstraint] toSecondViewRight:_feedbackTextView] withConstant:-20] addToView:self];
  [[[[_feedbackPlaceholder wtr_topConstraint] toSecondViewTop:_feedbackTextView] withConstant:17] addToView:self];
}

@end

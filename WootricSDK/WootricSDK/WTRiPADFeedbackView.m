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

#import "WTRiPADFeedbackView.h"
#import "WTRColor.h"
#import "WTRSurveyViewController.h"
#import "SimpleConstraints.h"
#import "UIItems.h"

@interface WTRiPADFeedbackView ()

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UILabel *followupLabel;
@property (nonatomic, strong) UILabel *feedbackPlaceholder;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) WTRSettings *settings;

@end

@implementation WTRiPADFeedbackView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    _settings = settings;
    self.hidden = YES;
    self.alpha = 0;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController];
  [self setupFollowupLabel];
  [self setupFeedbackLabel];
  [self setupSendButtonViewWithViewController:(UIViewController *)viewController];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupFollowupLabelConstraints];
  [self setupFeedbackTextViewConstraints];
  [self setupFeedbackLabelConstraints];
  [self setupSendButtonConstraints];
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
  if (_feedbackTextView.text) {
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

- (void)setupSendButtonViewWithViewController:(UIViewController *)viewController {
  _sendButton = [[UIButton alloc] init];
  _sendButton.backgroundColor = [WTRColor iPadSendButtonBackgroundColor];
  _sendButton.layer.cornerRadius = 3;
  _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
  [_sendButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_sendButton setTitle:[self.settings sendButtonText] forState:UIControlStateNormal];
  [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
  [_sendButton addTarget:viewController
                  action:NSSelectorFromString(@"sendButtonPressed")
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController {
  _feedbackTextView = [UIItems feedbackTextViewWithBackgroundColor:[WTRColor iPadFeedbackTextViewBackgroundColor]];
  _feedbackTextView.delegate = viewController;
}

- (void)setupFeedbackLabel {
  _feedbackPlaceholder = [UIItems feedbackPlaceholder];
}

- (void)setupFollowupLabel {
  _followupLabel = [UIItems followupLabelWithTextColor:[WTRColor iPadQuestionsTextColor]];
}

- (void)addSubviews {
  [self addSubview:_feedbackTextView];
  [self addSubview:_followupLabel];
  [self addSubview:_feedbackPlaceholder];
  [self addSubview:_sendButton];
}

- (void)setupSendButtonConstraints {
  [_sendButton wtr_constraintWidth:100];
  [[[[_sendButton wtr_topConstraint] toSecondViewBottom:_followupLabel] withConstant:8] addToView:self];
  [[[_sendButton wtr_bottomConstraint] toSecondViewBottom:self] addToView:self];
  [[[_sendButton wtr_leftConstraint] toSecondViewRight:_feedbackTextView] addToView:self];
}

- (void)setupFollowupLabelConstraints {
  [[[_followupLabel wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_followupLabel wtr_topConstraint] toSecondViewTop:self] withConstant:20] addToView:self];
  [[[[_followupLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_followupLabel wtr_rightConstraint] toSecondViewRight:self] withConstant:-16] addToView:self];
}

- (void)setupFeedbackTextViewConstraints {
  [[[[_feedbackTextView wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_feedbackTextView wtr_rightConstraint] toSecondViewRight:self] withConstant:-116] addToView:self];
  [[[[_feedbackTextView wtr_topConstraint] toSecondViewBottom:_followupLabel] withConstant:8] addToView:self];
  [[[_feedbackTextView wtr_bottomConstraint] toSecondViewBottom:self] addToView:self];
}

- (void)setupFeedbackLabelConstraints {
  [[[[_feedbackPlaceholder wtr_leftConstraint] toSecondViewLeft:_feedbackTextView] withConstant:20] addToView:self];
  [[[[_feedbackPlaceholder wtr_rightConstraint] toSecondViewRight:_feedbackTextView] withConstant:-20] addToView:self];
  [[[[_feedbackPlaceholder wtr_topConstraint] toSecondViewTop:_feedbackTextView] withConstant:17] addToView:self];
}

@end

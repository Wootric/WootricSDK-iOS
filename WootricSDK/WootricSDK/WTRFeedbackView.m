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
  [_feedbackPlaceholder sizeToFit];
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

- (void)setupEditScoreButtonWithViewController:(UIViewController *)viewController {
  _editScoreButton = [[UIButton alloc] init];
  _editScoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  [_editScoreButton setTitle:@"EDIT SCORE" forState:UIControlStateNormal];
  [_editScoreButton setTitleColor:[WTRColor editScoreTextColor] forState:UIControlStateNormal];
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
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_editScoreButton
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self addConstraint:constX];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_editScoreButton
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:16];
  [self addConstraint:constTop];
}

- (void)setupFollowupLabelConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_followupLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self addConstraint:constX];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_followupLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:50];
  [self addConstraint:constTop];

  NSLayoutConstraint *constR = [NSLayoutConstraint constraintWithItem:_followupLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:16];
  [self addConstraint:constR];

  NSLayoutConstraint *constL = [NSLayoutConstraint constraintWithItem:_followupLabel
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-16];
  [self addConstraint:constL];
}

- (void)setupFeedbackTextViewConstraints {
  NSLayoutConstraint *constL = [NSLayoutConstraint constraintWithItem:_feedbackTextView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:16];
  [self addConstraint:constL];

  NSLayoutConstraint *constR = [NSLayoutConstraint constraintWithItem:_feedbackTextView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-16];
  [self addConstraint:constR];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_feedbackTextView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_followupLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:16];
  [self addConstraint:constTop];

  NSLayoutConstraint *constBottom = [NSLayoutConstraint constraintWithItem:_feedbackTextView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:0];
  [self addConstraint:constBottom];
}

- (void)setupFeedbackLabelConstraints {
  NSLayoutConstraint *constL = [NSLayoutConstraint constraintWithItem:_feedbackPlaceholder
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_feedbackTextView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:20];
  [self addConstraint:constL];

  NSLayoutConstraint *constR = [NSLayoutConstraint constraintWithItem:_feedbackPlaceholder
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_feedbackTextView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-20];
  [self addConstraint:constR];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_feedbackPlaceholder
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_feedbackTextView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:17];
  [self addConstraint:constTop];
}

@end

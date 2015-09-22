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

@interface WTRFeedbackView ()

@property (nonatomic, strong) UIButton *editScoreButton;
@property (nonatomic, strong) UILabel *youChoseLabel;
@property (nonatomic, strong) UILabel *feedbackPlaceholder;
@property (nonatomic, strong) UITextView *feedbackTextView;

@end

@implementation WTRFeedbackView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    self.hidden = YES;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupEditScoreButtonWithViewController:viewController];
  [self setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController];
  [self setupYouChoseLabel];
  [self setupFeedbackLabel];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupEditScoreButtonConstraints];
  [self setupYouChoseLabelConstraints];
  [self setupFeedbackTextViewConstraints];
  [self setupFeedbackLabelConstraints];
}

- (void)setYouChoseLabelTextBasedOnScore:(int)score {
  _youChoseLabel.text = [NSString stringWithFormat:@"You chose %d/10", score];
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

- (void)setupEditScoreButtonWithViewController:(UIViewController *)viewController {
  _editScoreButton = [[UIButton alloc] init];
  _editScoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  [_editScoreButton setTitle:@"EDIT SCORE" forState:UIControlStateNormal];
  [_editScoreButton setTitleColor:[WTRColor editScoreText] forState:UIControlStateNormal];
  [_editScoreButton addTarget:viewController
                       action:NSSelectorFromString(@"editScoreButtonPressed:")
             forControlEvents:UIControlEventTouchUpInside];
  [_editScoreButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController {
  _feedbackTextView = [[UITextView alloc] init];
  _feedbackTextView.delegate = viewController;
  _feedbackTextView.backgroundColor = [UIColor whiteColor];
  _feedbackTextView.font = [UIFont systemFontOfSize:16];
  _feedbackTextView.textColor = [WTRColor textAreaText];
  _feedbackTextView.layer.borderColor = [WTRColor textAreaBorder].CGColor;
  _feedbackTextView.layer.borderWidth = 1;
  _feedbackTextView.layer.cornerRadius = 3;
  _feedbackTextView.textContainerInset = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
  _feedbackTextView.tintColor = [WTRColor textAreaCursor];
  [_feedbackTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupFeedbackLabel {
  _feedbackPlaceholder = [[UILabel alloc] init];
  _feedbackPlaceholder.textColor = [WTRColor textAreaText];
  _feedbackPlaceholder.font = [UIFont systemFontOfSize:16];
  _feedbackPlaceholder.numberOfLines = 0;
  _feedbackPlaceholder.lineBreakMode = NSLineBreakByWordWrapping;
  [_feedbackPlaceholder setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupYouChoseLabel {
  _youChoseLabel = [[UILabel alloc] init];
  _youChoseLabel.font = [UIFont boldSystemFontOfSize:18];
  [_youChoseLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)addSubviews {
  [self addSubview:_editScoreButton];
  [self addSubview:_feedbackTextView];
  [self addSubview:_youChoseLabel];
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

- (void)setupYouChoseLabelConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_youChoseLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self addConstraint:constX];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_youChoseLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:50];
  [self addConstraint:constTop];
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
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:96];
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

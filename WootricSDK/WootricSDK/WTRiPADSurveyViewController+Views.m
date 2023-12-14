//
//  WTRiPADSurveyViewController+Views.m
//  WootricSDK
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

#import "WTRiPADSurveyViewController+Views.h"
#import "WTRColor.h"
#import "UIItems.h"

@implementation WTRiPADSurveyViewController (Views)

- (void)setupViews {
  [self setupModalView];
  [self setupScrollView];
  [self setupQuestionView];
  [self setupFeedbackView];
  [self setupSocialShareView];
  [self setupFooterView];
  [self setupFinalThankYouLabel];
  [self setupDismissButton];

  [self addViewsToModal];
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.modalView];
}

- (void)addViewsToModal {
  [self.modalView addSubview:self.questionView];
  [self.modalView addSubview:self.feedbackView];
  [self.modalView addSubview:self.socialShareView];
  [self.modalView addSubview:self.finalThankYouLabel];
  [self.modalView addSubview:self.footerView];
  [self.modalView addSubview:self.dismissButton];
}

- (void)setupQuestionView {
  self.questionView = [[WTRiPADQuestionView alloc] initWithSettings:self.settings];
  [self.questionView initializeSubviewsWithTargetViewController:self];
}

- (void)setupFeedbackView {
  self.feedbackView = [[WTRiPADFeedbackView alloc] initWithSettings:self.settings];
  [self.feedbackView initializeSubviewsWithTargetViewController:self];
}

- (void)setupSocialShareView {
  self.socialShareView = [[WTRiPADSocialShareView alloc] initWithSettings:self.settings];
  [self.socialShareView initializeSubviewsWithTargetViewController:self];
}

- (void)setupFooterView {
  self.footerView = [[WTRiPADFooterView alloc] initWithSettings:self.settings];
  [self.footerView initializeSubviewsWithTargetViewController:self];
}

- (void)setupDismissButton {
  self.dismissButton = [[UIButton alloc] init];
  self.dismissButton.layer.cornerRadius = 15;
  self.dismissButton.layer.borderWidth = 1;
  self.dismissButton.layer.borderColor = [WTRColor iPadCircleButtonBorderColor].CGColor;
  self.dismissButton.titleLabel.font = [UIItems regularFontWithSize:20];
  [self.dismissButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f)];
  [self.dismissButton setTitle:@"\u00D7" forState:UIControlStateNormal];
  [self.dismissButton setTitleColor:[WTRColor iPadCircleButtonTextColor] forState:UIControlStateNormal];
  [self.dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.dismissButton addTarget:self action:NSSelectorFromString(@"dismissButtonPressed") forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupFinalThankYouLabel {
  self.finalThankYouLabel = [[UILabel alloc] init];
  self.finalThankYouLabel.textAlignment = NSTextAlignmentCenter;
  self.finalThankYouLabel.textColor = [WTRColor iPadQuestionsTextColor];
  self.finalThankYouLabel.numberOfLines = 0;
  self.finalThankYouLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.finalThankYouLabel.hidden = YES;
  self.finalThankYouLabel.font = [UIItems regularFontWithSize:18];
  self.finalThankYouLabel.text = [self.settings finalThankYouText];
  [self.finalThankYouLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupModalView {
  self.modalView = [[WTRiPADModalView alloc] init];
}

- (void)setupScrollView {
  self.scrollView = [[UIScrollView alloc] init];
  [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

@end

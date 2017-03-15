//
//  WTRSurveyViewController+Views.m
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

#import "WTRSurveyViewController+Views.h"
#import "WTRColor.h"
#import "UIImage+ImageFromColor.h"

@implementation WTRSurveyViewController (Views)

- (void)setupViews {
  [self setupModalView];
  [self setupScrollView];
  [self setupQuestionView];
  [self setupFeedbackView];
  [self setupSocialShareView];
  [self setupFinalThankYouLabel];
  [self setupSendButton];
  [self setupDismissButton];
  [self setupPoweredByWootric];

  [self addViewsToModal];
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.modalView];
}

#pragma mark - Buttons

- (void)setupDismissButton {
  // This button is positioned beyond modalView bounds
  // We need to add it as a property on modalView with overriden hitTest:withEvent: method
  UIButton *dismissButton = [[UIButton alloc] init];
  dismissButton.titleLabel.font = [UIFont systemFontOfSize:32];
  [dismissButton setTitle:@"\u00D7" forState:UIControlStateNormal];
  [dismissButton setTitleColor:[WTRColor dismissXColor] forState:UIControlStateNormal];
  [dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [dismissButton addTarget:self action:NSSelectorFromString(@"dismissButtonPressed:")
            forControlEvents:UIControlEventTouchUpInside];
  self.modalView.dismissButton = dismissButton;
}

- (void)setupFinalThankYouLabel {
  self.finalThankYouLabel = [[UILabel alloc] init];
  self.finalThankYouLabel.textAlignment = NSTextAlignmentCenter;
  self.finalThankYouLabel.textColor = [UIColor blackColor];
  self.finalThankYouLabel.numberOfLines = 0;
  self.finalThankYouLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.finalThankYouLabel.hidden = YES;
  if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
    self.finalThankYouLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
  } else {
    self.finalThankYouLabel.font = [UIFont systemFontOfSize:18];
  }
  self.finalThankYouLabel.text = [self.settings finalThankYouText];
  [self.finalThankYouLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupSendButton {
  self.sendButton = [[UIButton alloc] init];
  self.sendButton.backgroundColor = [[self.settings sendButtonBackgroundColor] colorWithAlphaComponent:0.4f];
  self.sendButton.enabled = NO;
  self.sendButton.layer.cornerRadius = 3;
  self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
  [self.sendButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.sendButton setTitle:[self.settings sendButtonText] forState:UIControlStateNormal];
  [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
  [self.sendButton addTarget:self
                      action:NSSelectorFromString(@"sendButtonPressed:")
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPoweredByWootric {
  self.poweredByWootric = [[UIButton alloc] init];
  [self.poweredByWootric setTranslatesAutoresizingMaskIntoConstraints:NO];
  NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Powered by Wootric"]];
  [attrStr addAttribute:NSForegroundColorAttributeName value:[WTRColor poweredByColor] range:NSMakeRange(0, 10)];
  [attrStr addAttribute:NSForegroundColorAttributeName value:[WTRColor wootricTextColor] range:NSMakeRange(11, 7)];
  [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 18)];
  [self.poweredByWootric setAttributedTitle:attrStr forState:UIControlStateNormal];
  [self.poweredByWootric addTarget:self
                      action:NSSelectorFromString(@"openWootricHomepage:")
            forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Modals

- (void)setupModalView {
  self.modalView = [[WTRModalView alloc] init];
}

- (void)setupQuestionView {
  self.questionView = [[WTRQuestionView alloc] initWithSettings:self.settings];
  [self.questionView initializeSubviewsWithTargetViewController:self];
}

- (void)setupFeedbackView {
  self.feedbackView = [[WTRFeedbackView alloc] initWithSettings:self.settings];
  [self.feedbackView initializeSubviewsWithTargetViewController:self];
}

- (void)setupSocialShareView {
  self.socialShareView = [[WTRSocialShareView alloc] initWithSettings:self.settings];
  [self.socialShareView initializeSubviewsWithTargetViewController:self];
}

- (void)addViewsToModal {
  [self.modalView addSubview:self.questionView];
  [self.modalView addSubview:self.feedbackView];
  [self.modalView addSubview:self.socialShareView];
  [self.modalView addSubview:self.modalView.dismissButton];
  [self.modalView addSubview:self.finalThankYouLabel];
  [self.modalView addSubview:self.sendButton];
  [self.modalView addSubview:self.poweredByWootric];
}

#pragma mark - ScrollView

- (void)setupScrollView {
  self.scrollView = [[UIScrollView alloc] init];
  [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

@end

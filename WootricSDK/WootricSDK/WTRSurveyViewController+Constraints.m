//
//  WTRSurveyViewController+Constraints.m
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

#import "WTRSurveyViewController+Constraints.h"

@implementation WTRSurveyViewController (Constraints)

- (void)setupConstraints {
  [self setupScrollViewConstraints];
  [self setupModalConstraints];
  [self setupQuestionViewConstraints];
  [self.questionView setupSubviewsConstraints];
  [self setupFeedbackViewConstraints];
  [self.feedbackView setupSubviewsConstraints];
  [self setupSocialShareViewConstraints];
  [self.socialShareView setupSubviewsConstraints];
  [self setupFinalThankYouLabelConstraints];
  [self setupSendButtonConstraints];
  [self setupDismissButtonConstraints];
  [self setupPoweredByWootricConstraints];
}

#pragma mark - Buttons

- (void)setupPoweredByWootricConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:self.poweredByWootric
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constX];

  NSLayoutConstraint *constBottom = [NSLayoutConstraint constraintWithItem:self.poweredByWootric
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.modalView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:-14];
  [self.modalView addConstraint:constBottom];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self.poweredByWootric
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:12];
  [self.poweredByWootric addConstraint:constH];
}

- (void)setupDismissButtonConstraints {
  NSLayoutConstraint *constT = [NSLayoutConstraint constraintWithItem:self.modalView.dismissButton
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:-8];
  [self.modalView addConstraint:constT];

  NSLayoutConstraint *constR = [NSLayoutConstraint constraintWithItem:self.modalView.dismissButton
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-8];
  [self.modalView addConstraint:constR];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self.modalView.dismissButton
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:32];
  [self.modalView.dismissButton addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self.modalView.dismissButton
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:32];
  [self.modalView.dismissButton addConstraint:constH];
}

- (void)setupSendButtonConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:-40];
  [self.modalView addConstraint:constY];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:144];
  [self.sendButton addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:40];
  [self.sendButton addConstraint:constH];
}

#pragma mark - ScrollView

- (void)setupScrollViewConstraints {
  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constH];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constY];
}

#pragma mark - Modals

- (void)setupFeedbackViewConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:self.feedbackView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:self.feedbackView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constY];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self.feedbackView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:2];
  [self.view addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self.feedbackView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:213];
  [self.feedbackView addConstraint:constH];
}

- (void)setupModalConstraints {
  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self.modalView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constW];

  self.constraintModalHeight = [NSLayoutConstraint constraintWithItem:self.modalView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:308];
  [self.modalView addConstraint:self.constraintModalHeight];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:self.modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constX];

  NSLayoutConstraint *constB = [NSLayoutConstraint constraintWithItem:self.modalView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.scrollView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0];
  [self.scrollView addConstraint:constB];

  self.constraintTopToModalTop = [NSLayoutConstraint constraintWithItem:self.modalView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.scrollView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:self.view.frame.size.height + 32];

  [self.scrollView addConstraint:self.constraintTopToModalTop];

  NSLayoutConstraint *constL = [NSLayoutConstraint constraintWithItem:self.modalView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.scrollView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0];
  [self.scrollView addConstraint:constL];

  NSLayoutConstraint *constR = [NSLayoutConstraint constraintWithItem:self.modalView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.scrollView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0];
  [self.scrollView addConstraint:constR];
}

- (void)setupQuestionViewConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:self.questionView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:self.questionView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constY];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self.questionView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:2];
  [self.view addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self.questionView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:213];
  [self.questionView addConstraint:constH];
}

- (void)setupSocialShareViewConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:self.socialShareView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:self.socialShareView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constY];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self.socialShareView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:2];
  [self.view addConstraint:constW];

  self.socialShareViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.socialShareView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:270];
  [self.socialShareView addConstraint:self.socialShareViewHeightConstraint];
}

- (void)setupFinalThankYouLabelConstraints {
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:self.finalThankYouLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.modalView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:36];
  [self.modalView addConstraint:constTop];

  NSLayoutConstraint *constLeft = [NSLayoutConstraint constraintWithItem:self.finalThankYouLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.modalView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:24];
  [self.modalView addConstraint:constLeft];

  NSLayoutConstraint *constRight = [NSLayoutConstraint constraintWithItem:self.modalView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.finalThankYouLabel
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:24];
  [self.modalView addConstraint:constRight];
}

@end

//
//  WTRiPADSurveyViewController+Constraints.m
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

#import "WTRiPADSurveyViewController+Constraints.h"
#import "SimpleConstraints.h"

@implementation WTRiPADSurveyViewController (Constraints)

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
  [self setupPoweredByWootricConstraints];
  [self setupDismissButtonConstraints];
}

- (void)setupPoweredByWootricConstraints {
  [self.poweredByWootric wtr_constraintHeight:12];
  [[[self.poweredByWootric wtr_centerXConstraint] toSecondViewCenterX:self.modalView] addToView:self.modalView];
  [[[[self.poweredByWootric wtr_bottomConstraint] toSecondViewBottom:self.modalView] withConstant:-14] addToView:self.modalView];
}

- (void)setupScrollViewConstraints {
  [self.scrollView wtr_constraintWidthEqualSecondViewWidth:self.view];
  [self.scrollView wtr_constraintHeightEqualSecondViewHeight:self.view];
  [[[self.scrollView wtr_centerXConstraint] toSecondViewCenterX:self.view] addConstraint];
  [[[self.scrollView wtr_centerYConstraint] toSecondViewCenterY:self.view] addConstraint];
}

- (void)setupModalConstraints {
  self.constraintModalHeight = [NSLayoutConstraint constraintWithItem:self.modalView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:165];

  [self.modalView addConstraint:self.constraintModalHeight];

  self.constraintTopToModalTop = [NSLayoutConstraint constraintWithItem:self.modalView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.scrollView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:self.view.frame.size.height];

  [self.scrollView addConstraint:self.constraintTopToModalTop];

  [self.modalView wtr_constraintWidthEqualSecondViewWidth:self.view];
  [[[self.modalView wtr_centerXConstraint] toSecondViewCenterX:self.view] addToView:self.view];
  [[[self.modalView wtr_bottomConstraint] toSecondViewBottom:self.scrollView] addToView:self.scrollView];
  [[[self.modalView wtr_leftConstraint] toSecondViewLeft:self.scrollView] addToView:self.scrollView];
  [[[self.modalView wtr_rightConstraint] toSecondViewRight:self.scrollView] addToView:self.scrollView];
}

- (void)setupQuestionViewConstraints {
  [self.questionView wtr_constraintWidthEqualSecondViewWidth:self.view];
  [self.questionView wtr_constraintHeight:110];
  [[[self.questionView wtr_centerXConstraint] toSecondViewCenterX:self.modalView] addToView:self.modalView];
  self.constraintQuestionTopToModalTop = [[self.questionView wtr_topConstraint] toSecondViewTop:self.modalView];
  [self.constraintQuestionTopToModalTop addToView:self.modalView];
}

- (void)setupFeedbackViewConstraints {
  [self.feedbackView wtr_constraintHeight:100];
  [self.feedbackView wtr_constraintWidthToSecondViewWidth:self.view withConstant:-80];
  [[[self.feedbackView wtr_topConstraint] toSecondViewTop:self.modalView] addToView:self.modalView];
  [[[self.feedbackView wtr_centerXConstraint] toSecondViewCenterX:self.modalView] addToView:self.modalView];
}

- (void)setupSocialShareViewConstraints {
  [self.socialShareView wtr_constraintWidthEqualSecondViewWidth:self.view];
  [[[self.socialShareView wtr_topConstraint] toSecondViewTop:self.modalView] addToView:self.modalView];
  [[[self.socialShareView wtr_centerXConstraint] toSecondViewCenterX:self.modalView] addToView:self.modalView];

  self.socialShareViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.socialShareView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:165];

  [self.socialShareView addConstraint:self.socialShareViewHeightConstraint];
}

- (void)setupFinalThankYouLabelConstraints {
  [[[[self.finalThankYouLabel wtr_topConstraint] toSecondViewTop:self.modalView] withConstant:36] addToView:self.modalView];
  [[[[self.finalThankYouLabel wtr_leftConstraint] toSecondViewLeft:self.modalView] withConstant:24] addToView:self.modalView];
  [[[[self.finalThankYouLabel wtr_rightConstraint] toSecondViewRight:self.modalView] withConstant:-24] addToView:self.modalView];
}

- (void)setupDismissButtonConstraints {
  [self.dismissButton wtr_constraintHeight:30];
  [self.dismissButton wtr_constraintWidth:30];
  [[[[self.dismissButton wtr_topConstraint] toSecondViewTop:self.modalView] withConstant:8] addToView:self.view];
  [[[[self.dismissButton wtr_rightConstraint] toSecondViewRight:self.modalView] withConstant:-8] addToView:self.view];
}

@end

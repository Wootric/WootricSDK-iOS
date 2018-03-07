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
#import "UIView+SafeArea.h"

@implementation WTRiPADSurveyViewController (Constraints)

- (void)setupConstraints {
  [self setupScrollViewConstraints];
  [self setupScrollContentViewConstraints];
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
  [[[self.poweredByWootric wtr_centerXConstraint] toSecondItemCenterX:self.modalView] addToView:self.modalView];
  [[[[self.poweredByWootric wtr_bottomConstraint] toSecondItemBottom:self.modalView] withConstant:-14] addToView:self.modalView];
}

- (void)setupScrollViewConstraints {
  [self.scrollView wtr_constraintWidthEqualSecondViewWidth:self.view];
  [self.scrollView wtr_constraintHeightEqualSecondViewHeight:self.view];
  [[[self.scrollView wtr_centerXConstraint] toSecondItemCenterX:self.view] addConstraint];
  [[[self.scrollView wtr_centerYConstraint] toSecondItemCenterY:self.view] addConstraint];
}

- (void) setupScrollContentViewConstraints {
  // The scroll content view will be at least as large as the scroll view itself.  It can expand to be taller.
  NSDictionary * views = @{@"scrollContentView": self.scrollContentView};
  NSArray<NSLayoutConstraint *> * horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollContentView]|" options:0 metrics:nil views:views];
  [self.scrollView addConstraints:horizontalConstraints];
  
  // Stuck to bottom
  NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:self.scrollContentView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.scrollView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0.0];
  [self.scrollView addConstraint:bottom];
  
  // Stick to the scroll content to the top of the scroll view.  The lower priority allows this constraint to be
  //  broken when the modal view grows taller than the scroll view.
  NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.scrollContentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0];
  top.priority = UILayoutPriorityDefaultHigh;
  [self.scrollView addConstraint:top];
  
  // Height at least as much as the scroll view
  NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:self.scrollContentView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                toItem:self.scrollView
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0
                                                              constant:0.0];
  [self.scrollView addConstraint:height];
  
  // Expand to be as tall as the modal
  NSLayoutConstraint * modalForcedHeight = [NSLayoutConstraint constraintWithItem:self.scrollContentView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:self.modalView
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:0.0];
  [self.scrollView addConstraint:modalForcedHeight];
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

  id scrollContentLayoutArea = [self.scrollContentView layoutAreaItemForConstraints];
  [self.modalView wtr_constraintWidthEqualSecondViewWidth:self.view];
  [[[self.modalView wtr_centerXConstraint] toSecondItemCenterX:self.view] addToView:self.view];
  [[[self.modalView wtr_bottomConstraint] toSecondItemBottom:scrollContentLayoutArea] addToView:self.scrollContentView];
  [[[self.modalView wtr_leftConstraint] toSecondItemLeft:scrollContentLayoutArea] addToView:self.scrollContentView];
  [[[self.modalView wtr_rightConstraint] toSecondItemRight:scrollContentLayoutArea] addToView:self.scrollContentView];
}

- (void)setupQuestionViewConstraints {
  [self.questionView wtr_constraintWidthEqualSecondViewWidth:self.view];
  [self.questionView wtr_constraintHeight:110];
  [[[self.questionView wtr_centerXConstraint] toSecondItemCenterX:self.modalView] addToView:self.modalView];
  self.constraintQuestionTopToModalTop = [[self.questionView wtr_topConstraint] toSecondItemTop:self.modalView];
  [self.constraintQuestionTopToModalTop addToView:self.modalView];
}

- (void)setupFeedbackViewConstraints {
  [self.feedbackView wtr_constraintHeight:100];
  [self.feedbackView wtr_constraintWidthToSecondViewWidth:self.view withConstant:-80];
  [[[self.feedbackView wtr_topConstraint] toSecondItemTop:self.modalView] addToView:self.modalView];
  [[[self.feedbackView wtr_centerXConstraint] toSecondItemCenterX:self.modalView] addToView:self.modalView];
}

- (void)setupSocialShareViewConstraints {
  [self.socialShareView wtr_constraintWidthEqualSecondViewWidth:self.view];
  [[[self.socialShareView wtr_topConstraint] toSecondItemTop:self.modalView] addToView:self.modalView];
  [[[self.socialShareView wtr_centerXConstraint] toSecondItemCenterX:self.modalView] addToView:self.modalView];

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
  [[[[self.finalThankYouLabel wtr_topConstraint] toSecondItemTop:self.modalView] withConstant:36] addToView:self.modalView];
  [[[[self.finalThankYouLabel wtr_leftConstraint] toSecondItemLeft:self.modalView] withConstant:24] addToView:self.modalView];
  [[[[self.finalThankYouLabel wtr_rightConstraint] toSecondItemRight:self.modalView] withConstant:-24] addToView:self.modalView];
}

- (void)setupDismissButtonConstraints {
  [self.dismissButton wtr_constraintHeight:30];
  [self.dismissButton wtr_constraintWidth:30];
  [[[[self.dismissButton wtr_topConstraint] toSecondItemTop:self.modalView] withConstant:8] addToView:self.view];
  [[[[self.dismissButton wtr_rightConstraint] toSecondItemRight:self.modalView] withConstant:-8] addToView:self.view];
}

@end

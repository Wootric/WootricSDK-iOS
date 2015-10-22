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
  [self setupNpsQuestionViewConstraints];
  [self.npsQuestionView setupSubviewsConstraints];
  [self setupPoweredByWootricConstraints];
  [self setupDismissButtonConstraints];
}

- (void)setupPoweredByWootricConstraints {
  [self.poweredByWootric constraintHeight:12];
  [[[self.poweredByWootric centerX] toSecondViewCenterX:self.modalView] addToView:self.modalView];
  [[[[self.poweredByWootric bottom] toSecondViewBottom:self.modalView] withConstant:-14] addToView:self.modalView];
}

- (void)setupScrollViewConstraints {
  [self.scrollView constraintWidthEqualSecondViewWidth:self.view];
  [self.scrollView constraintHeightEqualSecondViewHeight:self.view];
  [[[self.scrollView centerX] toSecondViewCenterX:self.view] addConstraint];
  [[[self.scrollView centerY] toSecondViewCenterY:self.view] addConstraint];
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

  [self.modalView constraintWidthEqualSecondViewWidth:self.view];
  [[[self.modalView centerX] toSecondViewCenterX:self.view] addToView:self.view];
  [[[self.modalView bottom] toSecondViewBottom:self.scrollView] addToView:self.scrollView];
  [[[self.modalView left] toSecondViewLeft:self.scrollView] addToView:self.scrollView];
  [[[self.modalView right] toSecondViewRight:self.scrollView] addToView:self.scrollView];
}

- (void)setupNpsQuestionViewConstraints {
  [self.npsQuestionView constraintWidthEqualSecondViewWidth:self.view];
  [self.npsQuestionView constraintHeight:100];
  [[[self.npsQuestionView centerX] toSecondViewCenterX:self.modalView] addToView:self.modalView];
  [[[self.npsQuestionView top] toSecondViewTop:self.modalView] addToView:self.modalView];
}

- (void)setupDismissButtonConstraints {
  [self.dismissButton constraintHeight:30];
  [self.dismissButton constraintWidth:30];
  [[[[self.dismissButton top] toSecondViewTop:self.modalView] withConstant:8] addToView:self.view];
  [[[[self.dismissButton right] toSecondViewRight:self.modalView] withConstant:-8] addToView:self.view];
}

@end

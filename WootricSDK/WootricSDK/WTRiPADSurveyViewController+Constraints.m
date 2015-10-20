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

@implementation WTRiPADSurveyViewController (Constraints)

- (void)setupConstraints {
  [self setupScrollViewConstraints];
  [self setupModalConstraints];
  [self setupNpsQuestionViewConstraints];
  [self.npsQuestionView setupSubviewsConstraints];
  [self setupPoweredByWootricConstraints];
}

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
                                                             constant:150];
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
                                                               constant:self.view.frame.size.height];

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

- (void)setupNpsQuestionViewConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:self.npsQuestionView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:self.npsQuestionView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.modalView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0];
  [self.modalView addConstraint:constY];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self.npsQuestionView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self.npsQuestionView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:100];
  [self.npsQuestionView addConstraint:constH];
}

@end

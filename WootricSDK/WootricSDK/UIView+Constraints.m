//
//  UIView+UIView_Constraints.m
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

#import "UIView+Constraints.h"

@implementation UIView (Constraints)

- (NSLayoutConstraint *)wtr_topConstraint {
  UIView *emptyView = [[UIView alloc] init];
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:emptyView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:0];
  return constraint;
}

- (NSLayoutConstraint *)wtr_bottomConstraint {
  UIView *emptyView = [[UIView alloc] init];
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:emptyView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:0];
  return constraint;
}

- (NSLayoutConstraint *)wtr_leftConstraint {
  UIView *emptyView = [[UIView alloc] init];
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:emptyView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:0];
  return constraint;
}

- (NSLayoutConstraint *)wtr_rightConstraint {
  UIView *emptyView = [[UIView alloc] init];
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:emptyView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:0];
  return constraint;
}

- (NSLayoutConstraint *)wtr_centerXConstraint {
  UIView *emptyView = [[UIView alloc] init];
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:emptyView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:0];
  return constraint;
}

- (NSLayoutConstraint *)wtr_centerYConstraint {
  UIView *emptyView = [[UIView alloc] init];
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:emptyView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0];
  return constraint;
}

- (void)wtr_constraintHeight:(CGFloat)height {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1
                                                                 constant:height];

  [self addConstraint:constraint];
}

- (void)wtr_constraintWidth:(CGFloat)width {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1
                                                                 constant:width];

  [self addConstraint:constraint];
}

- (void)wtr_constraintHeightEqualSecondViewHeight:(UIView *)secondView {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1
                                                                 constant:0];

  [secondView addConstraint:constraint];
}

- (void)wtr_constraintWidthEqualSecondViewWidth:(UIView *)secondView {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1
                                                                 constant:0];

  [secondView addConstraint:constraint];
}

- (void)wtr_constraintHeightToSecondViewHeight:(UIView *)secondView withConstant:(CGFloat)constant {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1
                                                                 constant:constant];

  [secondView addConstraint:constraint];
}

- (void)wtr_constraintWidthToSecondViewWidth:(UIView *)secondView withConstant:(CGFloat)constant {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1
                                                                 constant:constant];

  [secondView addConstraint:constraint];
}

@end

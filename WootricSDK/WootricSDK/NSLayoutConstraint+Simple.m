//
//  NSLayoutConstraint+Simple.m
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

#import "NSLayoutConstraint+Simple.h"

@implementation NSLayoutConstraint (Simple)

- (void)addToView:(UIView *)view {
  [view addConstraint:self];
}

- (NSLayoutConstraint *)withConstant:(CGFloat)constant {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                attribute:self.firstAttribute
                                                                relatedBy:self.relation
                                                                   toItem:self.secondItem
                                                                attribute:self.secondAttribute
                                                               multiplier:self.multiplier
                                                                 constant:constant];

  return constraint;
}

- (NSLayoutConstraint *)toSecondViewTop:(UIView *)secondView {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                attribute:self.firstAttribute
                                                                relatedBy:self.relation
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:self.multiplier
                                                                 constant:self.constant];

  return constraint;
}

- (NSLayoutConstraint *)toSecondViewBottom:(UIView *)secondView {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                attribute:self.firstAttribute
                                                                relatedBy:self.relation
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:self.multiplier
                                                                 constant:self.constant];

  return constraint;
}

- (NSLayoutConstraint *)toSecondViewLeft:(UIView *)secondView {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                attribute:self.firstAttribute
                                                                relatedBy:self.relation
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:self.multiplier
                                                                 constant:self.constant];

  return constraint;
}

- (NSLayoutConstraint *)toSecondViewRight:(UIView *)secondView {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                attribute:self.firstAttribute
                                                                relatedBy:self.relation
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:self.multiplier
                                                                 constant:self.constant];

  return constraint;
}

- (NSLayoutConstraint *)toSecondViewCenterX:(UIView *)secondView {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                attribute:self.firstAttribute
                                                                relatedBy:self.relation
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:self.multiplier
                                                                 constant:self.constant];

  return constraint;
}

- (NSLayoutConstraint *)toSecondViewCenterY:(UIView *)secondView {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem
                                                                attribute:self.firstAttribute
                                                                relatedBy:self.relation
                                                                   toItem:secondView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:self.multiplier
                                                                 constant:self.constant];

  return constraint;
}

- (void)addConstraint {
  [self.secondItem addConstraint:self];
}

@end

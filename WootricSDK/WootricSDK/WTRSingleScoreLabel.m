//
//  WTRSingleScoreLabel.m
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

#import "WTRSingleScoreLabel.h"
#import "SimpleConstraints.h"
#import "WTRColor.h"

@interface WTRSingleScoreLabel ()

@property (nonatomic, strong) UIColor *selectedColor;

@end

@implementation WTRSingleScoreLabel

- (instancetype)init {
  return [self initWithColor:[WTRColor selectedValueScoreColor]];
}

- (instancetype)initWithColor:(UIColor *)color {
  if (self = [super init]) {
    _selectedColor = color;
    self.textColor = [WTRColor anchorAndScoreColor];
    self.font = [UIFont systemFontOfSize:16];
    self.textAlignment = NSTextAlignmentCenter;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)setAsSelected {
  self.textColor = _selectedColor;
  self.font = [UIFont boldSystemFontOfSize:20];
}

- (void)setAsUnselected {
  self.textColor = [WTRColor anchorAndScoreColor];
  self.font = [UIFont systemFontOfSize:16];
}

- (void)addConstraintsWithLeftConstraintConstant:(CGFloat)leftConstant {
  UIView *superView = self.superview;

  self.leftConstraint = [NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:superView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:leftConstant];

  [superView addConstraint:self.leftConstraint];

  [[[self wtr_centerYConstraint] toSecondViewCenterY:superView] addToView:superView];
  [self wtr_constraintWidth:24];
  [self wtr_constraintHeight:16];
}

@end

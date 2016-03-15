//
//  WTRSliderDot.m
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

#import "WTRSliderDot.h"
#import "WTRColor.h"

@interface WTRSliderDot ()

@property (nonatomic, strong) UIColor *dotSelectedColor;

@end

@implementation WTRSliderDot

- (instancetype)init {
  return [self initWithColor:[WTRColor sliderDotBorderColor]];
}

- (instancetype)initWithColor:(UIColor *)color {
  if (self = [super init]) {
    _dotSelectedColor = color;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [WTRColor sliderDotBorderColor].CGColor;
    self.layer.masksToBounds = YES;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)setAsSelected {
  self.backgroundColor = _dotSelectedColor;
  self.layer.borderColor = _dotSelectedColor.CGColor;
}

- (void)setAsUnselected {
  self.backgroundColor = [UIColor whiteColor];
  self.layer.borderColor = [WTRColor sliderDotBorderColor].CGColor;
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

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:superView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0];

  [superView addConstraint:constY];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:8];
  [self addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:8];
  [self addConstraint:constH];
}

@end

//
//  WTRCircleScoreButton.m
//  WootricSDK
//
// Copyright (c) 2018 Wootric (https://wootric.com)
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

#import "WTRCircleScoreButton.h"
#import "WTRColor.h"
#import "SimpleConstraints.h"
#import "UIItems.h"

@interface WTRCircleScoreButton ()

@property (nonatomic, strong) UIColor *sliderColor;

@end

@implementation WTRCircleScoreButton

- (instancetype)initWithViewController:(UIViewController *)viewController color:(UIColor *)color scoreScaleType:(NSString *)scoreScaleType {
  if (self = [super init]) {
    _isSelected = NO;
    _sliderColor = color;
    _scoreScaleType = scoreScaleType;
    self.backgroundColor = [scoreScaleType isEqualToString:@"filled"] ? _sliderColor : [UIColor whiteColor];
    self.layer.cornerRadius = 21;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [WTRColor iPadCircleButtonBorderColor].CGColor;
    self.titleLabel.font = [UIItems regularFontWithSize:14];
    [self setTitleColor:[WTRColor iPadCircleButtonTextColorForColor:_sliderColor scoreScaleType:_scoreScaleType state:false] forState:UIControlStateNormal];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupConstraints];
    [self addTarget:viewController action:NSSelectorFromString(@"selectScore:") forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)setupConstraints {
  [self wtr_constraintHeight:42];
  [self wtr_constraintWidth:42];
}

- (void)addConstraintsWithSuperview:(UIView *)superView andLeftConstraintConstant:(CGFloat)leftConstant {
  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:superView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0];

  [superView addConstraint:constY];

  NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:superView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1
                                                                     constant:leftConstant];

  [superView addConstraint:leftConstraint];
}

- (void)markAsSelected {
  _isSelected = YES;
  if (_sliderColor) {
    self.backgroundColor = _sliderColor;
  } else {
    self.backgroundColor = [WTRColor iPadCircleButtonSelectedBackgroundColor];
  }
  self.layer.borderColor = [WTRColor iPadCircleButtonBorderColor].CGColor;
  [self setTitleColor:[WTRColor iPadCircleButtonTextColorForColor:_sliderColor scoreScaleType:_scoreScaleType state:true] forState:UIControlStateNormal];
}

- (void)markAsUnselected {
  _isSelected = NO;
  self.backgroundColor = [UIColor whiteColor];
  self.layer.borderColor = [WTRColor iPadCircleButtonBorderColor].CGColor;
  [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

@end

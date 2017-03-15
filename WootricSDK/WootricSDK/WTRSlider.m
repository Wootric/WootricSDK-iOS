//
//  WTRSlider.m
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

#import "WTRSlider.h"
#import "WTRColor.h"
#import "UIImage+ImageFromColor.h"
#import "WTRSliderDot.h"

@interface WTRSlider ()

@property (nonatomic, assign) int currentValue;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) WTRSettings *settings;


@end

@implementation WTRSlider

- (instancetype)initWithSuperview:(UIView *)superview viewController:(UIViewController *)viewController settings:(WTRSettings *)settings  {
    return [self initWithSuperview:superview viewController:viewController settings:(WTRSettings *)settings color:[WTRColor sliderValueColor]];
}

- (instancetype)initWithSuperview:(UIView *)superview viewController:(UIViewController *)viewController settings:(WTRSettings *)settings color:(UIColor *)color {
  if (self = [super init]) {
    _settings = settings;
    _sliderColor = color;
    _currentValue = -1;
    
    self.minimumValue = [_settings minimumScore];
    self.maximumValue = [_settings maximumScore];
    self.value = [_settings minimumScore];
    self.tintColor = [WTRColor sliderBackgroundColor];
    UIImage *image = [[UIImage alloc] init];
    UIImage *greyBackground = [UIImage imageFromColor:[WTRColor sliderBackgroundColor] withSize:24];
    UIImage *selectedBackground = [UIImage imageFromColor:[_sliderColor colorWithAlphaComponent:0.65f] withSize:24];
    [self setMaximumTrackImage:[greyBackground resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
    [self setMinimumTrackImage:[selectedBackground resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
    [self setThumbImage:image forState:UIControlStateNormal];
    [self setThumbImage:image forState:UIControlStateHighlighted];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addTarget:superview action:NSSelectorFromString(@"updateSliderScore:") forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:viewController action:NSSelectorFromString(@"sliderTapped:")];
    [self addGestureRecognizer:gr];
  }
  return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
  [super trackRectForBounds:bounds];
  CGRect customBounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
  return customBounds;
}

- (void)didAddSubview:(UIView *)subview {
  if ([subview isKindOfClass:[UIImageView class]]) {
    if (!_thumbAdded) {
      [self sendSubviewToBack:subview];
      _thumbAdded = YES;
    }
  } else if ([subview isKindOfClass:[UIView class]]) {
    [self sendSubviewToBack:subview];
  }
}

- (void)addDots {
  float sliderWidth = self.frame.size.width;

  for (int i = self.minimumValue; i <= self.maximumValue; i++) {
    WTRSliderDot *dot = [[WTRSliderDot alloc] initWithColor:_sliderColor];
    dot.tag = 9000 + i;
    [self addSubview:dot];

    CGFloat dotX = 8;
    if (i == self.minimumValue) {
      [dot addConstraintsWithLeftConstraintConstant:dotX];
    } else {
      int dotOffset = 2;
      if ([_settings.surveyType isEqualToString:@"CES"]) {
        dotOffset = 3;
      } else if ([_settings.surveyType isEqualToString:@"CSAT"]) {
        if ((int) _settings.surveyTypeScale == 0) {
          dotOffset = 4;
        } else if ((int) _settings.surveyTypeScale == 1) {
          dotOffset = 2;
        }
      }
      dotX += round(sliderWidth / (float) (self.maximumValue - self.minimumValue) * (i - self.minimumValue)) - dotOffset * (i - self.minimumValue);
      [dot addConstraintsWithLeftConstraintConstant:dotX];
    }

    [self bringSubviewToFront:dot];
  }
}

- (void)recalculateDotsPositionForSliderWidth:(CGFloat)sliderWidth {
  for (WTRSliderDot *dot in self.subviews) {
    if (dot.tag) {
      int i = (int)(dot.tag - 9000);
      CGFloat dotX = 8;
      if (i >= 1) {
        int dotOffset = 2;
        if ([_settings.surveyType isEqualToString:@"CES"]) {
          dotOffset = 3;
        } else if ([_settings.surveyType isEqualToString:@"CSAT"]) {
          if ((int) _settings.surveyTypeScale == 0) {
            dotOffset = 4;
          } else if ((int) _settings.surveyTypeScale == 1) {
            dotOffset = 2;
          }
        }
        dotX += round(sliderWidth / (float) (self.maximumValue - self.minimumValue) * (i - self.minimumValue)) - dotOffset * (i - self.minimumValue);
        dot.leftConstraint.constant = dotX;
      }
    }
  }
}

- (void)updateDots {
  int intValue = (int)self.value;
  if (_currentValue != intValue) {
    for (WTRSliderDot *dot in self.subviews) {
      if (dot.tag && (dot.tag <= 9000 + intValue)) {
        [dot setAsSelected];
      } else if (dot.tag) {
        [dot setAsUnselected];
      }
    }
    _currentValue = intValue;
  }
}

- (void)showThumb {
  [self setThumbImage:[UIImage imageFromColor:_sliderColor withSize:24]
             forState:UIControlStateNormal];
  [self setThumbImage:[UIImage imageFromColor:_sliderColor withSize:24]
              forState:UIControlStateHighlighted];
}

- (void)tappedAtPoint:(CGPoint)point {
  if (self.highlighted)
    return;
  CGFloat percentage = point.x / self.bounds.size.width;
  CGFloat delta = percentage * (self.maximumValue - self.minimumValue);
  CGFloat value = self.minimumValue + delta;
  [self setValue:value animated:YES];
}

@end

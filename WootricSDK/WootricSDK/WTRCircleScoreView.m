//
//  WTRCircleScoreView.m
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

#import "WTRCircleScoreView.h"
#import "WTRCircleScoreButton.h"
#import "SimpleConstraints.h"

@implementation WTRCircleScoreView

- (instancetype)initWithViewController:(UIViewController *)viewController settings:(WTRSettings *)settings {
  if (self = [super init]) {
    _settings = settings;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupConstraints];
    [self addCircleButtonsWithViewController:viewController];
  }
  return self;
}

- (void)setupConstraints {
  [self wtr_constraintHeight:42];
  [self wtr_constraintWidth:492];
}

- (void)addCircleButtonsWithViewController:(UIViewController *)viewController {
  for (int i = [_settings minimumScore]; i <= [_settings maximumScore]; i++) {
    WTRCircleScoreButton *circleButton = [[WTRCircleScoreButton alloc] initWithViewController:viewController];
    circleButton.tag = 9000 + i;
    circleButton.assignedScore = i;
    [circleButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
    [self addSubview:circleButton];

    CGFloat buttonX = 0;
    if ([_settings.surveyType isEqualToString:@"CES"]) {
      buttonX = 45;
    } else if ([_settings.surveyType isEqualToString:@"CSAT"]) {
      if ((int) _settings.surveyTypeScale == 0) {
        buttonX = 90;
      } else if ((int) _settings.surveyTypeScale == 1) {
        buttonX = -22;
      }
    }
    buttonX += 42 * i + 3 * i;
    [circleButton addConstraintsWithSuperview:self andLeftConstraintConstant:buttonX];
  }
}

- (void)selectCircleButton:(WTRCircleScoreButton *)button {
  for (WTRCircleScoreButton *circleButton in self.subviews) {
    if (circleButton.tag >= 9000) {
      [circleButton markAsUnselected];
    }
  }
  [button markAsSelected];
}

@end

//
//  WTRScoreView.m
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

#import "WTRScoreView.h"
#import "WTRSingleScoreLabel.h"
#import "WTRColor.h"

@interface WTRScoreView ()

@property (nonatomic, assign) int currentValue;
@property (nonatomic, strong) WTRSettings *settings;
@property (nonatomic, strong) UIColor *labelColor;

@end

@implementation WTRScoreView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  return [self initWithSettings:settings color:[WTRColor selectedValueScoreColor]];
}

- (instancetype)initWithSettings:(WTRSettings *)settings color:(UIColor *)color {
  if (self = [super init]) {
    _settings = settings;
    _labelColor = color;
    _currentValue = -1;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)addScores {
  float scoreLabelWidth = self.frame.size.width;
  int minimumScore = [_settings minimumScore];
  int maximumScore = [_settings maximumScore];

  for (int i = minimumScore; i <= maximumScore; i++) {
    WTRSingleScoreLabel *label = [[WTRSingleScoreLabel alloc] initWithColor:_labelColor];
    label.tag = 9000 + i;
    label.text = [NSString stringWithFormat:@"%d", i];
    [self addSubview:label];

    CGFloat labelX = 10;
    if (i == minimumScore) {
      [label addConstraintsWithLeftConstraintConstant:labelX];
    } else {
      int labelOffset = 2;
      if ([_settings.surveyType isEqualToString:@"CES"]) {
        labelOffset = 3;
      } else if ([_settings.surveyType isEqualToString:@"CSAT"]) {
        if ((int) _settings.surveyTypeScale == 0) {
          labelOffset = 4;
        } else if ((int) _settings.surveyTypeScale == 1) {
          labelOffset = 2;
        }
      }
      labelX += round(scoreLabelWidth / (float) (maximumScore - minimumScore) * (i - minimumScore)) - labelOffset * (i - minimumScore);
      [label addConstraintsWithLeftConstraintConstant:labelX];
    }
  }
}

- (void)recalculateScorePositionForScoreLabelWidth:(CGFloat)scoreLabelWidth {
  int minimumScore = [_settings minimumScore];
  int maximumScore = [_settings maximumScore];
  for (WTRSingleScoreLabel *label in self.subviews) {
    if (label.tag) {
      int i = (int)(label.tag - 9000);
      CGFloat labelX = 10;
      if (i >= 1) {
        int labelOffset = 2;
        if ([_settings.surveyType isEqualToString:@"CES"]) {
          labelOffset = 3;
        } else if ([_settings.surveyType isEqualToString:@"CSAT"]) {
          if ((int) _settings.surveyTypeScale == 0) {
            labelOffset = 4;
          } else if ((int) _settings.surveyTypeScale == 1) {
            labelOffset = 2;
          }
        }
        labelX += round(scoreLabelWidth / (float) (maximumScore - minimumScore) * (i - minimumScore)) - labelOffset * (i - minimumScore);
        label.leftConstraint.constant = labelX;
      }
    }
  }
}

- (void)highlightCurrentScore:(int)currentScore {
  if (_currentValue != currentScore) {
    for (WTRSingleScoreLabel *label in self.subviews) {
      if (label.tag && (label.tag == 9000 + currentScore)) {
        [label setAsSelected];
      } else if (label.tag) {
        [label setAsUnselected];
      }
    }
    _currentValue = currentScore;
  }
}

@end

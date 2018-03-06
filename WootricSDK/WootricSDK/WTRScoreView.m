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

static const CGFloat EndNumbersDistanceCenterToEdge = 10.0;

@interface WTRScoreView ()

@property (nonatomic, strong) WTRSettings *settings;
@property (nonatomic, strong) UIColor *labelColor;

@end

@implementation WTRScoreView
{
  NSArray<WTRSingleScoreLabel *> * scoreLabels;
  NSArray<UIView *> * spacers;
}

- (instancetype)initWithSettings:(WTRSettings *)settings {
  return [self initWithSettings:settings color:[WTRColor selectedValueScoreColor]];
}

- (instancetype)initWithSettings:(WTRSettings *)settings color:(UIColor *)color {
  if (self = [super init]) {
    _settings = settings;
    _labelColor = color;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)addScores {
  // Remove any previous labels/spacers
  [scoreLabels enumerateObjectsUsingBlock:^(WTRSingleScoreLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj removeFromSuperview];
  }];
  [spacers enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj removeFromSuperview];
  }];
  
  NSUInteger labelCount = _settings.maximumScore - _settings.minimumScore + 1;
  
  if (labelCount < 2) {
    return;
  }
  
  NSMutableArray<WTRSingleScoreLabel *> * newLabels = [[NSMutableArray alloc] initWithCapacity:labelCount];
  NSMutableArray<UIView *> * newSpacers = [[NSMutableArray alloc] initWithCapacity:labelCount - 1];
  WTRSingleScoreLabel * firstLabel = nil;
  
  for (int i = _settings.minimumScore; i <= _settings.maximumScore; i++) {
    WTRSingleScoreLabel * label = [[WTRSingleScoreLabel alloc] initWithColor:_labelColor];
    label.text = [NSString stringWithFormat:@"%d", i];
    [self addSubview:label];
    [newLabels addObject:label];
    
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem:label
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0.0];
    [self addConstraint:centerY];
    
    if (firstLabel == nil) {
      firstLabel = label;
    } else {
      NSLayoutConstraint * sameWidth = [NSLayoutConstraint constraintWithItem:label
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:firstLabel
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0
                                                                     constant:0.0];
      [self addConstraint:sameWidth];
    }
  }
  
  // Pin leftmost and rightmost labels to edges
  NSLayoutConstraint * leftmostLabelLeftness = [NSLayoutConstraint constraintWithItem:[newLabels firstObject]
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0
                                                                             constant:EndNumbersDistanceCenterToEdge];
  
  NSLayoutConstraint * rightmostLabelRightness = [NSLayoutConstraint constraintWithItem:self
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:[newLabels lastObject]
                                                                              attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1.0
                                                                               constant:EndNumbersDistanceCenterToEdge];
  
  [self addConstraints:@[leftmostLabelLeftness, rightmostLabelRightness]];
  
  // Put spacers between labels
  UIView * firstSpacer = nil;
  
  for (NSUInteger i = 0; i < (labelCount - 1); i++) {
    WTRSingleScoreLabel * leftLabel = newLabels[i];
    WTRSingleScoreLabel * rightLabel = newLabels[i + 1];
    
    UIView * spacer = [[UIView alloc] init];
    spacer.translatesAutoresizingMaskIntoConstraints = NO;
    spacer.hidden = YES;
    [self addSubview:spacer];
    
    // 1 pt tall for no particular reason
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:spacer
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:1.0];
    
    // Hold them both
    NSLayoutConstraint * leftHandhold = [NSLayoutConstraint constraintWithItem:leftLabel
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:spacer
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:0.0];
    
    NSLayoutConstraint * rightHandhold = [NSLayoutConstraint constraintWithItem:spacer
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:rightLabel
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    [self addConstraints:@[height, leftHandhold, rightHandhold]];
    
    // Same widths
    if (i == 0) {
      firstSpacer = spacer;
    } else {
      NSLayoutConstraint * sameWidth = [NSLayoutConstraint constraintWithItem:spacer
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:firstSpacer
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0
                                                                     constant:0.0];
      
      [self addConstraint:sameWidth];
    }
    
    [newSpacers addObject:spacer];
  }
  
  scoreLabels = newLabels;
  spacers = newSpacers;
}

- (void)highlightCurrentScore:(int)currentScore {
  NSUInteger labelIndex = currentScore - _settings.minimumScore;
  
  [scoreLabels enumerateObjectsUsingBlock:^(WTRSingleScoreLabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
    if (idx == labelIndex) {
      [label setAsSelected];
    } else {
      [label setAsUnselected];
    }
  }];
}

@end

//
//  WTRQuestionView.m
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

#import "WTRQuestionView.h"
#import "WTRColor.h"
#import "WTRScoreView.h"
#import "WTRSlider.h"
#import "UIItems.h"

@interface WTRQuestionView ()

@property (nonatomic, assign) BOOL firstTap;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *likelyAnchor;
@property (nonatomic, strong) UILabel *notLikelyAnchor;
@property (nonatomic, strong) UIButton *poweredByWootric;
@property (nonatomic, strong) WTRSlider *scoreSlider;
@property (nonatomic, strong) WTRScoreView *scoreLabel;
@property (nonatomic, strong) WTRSettings *settings;

@end

@implementation WTRQuestionView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [WTRColor sliderModalBorderColor].CGColor;
    _settings = settings;
    _firstTap = YES;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)recalculateDotsAndScorePositionForWidth:(CGFloat)widthAfterRotation {
  [_scoreSlider recalculateDotsPositionForSliderWidth:widthAfterRotation];
  [_scoreLabel recalculateScorePositionForScoreLabelWidth:widthAfterRotation];
}

- (void)addDotsAndScores {
  [_scoreSlider addDots];
  [_scoreLabel addScores];
}

- (int)getScoreSliderValue {
  return (int)_scoreSlider.value;
}

- (void)highlightAnchorForScore:(int)currentScore {
  if (currentScore == 0) {
    _notLikelyAnchor.textColor = [_settings sliderColor];
    _likelyAnchor.textColor = [WTRColor anchorAndScoreColor];
  } else if (currentScore == 10) {
    _likelyAnchor.textColor = [_settings sliderColor];
    _notLikelyAnchor.textColor = [WTRColor anchorAndScoreColor];
  } else {
    _notLikelyAnchor.textColor = [WTRColor anchorAndScoreColor];
    _likelyAnchor.textColor = [WTRColor anchorAndScoreColor];
  }
}

- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer {
  [_scoreSlider tappedAtPoint:[gestureRecognizer locationInView: _scoreSlider]];
  [self updateSliderScore:_scoreSlider];
}

- (void)updateSliderScore:(UISlider *)sender {
  if (_firstTap) {
    [_scoreSlider showThumb];
  }
  float currentValue = round(sender.value);
  int currentScore = (int)currentValue;
  _scoreSlider.value = currentValue;
  [_scoreSlider updateDots];
  [_scoreLabel highlightCurrentScore:currentScore];
  [self highlightAnchorForScore:(int)currentScore];
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupQuestionLabel];
  [self setupLikelyAnchor];
  [self setupNotLikelyAnchor];
  [self setupSliderWithSuperview:self andViewController:viewController];
  [self setupScoreLabel];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupQuestionLabelConstraints];
  [self setupSliderConstraints];
  [self setupScoreLabelConstraints];
  [self setupLikelyAnchorConstraints];
  [self setupNotLikelyAnchorConstraints];
}

#pragma mark - Subviews setup

- (void)setupQuestionLabel {
  if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
    _questionLabel = [UIItems questionLabelWithSettings:_settings
                                                      andFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]];
  } else {
    _questionLabel = [UIItems questionLabelWithSettings:_settings
                                                      andFont:[UIFont systemFontOfSize:18]];
  }
}

- (void)setupLikelyAnchor {
  _likelyAnchor = [UIItems likelyAnchorWithSettings:_settings
                                            andFont:[UIFont systemFontOfSize:14]];
}

- (void)setupNotLikelyAnchor {
  _notLikelyAnchor = [UIItems notLikelyAnchorWithSettings:_settings
                                                  andFont:[UIFont systemFontOfSize:14]];
}

- (void)setupSliderWithSuperview:(UIView *)superview andViewController:(UIViewController *)viewController {
  self.scoreSlider = [[WTRSlider alloc] initWithSuperview:superview viewController:viewController  settings:_settings color:[_settings sliderColor]];
}

- (void)setupScoreLabel {
  self.scoreLabel = [[WTRScoreView alloc] initWithSettings:_settings color:[_settings sliderColor]];
}

- (void)addSubviews {
  [self addSubview:_questionLabel];
  [self addSubview:_scoreSlider];
  [self addSubview:_scoreLabel];
  [self addSubview:_likelyAnchor];
  [self addSubview:_notLikelyAnchor];
}

#pragma mark - Subviews constraints

- (void)setupLikelyAnchorConstraints {
  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_likelyAnchor
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scoreSlider
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:16];
  [self addConstraint:constY];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_likelyAnchor
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0];
  [self addConstraint:constX];
}

- (void)setupNotLikelyAnchorConstraints {
  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_notLikelyAnchor
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scoreSlider
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:16];
  [self addConstraint:constY];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_notLikelyAnchor
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scoreSlider
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0];
  [self addConstraint:constX];
}

- (void)setupQuestionLabelConstraints {
  //  CGFloat topMargin = [self isSmallerScreenDevice] ? 30 : 40;
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_questionLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:16];
  [self addConstraint:constTop];

  //  CGFloat margin = [self isSmallerScreenDevice] ? 20 : 50;
  NSLayoutConstraint *constLeft = [NSLayoutConstraint constraintWithItem:_questionLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:20];
  [self addConstraint:constLeft];

  NSLayoutConstraint *constRight = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_questionLabel
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:20];
  [self addConstraint:constRight];
}

- (void)setupSliderConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self addConstraint:constX];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_questionLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:60];
  [self addConstraint:constTop];

  NSLayoutConstraint *constRight = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:-17];

  [self addConstraint:constRight];

  NSLayoutConstraint *constLeft = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:17];

  [self addConstraint:constLeft];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:23];
  [self addConstraint:constH];
}

- (void)setupScoreLabelConstraints {
  NSLayoutConstraint *constRight = [NSLayoutConstraint constraintWithItem:_scoreLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:-15];

  [self addConstraint:constRight];

  NSLayoutConstraint *constLeft = [NSLayoutConstraint constraintWithItem:_scoreLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:15];

  [self addConstraint:constLeft];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_scoreLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_questionLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:24];
  [self addConstraint:constTop];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:self.scoreLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:24];
  [self addConstraint:constH];
}

@end

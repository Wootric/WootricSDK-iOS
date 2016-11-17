//
//  WTRiPADNPSQuestionView.m
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

#import "WTRiPADNPSQuestionView.h"
#import "WTRCircleScoreView.h"
#import "WTRColor.h"
#import "SimpleConstraints.h"
#import "UIItems.h"

@interface WTRiPADNPSQuestionView ()

@property (nonatomic, assign) BOOL firstTap;
@property (nonatomic, strong) UILabel *npsQuestionLabel;
@property (nonatomic, strong) UILabel *likelyAnchor;
@property (nonatomic, strong) UILabel *notLikelyAnchor;
@property (nonatomic, strong) WTRCircleScoreView *scoreView;
@property (nonatomic, strong) WTRSettings *settings;

@end

@implementation WTRiPADNPSQuestionView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    self.backgroundColor = [UIColor whiteColor];
    _settings = settings;
    _firstTap = YES;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupNpsQuestionLabel];
  [self setupLikelyAnchor];
  [self setupNotLikelyAnchor];
  [self setupCircleScoreViewWithViewController:viewController];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupNpsQuestionLabelConstraints];
  [self setupScoreViewConstraints];
  [self setupLikelyAnchorConstraints];
  [self setupNotLikelyAnchorConstraints];
}

- (void)addSubviews {
  [self addSubview:_npsQuestionLabel];
  [self addSubview:_scoreView];
  [self addSubview:_likelyAnchor];
  [self addSubview:_notLikelyAnchor];
}

- (void)hideQuestionLabel {
  _npsQuestionLabel.hidden = YES;
}

- (void)selectCircleButton:(WTRCircleScoreButton *)button {
  [_scoreView selectCircleButton:button];
}

- (void)setupLikelyAnchorConstraints {
  [[[_likelyAnchor wtr_centerYConstraint] toSecondViewCenterY:_scoreView] addToView:self];
  [[[[_likelyAnchor wtr_leftConstraint] toSecondViewRight:_scoreView] withConstant:10] addToView:self];
}

- (void)setupNotLikelyAnchorConstraints {
  [[[_notLikelyAnchor wtr_centerYConstraint] toSecondViewCenterY:_scoreView] addToView:self];
  [[[[_notLikelyAnchor wtr_rightConstraint] toSecondViewLeft:_scoreView] withConstant:-10] addToView:self];
}

- (void)setupNpsQuestionLabelConstraints {
  [[[[_npsQuestionLabel wtr_topConstraint] toSecondViewTop:self] withConstant:20] addToView:self];
  [[[[_npsQuestionLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:45] addToView:self];
  [[[[self wtr_rightConstraint] toSecondViewRight:_npsQuestionLabel] withConstant:45] addToView:self];
}

- (void)setupScoreViewConstraints {
  [[[_scoreView wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_scoreView wtr_topConstraint] toSecondViewBottom:_npsQuestionLabel] withConstant:20] addToView:self];
}

- (void)setupCircleScoreViewWithViewController:(UIViewController *)viewController {
  _scoreView = [[WTRCircleScoreView alloc] initWithViewController:viewController];
}

- (void)setupNpsQuestionLabel {
  _npsQuestionLabel = [UIItems npsQuestionLabelWithSettings:_settings
                                                    andFont:[UIFont systemFontOfSize:18]];
}

- (void)setupLikelyAnchor {
  _likelyAnchor = [UIItems likelyAnchorWithSettings:_settings
                                            andFont:[UIFont italicSystemFontOfSize:12]];
}

- (void)setupNotLikelyAnchor {
  _notLikelyAnchor = [UIItems notLikelyAnchorWithSettings:_settings
                                                  andFont:[UIFont italicSystemFontOfSize:12]];
}

@end

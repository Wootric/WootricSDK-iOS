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
  [[[_likelyAnchor centerY] toSecondViewCenterY:_scoreView] addToView:self];
  [[[[_likelyAnchor left] toSecondViewRight:_scoreView] withConstant:10] addToView:self];
}

- (void)setupNotLikelyAnchorConstraints {
  [[[_notLikelyAnchor centerY] toSecondViewCenterY:_scoreView] addToView:self];
  [[[[_notLikelyAnchor right] toSecondViewLeft:_scoreView] withConstant:-10] addToView:self];
}

- (void)setupNpsQuestionLabelConstraints {
  [[[[_npsQuestionLabel top] toSecondViewTop:self] withConstant:20] addToView:self];
  [[[[_npsQuestionLabel left] toSecondViewLeft:self] withConstant:45] addToView:self];
  [[[[self right] toSecondViewRight:_npsQuestionLabel] withConstant:45] addToView:self];
}

- (void)setupScoreViewConstraints {
  [[[_scoreView centerX] toSecondViewCenterX:self] addToView:self];
  [[[[_scoreView top] toSecondViewBottom:_npsQuestionLabel] withConstant:20] addToView:self];
}

- (void)setupCircleScoreViewWithViewController:(UIViewController *)viewController {
  _scoreView = [[WTRCircleScoreView alloc] initWithViewController:viewController];
}

- (void)setupNpsQuestionLabel {
  _npsQuestionLabel = [[UILabel alloc] init];
  _npsQuestionLabel.textAlignment = NSTextAlignmentCenter;
  _npsQuestionLabel.textColor = [UIColor blackColor];
  _npsQuestionLabel.numberOfLines = 0;
  _npsQuestionLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _npsQuestionLabel.font = [UIFont systemFontOfSize:18];
  _npsQuestionLabel.text = [_settings npsQuestionText];
  [_npsQuestionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupLikelyAnchor {
  _likelyAnchor = [[UILabel alloc] init];
  _likelyAnchor.textColor = [WTRColor anchorAndScoreColor];
  _likelyAnchor.text = [self.settings likelyAnchorText];
  _likelyAnchor.font = [UIFont italicSystemFontOfSize:12];
  [_likelyAnchor setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupNotLikelyAnchor {
  _notLikelyAnchor = [[UILabel alloc] init];
  _notLikelyAnchor.textColor = [WTRColor anchorAndScoreColor];
  _notLikelyAnchor.text = [self.settings notLikelyAnchorText];
  _notLikelyAnchor.font = [UIFont italicSystemFontOfSize:12];
  [_notLikelyAnchor setTranslatesAutoresizingMaskIntoConstraints:NO];
}

@end

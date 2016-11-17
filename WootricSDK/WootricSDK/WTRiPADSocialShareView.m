//
//  WTRiPADSocialShareView.m
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

#import "WTRiPADSocialShareView.h"
#import "UIItems.h"
#import "WTRColor.h"
#import "NSString+FontAwesome.h"
#import "WTRiPADThankYouButton.h"
#import "SimpleConstraints.h"

@interface WTRiPADSocialShareView ()

@property (nonatomic, strong) WTRSettings *settings;
@property (nonatomic, strong) UIButton *twitterButton;
@property (nonatomic, strong) UIButton *noThanksButton;
@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UIButton *facebookLikeButton;
@property (nonatomic, strong) UILabel *finalThankYouLabel;
@property (nonatomic, strong) UILabel *customThankYouLabel;
@property (nonatomic, strong) UILabel *socialShareQuestionLabel;
@property (nonatomic, strong) WTRiPADThankYouButton *thankYouButton;
@property (nonatomic, strong) NSLayoutConstraint *twitterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *facebookXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *facebookLikeXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *noThanksXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *thankYouXConstraint;

@end

@implementation WTRiPADSocialShareView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    _settings = settings;
    self.backgroundColor = [UIColor whiteColor];
    self.hidden = YES;
    self.alpha = 0;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }

  return self;
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupFinalThankYouLabel];
  [self setupCustomThankYouLabel];
  [self setupTwitterButtonWithTargetViewController:viewController];
  [self setupThankYouButtonWithTargetViewController:viewController];
  [self setupNoThanksButtonWithTargetViewController:viewController];
  [self setupFacebookButtonWithTargetViewController:viewController];
  [self setupFacebookLikeButtonWithTargetViewController:viewController];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupFinalThankYouLabelConstraints];
  [self setupCustomThankYouLabelConstraints];
  [self setupThankYouButtonConstraints];
  [self setupNoThanksButtonConstraints];
  [self setupFacebookButtonConstraints];
  [self setupTwitterButtonConstraints];
  [self setupFacebookLikeButtonConstraints];
}

- (void)addSubviews {
  [self addSubview:_facebookLikeButton];
  [self addSubview:_twitterButton];
  [self addSubview:_facebookButton];
  [self addSubview:_thankYouButton];
  [self addSubview:_noThanksButton];
  [self addSubview:_finalThankYouLabel];
  [self addSubview:_customThankYouLabel];
  [self addSubview:_socialShareQuestionLabel];
}

- (void)setThankYouMessageDependingOnScore:(int)score {
  if ([_settings thankYouMessageDependingOnScore:score]) {
    _customThankYouLabel.text = [_settings thankYouMessageDependingOnScore:score];
  } else {
    _customThankYouLabel.text = [_settings socialShareQuestionText];
  }
}

- (void)setThankYouButtonTextAndURLDependingOnScore:(int)score andText:(NSString *)text {
  NSString *thankYouText = [_settings thankYouLinkTextDependingOnScore:score];
  NSURL *url = [_settings thankYouLinkURLDependingOnScore:score andText:text];

  [_thankYouButton setText:thankYouText andURL:url];
}

- (void)displayShareButtonsWithTwitterAvailable:(BOOL)twitterAvailable andFacebookAvailable:(BOOL)facebookAvailable {
  CGFloat spacing = 15.0;
  CGFloat socialButtonWidth = _facebookButton.frame.size.width / 2;
  CGFloat totalSpacing = spacing;
  CGFloat buttonsWidth = 0.0;
  CGFloat totalWidth;

  if (facebookAvailable) {
    totalSpacing += 30.0;
    buttonsWidth += 64.0;
    _facebookButton.hidden = NO;
    _facebookLikeButton.hidden = NO;
  }

  if (twitterAvailable) {
    totalSpacing += 15.0;
    buttonsWidth += 32.0;
    _twitterButton.hidden = NO;
  }

  buttonsWidth += _noThanksButton.frame.size.width;
  if (!_thankYouButton.hidden) {
    buttonsWidth += _thankYouButton.frame.size.width;
  }

  totalWidth = buttonsWidth + totalSpacing;

  [self setXConstraintsForFacebook:facebookAvailable
                           twitter:twitterAvailable
                    withTotalWidth:totalWidth
                           spacing:spacing
              andSocialButtonWidth:socialButtonWidth];
}

- (void)setXConstraintsForFacebook:(BOOL)facebookAvailable twitter:(BOOL)twitterAvailable withTotalWidth:(CGFloat)totalWidth spacing:(CGFloat)spacing andSocialButtonWidth:(CGFloat)socialButtonWidth {
  if (twitterAvailable && facebookAvailable) {
    _facebookLikeXConstraint.constant = -(totalWidth / 2) + socialButtonWidth;
    _twitterXConstraint.constant = _facebookLikeXConstraint.constant + (socialButtonWidth * 2) + spacing;
    _facebookXConstraint.constant = _twitterXConstraint.constant + (socialButtonWidth * 2) + spacing;
    _noThanksXConstraint.constant = _facebookXConstraint.constant + socialButtonWidth + spacing + (_noThanksButton.frame.size.width / 2);
  } else {
    if (twitterAvailable) {
      _twitterXConstraint.constant = -(totalWidth / 2) + socialButtonWidth;
      _noThanksXConstraint.constant = _twitterXConstraint.constant + socialButtonWidth + spacing + (_noThanksButton.frame.size.width / 2);
    } else if (facebookAvailable) {
      _facebookLikeXConstraint.constant = -(totalWidth / 2) + socialButtonWidth;
      _facebookXConstraint.constant = _facebookLikeXConstraint.constant + (socialButtonWidth * 2) + spacing;
      _noThanksXConstraint.constant = _facebookXConstraint.constant + socialButtonWidth + spacing + (_noThanksButton.frame.size.width / 2);
    } else {
      _noThanksXConstraint.constant = -(totalWidth / 2) + (_noThanksButton.frame.size.width / 2);
    }
  }
  _thankYouXConstraint.constant = _noThanksXConstraint.constant + (_noThanksButton.frame.size.width / 2) + spacing + (_thankYouButton.frame.size.width / 2);
}

#pragma mark - Setup Views

- (void)setupFacebookButtonWithTargetViewController:(UIViewController *)viewController {
  _facebookButton = [UIItems socialButtonWithTargetViewController:viewController title:[NSString fontAwesomeIconStringForEnum:FAFacebook] textColor:[WTRColor facebookLogoTextColor]];
}

- (void)setupTwitterButtonWithTargetViewController:(UIViewController *)viewController {
  _twitterButton = [UIItems socialButtonWithTargetViewController:viewController title:[NSString fontAwesomeIconStringForEnum:FATwitter] textColor:[WTRColor twitterLogoTextColor]];
}

- (void)setupFacebookLikeButtonWithTargetViewController:(UIViewController *)viewController {
  _facebookLikeButton = [UIItems socialButtonWithTargetViewController:viewController title:[NSString fontAwesomeIconStringForEnum:FAThumbsUp] textColor:[WTRColor facebookLogoTextColor]];
}

- (void)setupNoThanksButtonWithTargetViewController:(UIViewController *)viewController {
  _noThanksButton = [[UIButton alloc] init];
  _noThanksButton.layer.borderWidth = 1;
  _noThanksButton.layer.cornerRadius = 3;
  _noThanksButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
  _noThanksButton.layer.borderColor = [WTRColor iPadNoThanksButtonBorderColor].CGColor;
  _noThanksButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [_noThanksButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_noThanksButton setTitle:[_settings socialShareDeclineText] forState:UIControlStateNormal];
  [_noThanksButton setTitleColor:[WTRColor iPadNoThanksButtonTextColor] forState:UIControlStateNormal];
  [_noThanksButton addTarget:viewController
                      action:NSSelectorFromString(@"noThanksButtonPressed")
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupThankYouButtonWithTargetViewController:(UIViewController *)viewController {
  _thankYouButton = [[WTRiPADThankYouButton alloc] initWithViewController:viewController];
}

- (void)setupCustomThankYouLabel {
  _customThankYouLabel = [UIItems customThankYouLabelWithFont:[UIFont systemFontOfSize:14]];
}

- (void)setupFinalThankYouLabel {
  _finalThankYouLabel = [UIItems finalThankYouLabelWithSettings:_settings
                                                      textColor:[WTRColor iPadQuestionsTextColor]
                                                        andFont:[UIFont boldSystemFontOfSize:16]];
}

#pragma mark - Setup Constraints

- (void)setupFinalThankYouLabelConstraints {
  [[[[_finalThankYouLabel wtr_topConstraint] toSecondViewTop:self] withConstant:16] addToView:self];
  [[[[_finalThankYouLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[self wtr_rightConstraint] toSecondViewRight:_finalThankYouLabel] withConstant:24] addToView:self];
}

- (void)setupCustomThankYouLabelConstraints {
  [[[[_customThankYouLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_customThankYouLabel wtr_rightConstraint] toSecondViewRight:self] withConstant:-24] addToView:self];
  [[[[_customThankYouLabel wtr_topConstraint] toSecondViewBottom:_finalThankYouLabel] withConstant:12] addToView:self];
}

- (void)setupThankYouButtonConstraints {
  [_thankYouButton wtr_constraintHeight:40];
  [[[[_thankYouButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-44] addToView:self];

  _thankYouXConstraint = [NSLayoutConstraint constraintWithItem:_thankYouButton
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0];
  [self addConstraint:_thankYouXConstraint];
}

- (void)setupNoThanksButtonConstraints {
  [_noThanksButton wtr_constraintHeight:40];
  [[[[_noThanksButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-44] addToView:self];

  _noThanksXConstraint = [NSLayoutConstraint constraintWithItem:_noThanksButton
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0];
  [self addConstraint:_noThanksXConstraint];
}

- (void)setupFacebookButtonConstraints {
  [_facebookButton wtr_constraintWidth:32];
  [_facebookButton wtr_constraintHeight:32];
  [[[[_facebookButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-48] addToView:self];

  _facebookXConstraint = [NSLayoutConstraint constraintWithItem:_facebookButton
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0];
  [self addConstraint:_facebookXConstraint];
}

- (void)setupTwitterButtonConstraints {
  [_twitterButton wtr_constraintWidth:32];
  [_twitterButton wtr_constraintHeight:32];
  [[[[_twitterButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-48] addToView:self];

  _twitterXConstraint = [NSLayoutConstraint constraintWithItem:_twitterButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0];
  [self addConstraint:_twitterXConstraint];
}

- (void)setupFacebookLikeButtonConstraints {
  [_facebookLikeButton wtr_constraintWidth:32];
  [_facebookLikeButton wtr_constraintHeight:32];
  [[[[_facebookLikeButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-48] addToView:self];
    
  _facebookLikeXConstraint = [NSLayoutConstraint constraintWithItem:_facebookLikeButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0];
  [self addConstraint:_facebookLikeXConstraint];
}

- (void)noThankYouButton {
  _thankYouButton.hidden = YES;
}

@end

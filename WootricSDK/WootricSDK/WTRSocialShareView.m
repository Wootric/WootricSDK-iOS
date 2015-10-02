//
//  WTRSocialShareView.m
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

#import "WTRSocialShareView.h"
#import "WTRThankYouButton.h"
#import "WTRColor.h"

@interface WTRSocialShareView ()

@property (nonatomic, strong) WTRSettings *settings;
@property (nonatomic, strong) WTRThankYouButton *thankYouButton;
@property (nonatomic, strong) UIButton *noThanksButton;
@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UIButton *twitterButton;
@property (nonatomic, strong) UILabel *finalThankYouLabel;
@property (nonatomic, strong) UILabel *socialShareQuestionLabel;
@property (nonatomic, strong) UILabel *customThankYouLabel;
@property (nonatomic, strong) NSLayoutConstraint *facebookXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *twitterXConstraint;

@end

@implementation WTRSocialShareView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    _settings = settings;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [WTRColor sliderModalBorderColor].CGColor;
    self.hidden = YES;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }

  return self;
}

- (void)setThankYouButtonTextAndURLDependingOnScore:(int)score {
  NSString *text = [_settings thankYouLinkTextDependingOnScore:score];
  NSURL *url = [_settings thankYouLinkURLDependingOnScore:score];

  [_thankYouButton setText:text andURL:url];
}

- (void)displayShareButtonsWithTwitterAvailable:(BOOL)twitterAvailable andFacebookAvailable:(BOOL)facebookAvailable {
  if (facebookAvailable) {
    _facebookButton.hidden = NO;
  }

  if (twitterAvailable) {
    _twitterButton.hidden = NO;
  }

  if (twitterAvailable && facebookAvailable) {
    _twitterXConstraint.constant = 32;
    _facebookXConstraint.constant = -32;
  } else if (!twitterAvailable && !facebookAvailable) {
    _socialShareQuestionLabel.hidden = YES;
  }
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupThankYouButtonWithTargetViewController:viewController];
  [self setupNoThanksButtonWithTargetViewController:viewController];
  [self setupSocialShareQuestionLabel];
  [self setupFinalThankYouLabel];
  [self setupFacebookButtonWithTargetViewController:viewController];
  [self setupTwitterButtonWithTargetViewController:viewController];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupFinalThankYouLabelConstraints];
  [self setupThankYouButtonConstraints];
  [self setupNoThanksButtonConstraints];
  [self setupSocialShareQuestionLabelConstraints];
  [self setupFacebookButtonConstraints];
  [self setupTwitterButtonConstraints];
}

- (void)addSubviews {
  [self addSubview:_thankYouButton];
  [self addSubview:_noThanksButton];
  [self addSubview:_socialShareQuestionLabel];
  [self addSubview:_finalThankYouLabel];
  [self addSubview:_facebookButton];
  [self addSubview:_twitterButton];
}

- (void)setupThankYouButtonWithTargetViewController:(UIViewController *)viewController {
  _thankYouButton = [[WTRThankYouButton alloc] initWithViewController:viewController];
}

- (void)setupFacebookButtonWithTargetViewController:(UIViewController *)viewController {
  _facebookButton = [[UIButton alloc] init];
  _facebookButton.hidden = YES;
  [_facebookButton setImage:[UIImage imageNamed:@"facebook_icon"] forState:UIControlStateNormal];
  [_facebookButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_facebookButton addTarget:viewController
                      action:NSSelectorFromString(@"facebookButtonPressed")
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTwitterButtonWithTargetViewController:(UIViewController *)viewController {
  _twitterButton = [[UIButton alloc] init];
  _twitterButton.hidden = YES;
  [_twitterButton setImage:[UIImage imageNamed:@"twitter_icon"] forState:UIControlStateNormal];
  [_twitterButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_twitterButton addTarget:viewController
                      action:NSSelectorFromString(@"twitterButtonPressed")
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNoThanksButtonWithTargetViewController:(UIViewController *)viewController {
  _noThanksButton = [[UIButton alloc] init];
  _noThanksButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  [_noThanksButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_noThanksButton setTitle:[[_settings socialShareDeclineText] uppercaseString] forState:UIControlStateNormal];
  [_noThanksButton setTitleColor:[WTRColor sendButtonBackgroundColor] forState:UIControlStateNormal];
  [_noThanksButton addTarget:viewController
                      action:NSSelectorFromString(@"noThanksButtonPressed")
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupFinalThankYouLabel {
  _finalThankYouLabel = [[UILabel alloc] init];
  _finalThankYouLabel.textAlignment = NSTextAlignmentCenter;
  _finalThankYouLabel.textColor = [UIColor blackColor];
  _finalThankYouLabel.numberOfLines = 0;
  _finalThankYouLabel.lineBreakMode = NSLineBreakByWordWrapping;
  if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
    _finalThankYouLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
  } else {
    _finalThankYouLabel.font = [UIFont systemFontOfSize:18];
  }
  _finalThankYouLabel.text = [_settings finalThankYouText];
  [_finalThankYouLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupSocialShareQuestionLabel {
  _socialShareQuestionLabel = [[UILabel alloc] init];
  _socialShareQuestionLabel.textAlignment = NSTextAlignmentCenter;
  _socialShareQuestionLabel.textColor = [WTRColor socialShareQuestionTextColor];
  _socialShareQuestionLabel.numberOfLines = 0;
  _socialShareQuestionLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _socialShareQuestionLabel.font = [UIFont boldSystemFontOfSize:12];
  _socialShareQuestionLabel.text = [_settings socialShareQuestionText];
  [_socialShareQuestionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupFacebookButtonConstraints {
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_facebookButton
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_socialShareQuestionLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:24];
  [self addConstraint:constTop];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_facebookButton
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:32];
  [_facebookButton addConstraint:constH];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_facebookButton
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:32];
  [_facebookButton addConstraint:constW];

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
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_twitterButton
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_socialShareQuestionLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:24];
  [self addConstraint:constTop];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_twitterButton
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:32];
  [_twitterButton addConstraint:constH];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_twitterButton
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:32];
  [_twitterButton addConstraint:constW];

  _twitterXConstraint = [NSLayoutConstraint constraintWithItem:_twitterButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0];
  [self addConstraint:_twitterXConstraint];
}

- (void)setupSocialShareQuestionLabelConstraints {
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_socialShareQuestionLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_thankYouButton
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:16];
  [self addConstraint:constTop];

  NSLayoutConstraint *constLeft = [NSLayoutConstraint constraintWithItem:_socialShareQuestionLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:24];
  [self addConstraint:constLeft];

  NSLayoutConstraint *constRight = [NSLayoutConstraint constraintWithItem:_socialShareQuestionLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:-24];
  [self addConstraint:constRight];
}

- (void)setupFinalThankYouLabelConstraints {
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_finalThankYouLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:16];
  [self addConstraint:constTop];

  NSLayoutConstraint *constLeft = [NSLayoutConstraint constraintWithItem:_finalThankYouLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:24];
  [self addConstraint:constLeft];

  NSLayoutConstraint *constRight = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_finalThankYouLabel
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:24];
  [self addConstraint:constRight];
}

- (void)setupThankYouButtonConstraints {
  NSLayoutConstraint *constL = [NSLayoutConstraint constraintWithItem:_thankYouButton
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:24];
  [self addConstraint:constL];

  NSLayoutConstraint *constR = [NSLayoutConstraint constraintWithItem:_thankYouButton
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-24];
  [self addConstraint:constR];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_thankYouButton
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:50];
  [_thankYouButton addConstraint:constH];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_thankYouButton
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self addConstraint:constX];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_thankYouButton
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_finalThankYouLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:24];
  [self addConstraint:constTop];
}

- (void)setupNoThanksButtonConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_noThanksButton
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self addConstraint:constX];

  NSLayoutConstraint *constB = [NSLayoutConstraint constraintWithItem:_noThanksButton
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:-8];
  [self addConstraint:constB];
}

@end

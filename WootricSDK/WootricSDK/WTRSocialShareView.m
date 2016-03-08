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
#import "NSString+FontAwesome.h"
#import "SimpleConstraints.h"
#import "UIItems.h"

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

- (void)setThankYouButtonTextAndURLDependingOnScore:(int)score andText:(NSString *)feedbackText{
  NSString *text = [_settings thankYouLinkTextDependingOnScore:score];
  NSURL *url = [_settings thankYouLinkURLDependingOnScore:score andText:feedbackText];

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

- (void)setThankYouMessageDependingOnScore:(int)score {
  _customThankYouLabel.text = [_settings thankYouMessageDependingOnScore:score];
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupThankYouButtonWithTargetViewController:viewController];
  [self setupNoThanksButtonWithTargetViewController:viewController];
  [self setupSocialShareQuestionLabel];
  [self setupFinalThankYouLabel];
  [self setupCustomThankYouLabel];
  [self setupFacebookButtonWithTargetViewController:viewController];
  [self setupTwitterButtonWithTargetViewController:viewController];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupFinalThankYouLabelConstraints];
  [self setupCustomThankYouLabelConstraints];
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
  [self addSubview:_customThankYouLabel];
  [self addSubview:_facebookButton];
  [self addSubview:_twitterButton];
}

- (void)setupCustomThankYouLabel {
  _customThankYouLabel = [UIItems customThankYouLabelWithFont:[UIFont boldSystemFontOfSize:12]];
}

- (void)setupThankYouButtonWithTargetViewController:(UIViewController *)viewController {
  _thankYouButton = [[WTRThankYouButton alloc] initWithViewController:viewController];
}

- (void)setupFacebookButtonWithTargetViewController:(UIViewController *)viewController {
    _facebookButton = [UIItems socialButtonWithTargetViewController:viewController title:[NSString fontAwesomeIconStringForEnum:FAFacebook] textColor:[WTRColor facebookLogoTextColor] andActionString:@"facebookButtonPressed"];
}

- (void)setupTwitterButtonWithTargetViewController:(UIViewController *)viewController {
    _twitterButton = [UIItems socialButtonWithTargetViewController:viewController title:[NSString fontAwesomeIconStringForEnum:FATwitter] textColor:[WTRColor twitterLogoTextColor] andActionString:@"twitterButtonPressed"];
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
  if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
    _finalThankYouLabel = [UIItems finalThankYouLabelWithSettings:_settings
                                                        textColor:[UIColor blackColor]
                                                          andFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]];
  } else {
    _finalThankYouLabel = [UIItems finalThankYouLabelWithSettings:_settings
                                                        textColor:[UIColor blackColor]
                                                          andFont:[UIFont systemFontOfSize:18]];
  }
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

- (void)setupCustomThankYouLabelConstraints {
  [[[[_customThankYouLabel left] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_customThankYouLabel right] toSecondViewRight:self] withConstant:-24] addToView:self];
  [[[[_customThankYouLabel top] toSecondViewBottom:_finalThankYouLabel] withConstant:8] addToView:self];
}

- (void)setupFacebookButtonConstraints {
  [_facebookButton constraintWidth:32];
  [_facebookButton constraintHeight:32];
  [[[[_facebookButton top] toSecondViewBottom:_socialShareQuestionLabel] withConstant:18] addToView:self];

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
  [_twitterButton constraintWidth:32];
  [_twitterButton constraintHeight:32];
  [[[[_twitterButton top] toSecondViewBottom:_socialShareQuestionLabel] withConstant:18] addToView:self];

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
  [[[[_socialShareQuestionLabel left] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_socialShareQuestionLabel right] toSecondViewRight:self] withConstant:-24] addToView:self];
  [[[[_socialShareQuestionLabel top] toSecondViewBottom:_thankYouButton] withConstant:16] addToView:self];
}

- (void)setupFinalThankYouLabelConstraints {
  [[[[_finalThankYouLabel top] toSecondViewTop:self] withConstant:16] addToView:self];
  [[[[_finalThankYouLabel left] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[self right] toSecondViewRight:_finalThankYouLabel] withConstant:24] addToView:self];
}

- (void)setupThankYouButtonConstraints {
  [_thankYouButton constraintHeight:50];
  [[[_thankYouButton centerX] toSecondViewCenterX:self] addToView:self];
  [[[[_thankYouButton left] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_thankYouButton right] toSecondViewRight:self] withConstant:-24] addToView:self];
  [[[[_thankYouButton top] toSecondViewBottom:_finalThankYouLabel] withConstant:38] addToView:self];
}

- (void)setupNoThanksButtonConstraints {
  [[[_noThanksButton centerX] toSecondViewCenterX:self] addToView:self];
  [[[[_noThanksButton bottom] toSecondViewBottom:self] withConstant:-8] addToView:self];
}

@end

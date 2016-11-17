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
@property (nonatomic, strong) UIButton *facebookLikeButton;
@property (nonatomic, strong) UILabel *finalThankYouLabel;
@property (nonatomic, strong) UILabel *socialShareQuestionLabel;
@property (nonatomic, strong) UILabel *customThankYouLabel;
@property (nonatomic, strong) NSLayoutConstraint *facebookXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *twitterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *facebookLikeXConstraint;

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
    _facebookLikeButton.hidden = NO;
  }

  if (twitterAvailable) {
    _twitterButton.hidden = NO;
  }

  if (twitterAvailable && facebookAvailable) {
    _facebookLikeXConstraint.constant = 64;
    _twitterXConstraint.constant = 0;
    _facebookXConstraint.constant = -64;
  } else if (!twitterAvailable && facebookAvailable) {
    _facebookLikeXConstraint.constant = 32;
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
  [self setupFacebookLikeButtonWithTargetViewController:viewController];
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
  [self setupFacebookLikeButtonConstraints];
}

- (void)addSubviews {
  [self addSubview:_thankYouButton];
  [self addSubview:_noThanksButton];
  [self addSubview:_socialShareQuestionLabel];
  [self addSubview:_finalThankYouLabel];
  [self addSubview:_customThankYouLabel];
  [self addSubview:_facebookButton];
  [self addSubview:_twitterButton];
  [self addSubview:_facebookLikeButton];
}

- (void)setupCustomThankYouLabel {
  _customThankYouLabel = [UIItems customThankYouLabelWithFont:[UIFont boldSystemFontOfSize:12]];
}

- (void)setupThankYouButtonWithTargetViewController:(UIViewController *)viewController {
  _thankYouButton = [[WTRThankYouButton alloc] initWithViewController:viewController backgroundColor:[_settings thankYouButtonBackgroundColor]];
}

- (void)setupFacebookButtonWithTargetViewController:(UIViewController *)viewController {
  _facebookButton = [UIItems socialButtonWithTargetViewController:viewController title:[NSString fontAwesomeIconStringForEnum:FAFacebook] textColor:[_settings socialSharingColor]];
}

- (void)setupTwitterButtonWithTargetViewController:(UIViewController *)viewController {
  _twitterButton = [UIItems socialButtonWithTargetViewController:viewController title:[NSString fontAwesomeIconStringForEnum:FATwitter] textColor:[_settings socialSharingColor]];
}

- (void)setupFacebookLikeButtonWithTargetViewController:(UIViewController *)viewController {
  _facebookLikeButton = [UIItems socialButtonWithTargetViewController:viewController title:[NSString fontAwesomeIconStringForEnum:FAThumbsUp] textColor:[_settings socialSharingColor]];
}

- (void)setupNoThanksButtonWithTargetViewController:(UIViewController *)viewController {
  _noThanksButton = [[UIButton alloc] init];
  _noThanksButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  [_noThanksButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_noThanksButton setTitle:[[_settings socialShareDeclineText] uppercaseString] forState:UIControlStateNormal];
  [_noThanksButton setTitleColor:[_settings sendButtonBackgroundColor] forState:UIControlStateNormal];
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
  _socialShareQuestionLabel.textColor = [_settings socialSharingColor];
  _socialShareQuestionLabel.numberOfLines = 0;
  _socialShareQuestionLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _socialShareQuestionLabel.font = [UIFont boldSystemFontOfSize:12];
  _socialShareQuestionLabel.text = [_settings socialShareQuestionText];
  [_socialShareQuestionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupCustomThankYouLabelConstraints {
  [[[[_customThankYouLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_customThankYouLabel wtr_rightConstraint] toSecondViewRight:self] withConstant:-24] addToView:self];
  [[[[_customThankYouLabel wtr_topConstraint] toSecondViewBottom:_finalThankYouLabel] withConstant:8] addToView:self];
}

- (void)setupFacebookButtonConstraints {
  [_facebookButton wtr_constraintWidth:32];
  [_facebookButton wtr_constraintHeight:32];
  [[[[_facebookButton wtr_topConstraint] toSecondViewBottom:_socialShareQuestionLabel] withConstant:18] addToView:self];

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
  [[[[_twitterButton wtr_topConstraint] toSecondViewBottom:_socialShareQuestionLabel] withConstant:18] addToView:self];

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
    [[[[_facebookLikeButton wtr_topConstraint] toSecondViewBottom:_socialShareQuestionLabel] withConstant:18] addToView:self];
    
    _facebookLikeXConstraint = [NSLayoutConstraint constraintWithItem:_facebookLikeButton
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0];
    [self addConstraint:_facebookLikeXConstraint];
}

- (void)setupSocialShareQuestionLabelConstraints {
  [[[[_socialShareQuestionLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_socialShareQuestionLabel wtr_rightConstraint] toSecondViewRight:self] withConstant:-24] addToView:self];
  [[[[_socialShareQuestionLabel wtr_topConstraint] toSecondViewBottom:_thankYouButton] withConstant:16] addToView:self];
}

- (void)setupFinalThankYouLabelConstraints {
  [[[[_finalThankYouLabel wtr_topConstraint] toSecondViewTop:self] withConstant:16] addToView:self];
  [[[[_finalThankYouLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[self wtr_rightConstraint] toSecondViewRight:_finalThankYouLabel] withConstant:24] addToView:self];
}

- (void)setupThankYouButtonConstraints {
  [_thankYouButton wtr_constraintHeight:50];
  [[[_thankYouButton wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_thankYouButton wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_thankYouButton wtr_rightConstraint] toSecondViewRight:self] withConstant:-24] addToView:self];
  [[[[_thankYouButton wtr_topConstraint] toSecondViewBottom:_finalThankYouLabel] withConstant:38] addToView:self];
}

- (void)setupNoThanksButtonConstraints {
  [[[_noThanksButton wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_noThanksButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-8] addToView:self];
}

@end

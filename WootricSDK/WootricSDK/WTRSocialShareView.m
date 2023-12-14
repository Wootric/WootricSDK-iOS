//
//  WTRSocialShareView.m
//  WootricSDK
//
// Copyright (c) 2018 Wootric (https://wootric.com)
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
@property (nonatomic, strong) UILabel *thankYouMainLabel;
@property (nonatomic, strong) UILabel *thankYouSetupLabel;
@property (nonatomic, strong) NSLayoutConstraint *facebookXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *twitterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *facebookLikeXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *facebookTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *twitterTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *facebookLikeTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *thankYouButtonTopConstraint;

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

- (void)setThankYouButtonTextAndURLDependingOnScore:(int)score text:(NSString *)feedbackText {
  NSString *text = [_settings thankYouLinkTextDependingOnScore:score];
  NSURL *url = [_settings thankYouLinkURLDependingOnScore:score text:feedbackText email:_settings.endUserEmail];

  if (!text || !url) {
    _thankYouButton.hidden = YES;
    [self setupFacebookButtonTopConstraints:_thankYouSetupLabel];
    [self setupTwitterButtonTopConstraints:_thankYouSetupLabel];
    [self setupFacebookLikeButtonTopConstraints:_thankYouSetupLabel];
    return;
  }

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
  }
}

- (void)setThankYouMainDependingOnScore:(int)score {
  _thankYouMainLabel.text = [_settings thankYouMainDependingOnScore:score];
}

- (void)setThankYouSetupDependingOnScore:(int)score {
  _thankYouSetupLabel.text = [_settings thankYouSetupDependingOnScore:score];
  
  if (!_thankYouSetupLabel.text) {
    _thankYouSetupLabel.hidden = YES;
    [self setupThankYouButtonTopConstraints:_thankYouMainLabel];
    return;
  }
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupThankYouButtonWithTargetViewController:viewController];
  [self setupNoThanksButtonWithTargetViewController:viewController];
  [self setupThankYouMainLabel];
  [self setupThankYouSetupLabel];
  [self setupFacebookButtonWithTargetViewController:viewController];
  [self setupTwitterButtonWithTargetViewController:viewController];
  [self setupFacebookLikeButtonWithTargetViewController:viewController];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupThankYouMainLabelConstraints];
  [self setupThankYouSetupLabelConstraints];
  [self setupThankYouButtonConstraints];
  [self setupNoThanksButtonConstraints];
  [self setupFacebookButtonConstraints];
  [self setupTwitterButtonConstraints];
  [self setupFacebookLikeButtonConstraints];
}

- (void)addSubviews {
  [self addSubview:_thankYouButton];
  [self addSubview:_noThanksButton];
  [self addSubview:_thankYouMainLabel];
  [self addSubview:_thankYouSetupLabel];
  [self addSubview:_facebookButton];
  [self addSubview:_twitterButton];
  [self addSubview:_facebookLikeButton];
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
  _noThanksButton.titleLabel.font = [UIItems boldFontWithSize:12];
  [_noThanksButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_noThanksButton setTitle:[[_settings socialShareDeclineText] uppercaseString] forState:UIControlStateNormal];
  [_noThanksButton setTitleColor:[_settings sendButtonBackgroundColor] forState:UIControlStateNormal];
  [_noThanksButton addTarget:viewController
                      action:NSSelectorFromString(@"noThanksButtonPressed")
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupThankYouMainLabel {
  _thankYouMainLabel = [UIItems thankYouMainLabelWithSettings:_settings textColor:[UIColor blackColor] font:[UIItems mediumFontWithSize:18]];
}

- (void)setupThankYouSetupLabel {
  _thankYouSetupLabel = [[UILabel alloc] init];
  _thankYouSetupLabel.textAlignment = NSTextAlignmentCenter;
  _thankYouSetupLabel.textColor = [_settings socialSharingColor];
  _thankYouSetupLabel.numberOfLines = 0;
  _thankYouSetupLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _thankYouSetupLabel.font = [UIItems boldFontWithSize:12];
  [_thankYouSetupLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupFacebookButtonConstraints {
  [_facebookButton wtr_constraintWidth:32];
  [_facebookButton wtr_constraintHeight:32];
  
  [self setupFacebookButtonTopConstraints:_thankYouButton];

  _facebookXConstraint = [NSLayoutConstraint constraintWithItem:_facebookButton
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0];
  [self addConstraint:_facebookXConstraint];
}

- (void)setupFacebookButtonTopConstraints:(UIView *)secondViewBottom {
  if (_facebookTopConstraint) {
    [_facebookTopConstraint removeFromView:self];
  }
  
  _facebookTopConstraint = [[[_facebookButton wtr_topConstraint] toSecondViewBottom:secondViewBottom] withConstant:18];
  [_facebookTopConstraint addToView:self];
}

- (void)setupTwitterButtonConstraints {
  [_twitterButton wtr_constraintWidth:32];
  [_twitterButton wtr_constraintHeight:32];

  [self setupTwitterButtonTopConstraints:_thankYouButton];

  _twitterXConstraint = [NSLayoutConstraint constraintWithItem:_twitterButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0];
  [self addConstraint:_twitterXConstraint];
}

- (void)setupTwitterButtonTopConstraints:(UIView *)secondViewBottom {
  if (_twitterTopConstraint) {
    [_twitterTopConstraint removeFromView:self];
  }
  
  _twitterTopConstraint = [[[_twitterButton wtr_topConstraint] toSecondViewBottom:secondViewBottom] withConstant:18];
  [_twitterTopConstraint addToView:self];
}

- (void)setupFacebookLikeButtonConstraints {
  [_facebookLikeButton wtr_constraintWidth:32];
  [_facebookLikeButton wtr_constraintHeight:32];
  
  [self setupFacebookLikeButtonTopConstraints:_thankYouButton];
    
  _facebookLikeXConstraint = [NSLayoutConstraint constraintWithItem:_facebookLikeButton
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0];
  [self addConstraint:_facebookLikeXConstraint];
}

- (void)setupFacebookLikeButtonTopConstraints:(UIView *)secondViewBottom {
  if (_facebookLikeTopConstraint) {
    [_facebookLikeTopConstraint removeFromView:self];
  }
  
  _facebookLikeTopConstraint = [[[_facebookLikeButton wtr_topConstraint] toSecondViewBottom:secondViewBottom] withConstant:18];
  [_facebookLikeTopConstraint addToView:self];
}

- (void)setupThankYouMainLabelConstraints {
  [_thankYouMainLabel wtr_constraintHeight:50];
  [[[[_thankYouMainLabel wtr_topConstraint] toSecondViewTop:self] withConstant:16] addToView:self];
  [[[[_thankYouMainLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[self wtr_rightConstraint] toSecondViewRight:_thankYouMainLabel] withConstant:24] addToView:self];
}

- (void)setupThankYouSetupLabelConstraints {
  [_thankYouSetupLabel wtr_constraintHeight:30];
  [[[[_thankYouSetupLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_thankYouSetupLabel wtr_rightConstraint] toSecondViewRight:self] withConstant:-24] addToView:self];
  [[[[_thankYouSetupLabel wtr_topConstraint] toSecondViewBottom:_thankYouMainLabel] withConstant:8] addToView:self];
}

- (void)setupThankYouButtonConstraints {
  [_thankYouButton wtr_constraintHeight:50];
  [[[_thankYouButton wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_thankYouButton wtr_leftConstraint] toSecondViewLeft:self] withConstant:24] addToView:self];
  [[[[_thankYouButton wtr_rightConstraint] toSecondViewRight:self] withConstant:-24] addToView:self];
  [self setupThankYouButtonTopConstraints:_thankYouSetupLabel];
}

- (void)setupThankYouButtonTopConstraints:(UIView *)secondViewBottom {
  if (_thankYouButtonTopConstraint) {
    [_thankYouButtonTopConstraint removeFromView:self];
  }
  
  _thankYouButtonTopConstraint = [[[_thankYouButton wtr_topConstraint] toSecondViewBottom:secondViewBottom] withConstant:8];
  [_thankYouButtonTopConstraint addToView:self];
}

- (void)setupNoThanksButtonConstraints {
  [[[_noThanksButton wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  if ([_settings showDisclaimer]) {
    [[[[_noThanksButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-34] addToView:self];
  } else {
    [[[[_noThanksButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-8] addToView:self];
  }
}

@end

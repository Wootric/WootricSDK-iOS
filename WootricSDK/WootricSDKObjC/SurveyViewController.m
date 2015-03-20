//
//  SurveyViewController.m
//  WootricSDKObjC
//
//  Created by Łukasz Cichecki on 04/03/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import "SurveyViewController.h"
#import "WootricSDK.h"
#import "UIImage+ImageEffects.h"

@interface SurveyViewController ()

@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UISlider *scoreSlider;
@property (nonatomic, strong) UIButton *voteButton;
@property (nonatomic, strong) UIButton *sendFeedbackButton;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *commentTitleText;
@property (nonatomic, strong) UIImage *blurredImage;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *heartImageView;
@property (nonatomic, strong) UIImageView *dismissImageView;
@property (nonatomic, strong) UIImageView *sliderBackgroundView;
@property (nonatomic, strong) UIImageView *sliderCheckedBackgroundView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *askForFeedbackLabel;
@property (nonatomic, strong) UILabel *dragToChangeLabel;
@property (nonatomic, strong) UILabel *poweredByWootricLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *notLikelyLabel;
@property (nonatomic, strong) UILabel *extremelyLikelyLabel;

@end

@implementation SurveyViewController
  int score;
  bool scrolled;
  NSLayoutConstraint *constTopToModal;

- (void)viewDidLoad {
  [super viewDidLoad];

  [self registerForKeyboardNotification];
  [self setupView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupView {
  _blurredImage = [_imageToBlur applyBlurWithRadius:3 tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] saturationDeltaFactor:1 maskImage:nil];
  _tintColor = [UIColor colorWithRed:145.0/255.0 green:201.0/255.0 blue:29.0/255.0 alpha:1];
  _titleText = @"How likely are you to recommend us to a friend or collegue?";
  _commentTitleText = @"Thank you for your response!";

  [self setupModal];
  [self setupSlider];
  [self setupVoteButton];
  [self setupDismissButton];
  [self setupTitleLabel];
  [self setupCommentTextView];
  [self setupScrollView];
  [self setupDragToChangeLabel];
  [self setupNotLikelyLabel];
  [self setupPoweredByWootric];
  [self setupHeartIconImageView];
  [self setupExtremelyLikelyLabel];
  [self setupBackgroundImageView];
  [self setupSliderBackgroundView];
  [self setupSliderCheckedBackgroundView];
  [self setupScoreLabel];
  [self setupAskForFeedbackLabel];
  [self setupSendFeedbackButton];

  [self addViewsToModal];
  [self.view addSubview:_scrollView];
  [self.view addSubview:_backgroundImageView];
  [self.view sendSubviewToBack:_backgroundImageView];
  [_scrollView addSubview:_modalView];

  [self setupBackgroundImageViewContraints];
  [self setupScrollViewConstraints];
  [self setupModalConstraint];
  [self setupDismissButtonConstraints];
  [self setupTitleLabelConstraints];
  [self setupVoteButtonConstraints];
  [self setupSliderConstraints];
  [self setupDragToChangeLabelConstraints];
  [self setupNotLikelyLabelConstraints];
  [self setupExtremelyLikelyLabelConstraints];
  [self setupSliderBackgroundViewConstraints];
  [self setupSliderCheckedBackgroundViewConstraints];
  [self setupScoreLabelConstraints];
  [self setupAskForFeedbackLabelConstraints];
  [self setupCommentTextViewConstraints];
  [self setupSendFeedbackButtonConstraints];
}

#pragma mark - Setup constraints

- (void)setupSendFeedbackButtonConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_sendFeedbackButton
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_sendFeedbackButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_commentTextView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:15];
  [_modalView addConstraint:constY];
}

- (void)setupScoreLabelConstraints {
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_scoreLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_titleLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:5];
  [_modalView addConstraint:constTop];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_scoreLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_titleLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];
}

- (void)setupAskForFeedbackLabelConstraints {
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_askForFeedbackLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_scoreLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:5];
  [_modalView addConstraint:constTop];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_askForFeedbackLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_titleLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];
}

- (void)setupSliderCheckedBackgroundViewConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_sliderCheckedBackgroundView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_sliderCheckedBackgroundView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_titleLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:41];
  [_modalView addConstraint:constTop];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_sliderCheckedBackgroundView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:290];
  [_modalView addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_sliderCheckedBackgroundView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:55];
  [_modalView addConstraint:constH];
}


- (void)setupSliderBackgroundViewConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_sliderBackgroundView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_sliderBackgroundView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_titleLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:41];
  [_modalView addConstraint:constTop];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_sliderBackgroundView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:290];
  [_modalView addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_sliderBackgroundView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:55];
  [_modalView addConstraint:constH];
}

- (void)setupExtremelyLikelyLabelConstraints {
  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_extremelyLikelyLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scoreSlider
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:10];
  [_modalView addConstraint:constY];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_sliderBackgroundView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_extremelyLikelyLabel
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:25];
  [_modalView addConstraint:constX];
}

- (void)setupNotLikelyLabelConstraints {
  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_notLikelyLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scoreSlider
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:10];
  [_modalView addConstraint:constY];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_notLikelyLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_sliderBackgroundView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:25];
  [_modalView addConstraint:constX];
}

- (void)setupDragToChangeLabelConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_dragToChangeLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_dragToChangeLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scoreSlider
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:-5];
  [_modalView addConstraint:constY];
}

- (void)setupCommentTextViewConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_commentTextView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_commentTextView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_askForFeedbackLabel
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:35];
  [_modalView addConstraint:constY];

  NSLayoutConstraint *constL = [NSLayoutConstraint constraintWithItem:_commentTextView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:15];
  [_modalView addConstraint:constL];

  NSLayoutConstraint *constR = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_commentTextView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:15];
  [_modalView addConstraint:constR];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_commentTextView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:105];
  [_commentTextView addConstraint:constH];
}

- (void)setupSliderConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];

  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_titleLabel
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:45];
  [_modalView addConstraint:constTop];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:274];
  [_modalView addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_scoreSlider
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:45];
  [_modalView addConstraint:constH];
}

- (void)setupVoteButtonConstraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_voteButton
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [_modalView addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_voteButton
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:-65];
  [_modalView addConstraint:constY];
}

- (void)setupTitleLabelConstraints {
  NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_modalView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:40];
  [_modalView addConstraint:constTop];

  NSLayoutConstraint *constLeft = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_modalView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:60];
  [_modalView addConstraint:constLeft];

  NSLayoutConstraint *constRight = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_titleLabel
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:60];
  [_modalView addConstraint:constRight];
}

- (void)setupBackgroundImageViewContraints {
  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_backgroundImageView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_backgroundImageView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constY];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_backgroundImageView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_backgroundImageView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constH];
}

- (void)setupDismissButtonConstraints {
  NSLayoutConstraint *constXTop = [NSLayoutConstraint constraintWithItem:_dismissButton
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_modalView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:284];
  [_modalView addConstraint:constXTop];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_dismissButton
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-5];
  [_modalView addConstraint:constX];

  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_dismissButton
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:80];
  [_dismissButton addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_dismissButton
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:32];
  [_dismissButton addConstraint:constH];
}

- (void)setupScrollViewConstraints {
  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_scrollView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_scrollView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constH];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_scrollView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constX];

  NSLayoutConstraint *constY = [NSLayoutConstraint constraintWithItem:_scrollView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constY];
}

- (void)setupModalConstraint {
  NSLayoutConstraint *constW = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constW];

  NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:316];
  [_modalView addConstraint:constH];

  NSLayoutConstraint *constX = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0];
  [self.view addConstraint:constX];

  NSLayoutConstraint *constB = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0];
  [_scrollView addConstraint:constB];

  constTopToModal = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:self.view.frame.size.height - 316];
  [_scrollView addConstraint:constTopToModal];

  NSLayoutConstraint *constL = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0];
  [_scrollView addConstraint:constL];

  NSLayoutConstraint *constR = [NSLayoutConstraint constraintWithItem:_modalView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0];
  [_scrollView addConstraint:constR];
}

#pragma mark - Setup views

- (void)setupSendFeedbackButton {
  _sendFeedbackButton = [[UIButton alloc] init];
  _sendFeedbackButton.tintColor = _tintColor;
  _sendFeedbackButton.hidden = YES;
  _sendFeedbackButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.25];
  [_sendFeedbackButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_sendFeedbackButton setTitle:@"SEND FEEDBACK" forState:UIControlStateNormal];
  [_sendFeedbackButton setTitleColor:_tintColor forState:UIControlStateNormal];
  [_sendFeedbackButton setTitleColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateDisabled];
  [_sendFeedbackButton addTarget:self action:NSSelectorFromString(@"sendButtonPressed:")
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupScoreLabel {
  _scoreLabel = [[UILabel alloc] init];
  _scoreLabel.font = [UIFont systemFontOfSize:14];
  _scoreLabel.hidden = YES;
  _scoreLabel.textColor = [UIColor colorWithRed:236.0/255.0 green:104.0/255.0 blue:149.0/255.0 alpha:1];
  [_scoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupAskForFeedbackLabel {
  _askForFeedbackLabel = [[UILabel alloc] init];
  _askForFeedbackLabel.text = @"Please help us improve by sharing your feedback";
  _askForFeedbackLabel.font = [UIFont italicSystemFontOfSize:14];
  _askForFeedbackLabel.textColor = [UIColor darkGrayColor];
  _askForFeedbackLabel.hidden = YES;
  [_askForFeedbackLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupSliderCheckedBackgroundView {
  _sliderCheckedBackgroundView = [[UIImageView alloc] init];
  UIImage *image = [UIImage imageNamed:@"slider_bg_checked" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  _sliderCheckedBackgroundView.image = image;
  _sliderCheckedBackgroundView.alpha = 0;
  [_sliderCheckedBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupSliderBackgroundView {
  _sliderBackgroundView = [[UIImageView alloc] init];
  UIImage *image = [UIImage imageNamed:@"slider_bg_unchecked" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  _sliderBackgroundView.image = image;
  [_sliderBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupExtremelyLikelyLabel {
  _extremelyLikelyLabel = [[UILabel alloc] init];
  _extremelyLikelyLabel.text = @"Extremely likely";
  _extremelyLikelyLabel.font = [UIFont systemFontOfSize:10];
  _extremelyLikelyLabel.textColor = [UIColor darkGrayColor];
  [_extremelyLikelyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupNotLikelyLabel {
  _notLikelyLabel = [[UILabel alloc] init];
  _notLikelyLabel.text = @"Not at all likely";
  _notLikelyLabel.font = [UIFont systemFontOfSize:10];
  _notLikelyLabel.textColor = [UIColor darkGrayColor];
  [_notLikelyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupDragToChangeLabel {
  _dragToChangeLabel = [[UILabel alloc] init];
  _dragToChangeLabel.text = @"Drag to change score";
  _dragToChangeLabel.font = [UIFont systemFontOfSize:9];
  _dragToChangeLabel.textColor = [UIColor darkGrayColor];
  _dragToChangeLabel.hidden = YES;
  [_dragToChangeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupHeartIconImageView {
  UIImage *image = [UIImage imageNamed:@"icon_heart" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  _heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 297, 8, 8)];
  _heartImageView.image = image;
}

- (void)setupPoweredByWootric {
  _poweredByWootricLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 295, 100, 11)];
  _poweredByWootricLabel.text = @"powered by wootric";
  _poweredByWootricLabel.font = [UIFont systemFontOfSize:9];
  _poweredByWootricLabel.textColor = [UIColor darkGrayColor];
}

- (void)setupBackgroundImageView {
  _backgroundImageView = [[UIImageView alloc] init];
  _backgroundImageView.image = _blurredImage;
  [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupModal {
  _modalView = [[UIView alloc] init];
  _modalView.backgroundColor = [UIColor whiteColor];
  [_modalView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupScrollView {
  _scrollView = [[UIScrollView alloc] init];
  [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupCommentTextView {
  _commentTextView = [[UITextView alloc] init];
  _commentTextView.hidden = YES;
  _commentTextView.tintColor = _tintColor;
  _commentTextView.layer.cornerRadius = 2;
  _commentTextView.layer.borderWidth = 1;
  _commentTextView.layer.borderColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255 alpha:1].CGColor;
  _commentTextView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
  [_commentTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupTitleLabel {
  _titleLabel = [[UILabel alloc] init];
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  _titleLabel.textColor = [UIColor darkGrayColor];
  _titleLabel.numberOfLines = 0;
  _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _titleLabel.text = _titleText;
  _titleLabel.font = [UIFont systemFontOfSize:16];
  [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupDismissButton {
  _dismissButton = [[UIButton alloc] init];
  UIImage *image = [UIImage imageNamed:@"icon_close_round_grey" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  _dismissImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 16, 16)];
  _dismissImageView.image = image;
  _dismissImageView.tintColor = [UIColor whiteColor];
  _dismissButton.titleLabel.textAlignment = NSTextAlignmentRight;
  _dismissButton.titleLabel.font = [UIFont systemFontOfSize:10];
  [_dismissButton addSubview:_dismissImageView];
  [_dismissButton setTitle:@"DISMISS" forState:UIControlStateNormal];
  [_dismissButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  [_dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_dismissButton addTarget:self action:NSSelectorFromString(@"dismissButtonPressed:")
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSlider {
  _scoreSlider = [[UISlider alloc] init];
  _scoreSlider.minimumValue = 0;
  _scoreSlider.maximumValue = 10;
  _scoreSlider.value = 5;
  _scoreSlider.tintColor = _tintColor;
  UIImage *image = [[UIImage alloc] init];
  UIImage *imageBackground = [[UIImage imageNamed:@"slider_bg_numbers_unchecked"
                                         inBundle:[NSBundle bundleForClass:[self class]]
                    compatibleWithTraitCollection:nil] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [_scoreSlider setMaximumTrackImage:imageBackground forState:UIControlStateNormal];
  [_scoreSlider setMinimumTrackImage:imageBackground forState:UIControlStateNormal];
  [_scoreSlider setThumbImage:image forState:UIControlStateNormal];
  [_scoreSlider setThumbImage:image forState:UIControlStateHighlighted];
  [_scoreSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_scoreSlider addTarget:self action:NSSelectorFromString(@"updateSliderStep:")
         forControlEvents:UIControlEventValueChanged];
  UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(@"sliderTapped:")];
  [_scoreSlider addGestureRecognizer:gr];
}

- (void)setupVoteButton {
  _voteButton = [[UIButton alloc] init];
  _voteButton.tintColor = _tintColor;
  _voteButton.enabled = NO;
  _voteButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.25];
  [_voteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_voteButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
  [_voteButton setTitleColor:_tintColor forState:UIControlStateNormal];
  [_voteButton setTitleColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateDisabled];
  [_voteButton addTarget:self action:NSSelectorFromString(@"voteButtonPressed:")
           forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark

- (void)addViewsToModal {
  [_modalView addSubview:_dismissButton];
  [_modalView addSubview:_heartImageView];
  [_modalView addSubview:_poweredByWootricLabel];
  [_modalView addSubview:_titleLabel];
  [_modalView addSubview:_sliderBackgroundView];
  [_modalView addSubview:_sliderCheckedBackgroundView];
  [_modalView addSubview:_scoreSlider];
  [_modalView addSubview:_voteButton];
  [_modalView addSubview:_commentTextView];
  [_modalView addSubview:_dragToChangeLabel];
  [_modalView addSubview:_notLikelyLabel];
  [_modalView addSubview:_extremelyLikelyLabel];
  [_modalView addSubview:_askForFeedbackLabel];
  [_modalView addSubview:_scoreLabel];
  [_modalView addSubview:_sendFeedbackButton];
}

- (void)updateSliderStep:(UISlider *)sender {
  if (!_voteButton.enabled) {
    _voteButton.enabled = YES;
    _dragToChangeLabel.hidden = NO;
    UIImage *imageBackground = [[UIImage imageNamed:@"slider_bg_numbers_checked"
                                           inBundle:[NSBundle bundleForClass:[self class]]
                      compatibleWithTraitCollection:nil] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [_scoreSlider setMaximumTrackImage:imageBackground forState:UIControlStateNormal];
    [_scoreSlider setMinimumTrackImage:imageBackground forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
      _sliderBackgroundView.alpha = 0;
      _sliderCheckedBackgroundView.alpha = 1;
    }];
  }
  sender.value = round(sender.value);
  NSString *imageName = [NSString stringWithFormat:@"vote_icon_%d", (int)_scoreSlider.value];
  UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  [_scoreSlider setThumbImage:image forState:UIControlStateNormal];
  [_scoreSlider setThumbImage:image forState:UIControlStateHighlighted];
}

- (void)voteButtonPressed:(UIButton *)sender {
  score = (int)(_scoreSlider.value);

  [self changeView];
}

- (void)sliderTapped:(UIGestureRecognizer *)gesture {
  if (_scoreSlider.highlighted)
    return; // tap on thumb, let slider deal with it
  CGPoint pt = [gesture locationInView: _scoreSlider];
  CGFloat percentage = pt.x / _scoreSlider.bounds.size.width;
  CGFloat delta = percentage * (_scoreSlider.maximumValue - _scoreSlider.minimumValue);
  CGFloat value = _scoreSlider.minimumValue + delta;
  [_scoreSlider setValue:value animated:YES];
  [self updateSliderStep:_scoreSlider];
}

- (void)dismissButtonPressed:(UIButton *)sender {
  [WootricSDK userDeclined];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendButtonPressed:(UIButton *)sender {
  NSString *text = nil;
  if ([_commentTextView.text length] != 0) {
    text = _commentTextView.text;
  }
  [WootricSDK voteWithScore:(long)_scoreSlider.value andText:text];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)adjustInsetForKeyboardShow:(BOOL)show notification:(NSNotification *)notification {
  NSDictionary *userInfo = notification.userInfo ? notification.userInfo : @{};
  CGRect keyboardFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  double adjustmentHeight = CGRectGetHeight(keyboardFrame) * (show ? 1 : -1);
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, adjustmentHeight, 0);
  _scrollView.contentInset = contentInsets;
  _scrollView.scrollIndicatorInsets = contentInsets;

  if (!scrolled) {
    [_scrollView scrollRectToVisible:_modalView.frame animated:YES];
    scrolled = YES;
  }
}

- (void)registerForKeyboardNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:NSSelectorFromString(@"keyboardWillShow:")
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:NSSelectorFromString(@"keyboardWillHide:")
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
  [self adjustInsetForKeyboardShow:YES notification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  [self adjustInsetForKeyboardShow:NO notification:notification];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  constTopToModal.constant = self.view.frame.size.width - 316;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  UIImage *image = [WootricSDK imageToBlurFromViewController:[self presentingViewController]];
  UIImage *bluredImage = [image applyBlurWithRadius:3 tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.4] saturationDeltaFactor:1 maskImage:nil];
  _backgroundImageView.image = bluredImage;
  [_scrollView scrollRectToVisible:_modalView.frame animated:YES];
}

- (void)changeView {
  _voteButton.hidden = YES;
  _sendFeedbackButton.hidden = NO;
  _titleLabel.text = _commentTitleText;
  _titleLabel.textColor = _tintColor;
  _scoreSlider.hidden = YES;
  _commentTextView.hidden = NO;
  _dragToChangeLabel.hidden = YES;
  _extremelyLikelyLabel.hidden = YES;
  _notLikelyLabel.hidden = YES;
  _sliderBackgroundView.hidden = YES;
  _sliderCheckedBackgroundView.hidden = YES;
  _askForFeedbackLabel.hidden = NO;
  _scoreLabel.hidden = NO;
  _scoreLabel.text = [NSString stringWithFormat:@"You gave us an %d.", score];
  [_commentTextView becomeFirstResponder];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

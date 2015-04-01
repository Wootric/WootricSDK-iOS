//
//  SurveyViewController+Views.m
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

#import "SurveyViewController+Views.h"

@implementation SurveyViewController (Views)

- (void)setupViews {
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
  [self setupScorePopoverLabel];
  [self setupButtonCheckIcon];
  [self setupButtonSendIcon];

  [self addViewsToModal];
  [self.view addSubview:self.scrollView];
  [self.view addSubview:self.backgroundImageView];
  [self.view sendSubviewToBack:self.backgroundImageView];
  [self.scrollView addSubview:self.modalView];
}

- (void)setupScorePopoverLabel {
  self.scorePopoverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
  self.scorePopoverLabel.font = [UIFont systemFontOfSize:14];
  self.scorePopoverLabel.textColor = [UIColor darkGrayColor];
  self.scorePopoverLabel.hidden = YES;
  self.scorePopoverLabel.backgroundColor = [UIColor whiteColor];
  self.scorePopoverLabel.textAlignment = NSTextAlignmentCenter;
  self.scorePopoverLabel.layer.cornerRadius = 2;
  self.scorePopoverLabel.layer.borderColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255 alpha:1].CGColor;
  self.scorePopoverLabel.layer.borderWidth = 1;
}

- (void)setupSendFeedbackButton {
  self.sendFeedbackButton = [[UIButton alloc] init];
  self.sendFeedbackButton.tintColor = self.tintColor;
  self.sendFeedbackButton.hidden = YES;
  self.sendFeedbackButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.25];
  [self.sendFeedbackButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.sendFeedbackButton setTitle:@"SEND FEEDBACK" forState:UIControlStateNormal];
  [self.sendFeedbackButton setTitleColor:self.tintColor forState:UIControlStateNormal];
  [self.sendFeedbackButton setTitleColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateDisabled];
  [self.sendFeedbackButton addTarget:self action:NSSelectorFromString(@"sendButtonPressed:")
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupScoreLabel {
  self.scoreLabel = [[UILabel alloc] init];
  self.scoreLabel.font = [UIFont systemFontOfSize:14];
  self.scoreLabel.hidden = YES;
  self.scoreLabel.textColor = [UIColor colorWithRed:236.0/255.0 green:104.0/255.0 blue:149.0/255.0 alpha:1];
  [self.scoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupAskForFeedbackLabel {
  self.askForFeedbackLabel = [[UILabel alloc] init];
  self.askForFeedbackLabel.font = [UIFont systemFontOfSize:12];
  self.askForFeedbackLabel.textColor = [UIColor lightGrayColor];
  self.askForFeedbackLabel.hidden = YES;
  self.askForFeedbackLabel.numberOfLines = 0;
  self.askForFeedbackLabel.textAlignment = NSTextAlignmentLeft;
  [self.askForFeedbackLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupSliderCheckedBackgroundView {
  self.sliderCheckedBackgroundView = [[UIImageView alloc] init];
  NSString *imageName = [self isSmallerScreenDevice] ? @"slider_bg_checked" : @"slider_bg_checked_667h";
  UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.sliderCheckedBackgroundView.image = image;
  self.sliderCheckedBackgroundView.alpha = 0;
  [self.sliderCheckedBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupSliderBackgroundView {
  self.sliderBackgroundView = [[UIImageView alloc] init];
  NSString *imageName = [self isSmallerScreenDevice] ? @"slider_bg_unchecked" : @"slider_bg_unchecked_667h";
  UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.sliderBackgroundView.image = image;
  [self.sliderBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupExtremelyLikelyLabel {
  self.extremelyLikelyLabel = [[UILabel alloc] init];
  self.extremelyLikelyLabel.text = @"Extremely likely";
  self.extremelyLikelyLabel.font = [UIFont systemFontOfSize:10];
  self.extremelyLikelyLabel.textColor = [UIColor darkGrayColor];
  [self.extremelyLikelyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupNotLikelyLabel {
  self.notLikelyLabel = [[UILabel alloc] init];
  self.notLikelyLabel.text = @"Not at all likely";
  self.notLikelyLabel.font = [UIFont systemFontOfSize:10];
  self.notLikelyLabel.textColor = [UIColor darkGrayColor];
  [self.notLikelyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupDragToChangeLabel {
  self.dragToChangeLabel = [[UILabel alloc] init];
  self.dragToChangeLabel.text = @"Drag to change score";
  self.dragToChangeLabel.font = [UIFont systemFontOfSize:9];
  self.dragToChangeLabel.textColor = [UIColor darkGrayColor];
  self.dragToChangeLabel.hidden = YES;
  [self.dragToChangeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupHeartIconImageView {
  UIImage *image = [UIImage imageNamed:@"icon_heart" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 297, 8, 8)];
  self.heartImageView.image = image;
}

- (void)setupPoweredByWootric {
  self.poweredByWootricLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 295, 100, 11)];
  self.poweredByWootricLabel.text = @"powered by wootric";
  self.poweredByWootricLabel.font = [UIFont systemFontOfSize:9];
  self.poweredByWootricLabel.textColor = [UIColor darkGrayColor];
}

- (void)setupBackgroundImageView {
  self.backgroundImageView = [[UIImageView alloc] init];
  self.backgroundImageView.image = self.blurredImage;
  self.backgroundImageView.alpha = 0;
  [self.backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupModal {
  self.modalView = [[UIView alloc] init];
  self.modalView.backgroundColor = [UIColor whiteColor];
  [self.modalView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupScrollView {
  self.scrollView = [[UIScrollView alloc] init];
  [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupCommentTextView {
  self.commentTextView = [[UITextView alloc] init];
  self.commentTextView.hidden = YES;
  self.commentTextView.tintColor = self.tintColor;
  self.commentTextView.layer.cornerRadius = 2;
  self.commentTextView.layer.borderWidth = 1;
  self.commentTextView.layer.borderColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255 alpha:1].CGColor;
  self.commentTextView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
  [self.commentTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupTitleLabel {
  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.textColor = [UIColor darkGrayColor];
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  if (self.wootricQuestion != nil) {
    self.titleLabel.text = [NSString stringWithFormat:@"How likely are you to recommend us to a %@?", self.wootricQuestion];
  } else {
    self.titleLabel.text = self.defaultWootricQuestion;
  }
  self.titleLabel.font = [UIFont systemFontOfSize:16];
  [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupDismissButton {
  self.dismissButton = [[UIButton alloc] init];
  UIImage *image = [UIImage imageNamed:@"icon_close_round_grey" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.dismissImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 16, 16)];
  self.dismissImageView.image = image;
  self.dismissImageView.tintColor = [UIColor whiteColor];
  self.dismissButton.titleLabel.textAlignment = NSTextAlignmentRight;
  self.dismissButton.titleLabel.font = [UIFont systemFontOfSize:10];
  [self.dismissButton addSubview:self.dismissImageView];
  [self.dismissButton setTitle:@"DISMISS" forState:UIControlStateNormal];
  [self.dismissButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  [self.dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.dismissButton addTarget:self action:NSSelectorFromString(@"dismissButtonPressed:")
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSlider {
  self.scoreSlider = [[UISlider alloc] init];
  self.scoreSlider.minimumValue = 0;
  self.scoreSlider.maximumValue = 10;
  self.scoreSlider.value = 5;
  self.scoreSlider.tintColor = self.tintColor;
  NSString *imageName = [self isSmallerScreenDevice] ? @"slider_bg_numbers_unchecked" : @"slider_bg_numbers_unchecked_667h";
  UIImage *image = [[UIImage alloc] init];
  UIImage *imageBackground = [[UIImage imageNamed:imageName
                                         inBundle:[NSBundle bundleForClass:[self class]]
                    compatibleWithTraitCollection:nil] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [self.scoreSlider setMaximumTrackImage:imageBackground forState:UIControlStateNormal];
  [self.scoreSlider setMinimumTrackImage:imageBackground forState:UIControlStateNormal];
  [self.scoreSlider setThumbImage:image forState:UIControlStateNormal];
  [self.scoreSlider setThumbImage:image forState:UIControlStateHighlighted];
  [self.scoreSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.scoreSlider addTarget:self
                       action:NSSelectorFromString(@"updateSliderStep:")
             forControlEvents:UIControlEventValueChanged];
  [self.scoreSlider addTarget:self
                       action:NSSelectorFromString(@"showScore:")
             forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside | UIControlEventTouchDown];
  [self.scoreSlider addTarget:self
                       action:NSSelectorFromString(@"hideScore:")
             forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
  UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(@"sliderTapped:")];
  [self.scoreSlider addGestureRecognizer:gr];
}

- (void)setupVoteButton {
  self.voteButton = [[UIButton alloc] init];
  self.voteButton.tintColor = self.tintColor;
  self.voteButton.enabled = NO;
  self.voteButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.25];
  [self.voteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.voteButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
  [self.voteButton setTitleColor:self.tintColor forState:UIControlStateNormal];
  [self.voteButton setTitleColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateDisabled];
  [self.voteButton addTarget:self action:NSSelectorFromString(@"voteButtonPressed:")
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupButtonCheckIcon {
  UIImage *checkIcon = [UIImage imageNamed:@"icon_check_disabled" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.buttonIconCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
  self.buttonIconCheck.image = checkIcon;
  [self.buttonIconCheck setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupButtonSendIcon {
  UIImage *sendIcon = [UIImage imageNamed:@"icon_send_arrow" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.buttonIconSend = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
  self.buttonIconSend.image = sendIcon;
  self.buttonIconSend.hidden = YES;
  [self.buttonIconSend setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)addViewsToModal {
  [self.modalView addSubview:self.dismissButton];
  [self.modalView addSubview:self.heartImageView];
  [self.modalView addSubview:self.poweredByWootricLabel];
  [self.modalView addSubview:self.titleLabel];
  [self.modalView addSubview:self.sliderBackgroundView];
  [self.modalView addSubview:self.sliderCheckedBackgroundView];
  [self.modalView addSubview:self.scoreSlider];
  [self.modalView addSubview:self.voteButton];
  [self.modalView addSubview:self.commentTextView];
  [self.modalView addSubview:self.dragToChangeLabel];
  [self.modalView addSubview:self.notLikelyLabel];
  [self.modalView addSubview:self.extremelyLikelyLabel];
  [self.modalView addSubview:self.askForFeedbackLabel];
  [self.modalView addSubview:self.scoreLabel];
  [self.modalView addSubview:self.sendFeedbackButton];
  [self.modalView addSubview:self.scorePopoverLabel];
  [self.modalView addSubview:self.buttonIconCheck];
  [self.modalView addSubview:self.buttonIconSend];
}

@end

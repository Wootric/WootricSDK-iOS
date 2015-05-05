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
#import "SurveyViewController+Utils.h"

@implementation SurveyViewController (Views)

- (void)setupViews {
  [self setupModal];
  [self setupWootricLink];
  [self setupSlider];
  [self setupVoteButton];
  [self setupDismissButton];
  [self setupTitleLabel];
  [self setupCommentTextView];
  [self setupScrollView];
  [self setupDragToChangeLabel];
  [self setupNotLikelyLabel];
  [self setupPoweredByWootric];
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
  [self setupBackButton];
  [self setupChosenScoreLabel];

  [self addViewsToModal];
  [self.view addSubview:self.scrollView];
  [self.view addSubview:self.backgroundImageView];
  [self.view sendSubviewToBack:self.backgroundImageView];
  [self.scrollView addSubview:self.modalView];
}

#pragma mark - Buttons

- (void)setupWootricLink {
  self.wootricLink = [[UIButton alloc] initWithFrame:CGRectMake(63, 279, 40, 11)];
  [self.wootricLink setTitle:@"wootric" forState:UIControlStateNormal];
  self.wootricLink.titleLabel.font = [UIFont systemFontOfSize:9];
  self.wootricLink.titleLabel.textAlignment = NSTextAlignmentLeft;
  [self.wootricLink setTitleColor:[UIColor colorWithRed:0.51 green:0.745 blue:0.824 alpha:1] forState:UIControlStateNormal];
  [self.wootricLink addTarget:self action:NSSelectorFromString(@"openWootricPage:") forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBackButton {
  self.backButton = [[UIButton alloc] init];
  UIImage *image = [UIImage imageNamed:@"icon_back_arrow" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  UIImageView *backIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 16, 16)];
  backIcon.image = image;
  self.backButton.hidden = YES;
  [self.backButton addSubview:backIcon];
  [self.backButton setTitle:[self localizedString:@"back"] forState:UIControlStateNormal];
  self.backButton.titleLabel.font = [UIFont systemFontOfSize:11];
  [self.backButton setTitleColor:[UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1] forState:UIControlStateNormal];
  self.backButton.titleLabel.textAlignment = NSTextAlignmentRight;
  [self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.backButton addTarget:self action:NSSelectorFromString(@"backButtonPressed:")
                    forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSendFeedbackButton {
  self.sendFeedbackButton = [[UIButton alloc] init];
  self.sendFeedbackButton.tintColor = self.settings.tintColorSubmit;
  self.sendFeedbackButton.hidden = YES;
  self.sendFeedbackButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
  [self.sendFeedbackButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.sendFeedbackButton setTitle:[self localizedString:@"SEND FEEDBACK"] forState:UIControlStateNormal];
  [self.sendFeedbackButton setTitleColor:self.settings.tintColorSubmit forState:UIControlStateNormal];
  [self.sendFeedbackButton setTitleColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateDisabled];
  [self.sendFeedbackButton addTarget:self action:NSSelectorFromString(@"sendButtonPressed:")
                    forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupVoteButton {
  self.voteButton = [[UIButton alloc] init];
  self.voteButton.tintColor = self.settings.tintColorSubmit;
  self.voteButton.enabled = NO;
  self.voteButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
  [self.voteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.voteButton setTitle:[self localizedString:@"SUBMIT"] forState:UIControlStateNormal];
  [self.voteButton setTitleColor:self.settings.tintColorSubmit forState:UIControlStateNormal];
  [self.voteButton setTitleColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1] forState:UIControlStateDisabled];
  [self.voteButton addTarget:self action:NSSelectorFromString(@"voteButtonPressed:")
            forControlEvents:UIControlEventTouchUpInside];
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
  [self.dismissButton setTitle:[self localizedString:@"DISMISS"] forState:UIControlStateNormal];
  [self.dismissButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  [self.dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.dismissButton addTarget:self action:NSSelectorFromString(@"dismissButtonPressed:")
               forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Labels

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

- (void)setupScoreLabel {
  self.scoreLabel = [[UILabel alloc] init];
  self.scoreLabel.textAlignment = NSTextAlignmentCenter;
  self.scoreLabel.font = [UIFont systemFontOfSize:14];
  self.scoreLabel.hidden = YES;
  self.scoreLabel.numberOfLines = 0;
  self.scoreLabel.lineBreakMode = NSLineBreakByWordWrapping;
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

- (void)setupExtremelyLikelyLabel {
  self.extremelyLikelyLabel = [[UILabel alloc] init];
  self.extremelyLikelyLabel.text = [self localizedString:@"Extremely likely"];
  self.extremelyLikelyLabel.font = [UIFont systemFontOfSize:10];
  self.extremelyLikelyLabel.textColor = [UIColor darkGrayColor];
  [self.extremelyLikelyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupNotLikelyLabel {
  self.notLikelyLabel = [[UILabel alloc] init];
  self.notLikelyLabel.text = [self localizedString:@"Not at all likely"];
  self.notLikelyLabel.font = [UIFont systemFontOfSize:10];
  self.notLikelyLabel.textColor = [UIColor darkGrayColor];
  [self.notLikelyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupDragToChangeLabel {
  self.dragToChangeLabel = [[UILabel alloc] init];
  self.dragToChangeLabel.text = [self localizedString:@"Drag to change score"];
  self.dragToChangeLabel.font = [UIFont systemFontOfSize:9];
  self.dragToChangeLabel.textColor = [UIColor darkGrayColor];
  self.dragToChangeLabel.hidden = YES;
  [self.dragToChangeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupChosenScoreLabel {
  self.chosenScore = [[UILabel alloc] init];
  self.chosenScore.font = [UIFont systemFontOfSize:12];
  self.chosenScore.textColor = [UIColor whiteColor];
  self.chosenScore.layer.cornerRadius = 10;
  self.chosenScore.textAlignment = NSTextAlignmentCenter;
  self.chosenScore.layer.masksToBounds = YES;
  self.chosenScore.backgroundColor = self.settings.tintColorCircle;
  self.chosenScore.hidden = YES;
  [self.chosenScore setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupTitleLabel {
  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.textColor = [UIColor darkGrayColor];
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  if (self.settings.wootricRecommendTo != nil && self.settings.wootricRecommendProduct != nil) {
    self.titleLabel.text = [NSString stringWithFormat:[self localizedString:@"How likely are you to recommend %@ to a %@?"], self.settings.wootricRecommendProduct, self.settings.wootricRecommendTo];
  } else if (self.settings.wootricRecommendTo != nil) {
    self.titleLabel.text = [NSString stringWithFormat:[self localizedString:@"How likely are you to recommend us to a %@?"], self.settings.wootricRecommendTo];
  } else if (self.settings.wootricRecommendProduct != nil) {
    self.titleLabel.text = [NSString stringWithFormat:[self localizedString:@"How likely are you to recommend %@ to a friend or co-worker?"], self.settings.wootricRecommendProduct];
  } else {
    self.titleLabel.text = self.defaultWootricQuestion;
  }
  self.titleLabel.font = [UIFont systemFontOfSize:16];
  [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupPoweredByWootric {
  self.poweredByWootricLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 279, 100, 11)];
  self.poweredByWootricLabel.text = @"powered by ";
  self.poweredByWootricLabel.font = [UIFont systemFontOfSize:9];
  self.poweredByWootricLabel.textColor = [UIColor darkGrayColor];
}

#pragma mark - Background Views

- (void)setupSliderCheckedBackgroundView {
  self.sliderCheckedBackgroundView = [[UILabel alloc] init];
  self.sliderCheckedBackgroundView.layer.cornerRadius = 27.5;
  self.sliderCheckedBackgroundView.layer.masksToBounds = YES;
  self.sliderCheckedBackgroundView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
  self.sliderCheckedBackgroundView.alpha = 0;
  [self.sliderCheckedBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupSliderBackgroundView {
  self.sliderBackgroundView = [[UILabel alloc] init];
  self.sliderBackgroundView.layer.cornerRadius = 27.5;
  self.sliderBackgroundView.layer.borderWidth = 4;
  self.sliderBackgroundView.layer.borderColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1].CGColor;
  self.sliderBackgroundView.layer.masksToBounds = YES;
  self.sliderBackgroundView.backgroundColor = [UIColor whiteColor];
  [self.sliderBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupBackgroundImageView {
  self.backgroundImageView = [[UIImageView alloc] init];
  self.backgroundImageView.image = self.blurredImage;
  self.backgroundImageView.alpha = 0;
  [self.backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - Icons

- (void)setupButtonCheckIcon {
  UIImage *checkIcon = [UIImage imageNamed:@"icon_check_disabled"
                                  inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.buttonIconCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
  self.buttonIconCheck.image = checkIcon;
  [self.buttonIconCheck setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupButtonSendIcon {
  UIImage *sendIcon = [UIImage imageNamed:@"icon_send_arrow"
                                 inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  self.buttonIconSend = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
  self.buttonIconSend.image = sendIcon;
  self.buttonIconSend.hidden = YES;
  [self.buttonIconSend setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - Misc.

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
  self.commentTextView.tintColor = self.settings.tintColorSubmit;
  self.commentTextView.layer.cornerRadius = 2;
  self.commentTextView.layer.borderWidth = 1;
  self.commentTextView.layer.borderColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255 alpha:1].CGColor;
  self.commentTextView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
  [self.commentTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupSlider {
  self.scoreSlider = [[UISlider alloc] init];
  self.scoreSlider.minimumValue = 0;
  self.scoreSlider.maximumValue = 10;
  self.scoreSlider.value = 5;
  self.scoreSlider.tintColor = self.settings.tintColorSubmit;
  UIImage *image = [[UIImage alloc] init];
  [self.scoreSlider setMaximumTrackImage:image forState:UIControlStateNormal];
  [self.scoreSlider setMinimumTrackImage:image forState:UIControlStateNormal];
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

- (void)addViewsToModal {
  [self.modalView addSubview:self.dismissButton];
  [self.modalView addSubview:self.wootricLink];
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
  [self.modalView addSubview:self.backButton];
  [self.modalView addSubview:self.chosenScore];
}

@end

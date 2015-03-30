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
#import "SurveyViewController+Constraints.h"
#import "SurveyViewController+Views.h"

@implementation SurveyViewController
  int score;
  BOOL scrolled;

- (instancetype)init {
  if (self = [super init]) {
    _defaultWootricQuestion = @"How likely are you to recommend us to a friend or collegue?";
    _defaultResponseQuestion = @"Thank you! Care to tell us why?";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self registerForKeyboardNotification];
  [self setupView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupView {
  _blurredImage = [_imageToBlur applyBlurWithRadius:3
                                          tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]
                              saturationDeltaFactor:1
                                          maskImage:nil];
  _tintColor = [UIColor colorWithRed:145.0/255.0 green:201.0/255.0 blue:29.0/255.0 alpha:1];

  [self setupViews];
  [self setupConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
  [UIView animateWithDuration:0.25 animations:^{
    CGRect modalFrame = _modalView.frame;
    modalFrame.origin.y = self.view.frame.size.height - _modalView.frame.size.height;
    _modalView.frame = modalFrame;
    _constTopToModal.constant = self.view.frame.size.height - _modalView.frame.size.height;
    _backgroundImageView.alpha = 1;
  }];
}

#pragma mark

- (void)updateSliderStep:(UISlider *)sender {
  if (!_voteButton.enabled) {
    _voteButton.enabled = YES;
    _dragToChangeLabel.hidden = NO;
    NSString *imageName = [self isSmallerScreenDevice] ? @"slider_bg_numbers_checked" : @"slider_bg_numbers_checked_667h";
    UIImage *imageBackground = [[UIImage imageNamed:imageName
                                           inBundle:[NSBundle bundleForClass:[self class]]
                      compatibleWithTraitCollection:nil]
                   stretchableImageWithLeftCapWidth:10
                                       topCapHeight:0];
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

- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer {
  if (_scoreSlider.highlighted)
    return;
  CGPoint pt = [gestureRecognizer locationInView: _scoreSlider];
  CGFloat percentage = pt.x / _scoreSlider.bounds.size.width;
  CGFloat delta = percentage * (_scoreSlider.maximumValue - _scoreSlider.minimumValue);
  CGFloat value = _scoreSlider.minimumValue + delta;
  [_scoreSlider setValue:value animated:YES];
  [_scoreSlider removeGestureRecognizer:gestureRecognizer];
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

  [UIView animateWithDuration:0.2 animations:^{
    _backgroundImageView.alpha = 0;
  } completion:^(BOOL finished) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }];
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
  _scorePopoverLabel.hidden = YES;
  _constTopToModal.constant = self.view.frame.size.width - _modalView.frame.size.height;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  UIImage *image = [WootricSDK imageToBlurFromViewController:[self presentingViewController]];
  UIImage *bluredImage = [image applyBlurWithRadius:3
                                          tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]
                              saturationDeltaFactor:1
                                          maskImage:nil];
  _backgroundImageView.image = bluredImage;
  [_scrollView scrollRectToVisible:_modalView.frame animated:YES];
}

- (void)changeView {
  [self hideItems];
  [self showItems];
  scrolled = NO;
  _titleLabel.text = [self textDependingOnScore:score];
  _titleLabel.textColor = _tintColor;
  _scoreLabel.text = [NSString stringWithFormat:@"You gave us an %d.", score];
  [_commentTextView becomeFirstResponder];
}

- (void)hideItems {
  _voteButton.hidden = YES;
  _dragToChangeLabel.hidden = YES;
  _extremelyLikelyLabel.hidden = YES;
  _notLikelyLabel.hidden = YES;
  _sliderBackgroundView.hidden = YES;
  _sliderCheckedBackgroundView.hidden = YES;
  _scoreSlider.hidden = YES;
}

- (void)showItems {
  _sendFeedbackButton.hidden = NO;
  _askForFeedbackLabel.hidden = NO;
  _scoreLabel.hidden = NO;
  _commentTextView.hidden = NO;
}

- (NSString *)textDependingOnScore:(int)score {
  if (score <= 6 && _detractorQuestion != nil) {
    return _detractorQuestion;
  } else if (score <= 8 && _passiveQuestion != nil) {
    return _passiveQuestion;
  } else if (_promoterQuestion != nil) {
    return _promoterQuestion;
  }
  return _defaultResponseQuestion;
}

- (BOOL)isSmallerScreenDevice {
  if ([[UIScreen mainScreen] nativeBounds].size.height <= 1136) {
    return YES;
  }
  return NO;
}

- (void)showScore:(UISlider *)slider {
  score = (int)(_scoreSlider.value);
  float xPosition = [self xPositionFromSliderValue:slider];
  _scorePopoverLabel.hidden = NO;
  _dragToChangeLabel.hidden = YES;
  _scorePopoverLabel.frame = CGRectMake(xPosition, _sliderBackgroundView.frame.origin.y - 35, 20, 30);
  _scorePopoverLabel.text = [NSString stringWithFormat:@"%d", score];
}

- (void)hideScore:(UISlider *)slider {
  _scorePopoverLabel.hidden = YES;
  _dragToChangeLabel.hidden = NO;
}

- (float)xPositionFromSliderValue:(UISlider *)aSlider;
{
  float sliderRange = aSlider.frame.size.width - aSlider.currentThumbImage.size.width;
  float sliderOrigin = aSlider.frame.origin.x + (aSlider.currentThumbImage.size.width / 4);
  float sliderValueToPixels = (((aSlider.value-aSlider.minimumValue)/(aSlider.maximumValue-aSlider.minimumValue)) * sliderRange) + sliderOrigin;

  return sliderValueToPixels;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

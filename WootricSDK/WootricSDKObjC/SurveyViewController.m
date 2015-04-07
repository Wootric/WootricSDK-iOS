//
//  SurveyViewController.m
//  WootricSDKObjC
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
    _defaultWootricQuestion = @"How likely are you to recommend us to a friend or co-worker?";
    _defaultResponseQuestion = @"Thank you! Care to tell us why?";
    _defaultPlaceholderText = @"Help us by explaining your score.";
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

  _commentTextView.delegate = self;
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
    UIImage *iconCheckEnabled = [UIImage imageNamed:@"icon_check_enabled" inBundle:[NSBundle bundleForClass: [self class]] compatibleWithTraitCollection:nil];
    _buttonIconCheck.image = iconCheckEnabled;
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
  _sendFeedbackButton.enabled = NO;
  _dismissButton.enabled = NO;
  _commentTextView.editable = NO;
  UIImage *sendArrowDisabled = [UIImage imageNamed:@"icon_send_arrow_disabled" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
  _buttonIconSend.image = sendArrowDisabled;
  NSString *text = nil;
  if ([_commentTextView.text length] != 0) {
    text = _commentTextView.text;
  }
  [WootricSDK voteWithScore:(long)_scoreSlider.value andText:text];
  [_commentTextView resignFirstResponder];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:0.2 animations:^{
      _backgroundImageView.alpha = 0;
    } completion:^(BOOL finished) {
      [self dismissViewControllerAnimated:YES completion:nil];
    }];
  });
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
  [self changeItemsVisibilityTo:YES];
  scrolled = NO;
  _titleLabel.text = [self textDependingOnScore];
  _titleLabel.textColor = _tintColor;
  _askForFeedbackLabel.text = [self placeholderDependingOnScore];
  _scoreLabel.text = [NSString stringWithFormat:@"You gave us an %d.", score];
  [_commentTextView becomeFirstResponder];
}

- (void)backButtonPressed:(UIButton *)sender {
  [self changeItemsVisibilityTo:NO];
  if (_wootricQuestion != nil) {
    _titleLabel.text = [NSString stringWithFormat:@"How likely are you to recommend us to a %@?", _wootricQuestion];
  } else {
    _titleLabel.text = _defaultWootricQuestion;
  }
  _titleLabel.textColor = [UIColor darkGrayColor];
  [_commentTextView resignFirstResponder];
}

- (void)changeItemsVisibilityTo:(BOOL)flag {
  _voteButton.hidden = flag;
  _dragToChangeLabel.hidden = flag;
  _extremelyLikelyLabel.hidden = flag;
  _notLikelyLabel.hidden = flag;
  _sliderBackgroundView.hidden = flag;
  _sliderCheckedBackgroundView.hidden = flag;
  _scoreSlider.hidden = flag;
  _buttonIconCheck.hidden = flag;
  _buttonIconSend.hidden = !flag;
  _sendFeedbackButton.hidden = !flag;
  _askForFeedbackLabel.hidden = !flag;
  _scoreLabel.hidden = !flag;
  _commentTextView.hidden = !flag;
  _backButton.hidden = !flag;
}

- (NSString *)textDependingOnScore {
  if (score <= 6 && _detractorQuestion != nil) {
    return _detractorQuestion;
  } else if (score <= 8 && _passiveQuestion != nil) {
    return _passiveQuestion;
  } else if (_promoterQuestion != nil) {
    return _promoterQuestion;
  }
  return _defaultResponseQuestion;
}

- (NSString *)placeholderDependingOnScore {
  if (score <= 6 && _detractorPlaceholder != nil) {
    return _detractorPlaceholder;
  } else if (score <= 8 && _passivePlaceholder != nil) {
    return _passivePlaceholder;
  } else if (_promoterPlaceholder != nil) {
    return _promoterPlaceholder;
  }
  return _defaultPlaceholderText;
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

- (void)textViewDidChange:(UITextView *)textView {
  if (textView.text.length == 0) {
    _askForFeedbackLabel.hidden = NO;
  } else {
    _askForFeedbackLabel.hidden = YES;
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

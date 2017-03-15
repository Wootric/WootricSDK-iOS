//
//  WTRSurveyViewController.m
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

#import "WTRSurveyViewController.h"
#import "WTRSurveyViewController+Constraints.h"
#import "WTRSurveyViewController+Views.h"
#import "WTRColor.h"
#import "UIImage+ImageFromColor.h"
#import "WTRSurvey.h"
#import "WTRThankYouButton.h"
#import "NSString+FontAwesome.h"
#import <Social/Social.h>

@interface WTRSurveyViewController ()

@property (nonatomic, assign) BOOL scrolled;
@property (nonatomic, assign) BOOL alreadyVoted;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) CAGradientLayer *gradient;

@end

@implementation WTRSurveyViewController

- (instancetype)initWithSurveySettings:(WTRSettings *)settings {
  if (self = [super init]) {
    _gradient = [CAGradientLayer layer];
    _settings = settings;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self registerForKeyboardNotification];
  [self setupViews];
  [self setupConstraints];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
  [UIView animateWithDuration:0.25 animations:^{
    self.view.backgroundColor = [WTRColor viewBackgroundColor];
    CGRect modalFrame = _modalView.frame;
    CGFloat modalPosition = self.view.frame.size.height - _modalView.frame.size.height;
    modalFrame.origin.y = modalPosition;
    _modalView.frame = modalFrame;
    _constraintTopToModalTop.constant = modalPosition;
  }];
  [self setModalGradient:_modalView.bounds];
  [_modalView.layer insertSublayer:_gradient atIndex:0];
  [_questionView addDotsAndScores];
}

#pragma mark - Button methods

- (void)openThankYouURL:(WTRThankYouButton *)sender {
  NSLog(@"%@", sender.buttonURL);
  if (![[UIApplication sharedApplication] openURL:sender.buttonURL]) {
    NSLog(@"WootricSDK: Failed to open 'thank you' url");
  } else {
    [self dismissViewControllerWithBackgroundFade];
  }
}

- (void)editScoreButtonPressed:(UIButton *)sender {
  [_feedbackView textViewResignFirstResponder];
  _scrolled = NO;
  [self setQuestionViewVisible:YES andFeedbackViewVisible:NO];
}

- (void)dismissButtonPressed:(UIButton *)sender {
  if (!_alreadyVoted) {
    [self endUserDeclined];
  }
  [_feedbackView textViewResignFirstResponder];
  [self dismissViewControllerWithBackgroundFade];
}

- (void)sendButtonPressed:(UIButton *)sender {
  _alreadyVoted = YES;
  int score = [_questionView getScoreSliderValue];
  NSString *placeholderText = [_settings followupPlaceholderTextForScore:score];
  NSString *text = [_feedbackView feedbackText];
  [self endUserVotedWithScore:score andText:text];
  if ([_feedbackView isActive]) {
    [_feedbackView textViewResignFirstResponder];
    [self presentShareScreenOrDismissForScore:score];
  } else {
    if (_settings.skipFeedbackScreen && score >= 9) {
      [self presentShareScreenOrDismissForScore:score];
    } else {
      [self setQuestionViewVisible:NO andFeedbackViewVisible:YES];
      [_feedbackView setFollowupLabelTextBasedOnScore:score];
      [_feedbackView setFeedbackPlaceholderText:placeholderText];
    }
  }
}

- (void)presentShareScreenOrDismissForScore:(int)score {
  if ([self socialShareAvailableForScore:score]) {
    [self setupFacebookAndTwitterForScore:score];
    [self presentSocialShareViewWithScore:score];
  } else {
    [self dismissWithFinalThankYou];
  }
}

- (void)noThanksButtonPressed {
  [self dismissViewControllerWithBackgroundFade];
}

- (void)endUserVotedWithScore:(int)score andText:(NSString *)text {
  WTRSurvey *survey = [[WTRSurvey alloc] init];
  [survey endUserVotedWithScore:score andText:text];
  NSLog(@"WootricSDK: Vote");
}

- (void)endUserDeclined {
  WTRSurvey *survey = [[WTRSurvey alloc] init];
  [survey endUserDeclined];
  NSLog(@"WootricSDK: Decline");
}

- (void)setQuestionViewVisible:(BOOL)questionFlag andFeedbackViewVisible:(BOOL)feedbackFlag {
  _questionView.hidden = !questionFlag;
  _feedbackView.hidden = !feedbackFlag;
}

- (void)openWootricHomepage:(UIButton *)sender {
  NSURL *url = [NSURL URLWithString:@"https://www.wootric.com"];
  if (![[UIApplication sharedApplication] openURL:url]) {
    NSLog(@"Failed to open wootric page");
  }
}


-(void)socialButtonPressedForService:(UIButton *)sender {
  if ([sender.titleLabel.text isEqualToString:[NSString fontAwesomeIconStringForEnum:FAThumbsUp]]) {
    NSURL *url = _settings.facebookPage;
    if (![[UIApplication sharedApplication] openURL:url]) {
      NSLog(@"Failed to open facebook page");
    }
  } else {
    NSString *serviceType;
    NSString *socialNetwork;
    if ([sender.titleLabel.text isEqualToString:[NSString fontAwesomeIconStringForEnum:FATwitter]]) {
      serviceType = SLServiceTypeTwitter;
      socialNetwork = @"Twitter";
    } else {
      serviceType = SLServiceTypeFacebook;
      socialNetwork = @"Facebook";
    }
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
      SLComposeViewController *sheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
      if ([serviceType isEqualToString:SLServiceTypeFacebook]) {
        [sheet addURL:_settings.facebookPage];
      } else {
        [sheet setInitialText:[NSString stringWithFormat:@"%@ @%@", [_feedbackView feedbackText], _settings.twitterHandler]];
      }
      [sheet setCompletionHandler:^(SLComposeViewControllerResult result){
        switch (result) {
          case SLComposeViewControllerResultCancelled:
            NSLog(@"WootricSDK: Post cancelled");
            break;
          case SLComposeViewControllerResultDone:
            NSLog(@"WootricSDK: Post successful");
            break;
          default:
            break;
        }
      }];
      [self presentViewController:sheet animated:YES completion:nil];
    } else {
      NSString *message = [NSString stringWithFormat:@"You can't post right now, make sure your device has an internet connection and you have at least one %@ account setup", socialNetwork];
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
      [alertView show];
    }
  }
}

#pragma mark - Slider methods

- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer {
  if (!_sendButton.enabled) {
    _sendButton.enabled = YES;
    _sendButton.backgroundColor = [_settings sendButtonBackgroundColor];
  }
  [_questionView sliderTapped:gestureRecognizer];
}

#pragma mark - Helper methods

- (void)setupFacebookAndTwitterForScore:(int)score {
  BOOL twitterAvailable = ([self twitterHandlerAndFeedbackTextPresent] && score >= 9);
  BOOL facebookAvailable = ([_settings facebookPageSet] && score >= 9);
  if (!twitterAvailable && !facebookAvailable) {
    _constraintModalHeight.constant = 230;
    _socialShareViewHeightConstraint.constant = 190;
    _constraintTopToModalTop.constant = self.view.frame.size.height - _constraintModalHeight.constant;
    [UIView animateWithDuration:0.2 animations:^{
      [self.view layoutIfNeeded];
    }];
  }
  [_socialShareView displayShareButtonsWithTwitterAvailable:twitterAvailable andFacebookAvailable:facebookAvailable];
}

- (BOOL)socialShareAvailableForScore:(int)score {
  return ([_settings thankYouLinkConfiguredForScore:score] ||
          ([self twitterHandlerAndFeedbackTextPresent] && score >= 9) ||
          ([_settings facebookPageSet] && score >= 9));
}

- (BOOL)twitterHandlerAndFeedbackTextPresent {
  return ([_settings twitterHandlerSet] && [_feedbackView feedbackTextPresent]);
}

- (void)presentSocialShareViewWithScore:(int)score {
  NSString *text = [_feedbackView feedbackText];
  [_socialShareView setThankYouButtonTextAndURLDependingOnScore:score andText:text];
  [_socialShareView setThankYouMessageDependingOnScore:score];
  [self setQuestionViewVisible:NO andFeedbackViewVisible:NO];
  _sendButton.hidden = YES;
  _socialShareView.hidden = NO;
}

- (void)dismissWithFinalThankYou {
  _feedbackView.hidden = YES;
  _questionView.hidden = YES;
  _socialShareView.hidden = YES;
  _sendButton.hidden = YES;
  _poweredByWootric.hidden = YES;
  _finalThankYouLabel.hidden = NO;
  [_modalView hideDismissButton];
  _constraintModalHeight.constant = 125;
  _constraintTopToModalTop.constant = self.view.frame.size.height - _constraintModalHeight.constant;
  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  }];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self dismissViewControllerWithBackgroundFade];
  });
}

- (void)dismissViewControllerWithBackgroundFade {
  [UIView animateWithDuration:0.2 animations:^{
    self.view.backgroundColor = [UIColor clearColor];
  } completion:^(BOOL finished) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }];
}

- (void)setModalGradient:(CGRect)bounds {
  _gradient.frame = bounds;
  _gradient.colors = @[(id)[WTRColor grayGradientTopColor].CGColor, (id)[WTRColor grayGradientBottomColor].CGColor];
}

- (void)getSizeAndRecalculatePositionsBasedOnOrientation:(UIInterfaceOrientation)interfaceOrientation {
  BOOL isFromLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
  BOOL isToLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
  if ((!isFromLandscape && isToLandscape) || (isFromLandscape && !isToLandscape)) {
    CGFloat widthAfterRotation;
    CGFloat leftAndRightMargins = 28;
    if (IS_OS_8_OR_LATER || isToLandscape) {
      widthAfterRotation = self.view.frame.size.height - leftAndRightMargins;
    } else {
      widthAfterRotation = self.view.frame.size.width - leftAndRightMargins;
    }
    [_questionView recalculateDotsAndScorePositionForWidth:widthAfterRotation];
  }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

  BOOL isToLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
  CGFloat modalPosition;
  CGRect bounds = self.view.bounds;
  CGRect gradientBounds;

  if ((bounds.size.width > bounds.size.height) && isToLandscape) {
    modalPosition = bounds.size.height - _modalView.frame.size.height;
  } else {
    modalPosition = bounds.size.width - _modalView.frame.size.height;
  }

  if ((bounds.size.height > bounds.size.width) && isToLandscape) {
    gradientBounds = CGRectMake(bounds.origin.y, bounds.origin.x, bounds.size.height, bounds.size.width);
  } else {
    gradientBounds = bounds;
  }

  _constraintTopToModalTop.constant = modalPosition;
  [self getSizeAndRecalculatePositionsBasedOnOrientation:toInterfaceOrientation];
  [self setModalGradient:gradientBounds];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  _scrolled = NO;

  BOOL isFromLandscape = UIInterfaceOrientationIsLandscape(fromInterfaceOrientation);
  CGRect bounds = self.view.bounds;
  if (_keyboardHeight == 0 && isFromLandscape && (bounds.size.width > bounds.size.height)) {
    [_scrollView scrollRectToVisible:_modalView.frame animated:YES];
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

- (void)adjustInsetForKeyboardShow:(BOOL)show notification:(NSNotification *)notification {
  NSDictionary *userInfo = notification.userInfo ? notification.userInfo : @{};
  CGRect keyboardFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  double adjustmentHeight = CGRectGetHeight(keyboardFrame) * (show ? 1 : -1);
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, adjustmentHeight, 0);
  _scrollView.contentInset = contentInsets;
  _scrollView.scrollIndicatorInsets = contentInsets;

  if ((_keyboardHeight != keyboardFrame.size.height)) {
    _keyboardHeight = keyboardFrame.size.height;
    [_scrollView setContentOffset:CGPointMake(0, _keyboardHeight) animated:YES];
  } else if (!_scrolled) {
    [_scrollView scrollRectToVisible:_modalView.frame animated:YES];
    _scrolled = YES;
  }
}

- (void)textViewDidChange:(UITextView *)textView {
  if (textView.text.length == 0) {
    [_feedbackView showFeedbackPlaceholder:YES];
  } else {
    [_feedbackView showFeedbackPlaceholder:NO];
  }
}

#pragma mark - dealloc

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

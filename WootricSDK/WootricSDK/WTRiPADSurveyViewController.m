//
//  WTRiPADSurveyViewController.m
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

#import "WTRiPADSurveyViewController.h"
#import "WTRiPADSurveyViewController+Constraints.h"
#import "WTRiPADSurveyViewController+Views.h"
#import "WTRCircleScoreButton.h"
#import "WTRiPADThankYouButton.h"
#import "WTRColor.h"
#import "WTRSurvey.h"
#import "NSString+FontAwesome.h"
#import <Social/Social.h>

@interface WTRiPADSurveyViewController ()

@property (nonatomic, assign) BOOL scrolled;
@property (nonatomic, assign) int currentScore;
@property (nonatomic, assign) BOOL alreadyVoted;
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation WTRiPADSurveyViewController

- (instancetype)initWithSurveySettings:(WTRSettings *)settings {
  if (self = [super init]) {
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
}

- (void)selectScore:(WTRCircleScoreButton *)sender {
  NSString *placeholderText = [_settings followupPlaceholderTextForScore:sender.assignedScore];
  _currentScore = sender.assignedScore;
  [_questionView selectCircleButton:sender];
  [self endUserVotedWithScore:sender.assignedScore andText:nil];
  [_feedbackView setFollowupLabelTextBasedOnScore:sender.assignedScore];
  [_feedbackView setFeedbackPlaceholderText:placeholderText];
  if (_feedbackView.hidden) {
    if (_settings.skipFeedbackScreen && _currentScore >= 9) {
      [self sendButtonPressed];
    } else {
      [self showFeedbackView];
    }
  }
}

- (void)showFeedbackView {
  [_questionView hideQuestionLabel];
  _feedbackView.hidden = NO;
  _constraintModalHeight.constant = 215;
  _constraintQuestionTopToModalTop.constant = 50;
  _constraintTopToModalTop.constant = self.view.frame.size.height - _constraintModalHeight.constant;
  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.2 animations:^{
      _feedbackView.alpha = 1;
    }];
  }];
}

- (void)endUserVotedWithScore:(int)score andText:(NSString *)text {
  WTRSurvey *survey = [[WTRSurvey alloc] init];
  [survey endUserVotedWithScore:score andText:text];
  _alreadyVoted = YES;
  NSLog(@"WootricSDK: Vote");
}

- (void)openWootricHomepage:(UIButton *)sender {
  NSURL *url = [NSURL URLWithString:@"https://www.wootric.com"];
  if (![[UIApplication sharedApplication] openURL:url]) {
    NSLog(@"Failed to open wootric page");
  }
}

- (void)openThankYouURL:(WTRiPADThankYouButton *)sender {
  if (![[UIApplication sharedApplication] openURL:sender.buttonURL]) {
    NSLog(@"WootricSDK: Failed to open 'thank you' url");
  } else {
    [self dismissViewControllerWithBackgroundFade];
  }
}

- (void)sendButtonPressed {
  NSString *text;
  if ([_feedbackView feedbackTextPresent]) {
    text = [_feedbackView feedbackText];
  }
  if ([self socialShareAvailableForScore:_currentScore]) {
    [_socialShareView setThankYouButtonTextAndURLDependingOnScore:_currentScore andText:text];
    [_socialShareView setThankYouMessageDependingOnScore:_currentScore];
    [self setupFacebookAndTwitterForScore:_currentScore];
    [self presentSocialShareViewWithScore:_currentScore];
  } else {
    [self dismissWithFinalThankYou];
  }
  [self endUserVotedWithScore:_currentScore andText:text];
}

- (void)dismissButtonPressed {
  if (!_alreadyVoted) {
    WTRSurvey *survey = [[WTRSurvey alloc] init];
    [survey endUserDeclined];
  }
  [_feedbackView textViewResignFirstResponder];
  [self dismissViewControllerWithBackgroundFade];
}

- (void)noThanksButtonPressed {
  [self dismissViewControllerWithBackgroundFade];
}

- (void)dismissViewControllerWithBackgroundFade {
  [UIView animateWithDuration:0.2 animations:^{
    self.view.backgroundColor = [UIColor clearColor];
  } completion:^(BOOL finished) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }];
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

- (void)setupFacebookAndTwitterForScore:(int)score {
  BOOL twitterAvailable = ([self twitterHandlerAndFeedbackTextPresent] && score >= 9);
  BOOL facebookAvailable = ([_settings facebookPageSet] && score >= 9);
  if (![_settings thankYouLinkConfiguredForScore:score]) {
    [_socialShareView noThankYouButton];
  }
  [self.view layoutIfNeeded];
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
  _constraintModalHeight.constant = 165;
  _constraintTopToModalTop.constant = self.view.frame.size.height - _constraintModalHeight.constant;
  [self setQuestionViewVisible:NO andFeedbackViewVisible:NO];
  [_feedbackView textViewResignFirstResponder];
  _socialShareView.hidden = NO;
  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.1 animations:^{
      _socialShareView.alpha = 1;
    }];
  }];
}

- (void)dismissWithFinalThankYou {
  _feedbackView.hidden = YES;
  _questionView.hidden = YES;
  _socialShareView.hidden = YES;
  _poweredByWootric.hidden = YES;
  _finalThankYouLabel.hidden = NO;
  _dismissButton.hidden = YES;
  _constraintModalHeight.constant = 125;
  _constraintTopToModalTop.constant = self.view.frame.size.height - _constraintModalHeight.constant;
  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  }];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self dismissViewControllerWithBackgroundFade];
  });
}

- (void)setQuestionViewVisible:(BOOL)questionFlag andFeedbackViewVisible:(BOOL)feedbackFlag {
  _questionView.hidden = !questionFlag;
  _feedbackView.hidden = !feedbackFlag;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

  BOOL isToLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
  CGFloat modalPosition;
  CGRect bounds = self.view.bounds;

  if ((bounds.size.width > bounds.size.height) && isToLandscape) {
    modalPosition = bounds.size.height - _modalView.frame.size.height;
  } else {
    modalPosition = bounds.size.width - _modalView.frame.size.height;
  }

  _constraintTopToModalTop.constant = modalPosition;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

  if (_keyboardHeight == 0) {
    [_scrollView setContentOffset:CGPointMake(0, _keyboardHeight) animated:YES];
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

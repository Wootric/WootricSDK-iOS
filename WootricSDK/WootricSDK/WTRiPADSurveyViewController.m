//
//  WTRiPADSurveyViewController.m
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

#import "WTRiPADSurveyViewController.h"
#import "WTRiPADSurveyViewController+Constraints.h"
#import "WTRiPADSurveyViewController+Views.h"
#import "WTRCircleScoreButton.h"
#import "WTRiPADThankYouButton.h"
#import "WTRColor.h"
#import "WTRSurvey.h"
#import "WTRLogger.h"
#import "WTRApiClient.h"
#import "WTRUtils.h"
#import "NSString+FontAwesome.h"
#import "WTRDefaultNotificationCenter.h"
#import "Wootric.h"
#import "WTRSurveyDelegate.h"
#import <Social/Social.h>

@interface WTRiPADSurveyViewController ()

@property (nonatomic, assign) BOOL scrolled;
@property (nonatomic, assign) int currentScore;
@property (nonatomic, assign) BOOL alreadyVoted;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) NSString *accountToken;
@property (nonatomic, strong) NSString *endUserId;
@property (nonatomic, strong) NSString *uniqueLink;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *feedbackText;
@property (nonatomic, strong) WTRNotificationCenter *notificationCenter;

@end

@implementation WTRiPADSurveyViewController

- (instancetype)initWithSurveySettings:(WTRSettings *)settings notificationCenter:(WTRNotificationCenter *)notificationCenter {
  if (self = [super init]) {
    _settings = settings;
    _notificationCenter = notificationCenter;
    _feedbackText = @"";
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  WTRApiClient *client = [WTRApiClient sharedInstance];
  _accountToken = [client accountToken];
  _endUserId = [client getEndUserId];
  _uniqueLink = [client getUniqueLink];
  _token = [client getToken];

  [self registerForKeyboardNotification];
  [self setupViews];
  [self setupConstraints];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_notificationCenter postNotificationName:[Wootric surveyWillDisappearNotification]
                                     object:self];
  [[Wootric delegate] willHideSurvey];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_notificationCenter postNotificationName:[Wootric surveyDidAppearNotification]
                                     object:self];
  [[Wootric delegate] didPresentSurvey];

  [UIView animateWithDuration:0.25 animations:^{
    self.view.backgroundColor = [WTRColor viewBackgroundColor];
    CGRect modalFrame = self->_modalView.frame;
    CGFloat modalPosition = self.view.frame.size.height - self->_modalView.frame.size.height;
    modalFrame.origin.y = modalPosition;
    self->_modalView.frame = modalFrame;
    self->_constraintTopToModalTop.constant = modalPosition;
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_notificationCenter postNotificationName:[Wootric surveyDidDisappearNotification]
                                     object:self
                                   userInfo:@{@"score": @(_currentScore), @"voted": @(_alreadyVoted)}];
  NSDictionary *driverPicklist = [[NSDictionary alloc] initWithDictionary:[_feedbackView getDriverPicklistSelectedAnswers]];
  if (_alreadyVoted) {
    [[Wootric delegate] didHideSurvey:@{@"score": @(_currentScore), @"type": @"response", @"text": @"", @"driver_picklist_answers": driverPicklist}];
  } else {
    [[Wootric delegate] didHideSurvey:@{@"score": @(_currentScore), @"type": @"response", @"text": _feedbackText, @"driver_picklist_answers": driverPicklist}];
  }
}

- (void)selectScore:(WTRCircleScoreButton *)sender {
  NSString *placeholderText = [_settings followupPlaceholderTextForScore:sender.assignedScore];
  _currentScore = sender.assignedScore;
  [_questionView selectCircleButton:sender];
  [self endUserVotedWithScore:sender.assignedScore text:nil picklistAnswers:nil];
  [_feedbackView setDriverPicklistBasedOnScore:sender.assignedScore];
  [_feedbackView setFollowupLabelTextBasedOnScore:sender.assignedScore];
  [_feedbackView setFeedbackPlaceholderText:placeholderText];
  if (_feedbackView.hidden) {
    if (_settings.skipFeedbackScreen) {
      [self sendButtonPressed];
    } else if (_settings.skipFeedbackScreenForPromoter && [_settings positiveTypeScore:_currentScore]) {
      [self sendButtonPressed];
    } else {
      [self showFeedbackView];
    }
  } else {
    [self updateConstraints];
  }
}

- (void)showFeedbackView {
  [_questionView hideQuestionLabel];
  _feedbackView.hidden = NO;
  [self updateConstraints];
}

- (void)updateConstraints {
  _constraintModalHeight.constant = 200 + [_feedbackView followupLabelHeight];
  _constraintFeedbackViewHeight.constant = 90 + [_feedbackView followupLabelHeight];
  _constraintQuestionViewHeight.constant = 110 + [_feedbackView followupLabelHeight];
  _constraintQuestionTopToModalTop.constant = 50 + [_feedbackView followupLabelHeight];

  NSDictionary *driverPicklistSettings = [_settings driverPicklistSettingsForScore:_currentScore];

  if ([[_settings driverPicklistAnswersForScore:_currentScore] count] > 0) {
    _constraintModalHeight.constant += [_feedbackView driverPicklistHeight];
    _constraintFeedbackViewHeight.constant += [_feedbackView driverPicklistHeight];
    _constraintQuestionTopToModalTop.constant += [_feedbackView driverPicklistHeight];

    if (driverPicklistSettings[@"dpl_hide_open_ended"] && [driverPicklistSettings[@"dpl_hide_open_ended"] intValue] == 1) {
      _constraintModalHeight.constant -= 24;
      _constraintFeedbackViewHeight.constant = 34 + [_feedbackView driverPicklistHeight] + [_feedbackView followupLabelHeight];
      _constraintQuestionTopToModalTop.constant = [_feedbackView driverPicklistHeight] + [_feedbackView followupLabelHeight] - 20;
      _constraintQuestionViewHeight.constant += [_feedbackView driverPicklistHeight];
      [_questionView showSendButton:true];
    } else {
      [_questionView showSendButton:false];
    }
  } else {
    [_questionView showSendButton:false];
  }
  _constraintTopToModalTop.constant = self.view.frame.size.height - _constraintModalHeight.constant;

  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.2 animations:^{
      self->_feedbackView.alpha = 1;
    }];
  }];
}

- (void)endUserVotedWithScore:(int)score text:(NSString *)text picklistAnswers:(NSDictionary *)picklistAnswers {
  WTRSurvey *survey = [[WTRSurvey alloc] init];
  [survey endUserVotedWithScore:score text:text picklistAnswers:picklistAnswers];
  _alreadyVoted = YES;
  [WTRLogger log:@"Vote"];
}

- (void)openWootricHomepage:(UIButton *)sender {
  NSURL *url = [NSURL URLWithString:@"https://www.wootric.com"];
  [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
    if (!success) {
      [WTRLogger logError:@"Failed to open wootric page."];
    }
  }];
}

- (void)optOutButtonPressed:(UIButton *)sender {
  [[UIApplication sharedApplication] openURL:[self optOutURL] options:@{} completionHandler:^(BOOL success) {
    if (success) {
      [self dismissViewControllerWithBackgroundFade];
    } else {
      [WTRLogger logError:@"Failed to open opt out page."];
    }
  }];
}

- (void)openDisclaimerLink:(UITapGestureRecognizer *)gesture {
  NSURL *url = self.settings.disclaimerLinkURL;

  if (url) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
      if (!success) {
        [WTRLogger logError:@"Failed to open disclaimerLinkURL page."];
      }
    }];
  } else {
    [WTRLogger logError:@"No disclaimerLinkURL set."];
  }
}

- (void)openThankYouURL:(WTRiPADThankYouButton *)sender {
  [[UIApplication sharedApplication] openURL:sender.buttonURL options:@{} completionHandler:^(BOOL success) {
    if (success) {
      [self dismissViewControllerWithBackgroundFade];
    } else {
      [WTRLogger logError:@"Failed to open thank you link page."];
    }
  }];
}

- (void)sendButtonPressed {
  NSDictionary *picklistAnswers = [_feedbackView getDriverPicklistSelectedAnswers];
  if ([_feedbackView feedbackTextPresent]) {
    _feedbackText = [_feedbackView feedbackText];
  }
  if ([self socialShareAvailableForScore:_currentScore]) {
    [_socialShareView setThankYouButtonTextAndURLDependingOnScore:_currentScore text:_feedbackText];
    [_socialShareView setThankYouMainDependingOnScore:_currentScore];
    [_socialShareView setThankYouSetupDependingOnScore:_currentScore];
    [self setupFacebookAndTwitterForScore:_currentScore];
    [self presentSocialShareViewWithScore:_currentScore];
  } else {
    [self dismissWithFinalThankYou];
  }
  [self endUserVotedWithScore:_currentScore text:_feedbackText picklistAnswers:picklistAnswers];
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

- (void)socialButtonPressedForService:(UIButton *)sender {
  if ([sender.titleLabel.text isEqualToString:[NSString fontAwesomeIconStringForEnum:FAThumbsUp]]) {
    NSURL *url = _settings.facebookPage;
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
      if (!success) {
        [WTRLogger logError:@"Failed to open Facebook page."];
      }
    }];
  } else {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[_feedbackView feedbackText]] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[
      UIActivityTypePostToWeibo,
      UIActivityTypeMessage,
      UIActivityTypeMail,
      UIActivityTypePrint,
      UIActivityTypeCopyToPasteboard,
      UIActivityTypeAssignToContact,
      UIActivityTypeSaveToCameraRoll,
      UIActivityTypeAddToReadingList,
      UIActivityTypePostToFlickr,
      UIActivityTypePostToVimeo,
      UIActivityTypePostToTencentWeibo,
      UIActivityTypeAirDrop,
      UIActivityTypeOpenInIBooks
    ];
    [self presentViewController:activityViewController animated:YES completion:^{
      [WTRLogger log:@"Post successful."];
    }];
  }
}

- (NSURL *)optOutURL {
  NSString *tld = [WTRUtils getTokenTLD:_accountToken];
  return [NSURL URLWithString:[NSString stringWithFormat:@"https://app.wootric.%@/opt_out?token=%@&metric_type=%@&end_user_id=%@&end_user_email=%@&unique_link=%@&opt_out_token=%@", tld, _accountToken, _settings.surveyType, _endUserId, _settings.endUserEmail, _uniqueLink, _token]];
}

- (void)setupFacebookAndTwitterForScore:(int)score {
  BOOL twitterAvailable = ([self twitterHandlerAndFeedbackTextPresent] && [_settings positiveTypeScore:score]);
  BOOL facebookAvailable = ([_settings facebookPageSet] && [_settings positiveTypeScore:score]);
  if (![_settings thankYouLinkConfiguredForScore:score]) {
    [_socialShareView noThankYouButton];
  }
  [self.view layoutIfNeeded];
  [_socialShareView displayShareButtonsWithTwitterAvailable:twitterAvailable andFacebookAvailable:facebookAvailable];
}

- (BOOL)socialShareAvailableForScore:(int)score {
  return ([_settings thankYouLinkConfiguredForScore:score] ||
          ([self twitterHandlerAndFeedbackTextPresent] && [_settings positiveTypeScore:score]) ||
          ([_settings facebookPageSet] && [_settings positiveTypeScore:score]));
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
      self->_socialShareView.alpha = 1;
    }];
  }];
}

- (void)dismissWithFinalThankYou {
  _feedbackView.hidden = YES;
  _questionView.hidden = YES;
  _socialShareView.hidden = YES;
  _finalThankYouLabel.hidden = NO;
  _footerView.hidden = YES;
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
    CGFloat modalPosition;
    CGRect bounds = self.view.bounds;

    modalPosition = bounds.size.height - self->_modalView.frame.size.height;

    self->_constraintTopToModalTop.constant = modalPosition;
    if (!self->_feedbackView.hidden) {
      [self updateConstraints];
    }
  } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    if (self->_keyboardHeight == 0) {
      [self->_scrollView setContentOffset:CGPointMake(0, self->_keyboardHeight) animated:YES];
    }
  }];
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
  CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
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

//
//  WTRSurveyViewController.m
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

#import "WTRSurveyViewController.h"
#import "WTRSurveyViewController+Constraints.h"
#import "WTRSurveyViewController+Views.h"
#import "WTRColor.h"
#import "UIImage+ImageFromColor.h"
#import "WTRSurvey.h"
#import "WTRThankYouButton.h"
#import "WTRLogger.h"
#import "WTRApiClient.h"
#import "WTRUtils.h"
#import "NSString+FontAwesome.h"
#import "Wootric.h"
#import "WTRSurveyDelegate.h"
#import <Social/Social.h>

@interface WTRSurveyViewController ()

@property (nonatomic, assign) BOOL scrolled;
@property (nonatomic, assign) int currentScore;
@property (nonatomic, assign) BOOL alreadyVoted;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) CAGradientLayer *gradient;
@property (nonatomic, strong) NSString *accountToken;
@property (nonatomic, strong) NSString *endUserId;
@property (nonatomic, strong) NSString *uniqueLink;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *feedbackText;
@property (nonatomic, strong) WTRNotificationCenter *notificationCenter;

@end

@implementation WTRSurveyViewController

- (instancetype)initWithSurveySettings:(WTRSettings *)settings notificationCenter:(WTRNotificationCenter *)notificationCenter {
  if (self = [super init]) {
    _gradient = [CAGradientLayer layer];
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
  [self setModalGradient:_modalView.bounds];
  [_modalView.layer insertSublayer:_gradient atIndex:0];
  [_questionView addDotsAndScores];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_notificationCenter postNotificationName:[Wootric surveyDidDisappearNotification]
                                     object:self
                                   userInfo:@{@"score": @(_currentScore), @"voted": @(_alreadyVoted), @"text": _feedbackText}];
  NSDictionary *driverPicklist = [[NSDictionary alloc] initWithDictionary:[_feedbackView getDriverPicklistSelectedAnswers]];
  if (_alreadyVoted) {
    [[Wootric delegate] didHideSurvey:@{@"score": @(_currentScore), @"type": @"response", @"text": @"", @"driver_picklist_answers": driverPicklist}];
  } else {
    [[Wootric delegate] didHideSurvey:@{@"score": @(_currentScore), @"type": @"response", @"text": _feedbackText, @"driver_picklist_answers": driverPicklist}];
  }
}

#pragma mark - Button methods

- (void)openThankYouURL:(WTRThankYouButton *)sender {
  UIApplication *application = [UIApplication sharedApplication];
  [WTRLogger log:@"%@", sender.buttonURL];

  if (!sender.buttonURL) {
    [WTRLogger logError:@"Invalid URL"];
    return;
  }

  if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
    [application openURL:sender.buttonURL
                                       options:@{}
                             completionHandler:^(BOOL success) {
      if (success) {
        [self dismissViewControllerWithBackgroundFade];
      } else {
        [WTRLogger logError:@"Failed to open 'thank you' url"];
      }
    }];
  } else {
    [[UIApplication sharedApplication] openURL:sender.buttonURL options:@{} completionHandler:^(BOOL success) {
      if (success) {
        [self dismissViewControllerWithBackgroundFade];
      } else {
        [WTRLogger logError:@"Failed to open wootric page"];
      }
    }];
  }
}

- (void)editScoreButtonPressed:(UIButton *)sender {
  if ([_settings driverPicklistAnswers]) {
    [self updateConstraintModalHeight:308];
    [self setModalGradient:_modalView.bounds];
    [_modalView.layer insertSublayer:_gradient atIndex:0];
  }

  [_feedbackView clearFeedbackText];
  [_feedbackView textViewResignFirstResponder];
  _scrolled = NO;
  [self setQuestionViewVisible:YES andFeedbackViewVisible:NO];
  [self updateConstraints];
  [self updateDisclaimerLabelConstraintsForScreen:1];
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
  _currentScore = [_questionView getScoreSliderValue];
  NSDictionary *picklistAnswers = [_feedbackView getDriverPicklistSelectedAnswers];

  NSString *placeholderText = [_settings followupPlaceholderTextForScore:_currentScore];
  _feedbackText = [_feedbackView feedbackText];
  [self endUserVotedWithScore:_currentScore text:_feedbackText picklistAnswers:picklistAnswers];
  if ([_feedbackView isActive]) {
    [_feedbackView textViewResignFirstResponder];
    [self presentShareScreenOrDismissForScore:_currentScore];
  } else {
    if (_settings.skipFeedbackScreen) {
      [self presentShareScreenOrDismissForScore:_currentScore];
    } else if (_settings.skipFeedbackScreenForPromoter && [_settings positiveTypeScore:_currentScore]) {
      [self presentShareScreenOrDismissForScore:_currentScore];
    } else {
      [self setQuestionViewVisible:NO andFeedbackViewVisible:YES];
      [_feedbackView setFollowupLabelTextBasedOnScore:_currentScore];
      [_feedbackView setFeedbackPlaceholderText:placeholderText];
      [_feedbackView setDriverPicklistBasedOnScore:_currentScore];

      [self updateConstraints];
      [self updateDisclaimerLabelConstraintsForScreen:2];
    }
  }
}

- (void)updateConstraints {
  int modalHeight = 308;
  int feedbackViewHeight = 213;
  int openEndedHeight = 148;
  int disclaimerHeight = 18;
  int feedbackViewSpacing = 5;
  int modalSpacing = 10;
  
  if (!_questionView.hidden) {
    if ([_settings driverPicklistAnswers]) {
      [self updateConstraintModalHeight:modalHeight];
    }
  } else if (!_feedbackView.hidden) {
    if ([_settings driverPicklistAnswers]) {
      if ([_settings showDisclaimer]) {
        modalHeight += disclaimerHeight;
      }
      NSDictionary *driverPicklistSettings = [_settings driverPicklistSettingsForScore:_currentScore];
      if (driverPicklistSettings[@"dpl_hide_open_ended"] && [driverPicklistSettings[@"dpl_hide_open_ended"] intValue] == 1) {
        modalHeight = (modalHeight - openEndedHeight) + modalSpacing + [_feedbackView driverPicklistHeight] + [_feedbackView followupLabelHeight];
        feedbackViewHeight = feedbackViewHeight + [_feedbackView driverPicklistHeight] + [_feedbackView followupLabelHeight];
      } else {
        modalHeight = modalHeight + [_feedbackView driverPicklistHeight] + [_feedbackView followupLabelHeight];
        feedbackViewHeight = feedbackViewHeight + feedbackViewSpacing + [_feedbackView driverPicklistHeight] + [_feedbackView followupLabelHeight];
      }
      [self updateConstraintModalHeight:modalHeight feedbackViewHeight:feedbackViewHeight];
    }
  }
  
  [self setModalGradient:_modalView.bounds];
  [_modalView.layer insertSublayer:_gradient atIndex:0];
}

- (void)presentShareScreenOrDismissForScore:(int)score {
  if ([self socialShareAvailableForScore:score]) {
    [self setupFacebookAndTwitterForScore:score];
    [self presentSocialShareViewWithScore:score];
    if ([_settings showDisclaimer]) {
      [self updateDisclaimerLabelConstraintsForScreen:3];
    }
  } else {
    [self dismissWithFinalThankYouForScore:score];
  }
}

- (void)noThanksButtonPressed {
  [self dismissViewControllerWithBackgroundFade];
}

- (void)endUserVotedWithScore:(int)score text:(NSString *)text picklistAnswers:(NSDictionary *)picklistAnswers {
  WTRSurvey *survey = [[WTRSurvey alloc] init];
  [survey endUserVotedWithScore:score text:text picklistAnswers:picklistAnswers];
  [WTRLogger log:@"Vote"];
}

- (void)endUserDeclined {
  WTRSurvey *survey = [[WTRSurvey alloc] init];
  [survey endUserDeclined];
  [WTRLogger log:@"WootricSDK: Decline"];
}

- (void)setQuestionViewVisible:(BOOL)questionFlag andFeedbackViewVisible:(BOOL)feedbackFlag {
  _questionView.hidden = !questionFlag;
  _feedbackView.hidden = !feedbackFlag;
}

- (void)openWootricHomepage:(UIButton *)sender {
  NSURL *url = [NSURL URLWithString:@"https://www.wootric.com"];
  [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
    if (!success) {
      [WTRLogger logError:@"Failed to open wootric page."];
    }
  }];
}

- (void)openDisclaimerLink:(UITapGestureRecognizer *)gesture {
  NSURL *url = self.settings.disclaimerLinkURL;
  
  if (url) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
      if (!success) {
        [WTRLogger logError:@"Failed to disclaimerLinkURL page"];
      }
    }];
  } else {
    [WTRLogger logError:@"No disclaimerLinkURL set."];
  }
}

- (void)optOutButtonPressed:(UIButton *)sender {
  [[UIApplication sharedApplication] openURL:[self optOutURL] options:@{} completionHandler:^(BOOL success) {
    if (success) {
      [self dismissViewControllerWithBackgroundFade];
    } else {
      [WTRLogger logError:@"Failed to open opt out page"];
    }
  }];
}

-(void)socialButtonPressedForService:(UIButton *)sender {
  if ([sender.titleLabel.text isEqualToString:[NSString fontAwesomeIconStringForEnum:FAThumbsUp]]) {
    NSURL *url = _settings.facebookPage;
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
      if (!success) {
        [WTRLogger logError:@"Failed to open Facebook page"];
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
      [WTRLogger log:@"Post successful"];
    }];
  }
}

#pragma mark - Slider methods

- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer {
  [_questionView sliderTapped:gestureRecognizer];
}

#pragma mark - Helper methods

- (void)toggleSenderButton {
  if (!_sendButton.enabled) {
    _sendButton.enabled = YES;
    _sendButton.backgroundColor = [_settings sendButtonBackgroundColor];
  }
}

- (NSURL *)optOutURL {
  NSString *tld = [WTRUtils getTokenTLD:_accountToken];
  return [NSURL URLWithString:[NSString stringWithFormat:@"https://app.wootric.%@/opt_out?token=%@&metric_type=%@&end_user_id=%@&end_user_email=%@&unique_link=%@&opt_out_token=%@", tld, _accountToken, _settings.surveyType, _endUserId, _settings.endUserEmail, _uniqueLink, _token]];
}

- (void)setupFacebookAndTwitterForScore:(int)score {
  BOOL twitterAvailable = ([self twitterHandlerAndFeedbackTextPresent] && [_settings positiveTypeScore:score]);
  BOOL facebookAvailable = ([_settings facebookPageSet] && [_settings positiveTypeScore:score]);
  
  CGFloat modalHeight = _constraintModalHeight.constant - 70.0f;
  CGFloat socialShareViewHeight = _socialShareViewHeightConstraint.constant - 10.0f;
  
  if (!twitterAvailable && !facebookAvailable) {
    if ([_settings thankYouSetupDependingOnScore:score] == nil) {
      modalHeight = 220;
      socialShareViewHeight = 180;
    } else {
      modalHeight = 240;
      socialShareViewHeight = 200;
    }
  } else if ((twitterAvailable || facebookAvailable) && ![_settings thankYouLinkConfiguredForScore:score]) {
    modalHeight = 240;
    socialShareViewHeight = 200;
  } else if (![_settings positiveTypeScore:score] && ![_settings thankYouLinkConfiguredForScore:score]) {
    modalHeight = 240;
    socialShareViewHeight = 200;
  }

  if ([_settings showDisclaimer]) {
    modalHeight += 14;
    socialShareViewHeight += 24;
  }
  [self updateConstraintModalHeight:modalHeight socialShareViewHeight:socialShareViewHeight];
  [_socialShareView displayShareButtonsWithTwitterAvailable:twitterAvailable andFacebookAvailable:facebookAvailable];
}

- (void)updateConstraintModalHeight:(CGFloat)constraintModalHeight {
  _constraintModalHeight.constant = constraintModalHeight;
  _constraintTopToModalTop.constant = self.view.frame.size.height - _constraintModalHeight.constant;
  
  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (void)updateConstraintModalHeight:(CGFloat)constraintModalHeight feedbackViewHeight:(CGFloat)feedbackViewHeightConstraint {
  _constraintFeedbackViewHeight.constant = feedbackViewHeightConstraint;
  [self updateConstraintModalHeight:constraintModalHeight];
}

- (void)updateConstraintModalHeight:(CGFloat)constraintModalHeight socialShareViewHeight:(CGFloat)socialShareViewHeightConstraint {
  _socialShareViewHeightConstraint.constant = socialShareViewHeightConstraint;
  [self updateConstraintModalHeight:constraintModalHeight];
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
  NSString *text = [_feedbackView feedbackText];
  [_socialShareView setThankYouButtonTextAndURLDependingOnScore:score text:text];
  [_socialShareView setThankYouMainDependingOnScore:score];
  [_socialShareView setThankYouSetupDependingOnScore:score];
  [self setQuestionViewVisible:NO andFeedbackViewVisible:NO];
  _sendButton.hidden = YES;
  _socialShareView.hidden = NO;
  _optOutButton.hidden = YES;
  [self setupPoweredByWootricConstraintsCenteredX];
}

- (void)dismissWithFinalThankYouForScore:(int)score {
  _feedbackView.hidden = YES;
  _questionView.hidden = YES;
  _socialShareView.hidden = YES;
  _sendButton.hidden = YES;
  _poweredByWootric.hidden = YES;
  _optOutButton.hidden = YES;
  _finalThankYouLabel.hidden = NO;
  _disclaimerLabel.hidden = YES;
  _finalThankYouLabel.text = [_settings thankYouMainDependingOnScore:score];
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

- (void)getSizeAndRecalculatePositionsBasedOnOrientation {
  BOOL isFromLandscape = !UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
  CGFloat widthAfterRotation;
  CGFloat leftAndRightMargins = 28;
  
  UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
  if (IS_OS_8_OR_LATER || isFromLandscape) {
    widthAfterRotation = self.view.frame.size.width - leftAndRightMargins;
  } else {
    widthAfterRotation = self.view.frame.size.height - (leftAndRightMargins + window.safeAreaInsets.top);
  }
  [_questionView recalculateDotsAndScorePositionForWidth:widthAfterRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

  UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
    BOOL isFromLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
    CGFloat modalPosition;
    CGRect bounds = self.view.bounds;
    CGRect gradientBounds;

    modalPosition = bounds.size.height - self->_modalView.frame.size.height;

    if ((bounds.size.height > bounds.size.width) && !isFromLandscape) {
      gradientBounds = CGRectMake(bounds.origin.y, bounds.origin.x, bounds.size.height, bounds.size.width);
    } else {
      gradientBounds = bounds;
    }

    self->_constraintTopToModalTop.constant = modalPosition;
    [self getSizeAndRecalculatePositionsBasedOnOrientation];
    [self setModalGradient:gradientBounds];
    [self updateConstraints];
  } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    self->_scrolled = NO;
    
    BOOL isFromLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
    CGRect bounds = self.view.bounds;
    if (self->_keyboardHeight == 0 && isFromLandscape && (bounds.size.width > bounds.size.height)) {
      [self->_scrollView scrollRectToVisible:self->_modalView.frame animated:YES];
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

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
#import "WTRColor.h"
#import "WTRSurvey.h"

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
  [_npsQuestionView selectCircleButton:sender];
  [self endUserVotedWithScore:sender.assignedScore andText:nil];
  [_feedbackView setFollowupLabelTextBasedOnScore:sender.assignedScore];
  [_feedbackView setFeedbackPlaceholderText:placeholderText];
  if (_feedbackView.hidden) {
    [self showFeedbackView];
  }
}

- (void)showFeedbackView {
  [_npsQuestionView hideQuestionLabel];
  _feedbackView.hidden = NO;
  _constraintModalHeight.constant = 215;
  _constraintNPSTopToModalTop.constant = 50;
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

- (void)sendButtonPressed {
  NSString *text = nil;
  if ([_feedbackView feedbackTextPresent]) {
    text = [_feedbackView feedbackText];
  }
  [self endUserVotedWithScore:_currentScore andText:text];
}

- (void)dismissButtonPressed {
  if (!_alreadyVoted) {
    WTRSurvey *survey = [[WTRSurvey alloc] init];
    [survey endUserDeclined];
  }
  [self dismissViewControllerWithBackgroundFade];
}

- (void)dismissViewControllerWithBackgroundFade {
  [UIView animateWithDuration:0.2 animations:^{
    self.view.backgroundColor = [UIColor clearColor];
  } completion:^(BOOL finished) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

  CGFloat modalPosition = self.view.bounds.size.width - _modalView.frame.size.height;
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

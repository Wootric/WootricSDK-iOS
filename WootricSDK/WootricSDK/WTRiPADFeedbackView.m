//
//  WTRFeedbackView.m
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

#import "WTRCollectionViewCenterLayout.h"
#import "WTRiPADFeedbackView.h"
#import "WTRColor.h"
#import "WTRUtils.h"
#import "WTRSurveyViewController.h"
#import "SimpleConstraints.h"
#import "UIItems.h"
#import "WTRDriverPicklistCollectionViewCell.h"

@interface WTRiPADFeedbackView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UILabel *followupLabel;
@property (nonatomic, strong) UILabel *feedbackPlaceholder;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) WTRSettings *settings;
@property (nonatomic, strong) UICollectionView *driverPicklistCollectionView;
@property (nonatomic, strong) NSArray *driverPicklist;
@property (nonatomic, strong) NSMutableArray *driverPicklistKeys;
@property (nonatomic, strong) NSMutableArray *driverPicklistAnswers;
@property BOOL multiselect;
@property (nonatomic, strong) NSLayoutConstraint *driverPicklistBottomConstraint;
@end

@implementation WTRiPADFeedbackView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    _settings = settings;
    _driverPicklistKeys = [[NSMutableArray alloc] initWithCapacity:5];
    _driverPicklistAnswers = [[NSMutableArray alloc] initWithCapacity:5];
    self.hidden = YES;
    self.alpha = 0;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController];
  [self setupFollowupLabel];
  [self setupDriverPicklistView];
  [self setupFeedbackLabel];
  [self setupSendButtonViewWithViewController:(UIViewController *)viewController];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupFollowupLabelConstraints];
  [self setupDriverPicklistViewConstraints];
  [self setupFeedbackTextViewConstraints];
  [self setupFeedbackLabelConstraints];
  [self setupSendButtonConstraints];
}

- (void)setFollowupLabelTextBasedOnScore:(int)score {
  _followupLabel.text = [_settings followupQuestionTextForScore:score];
}

- (void)setDriverPicklistBasedOnScore:(int)score {
  _driverPicklist = [_settings driverPicklistAnswersForScore:score];
  [_driverPicklistKeys removeAllObjects];
  [_driverPicklistAnswers removeAllObjects];

  NSDictionary *driverPicklistSettings = [_settings driverPicklistSettingsForScore:score];

  if (driverPicklistSettings[@"dpl_randomize_list"] && [driverPicklistSettings[@"dpl_randomize_list"] intValue] == 1) {
    _driverPicklist = [[WTRUtils shuffleArray:_driverPicklist] mutableCopy];
  }

  for (NSArray *dpl in _driverPicklist) {
    [_driverPicklistKeys addObject:dpl[0]];
    [_driverPicklistAnswers addObject:dpl[1]];
  }

  if (driverPicklistSettings[@"dpl_hide_open_ended"] && [driverPicklistSettings[@"dpl_hide_open_ended"] intValue] == 1) {
    _feedbackTextView.hidden = true;
    _feedbackPlaceholder.hidden = true;
    _sendButton.hidden = true;
    _driverPicklistBottomConstraint.constant = -4;
  } else {
    _feedbackTextView.hidden = false;
    _feedbackPlaceholder.hidden = false;
    _sendButton.hidden = false;
    _driverPicklistBottomConstraint.constant = -51;
  }
  if (driverPicklistSettings[@"dpl_multi_select"]) {
    _multiselect = [driverPicklistSettings[@"dpl_multi_select"] boolValue];
  }
  if ([_driverPicklistKeys count] > 0) {
    [_driverPicklistCollectionView setHidden:false];
  } else {
    [_driverPicklistCollectionView setHidden:true];
  }
  [_driverPicklistCollectionView reloadData];
}

- (void)textViewResignFirstResponder {
  [_feedbackTextView resignFirstResponder];
}

- (void)showFeedbackPlaceholder:(BOOL)flag {
  _feedbackPlaceholder.hidden = !flag;
}

- (void)setFeedbackPlaceholderText:(NSString *)text {
  _feedbackPlaceholder.text = text;
}

- (NSString *)feedbackText {
  if (_feedbackTextView.text) {
    return _feedbackTextView.text;
  }
  return @"";
}

- (BOOL)feedbackTextPresent {
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return !([[_feedbackTextView.text stringByTrimmingCharactersInSet:set] length] == 0);
}

- (BOOL)isActive {
  return !self.hidden;
}

- (NSDictionary *)getDriverPicklistSelectedAnswers {
  return [self selectedAnswers];
}

- (void)setupSendButtonViewWithViewController:(UIViewController *)viewController {
  _sendButton = [[UIButton alloc] init];
  _sendButton.backgroundColor = [WTRColor iPadSendButtonBackgroundColor];
  _sendButton.layer.cornerRadius = 3;
  _sendButton.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
  _sendButton.titleLabel.font = [UIItems boldFontWithSize:14];
  [_sendButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_sendButton setTitle:[self.settings sendButtonText] forState:UIControlStateNormal];
  [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
  [_sendButton addTarget:viewController
                  action:NSSelectorFromString(@"sendButtonPressed")
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupDriverPicklistView {
  WTRCollectionViewCenterLayout *centerLayout = [WTRCollectionViewCenterLayout new];
  _driverPicklistCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:centerLayout];
  _driverPicklistCollectionView.translatesAutoresizingMaskIntoConstraints = false;
  _driverPicklistCollectionView.delegate = self;
  _driverPicklistCollectionView.dataSource = self;
  [_driverPicklistCollectionView setBackgroundColor:[UIColor clearColor]];
  [_driverPicklistCollectionView registerClass:[WTRDriverPicklistCollectionViewCell class] forCellWithReuseIdentifier:@"driverPicklistIdentifier"];
}

- (void)setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController {
  _feedbackTextView = [UIItems feedbackTextViewWithBackgroundColor:[WTRColor iPadFeedbackTextViewBackgroundColor]];
  _feedbackTextView.delegate = viewController;
}

- (void)setupFeedbackLabel {
  _feedbackPlaceholder = [UIItems feedbackPlaceholder];
}

- (void)setupFollowupLabel {
  _followupLabel = [UIItems followupLabelWithTextColor:[WTRColor iPadQuestionsTextColor]];
}

- (void)addSubviews {
  [self addSubview:_feedbackTextView];
  [self addSubview:_followupLabel];
  [self addSubview:_driverPicklistCollectionView];
  [self addSubview:_feedbackPlaceholder];
  [self addSubview:_sendButton];
}

- (void)setupSendButtonConstraints {
  [_sendButton wtr_constraintWidth:100];
  [[[_sendButton wtr_topConstraint] toSecondViewTop:_feedbackTextView] addToView:self];
  [[[_sendButton wtr_bottomConstraint] toSecondViewBottom:_feedbackTextView] addToView:self];
  [[[_sendButton wtr_leftConstraint] toSecondViewRight:_feedbackTextView] addToView:self];
}

- (void)setupFollowupLabelConstraints {
  [[[_followupLabel wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_followupLabel wtr_topConstraint] toSecondViewTop:self] withConstant:20] addToView:self];
  [[[[_followupLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_followupLabel wtr_rightConstraint] toSecondViewRight:self] withConstant:-16] addToView:self];
}

- (void)setupDriverPicklistViewConstraints {
  [[[_driverPicklistCollectionView wtr_leftConstraint] toSecondViewLeft:self] addToView:self];
  [[[_driverPicklistCollectionView wtr_rightConstraint] toSecondViewRight:self] addToView:self];
  [[[[_driverPicklistCollectionView wtr_topConstraint] toSecondViewBottom:_followupLabel] withConstant:8] addToView:self];
  _driverPicklistBottomConstraint = [[[_driverPicklistCollectionView wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-4];
  [_driverPicklistBottomConstraint addToView:self];
}

- (void)setupFeedbackTextViewConstraints {
  [_feedbackTextView wtr_constraintHeight:51.0f];
  [[[[_feedbackTextView wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_feedbackTextView wtr_rightConstraint] toSecondViewRight:self] withConstant:-116] addToView:self];
  [[[_feedbackTextView wtr_bottomConstraint] toSecondViewBottom:self] addToView:self];
}

- (void)setupFeedbackLabelConstraints {
  [[[[_feedbackPlaceholder wtr_leftConstraint] toSecondViewLeft:_feedbackTextView] withConstant:20] addToView:self];
  [[[[_feedbackPlaceholder wtr_rightConstraint] toSecondViewRight:_feedbackTextView] withConstant:-20] addToView:self];
  [[[[_feedbackPlaceholder wtr_topConstraint] toSecondViewTop:_feedbackTextView] withConstant:14] addToView:self];
}

#pragma mark - CollectionView methods

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  WTRDriverPicklistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"driverPicklistIdentifier" forIndexPath:indexPath];
  [cell setBackgroundColor:_settings.driverPicklistColor];
  [cell setText:_driverPicklistAnswers[indexPath.row]];
  return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [_driverPicklistKeys count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [WTRUtils sizeForText:(NSString*)_driverPicklistAnswers[indexPath.row] fontSize:(int)WTRFontSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 5.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (!_multiselect) {
    for (WTRDriverPicklistCollectionViewCell *cell in [_driverPicklistCollectionView visibleCells]) {
      if (cell != [collectionView cellForItemAtIndexPath:indexPath]) {
        [cell unselect];
      }
    }
  }
}

- (CGFloat)followupLabelHeight {
  return [self.followupLabel systemLayoutSizeFittingSize:[WTRUtils sizeForText:self.followupLabel.text fontSize:(int)WTRFontSize]].height;
}

- (int)driverPicklistHeight {
  return self.driverPicklistCollectionView.collectionViewLayout.collectionViewContentSize.height;
}

- (NSDictionary *)selectedAnswers {
  NSMutableDictionary *answers = [NSMutableDictionary new];
  for (WTRDriverPicklistCollectionViewCell *cell in [_driverPicklistCollectionView visibleCells]) {
    if ([cell selectedValue]) {
      answers[cell.titleLabel.text] = cell.titleLabel.text;
    }
  }
  return answers;
}

- (NSString *)keyForObject:(NSString *)object {
  return [_driverPicklistKeys objectAtIndex:[_driverPicklistAnswers indexOfObject:object]];
}
@end

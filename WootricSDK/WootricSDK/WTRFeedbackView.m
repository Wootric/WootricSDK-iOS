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
#import "WTRFeedbackView.h"
#import "WTRColor.h"
#import "WTRUtils.h"
#import "WTRSurveyViewController.h"
#import "SimpleConstraints.h"
#import "UIItems.h"
#import "WTRDriverPicklistCollectionViewCell.h"

@interface WTRFeedbackView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *editScoreButton;
@property (nonatomic, strong) UILabel *followupLabel;
@property (nonatomic, strong) UILabel *feedbackPlaceholder;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) UICollectionView *driverPicklistCollectionView;
@property (nonatomic, strong) NSArray *driverPicklist;
@property (nonatomic, strong) NSMutableArray *driverPicklistKeys;
@property (nonatomic, strong) NSMutableArray *driverPicklistAnswers;
@property (nonatomic, strong) WTRSettings *settings;
@property BOOL multiselect;

@end

@implementation WTRFeedbackView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    _settings = settings;
    _driverPicklistKeys = [[NSMutableArray alloc] initWithCapacity:5];
    _driverPicklistAnswers = [[NSMutableArray alloc] initWithCapacity:5];
    self.hidden = YES;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
  [self setupEditScoreButtonWithViewController:viewController];
  [self setupFeedbackTextViewWithViewController:(WTRSurveyViewController *)viewController];
  [self setupDriverPicklistView];
  [self setupFollowupLabel];
  [self setupFeedbackLabel];
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  [self setupEditScoreButtonConstraints];
  [self setupFollowupLabelConstraints];
  [self setupDriverPicklistViewConstraints];
  [self setupFeedbackTextViewConstraints];
  [self setupFeedbackLabelConstraints];
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
  } else {
    _feedbackTextView.hidden = false;
    _feedbackPlaceholder.hidden = false;
  }
  if (driverPicklistSettings[@"dpl_multi_select"]) {
    _multiselect = [driverPicklistSettings[@"dpl_multi_select"] boolValue];
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
  if ([self feedbackTextPresent]) {
    return _feedbackTextView.text;
  }
  return @"";
}

- (void)clearFeedbackText {
  _feedbackTextView.text = @"";
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

- (void)setupEditScoreButtonWithViewController:(UIViewController *)viewController {
  _editScoreButton = [[UIButton alloc] init];
  _editScoreButton.titleLabel.font = [UIItems boldFontWithSize:12];
  [_editScoreButton setTitle:[_settings editScoreButtonText].uppercaseString forState:UIControlStateNormal];
  [_editScoreButton setTitleColor:[_settings sliderColor] forState:UIControlStateNormal];
  [_editScoreButton addTarget:viewController
                       action:NSSelectorFromString(@"editScoreButtonPressed:")
             forControlEvents:UIControlEventTouchUpInside];
  [_editScoreButton setTranslatesAutoresizingMaskIntoConstraints:NO];
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
  _feedbackTextView = [UIItems feedbackTextViewWithBackgroundColor:[UIColor whiteColor]];
  _feedbackTextView.delegate = viewController;
}

- (void)setupFeedbackLabel {
  _feedbackPlaceholder = [UIItems feedbackPlaceholder];
}

- (void)setupFollowupLabel {
  _followupLabel = [UIItems followupLabelWithTextColor:[UIColor blackColor]];
}

- (void)addSubviews {
  [self addSubview:_editScoreButton];
  [self addSubview:_driverPicklistCollectionView];
  [self addSubview:_feedbackTextView];
  [self addSubview:_followupLabel];
  [self addSubview:_feedbackPlaceholder];
}

- (void)setupEditScoreButtonConstraints {
  [[[_editScoreButton wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_editScoreButton wtr_topConstraint] toSecondViewTop:self] withConstant:16] addToView:self];
}

- (void)setupFollowupLabelConstraints {
  [[[_followupLabel wtr_centerXConstraint] toSecondViewCenterX:self] addToView:self];
  [[[[_followupLabel wtr_topConstraint] toSecondViewTop:self] withConstant:50] addToView:self];
  [[[[_followupLabel wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_followupLabel wtr_rightConstraint] toSecondViewRight:self] withConstant:-16] addToView:self];
}

- (void)setupDriverPicklistViewConstraints {
  [[[[_driverPicklistCollectionView wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_driverPicklistCollectionView wtr_rightConstraint] toSecondViewRight:self] withConstant:-16] addToView:self];
  [[[[_driverPicklistCollectionView wtr_topConstraint] toSecondViewBottom:_followupLabel] withConstant:10] addToView:self];
  [[[[_driverPicklistCollectionView wtr_bottomConstraint] toSecondViewTop:_feedbackTextView] withConstant:10] addToView:self];
}

- (void)setupFeedbackTextViewConstraints {
  [_feedbackTextView wtr_constraintHeight:138.0f];
  [[[[_feedbackTextView wtr_leftConstraint] toSecondViewLeft:self] withConstant:16] addToView:self];
  [[[[_feedbackTextView wtr_rightConstraint] toSecondViewRight:self] withConstant:-16] addToView:self];
  [[[[_feedbackTextView wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-14] addToView:self];
}

- (void)setupFeedbackLabelConstraints {
  [[[[_feedbackPlaceholder wtr_leftConstraint] toSecondViewLeft:_feedbackTextView] withConstant:20] addToView:self];
  [[[[_feedbackPlaceholder wtr_rightConstraint] toSecondViewRight:_feedbackTextView] withConstant:-20] addToView:self];
  [[[[_feedbackPlaceholder wtr_topConstraint] toSecondViewTop:_feedbackTextView] withConstant:17] addToView:self];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  WTRDriverPicklistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"driverPicklistIdentifier" forIndexPath:indexPath];
  [cell setBackgroundColor:_settings.sliderColor];
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
      answers[[self keyForObject:cell.titleLabel.text]] = cell.titleLabel.text;
    }
  }
  return answers;
}

- (NSString *)keyForObject:(NSString *)object {
  return [_driverPicklistKeys objectAtIndex:[_driverPicklistAnswers indexOfObject:object]];
}

@end

//
//  SurveyViewController.h
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

#import <UIKit/UIKit.h>

@interface SurveyViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) NSLayoutConstraint *constTopToModal;
@property (nonatomic, strong) NSLayoutConstraint *constModalHeight;
@property (nonatomic, strong) UIImage *imageToBlur;
@property (nonatomic, strong) UIImage *blurredImage;
@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UISlider *scoreSlider;
@property (nonatomic, strong) UIButton *voteButton;
@property (nonatomic, strong) UIButton *sendFeedbackButton;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *tintColorPink;
@property (nonatomic, strong) UIColor *tintColorGreen;
@property (nonatomic, strong) NSString *wootricQuestion;
@property (nonatomic, strong) NSString *defaultWootricQuestion;
@property (nonatomic, strong) NSString *defaultPlaceholderText;
@property (nonatomic, strong) NSString *defaultResponseQuestion;
@property (nonatomic, strong) NSString *detractorQuestion;
@property (nonatomic, strong) NSString *passiveQuestion;
@property (nonatomic, strong) NSString *promoterQuestion;
@property (nonatomic, strong) NSString *detractorPlaceholder;
@property (nonatomic, strong) NSString *passivePlaceholder;
@property (nonatomic, strong) NSString *promoterPlaceholder;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *heartImageView;
@property (nonatomic, strong) UIImageView *dismissImageView;
@property (nonatomic, strong) UIImageView *sliderBackgroundView;
@property (nonatomic, strong) UIImageView *sliderCheckedBackgroundView;
@property (nonatomic, strong) UIImageView *buttonIconCheck;
@property (nonatomic, strong) UIImageView *buttonIconSend;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *askForFeedbackLabel;
@property (nonatomic, strong) UILabel *dragToChangeLabel;
@property (nonatomic, strong) UILabel *poweredByWootricLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *notLikelyLabel;
@property (nonatomic, strong) UILabel *extremelyLikelyLabel;
@property (nonatomic, strong) UILabel *scorePopoverLabel;
- (BOOL)isSmallerScreenDevice;

@end

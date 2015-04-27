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

@property (nonatomic) NSLayoutConstraint *constTopToModal;
@property (nonatomic) NSLayoutConstraint *sliderWidth;
@property (nonatomic) NSLayoutConstraint *constModalHeight;
@property (nonatomic) UIImage *imageToBlur;
@property (nonatomic) UIImage *blurredImage;
@property (nonatomic) UIView *modalView;
@property (nonatomic) UISlider *scoreSlider;
@property (nonatomic) UIButton *voteButton;
@property (nonatomic) UIButton *sendFeedbackButton;
@property (nonatomic) UIButton *dismissButton;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *wootricLink;
@property (nonatomic) UITextView *commentTextView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIColor *tintColorPink;
@property (nonatomic) UIColor *tintColorGreen;
@property (nonatomic) NSString *customQuestion;
@property (nonatomic) NSString *customPlaceholder;
@property (nonatomic) NSString *wootricRecommendTo;
@property (nonatomic) NSString *wootricRecommendProduct;
@property (nonatomic) NSString *defaultWootricQuestion;
@property (nonatomic) NSString *defaultPlaceholderText;
@property (nonatomic) NSString *defaultResponseQuestion;
@property (nonatomic) NSString *detractorQuestion;
@property (nonatomic) NSString *passiveQuestion;
@property (nonatomic) NSString *promoterQuestion;
@property (nonatomic) NSString *detractorPlaceholder;
@property (nonatomic) NSString *passivePlaceholder;
@property (nonatomic) NSString *promoterPlaceholder;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *heartImageView;
@property (nonatomic) UIImageView *dismissImageView;
@property (nonatomic) UIImageView *buttonIconCheck;
@property (nonatomic) UIImageView *buttonIconSend;
@property (nonatomic) UILabel *sliderBackgroundView;
@property (nonatomic) UILabel *sliderCheckedBackgroundView;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *askForFeedbackLabel;
@property (nonatomic) UILabel *dragToChangeLabel;
@property (nonatomic) UILabel *poweredByWootricLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *notLikelyLabel;
@property (nonatomic) UILabel *extremelyLikelyLabel;
@property (nonatomic) UILabel *scorePopoverLabel;

@end

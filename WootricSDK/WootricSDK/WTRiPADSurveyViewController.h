//
//  WTRiPADSurveyViewController.h
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

#import <UIKit/UIKit.h>
#import "WTRSettings.h"
#import "WTRiPADModalView.h"
#import "WTRiPADQuestionView.h"
#import "WTRiPADFeedbackView.h"
#import "WTRiPADSocialShareView.h"

@interface WTRiPADSurveyViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) WTRSettings *settings;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *poweredByWootric;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) WTRiPADModalView *modalView;
@property (nonatomic, strong) WTRiPADQuestionView *questionView;
@property (nonatomic, strong) WTRiPADFeedbackView *feedbackView;
@property (nonatomic, strong) WTRiPADSocialShareView *socialShareView;
@property (nonatomic, strong) NSLayoutConstraint *constraintTopToModalTop;
@property (nonatomic, strong) NSLayoutConstraint *constraintQuestionTopToModalTop;
@property (nonatomic, strong) NSLayoutConstraint *constraintModalHeight;
@property (nonatomic, strong) NSLayoutConstraint *socialShareViewHeightConstraint;
@property (nonatomic, strong) UILabel *finalThankYouLabel;

- (instancetype)initWithSurveySettings:(WTRSettings *)settings;

@end

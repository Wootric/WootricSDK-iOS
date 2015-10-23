//
//  WTRiPADSurveyViewController+Views.m
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

#import "WTRiPADSurveyViewController+Views.h"
#import "WTRColor.h"

@implementation WTRiPADSurveyViewController (Views)

- (void)setupViews {
  [self setupModalView];
  [self setupScrollView];
  [self setupNPSQuestionView];
  [self setupFeedbackView];
  [self setupDismissButton];
  [self setupPoweredByWootric];

  [self addViewsToModal];
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.modalView];
}

- (void)addViewsToModal {
  [self.modalView addSubview:self.npsQuestionView];
  [self.modalView addSubview:self.feedbackView];
  [self.modalView addSubview:self.poweredByWootric];
  [self.modalView addSubview:self.dismissButton];
}

- (void)setupNPSQuestionView {
  self.npsQuestionView = [[WTRiPADNPSQuestionView alloc] initWithSettings:self.settings];
  [self.npsQuestionView initializeSubviewsWithTargetViewController:self];
}

- (void)setupFeedbackView {
  self.feedbackView = [[WTRiPADFeedbackView alloc] initWithSettings:self.settings];
  [self.feedbackView initializeSubviewsWithTargetViewController:self];
}

- (void)setupDismissButton {
  self.dismissButton = [[UIButton alloc] init];
  self.dismissButton.layer.cornerRadius = 15;
  self.dismissButton.layer.borderWidth = 1;
  self.dismissButton.layer.borderColor = [WTRColor iPadCircleButtonBorderColor].CGColor;
  self.dismissButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [self.dismissButton setTitle:@"\u00D7" forState:UIControlStateNormal];
  [self.dismissButton setTitleColor:[WTRColor iPadCircleButtonTextColor] forState:UIControlStateNormal];
  [self.dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.dismissButton addTarget:self action:NSSelectorFromString(@"dismissButtonPressed") forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPoweredByWootric {
  self.poweredByWootric = [[UIButton alloc] init];
  [self.poweredByWootric setTranslatesAutoresizingMaskIntoConstraints:NO];
  NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Powered by Wootric"]];
  [attrStr addAttribute:NSForegroundColorAttributeName value:[WTRColor poweredByColor] range:NSMakeRange(0, 10)];
  [attrStr addAttribute:NSForegroundColorAttributeName value:[WTRColor iPadPoweredByWootricTextColor] range:NSMakeRange(11, 7)];
  [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 18)];
  [self.poweredByWootric setAttributedTitle:attrStr forState:UIControlStateNormal];
  [self.poweredByWootric addTarget:self
                            action:NSSelectorFromString(@"openWootricHomepage:")
                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupModalView {
  self.modalView = [[WTRiPADModalView alloc] init];
}

- (void)setupScrollView {
  self.scrollView = [[UIScrollView alloc] init];
  [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

@end

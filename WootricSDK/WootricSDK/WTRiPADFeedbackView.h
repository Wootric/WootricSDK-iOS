//
//  WTRiPADFeedbackView.h
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
// OUT OF OR IN CONNE

#import <UIKit/UIKit.h>
#import "WTRSettings.h"

@interface WTRiPADFeedbackView : UIView

- (instancetype)initWithSettings:(WTRSettings *)settings;
- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController;
- (void)setupSubviewsConstraints;
- (void)setFollowupLabelTextBasedOnScore:(int)score;
- (void)setDriverPicklistBasedOnScore:(int)score;
- (void)textViewResignFirstResponder;
- (void)showFeedbackPlaceholder:(BOOL)flag;
- (void)setFeedbackPlaceholderText:(NSString *)text;
- (NSString *)feedbackText;
- (BOOL)feedbackTextPresent;
- (BOOL)isActive;
- (NSDictionary *)getDriverPicklistSelectedAnswers;
- (CGFloat)followupLabelHeight;
- (int)driverPicklistHeight;

@end

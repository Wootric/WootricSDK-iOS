//
//  UIView+UIView_Constraints.h
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

@interface UIView (Constraints)

- (NSLayoutConstraint *)wtr_topConstraint;
- (NSLayoutConstraint *)wtr_bottomConstraint;
- (NSLayoutConstraint *)wtr_leftConstraint;
- (NSLayoutConstraint *)wtr_rightConstraint;
- (NSLayoutConstraint *)wtr_centerXConstraint;
- (NSLayoutConstraint *)wtr_centerYConstraint;
- (void)wtr_constraintHeight:(CGFloat)height;
- (void)wtr_constraintWidth:(CGFloat)width;
- (void)wtr_constraintHeightEqualSecondViewHeight:(UIView *)secondView;
- (void)wtr_constraintWidthEqualSecondViewWidth:(UIView *)secondView;
- (void)wtr_constraintHeightToSecondViewHeight:(UIView *)secondView withConstant:(CGFloat)constant;
- (void)wtr_constraintWidthToSecondViewWidth:(UIView *)secondView withConstant:(CGFloat)constant;

@end

//
//  UIItems.m
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

#import "UIItems.h"
#import "WTRColor.h"

@implementation UIItems

+ (UILabel *)likelyAnchorWithSettings:(WTRSettings *)settings andFont:(UIFont *)font {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textColor = [WTRColor anchorAndScoreColor];
  tempLabel.text = [settings likelyAnchorText];
  tempLabel.font = font;
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UILabel *)notLikelyAnchorWithSettings:(WTRSettings *)settings andFont:(UIFont *)font {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textColor = [WTRColor anchorAndScoreColor];
  tempLabel.text = [settings notLikelyAnchorText];
  tempLabel.font = font;
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UILabel *)followupLabelWithTextColor:(UIColor *)textColor {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.font = [UIFont boldSystemFontOfSize:16];
  tempLabel.numberOfLines = 0;
  tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
  tempLabel.textAlignment = NSTextAlignmentCenter;
  tempLabel.textColor = textColor;
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UILabel *)feedbackPlaceholder {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textColor = [WTRColor textAreaTextColor];
  tempLabel.font = [UIFont systemFontOfSize:16];
  tempLabel.numberOfLines = 0;
  tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UITextView *)feedbackTextViewWithBackgroundColor:(UIColor *)backgroundColor {
  UITextView *tempTextView = [[UITextView alloc] init];
  tempTextView.backgroundColor = backgroundColor;
  tempTextView.font = [UIFont systemFontOfSize:16];
  tempTextView.textColor = [WTRColor textAreaTextColor];
  tempTextView.layer.borderColor = [WTRColor textAreaBorderColor].CGColor;
  tempTextView.layer.borderWidth = 1;
  tempTextView.layer.cornerRadius = 3;
  tempTextView.textContainerInset = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
  tempTextView.tintColor = [WTRColor textAreaCursorColor];
  [tempTextView setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempTextView;
}

+ (UILabel *)npsQuestionLabelWithSettings:(WTRSettings *)settings andFont:(UIFont *)font {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textAlignment = NSTextAlignmentCenter;
  tempLabel.textColor = [UIColor blackColor];
  tempLabel.numberOfLines = 0;
  tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
  tempLabel.font = font;
  tempLabel.text = [settings npsQuestionText];
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

@end

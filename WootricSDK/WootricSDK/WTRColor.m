//
//  WTRColor.m
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

#import "WTRColor.h"

@implementation WTRColor

+ (UIColor *)viewBackgroundColor {
  return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
}

+ (UIColor *)dismissXColor {
  return [self colorWithHexString:@"#C8C8C8"];
}

+ (UIColor *)sliderModalBorderColor {
  return [self colorWithHexString:@"EBEBEB"];
}

+ (UIColor *)grayGradientTopColor {
  return [self colorWithHexString:@"#FDFDFD"];
}

+ (UIColor *)grayGradientBottomColor {
  return [self colorWithHexString:@"#F7F7F7"];
}

+ (UIColor *)sliderBackgroundColor {
  return [self colorWithHexString:@"#EFEFEF"];
}

+ (UIColor *)sliderDotBorderColor {
  return [self colorWithHexString:@"#E6E6E6"];
}

+ (UIColor *)anchorAndScoreColor {
  return [self colorWithHexString:@"#C8C8C8"];
}

+ (UIColor *)sendButtonDisabledBackgroundColor {
  return [[self colorWithHexString:@"#D43B69"] colorWithAlphaComponent:0.4f];
}

+ (UIColor *)sendButtonBackgroundColor {
  return [self colorWithHexString:@"#D43B69"];
}

+ (UIColor *)poweredByColor {
  return [self colorWithHexString:@"#AFAFAF"];
}

+ (UIColor *)wootricTextColor {
  return [self colorWithHexString:@"4A4A4A"];
}

+ (UIColor *)sliderValueColor {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)sliderDotSelectedColor {
  return [self colorWithHexString:@"#105DA0"];
}

+ (UIColor *)selectedValueDotColor {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)selectedValueScoreColor {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)socialShareQuestionTextColor {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)facebookLogoTextColor {
  return [self colorWithHexString:@"#3b5998"];
}

+ (UIColor *)twitterLogoTextColor {
  return [self colorWithHexString:@"#00aced"];
}

+ (UIColor *)selectedValueUnderlineColor {
  return [self colorWithHexString:@"#D43B69"];
}

+ (UIColor *)editScoreTextColor {
  return [self colorWithHexString:@"#437FC5"];
}

+ (UIColor *)textAreaBorderColor {
  return [self colorWithHexString:@"#DEDEDE"];
}

+ (UIColor *)textAreaTextColor {
  return [self colorWithHexString:@"#7F7F7F"];
}

+ (UIColor *)textAreaCursorColor {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)callToActionButtonBackgroundColor {
  return [self colorWithHexString:@"#18BB71"];
}

+ (UIColor *)callToActionButtonBorderColor {
  return [self colorWithHexString:@"#13AF68"];
}

+ (UIColor *)iPadCircleButtonBorderColor {
  return [self colorWithHexString:@"#CBCBCB"];
}

+ (UIColor *)iPadCircleButtonTextColor {
  return [self colorWithHexString:@"#737373"];
}

+ (UIColor *)iPadCircleButtonSelectedBackgroundColor {
  return [self colorWithHexString:@"#2D91D7"];
}

+ (UIColor *)iPadCircleButtonSelectedBorderColor {
  return [self colorWithHexString:@"#2475AE"];
}

+ (UIColor *)iPadPoweredByWootricTextColor {
  return [self colorWithHexString:@"#82BED3"];
}

+ (UIColor *)iPadQuestionsTextColor {
  return [self colorWithHexString:@"#7DA52D"];
}

+ (UIColor *)iPadFeedbackTextViewBackgroundColor {
  return [self colorWithHexString:@"#FAFAFA"];
}

+ (UIColor *)iPadSendButtonBackgroundColor {
  return [self colorWithHexString:@"#808080"];
}

+ (UIColor *)iPadThankYouButtonBorderColor {
  return [self colorWithHexString:@"#97C7E8"];
}

+ (UIColor *)iPadThankYouButtonTextColor {
  return [self colorWithHexString:@"#3492D5"];
}

+ (UIColor *)iPadNoThanksButtonBorderColor {
  return [self colorWithHexString:@"#E6E6E6"];
}

+ (UIColor *)iPadNoThanksButtonTextColor {
  return [self colorWithHexString:@"#888888"];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
  NSString *noHashString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
  NSScanner *scanner = [NSScanner scannerWithString:noHashString];
  [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]];

  unsigned hex;
  if (![scanner scanHexInt:&hex]) return nil;
  int r = (hex >> 16) & 0xFF;
  int g = (hex >> 8) & 0xFF;
  int b = (hex) & 0xFF;

  return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

@end

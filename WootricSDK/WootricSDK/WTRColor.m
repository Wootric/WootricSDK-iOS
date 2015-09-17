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

+ (UIColor *)viewBackground {
  return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
}

+ (UIColor *)dismissX {
  return [self colorWithHexString:@"#C8C8C8"];
}

+ (UIColor *)sliderModalBorder {
  return [self colorWithHexString:@"EBEBEB"];
}

+ (UIColor *)grayGradientTop {
  return [self colorWithHexString:@"#FDFDFD"];
}

+ (UIColor *)grayGradientBottom {
  return [self colorWithHexString:@"#F7F7F7"];
}

+ (UIColor *)sliderBackground {
  return [self colorWithHexString:@"#EFEFEF"];
}

+ (UIColor *)sliderDotBorder {
  return [self colorWithHexString:@"#E6E6E6"];
}

+ (UIColor *)anchorAndScore {
  return [self colorWithHexString:@"#C8C8C8"];
}

+ (UIColor *)sendButtonDisabledBackground {
  return [[self colorWithHexString:@"#D43B69"] colorWithAlphaComponent:0.4f];
}

+ (UIColor *)sendButtonBackground {
  return [self colorWithHexString:@"#D43B69"];
}

+ (UIColor *)poweredBy {
  return [self colorWithHexString:@"#AFAFAF"];
}

+ (UIColor *)wootricText {
  return [self colorWithHexString:@"4A4A4A"];
}

+ (UIColor *)sliderValue {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)sliderDotSelected {
  return [self colorWithHexString:@"#105DA0"];
}

+ (UIColor *)selectedValueDot {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)selectedValueScore {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)selectedValueUnderline {
  return [self colorWithHexString:@"#D43B69"];
}

+ (UIColor *)editScoreText {
  return [self colorWithHexString:@"#437FC5"];
}

+ (UIColor *)textAreaBorder {
  return [self colorWithHexString:@"#DEDEDE"];
}

+ (UIColor *)textAreaText {
  return [self colorWithHexString:@"#7F7F7F"];
}

+ (UIColor *)textAreaCursor {
  return [self colorWithHexString:@"#3081C2"];
}

+ (UIColor *)callToActionButtonBackground {
  return [self colorWithHexString:@"#18BB71"];
}

+ (UIColor *)callToActionButtonBorder {
  return [self colorWithHexString:@"#13AF68"];
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

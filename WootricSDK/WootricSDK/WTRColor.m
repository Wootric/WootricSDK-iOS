//
//  WTRColor.m
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

#import "WTRColor.h"


static NSString *const WTRDismissColor = @"#C8C8C8";
static NSString *const WTRSliderModalBorderColor = @"#EBEBEB";
static NSString *const WTRSliderBackgroundColor = @"#EFEFEF";
static NSString *const WTRSliderDotBorderColor = @"#E6E6E6";
static NSString *const WTRGrayGradientTopColor = @"#FDFDFD";
static NSString *const WTRGrayGradientBottomColor = @"#F7F7F7";
static NSString *const WTRSocialShareTextColor = @"#3081C2";
static NSString *const WTRSocialLogoTextColor = @"#105DA0";
static NSString *const WTRTextAreaTextColor = @"#000000";
static NSString *const WTRTextAreaPlaceholderColor = @"#66737E";
static NSString *const WTRCircleButtonBorderColor = @"#CBCBCB";
static NSString *const WTRCircleButtonSelectedColor = @"#B3CDFF";
static NSString *const WTRTextViewBackgroundColor = @"#FAFAFA";

static NSString *const WTROrcaColor = @"#253746";
static NSString *const WTROrcaL2Color = @"#66737E";
static NSString *const WTRBlueColor = @"#0058FF";
static NSString *const WTRAdminBlueColor = @"#B3CDFF";

static NSString *const WTRScoreScaleFilledType = @"filled";

@implementation WTRColor

+ (UIColor *)viewBackgroundColor {
  return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
}

+ (UIColor *)dismissXColor {
  return [self colorWithHexString:WTRDismissColor];
}

+ (UIColor *)sliderModalBorderColor {
  return [self colorWithHexString:WTRSliderModalBorderColor];
}

+ (UIColor *)grayGradientTopColor {
  return [self colorWithHexString:WTRGrayGradientTopColor];
}

+ (UIColor *)grayGradientBottomColor {
  return [self colorWithHexString:WTRGrayGradientBottomColor];
}

+ (UIColor *)sliderBackgroundColor {
  return [self colorWithHexString:WTRSliderBackgroundColor];
}

+ (UIColor *)sliderDotBorderColor {
  return [self colorWithHexString:WTRSliderDotBorderColor];
}

+ (UIColor *)anchorAndScoreColor {
  return [self colorWithHexString:WTROrcaL2Color];
}

+ (UIColor *)sendButtonDisabledBackgroundColor {
  return [[self colorWithHexString:WTRBlueColor] colorWithAlphaComponent:0.4f];
}

+ (UIColor *)sendButtonBackgroundColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)sendButtonTextColorForColor:(UIColor *)color {
  if (color) {
    return [self fontColorForColor:color];
  }
  return [UIColor whiteColor];
}

+ (UIColor *)poweredByColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)optOutTextColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)wootricTextColorForColor:(UIColor *)color {
  if (color) {
    return [self fontColorForColor:color];
  }
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)sliderValueColor {
  return [self colorWithHexString:WTRAdminBlueColor];
}

+ (UIColor *)sliderDotSelectedColor {
  return [self colorWithHexString:WTRAdminBlueColor];
}

+ (UIColor *)selectedValueDotColor {
  return [self colorWithHexString:WTRAdminBlueColor];
}

+ (UIColor *)selectedValueScoreColor {
  return [self colorWithHexString:WTRAdminBlueColor];
}

+ (UIColor *)socialShareQuestionTextColor {
  return [self colorWithHexString:WTRSocialShareTextColor];
}

+ (UIColor *)noThanksButtonTextColor {
  return [self colorWithHexString:WTRSocialShareTextColor];
}

+ (UIColor *)facebookLogoTextColor {
  return [self colorWithHexString:WTRSocialLogoTextColor];
}

+ (UIColor *)twitterLogoTextColor {
  return [self colorWithHexString:WTRSocialLogoTextColor];
}

+ (UIColor *)selectedValueUnderlineColor {
  return [self colorWithHexString:WTRBlueColor];
}

+ (UIColor *)editScoreTextColor {
  return [self colorWithHexString:WTRBlueColor];
}

+ (UIColor *)textAreaBorderColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)textAreaTextColor {
  return [self colorWithHexString:WTRTextAreaTextColor];
}

+ (UIColor *)textAreaPlaceholderColor {
  return [self colorWithHexString:WTRTextAreaPlaceholderColor];
}

+ (UIColor *)textAreaCursorColor {
  return [self colorWithHexString:WTRSocialShareTextColor];
}

+ (UIColor *)callToActionButtonBackgroundColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)iPadCircleButtonBorderColor {
  return [self colorWithHexString:WTRCircleButtonBorderColor];
}

+ (UIColor *)iPadCircleButtonTextColorForColor:(UIColor *)color scoreScaleType:(NSString *)scoreScaleType state:(BOOL)isSelected {
  if (isSelected || [scoreScaleType isEqualToString:WTRScoreScaleFilledType]) {
    if (color) {
      return [self fontColorForColor:color];
    } else {
      return [self fontColorForColor:[self colorWithHexString:WTROrcaColor]];
    }
  }
  return [UIColor blackColor];
}

+ (UIColor *)iPadCircleButtonTextColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)iPadCircleButtonSelectedBackgroundColor {
  return [self colorWithHexString:WTRCircleButtonSelectedColor];
}

+ (UIColor *)iPadCircleButtonSelectedBorderColor {
  return [self colorWithHexString:WTRCircleButtonSelectedColor];
}

+ (UIColor *)iPadPoweredByWootricTextColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)iPadQuestionsTextColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)iPadFeedbackTextViewBackgroundColor {
  return [self colorWithHexString:WTRTextViewBackgroundColor];
}

+ (UIColor *)iPadSendButtonBackgroundColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)iPadThankYouButtonBorderColor {
  return [self colorWithHexString:WTRBlueColor];
}

+ (UIColor *)iPadThankYouButtonTextColorForColor:(UIColor *)color {
  if (color) {
    return [self fontColorForColor:color];
  }
  return [self colorWithHexString:WTRBlueColor];
}

+ (UIColor *)iPadNoThanksButtonBorderColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)iPadNoThanksButtonTextColor {
  return [self colorWithHexString:WTROrcaColor];
}

+ (UIColor *)lighterColor:(UIColor *)color byPercetage:(CGFloat)percentage {
  return [self adjustColor:color byPercentage:ABS(percentage)];
}

+ (UIColor *)darkerColor:(UIColor *)color byPercentage:(CGFloat)percentage {
  return [self adjustColor:color byPercentage:(-1 * ABS(percentage))];
}

+ (nullable UIColor *)adjustColor:(UIColor *)color byPercentage:(CGFloat)percentage {
  CGFloat red, green, blue, alpha;
  if ([color getRed:&red green:&green blue:&blue alpha:&alpha]) {
    return [UIColor colorWithRed:MIN(red + percentage/100.f, 1.0) green:MIN(green + percentage/100.f, 1.0) blue:MIN(blue + percentage/100.f, 1.0) alpha:alpha];
  } else {
    return nil;
  }
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

+ (nullable UIColor *)fontColorForColor:(UIColor *)color {
  CGFloat red, green, blue, alpha;
  if ([color getRed:&red green:&green blue:&blue alpha:&alpha]) {
    CGFloat yiq = ((red * 255 * 299) + (green * 255 * 587) + (blue * 255 * 114)) / 1000;
    return yiq >= 128 ? [UIColor blackColor] : [UIColor whiteColor];
  } else {
    return nil;
  }
}

@end

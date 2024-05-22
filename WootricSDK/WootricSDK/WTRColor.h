//
//  WTRColor.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WTRColor : NSObject

+ (UIColor *)viewBackgroundColor;
+ (UIColor *)dismissXColor;
+ (UIColor *)sliderModalBorderColor;
+ (UIColor *)grayGradientTopColor;
+ (UIColor *)grayGradientBottomColor;
+ (UIColor *)sliderBackgroundColor;
+ (UIColor *)sliderDotBorderColor;
+ (UIColor *)anchorAndScoreColor;
+ (UIColor *)sendButtonBackgroundColor;
+ (UIColor *)sendButtonDisabledBackgroundColor;
+ (UIColor *)sendButtonTextColorForColor:(UIColor *)color;
+ (UIColor *)poweredByColor;
+ (UIColor *)optOutTextColor;
+ (UIColor *)wootricTextColorForColor:(UIColor *)color;
+ (UIColor *)sliderValueColor;
+ (UIColor *)sliderDotSelectedColor;
+ (UIColor *)selectedValueDotColor;
+ (UIColor *)selectedValueScoreColor;
+ (UIColor *)selectedValueUnderlineColor;
+ (UIColor *)editScoreTextColor;
+ (UIColor *)textAreaBorderColor;
+ (UIColor *)textAreaTextColor;
+ (UIColor *)textAreaPlaceholderColor;
+ (UIColor *)textAreaCursorColor;
+ (UIColor *)callToActionButtonBackgroundColor;
+ (UIColor *)socialShareQuestionTextColor;
+ (UIColor *)noThanksButtonTextColor;
+ (UIColor *)facebookLogoTextColor;
+ (UIColor *)twitterLogoTextColor;

+ (UIColor *)iPadCircleButtonBorderColor;
+ (UIColor *)iPadCircleButtonTextColorForColor:(UIColor *)color scoreScaleType:(NSString *)scoreScaleType state:(BOOL)isSelected;
+ (UIColor *)iPadCircleButtonSelectedBackgroundColor;
+ (UIColor *)iPadCircleButtonSelectedBorderColor;
+ (UIColor *)iPadPoweredByWootricTextColor;
+ (UIColor *)iPadQuestionsTextColor;
+ (UIColor *)iPadFeedbackTextViewBackgroundColor;
+ (UIColor *)iPadSendButtonBackgroundColor;
+ (UIColor *)iPadThankYouButtonBorderColor;
+ (UIColor *)iPadThankYouButtonTextColorForColor:(UIColor *)color;
+ (UIColor *)iPadNoThanksButtonBorderColor;
+ (UIColor *)iPadNoThanksButtonTextColor;

+ (UIColor *)lighterColor:(UIColor *)color byPercetage:(CGFloat)percentage;
+ (UIColor *)darkerColor:(UIColor *)color byPercentage:(CGFloat)percentage;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

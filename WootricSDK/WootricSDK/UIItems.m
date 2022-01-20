//
//  UIItems.m
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

#import "UIItems.h"
#import "WTRColor.h"
#import "NSString+FontAwesome.h"
#import <CoreText/CTFontManager.h>

@implementation UIItems

+ (void)dynamicallyAddFont {
  NSArray *fonts = @[@"fontawesome-webfont", @"IBMPlexSans-Italic", @"IBMPlexSans-Bold", @"IBMPlexSans-Medium", @"IBMPlexSans-Regular"];

  for (NSString *font in fonts) {
    NSString *fontPath = [SWIFTPM_MODULE_BUNDLE pathForResource:font ofType:@"ttf"];

    CFErrorRef error;
    NSURL *url = [NSURL fileURLWithPath:fontPath isDirectory:NO];
    if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error)) {
      if (CFErrorGetCode(error) == kCTFontManagerErrorAlreadyRegistered) {
        CFRelease(error);
        return;
      }
      CFStringRef errorDescription = CFErrorCopyDescription(error);
      NSLog(@"WootricSDK: Failed to load font: %@", errorDescription);
      CFRelease(errorDescription);
      CFRelease(error);
    }
  }
}

+ (UIFont *)regularFontWithSize:(CGFloat)fontSize {
  return [UIFont fontWithName:@"IBMPlexSans" size:fontSize];
}

+ (UIFont *)boldFontWithSize:(CGFloat)fontSize {
  return [UIFont fontWithName:@"IBMPlexSans-Bold" size:fontSize];
}

+ (UIFont *)mediumFontWithSize:(CGFloat)fontSize {
  return [UIFont fontWithName:@"IBMPlexSans-Medium" size:fontSize];
}

+ (UIFont *)italicFontWithSize:(CGFloat)fontSize {
  return [UIFont fontWithName:@"IBMPlexSans-Italic" size:fontSize];
}

+ (UILabel *)likelyAnchorWithSettings:(WTRSettings *)settings font:(UIFont *)font {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textColor = [WTRColor anchorAndScoreColor];
  tempLabel.text = [settings likelyAnchorText];
  tempLabel.font = font;
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UILabel *)notLikelyAnchorWithSettings:(WTRSettings *)settings font:(UIFont *)font {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textColor = [WTRColor anchorAndScoreColor];
  tempLabel.text = [settings notLikelyAnchorText];
  tempLabel.font = font;
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UILabel *)followupLabelWithTextColor:(UIColor *)textColor {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.font = [self boldFontWithSize:16];
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
  tempLabel.font = [self regularFontWithSize:16];
  tempLabel.numberOfLines = 0;
  tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UITextView *)feedbackTextViewWithBackgroundColor:(UIColor *)backgroundColor {
  UITextView *tempTextView = [[UITextView alloc] init];
  tempTextView.backgroundColor = backgroundColor;
  tempTextView.font = [self regularFontWithSize:16];
  tempTextView.textColor = [WTRColor textAreaTextColor];
  tempTextView.layer.borderColor = [WTRColor textAreaBorderColor].CGColor;
  tempTextView.layer.borderWidth = 1;
  tempTextView.layer.cornerRadius = 3;
  tempTextView.textContainerInset = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
  tempTextView.tintColor = [WTRColor textAreaCursorColor];
  [tempTextView setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempTextView;
}

+ (UILabel *)questionLabelWithSettings:(WTRSettings *)settings font:(UIFont *)font {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textAlignment = NSTextAlignmentCenter;
  tempLabel.textColor = [UIColor blackColor];
  tempLabel.numberOfLines = 0;
  tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
  tempLabel.font = font;
  tempLabel.text = [settings questionText];
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UILabel *)thankYouMainLabelWithSettings:(WTRSettings *)settings textColor:(UIColor *)textColor font:(UIFont *)font {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textAlignment = NSTextAlignmentCenter;
  tempLabel.textColor = textColor;
  tempLabel.numberOfLines = 0;
  tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
  tempLabel.font = font;
  tempLabel.text = [settings finalThankYouText];
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UILabel *)thankYouSetupLabelWithFont:(UIFont *)font {
  UILabel *tempLabel = [[UILabel alloc] init];
  tempLabel.textAlignment = NSTextAlignmentCenter;
  tempLabel.textColor = [UIColor blackColor];
  tempLabel.numberOfLines = 0;
  tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
  tempLabel.font = font;
  [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

  return tempLabel;
}

+ (UIButton *)socialButtonWithTargetViewController:(UIViewController *)viewController title:(NSString *)title textColor:(UIColor *)textColor {
  UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  tempButton.hidden = YES;
    
  [tempButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
  [tempButton setTitle:title forState:UIControlStateNormal];
  [tempButton setTitleColor:textColor forState:UIControlStateNormal];
  [tempButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tempButton addTarget:viewController
                 action:NSSelectorFromString(@"socialButtonPressedForService:")
       forControlEvents:UIControlEventTouchUpInside];
  
  return tempButton;
}

@end

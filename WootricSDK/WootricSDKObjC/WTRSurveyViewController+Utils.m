//
//  WTRSurveyViewController+Utils.m
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

#import "WTRSurveyViewController+Utils.h"

@implementation WTRSurveyViewController (Utils)

- (NSString *)localizedString:(NSString *)key {
  NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:self.settings.language ofType:@"lproj"];
  NSBundle *bundle = nil;

  if (path == nil) {
    bundle = [NSBundle bundleForClass:[self class]];
  } else {
    bundle = [NSBundle bundleWithPath:path];
  }

  return [bundle localizedStringForKey:key
                                 value:nil
                                 table:@"WootricLocalizable"];
}

- (BOOL)isSmallerScreenDevice {
  // 'nativeBounds' only available on iOS 8.0+.
  CGRect nativeBounds = CGRectZero;

  if ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]) {
    nativeBounds = [[UIScreen mainScreen] nativeBounds];
  } else {
    nativeBounds = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] scale];
    nativeBounds = CGRectMake(0.0, 0.0,
                              nativeBounds.size.width * scale, nativeBounds.size.height * scale);
  }

  // < iPhone 6 + iPhone 6 in "Zoomed Display"
  if (nativeBounds.size.height <= 1136 ||
      [UIScreen mainScreen].currentMode.size.height <= 1136) {
    return YES;
  }
  return NO;
}

// HAXX to return slider width before autolayout is solved.
// Method that requires this values could be called in viewDidLayoutSubviews,
// but viewDidLayoutSubviews is called twice at 'init' where first value of slider width is 100.0
// which is wrong, but I don't want to check for a magic number which may change.
- (float)sliderWidthBeforeAutolayout {
  return self.sliderWidth.constant;
}

- (float)sliderWidthDependingOnDevice {
  CGFloat sliderWidth = [self isSmallerScreenDevice] ? 290 : 345;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    sliderWidth = 517;
  }

  return sliderWidth;
}

@end

//
//  SurveyViewController+Utils.m
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

#import "SurveyViewController+Utils.h"

@implementation SurveyViewController (Utils)

- (NSString *)localizedString:(NSString *)key {
//  NSString *path = [[NSBundle mainBundle] pathForResource:@"pl" ofType:@"lproj"];
//  NSLog(@"%@", path);
//
//  NSString * path = [[NSBundle mainBundle] pathForResource:@"pt-PT" ofType:@"lproj"];
//  NSBundle * bundle = nil;
//  if(path == nil){
//    bundle = [NSBundle mainBundle];
//  }else{
//    bundle = [NSBundle bundleWithPath:path];
//  }
//  NSString * str = [bundle localizedStringForKey:@"a string" value:@"comment" table:nil];
  return [[NSBundle bundleForClass:[self class]] localizedStringForKey:key
                                                                 value:nil
                                                                 table:@"WootricLocalizable"];
}

- (BOOL)isSmallerScreenDevice {
  // < iPhone 6 + iPhone 6 in "Zoomed Display"
  if ([[UIScreen mainScreen] nativeBounds].size.height <= 1136 ||
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

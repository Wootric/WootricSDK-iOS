//
//  WTRiPADThankYouButton.m
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

#import "WTRiPADThankYouButton.h"
#import "WTRColor.h"
#import "UIItems.h"
#import <WootricSDK/WootricSDK-Swift.h>

@implementation WTRiPADThankYouButton

- (instancetype)initWithViewController:(UIViewController *)viewController {
  if (self = [super init]) {
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    [self configureContentInsetsWithTop:0 leading:10 bottom:0 trailing:10];
    self.layer.borderColor = [WTRColor iPadThankYouButtonBorderColor].CGColor;
    self.titleLabel.font = [UIItems regularFontWithSize:14];
    [self setTitleColor:[WTRColor iPadThankYouButtonTextColor] forState:UIControlStateNormal];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addTarget:viewController action:NSSelectorFromString(@"openThankYouURL:") forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)setText:(NSString *)text andURL:(NSURL *)url {
  _buttonURL = url;
  [self setTitle:text forState:UIControlStateNormal];
}

@end

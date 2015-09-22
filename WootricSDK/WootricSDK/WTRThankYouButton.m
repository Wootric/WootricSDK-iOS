//
//  WTRThankYouButton.m
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

#import "WTRThankYouButton.h"
#import "WTRColor.h"

@interface WTRThankYouButton ()

@property (nonatomic, strong) NSURL *buttonURL;

@end

@implementation WTRThankYouButton

- (instancetype)initWithText:(NSString *)text andURL:(NSURL *)url {
  if (self = [super init]) {
    _buttonURL = url;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.backgroundColor = [WTRColor callToActionButtonBackground];
    self.layer.borderColor = [WTRColor callToActionButtonBorder].CGColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setTitle:text forState:UIControlStateNormal];
    [self addTarget:self action:NSSelectorFromString(@"openURL") forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)openURL {
  if (![[UIApplication sharedApplication] openURL:_buttonURL]) {
    NSLog(@"Failed to open url");
  }
}

@end

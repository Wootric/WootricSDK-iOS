//
//  WTRiPADThankYouButton.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 28/10/15.
//  Copyright © 2015 Wootric. All rights reserved.
//

#import "WTRiPADThankYouButton.h"
#import "WTRColor.h"

@implementation WTRiPADThankYouButton

- (instancetype)initWithViewController:(UIViewController *)viewController {
  if (self = [super init]) {
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.layer.borderColor = [WTRColor iPadThankYouButtonBorderColor].CGColor;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
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

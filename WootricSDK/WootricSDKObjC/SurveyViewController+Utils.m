//
//  SurveyViewController+Utils.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 21/04/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import "SurveyViewController+Utils.h"

@implementation SurveyViewController (Utils)

- (NSString *)localizedString:(NSString *)key {
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

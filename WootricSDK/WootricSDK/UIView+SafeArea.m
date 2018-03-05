//
//  UIView+SafeArea.m
//  WootricSDK
//
//  Created by Jason Neel on 3/5/18.
//  Copyright © 2018 Wootric. All rights reserved.
//

#import "UIView+SafeArea.h"

@implementation UIView (SafeArea)

/**
 *  Returns the safe area layout guide if available, otherwise self
 */
- (id) layoutAreaItemForConstraints {
  if (@available(iOS 11.0, *)) {
    return self.safeAreaLayoutGuide;
  }
  
  return self;
}

@end

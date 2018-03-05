//
//  UIView+SafeArea.h
//  WootricSDK
//
//  Created by Jason Neel on 3/5/18.
//  Copyright © 2018 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SafeArea)

/**
 *  Returns the safe area layout guide if available, otherwise self
 */
- (id) layoutAreaItemForConstraints;

@end

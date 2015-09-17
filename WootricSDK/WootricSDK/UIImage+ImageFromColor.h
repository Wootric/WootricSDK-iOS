//
//  UIImage+ImageFromColor.h
//  WootricSDK
//
//  Created by Łukasz Cichecki on 11/09/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageFromColor)

+ (UIImage *)imageFromColor:(UIColor *)color withSize:(float)size;

@end

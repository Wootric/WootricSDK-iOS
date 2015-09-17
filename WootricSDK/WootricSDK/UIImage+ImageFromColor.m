//
//  UIImage+ImageFromColor.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 11/09/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import "UIImage+ImageFromColor.h"

@implementation UIImage (ImageFromColor)

+ (UIImage *)imageFromColor:(UIColor *)color withSize:(float)size {
  CGRect rect = CGRectMake(0, 0, size, size);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
  [[UIBezierPath bezierPathWithRoundedRect:rect
                              cornerRadius:(size / 2)] addClip];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

@end

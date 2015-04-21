//
//  SurveyViewController+Utils.h
//  WootricSDK
//
//  Created by Łukasz Cichecki on 21/04/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import "SurveyViewController.h"

@interface SurveyViewController (Utils)

- (BOOL)isSmallerScreenDevice;
- (NSString *)localizedString:(NSString *)key;
- (float)sliderWidthBeforeAutolayout;
- (float)sliderWidthDependingOnDevice;

@end

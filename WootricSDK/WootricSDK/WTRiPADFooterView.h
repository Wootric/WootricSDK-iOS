//
//  WTRiPADFooterView.h
//  WootricSDK
//
//  Created by Diego Serrano on 2/20/24.
//  Copyright © 2024 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRSettings.h"

@interface WTRiPADFooterView : UIView

@property (nonatomic, assign) WTRSettings * settings;

- (instancetype)initWithSettings:(WTRSettings *)settings;
- (void)setupSubviewsConstraints;
- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController;

@end

//
//  WTRFeedbackView.h
//  WootricSDK
//
//  Created by Łukasz Cichecki on 18/09/15.
//  Copyright © 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRSettings.h"

@interface WTRFeedbackView : UIView

- (instancetype)initWithSettings:(WTRSettings *)settings;
- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController;
- (void)setupSubviewsConstraints;
- (void)setYouChoseLabelTextBasedOnScore:(int)score;
- (void)textViewResignFirstResponder;
- (void)showFeedbackPlaceholder:(BOOL)flag;
- (void)setFeedbackPlaceholderText:(NSString *)text;

@end

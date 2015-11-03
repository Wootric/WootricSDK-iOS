//
//  WTRiPADThankYouButton.h
//  WootricSDK
//
//  Created by Łukasz Cichecki on 28/10/15.
//  Copyright © 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTRiPADThankYouButton : UIButton

@property (nonatomic, strong) NSURL *buttonURL;

- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)setText:(NSString *)text andURL:(NSURL *)url;

@end

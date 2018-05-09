//
//  WootricDelegate.h
//  WootricSDK
//
//  Created by Nikita Kolmogorov on 2018-05-09.
//  Copyright © 2018 Wootric. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WootricDelegate <NSObject>

- (void)willPresentSurvey;
- (void)didSelectScore:(NSInteger)score;

@end

//
//  WTREventListOperation.h
//  WootricSDK
//
//  Created by Diego Serrano on 3/23/20.
//  Copyright © 2020 Wootric. All rights reserved.
//

#import "WTROperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTREventListOperation : WTROperation

- (instancetype)initWithAccountToken:(NSString *)accountToken completion:(void (^)(NSArray *eventList))completion;

@end

NS_ASSUME_NONNULL_END

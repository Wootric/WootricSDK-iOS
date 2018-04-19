//
//  WTRLogger.h
//  WootricSDK
//
//  Created by Dev Team on 2/3/16.
//  Copyright © 2016 Wootric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTRLogLevel.h"

@interface WTRLogger : NSObject

+ (void)setLogLevel:(WTRLogLevel)level;
+ (WTRLogLevel)logLevel;

+ (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)log:(NSString *)format arguments:(va_list)argList NS_FORMAT_FUNCTION(1,0);

+ (void)logLevel:(WTRLogLevel)level format:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);
+ (void)logLevel:(WTRLogLevel)level format:(NSString *)format arguments:(va_list)argList NS_FORMAT_FUNCTION(2,0);

+ (void)logLevel:(WTRLogLevel)level message:(NSString *)message;

+ (void)logError:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)logError:(NSString *)format arguments:(va_list)argList NS_FORMAT_FUNCTION(1,0);

@end

//
//  WTRLogger.m
//  WootricSDK
//
//  Created by Dev Team on 2/3/16.
//  Copyright © 2016 Wootric. All rights reserved.
//

#import "WTRLogger.h"

@interface WTRLogger()

@property (nonatomic, assign) WTRLogLevel logLevel;

@end

@implementation WTRLogger

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static WTRLogger *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)setLogLevel:(WTRLogLevel)level {
    [WTRLogger sharedInstance].logLevel = level;
}

+ (WTRLogLevel)logLevel {
    return [WTRLogger sharedInstance].logLevel;
}

+ (void)log:(NSString *)format, ... {
    if (format) {
        va_list args;
        va_start(args, format);
        [self log:format arguments:args];
        va_end(args);
    }
}

+ (void)log:(NSString *)format arguments:(va_list)argList {
    [self logLevel:WTRLogLevelVerbose format:format arguments:argList];
}

+ (void)logLevel:(WTRLogLevel)level format:(NSString *)format, ... {
    if (format) {
        va_list args;
        va_start(args, format);
        [self logLevel:level format:format arguments:args];
        va_end(args);
    }
}

+ (void)logLevel:(WTRLogLevel)level format:(NSString *)format arguments:(va_list)argList {
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    [self logLevel:level message:message];
}

+ (void)logLevel:(WTRLogLevel)level message:(NSString *)message {
    if ([WTRLogger logLevel] == WTRLogLevelNone || level > [WTRLogger logLevel] ) {
        return;
    }
    
    NSMutableString *prefix = [NSMutableString stringWithFormat:@"WootricSDK"];
    
    switch (level) {
        case WTRLogLevelError:
            [prefix appendString:@" [Error]:"];
            break;
        default:
            [prefix appendString:@":"];
    }
    
    NSLog(@"%@ %@", prefix, message);
}

+ (void)logError:(NSString *)format, ... {
    if (format) {
        va_list args;
        va_start(args, format);
        [self logError:format arguments:args];
        va_end(args);
    }
}

+ (void)logError:(NSString *)format arguments:(va_list)argList {
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    [self logErrorMessage:message];
}

+ (void)logErrorMessage:(NSString *)message {
    [self logLevel:WTRLogLevelError message:message];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.logLevel = WTRLogLevelVerbose;
    }
    return self;
}


@end

//
//  WTRLogger.m
//  WootricSDK
//
// Copyright (c) 2018 Wootric (https://wootric.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

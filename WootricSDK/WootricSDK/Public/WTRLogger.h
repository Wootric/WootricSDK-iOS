//
//  WTRLogger.h
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

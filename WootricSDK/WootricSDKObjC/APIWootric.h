//
//  APIWootric.h
//  WootricSDKObjC
//
// Copyright (c) 2015 Wootric (https://wootric.com)
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
#import "WTSettings.h"

@interface APIWootric : NSObject

@property (nonatomic) WTSettings *settings;
@property (nonatomic) NSString *clientSecret;
@property (nonatomic) NSString *clientID;
@property (nonatomic) NSString *accountToken;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSString *endUserEmail;
@property (nonatomic) NSString *apiVersion;
@property (nonatomic) NSString *originURL;

+ (instancetype)sharedInstance;
- (void)getTrackingPixel;
- (void)voteWithScore:(NSInteger)score andText:(NSString *)text;
- (void)userDeclined;
- (BOOL)checkConfiguration;
- (void)surveyForEndUser:(void (^)())completionHandler;

@end

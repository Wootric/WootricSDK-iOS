//
//  WTRCustomMessages.h
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

@interface WTRCustomMessages : NSObject

@property (nonatomic, strong) NSString *followupQuestion;
@property (nonatomic, strong) NSString *detractorQuestion;
@property (nonatomic, strong) NSString *passiveQuestion;
@property (nonatomic, strong) NSString *promoterQuestion;
@property (nonatomic, strong) NSString *followupText;
@property (nonatomic, strong) NSString *detractorText;
@property (nonatomic, strong) NSString *passiveText;
@property (nonatomic, strong) NSString *promoterText;
@property (nonatomic, copy) NSDictionary *driverPicklist;
@property (nonatomic, copy) NSDictionary *detractorPicklist;
@property (nonatomic, copy) NSDictionary *passivePicklist;
@property (nonatomic, copy) NSDictionary *promoterPicklist;
@property (nonatomic, copy) NSDictionary *driverPicklistSettings;
@property (nonatomic, copy) NSDictionary *detractorPicklistSettings;
@property (nonatomic, copy) NSDictionary *passivePicklistSettings;
@property (nonatomic, copy) NSDictionary *promoterPicklistSettings;

- (instancetype)initWithCustomMessages:(NSDictionary *)customMessages;
- (id)copyWithZone:(NSZone *)zone;

@end

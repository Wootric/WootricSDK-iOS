//
//  WTRCustomThankYou.h
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

@interface WTRCustomThankYou : NSObject

@property (nonatomic, strong) NSString *thankYouMain;
@property (nonatomic, strong) NSString *thankYouSetup;
@property (nonatomic, strong) NSString *detractorThankYouMain;
@property (nonatomic, strong) NSString *detractorThankYouSetup;
@property (nonatomic, strong) NSString *passiveThankYouMain;
@property (nonatomic, strong) NSString *passiveThankYouSetup;
@property (nonatomic, strong) NSString *promoterThankYouMain;
@property (nonatomic, strong) NSString *promoterThankYouSetup;
@property (nonatomic, strong) NSString *thankYouLinkText;
@property (nonatomic, strong) NSURL *thankYouLinkURL;
@property (nonatomic, strong) NSString *detractorThankYouLinkText;
@property (nonatomic, strong) NSURL *detractorThankYouLinkURL;
@property (nonatomic, strong) NSString *passiveThankYouLinkText;
@property (nonatomic, strong) NSURL *passiveThankYouLinkURL;
@property (nonatomic, strong) NSString *promoterThankYouLinkText;
@property (nonatomic, strong) NSURL *promoterThankYouLinkURL;
@property (nonatomic, assign) int isEmailInURL;
@property (nonatomic, assign) int isDetractorEmailInURL;
@property (nonatomic, assign) int isPassiveEmailInURL;
@property (nonatomic, assign) int isPromoterEmailInURL;
@property (nonatomic, assign) int isScoreInURL;
@property (nonatomic, assign) int isDetractorScoreInURL;
@property (nonatomic, assign) int isPassiveScoreInURL;
@property (nonatomic, assign) int isPromoterScoreInURL;
@property (nonatomic, assign) int isCommentInURL;
@property (nonatomic, assign) int isDetractorCommentInURL;
@property (nonatomic, assign) int isPassiveCommentInURL;
@property (nonatomic, assign) int isPromoterCommentInURL;

- (instancetype)initWithCustomThankYou:(NSDictionary *)customThankYou;
- (BOOL)hasShareConfiguration;
- (id)copyWithZone:(NSZone *)zone;

@end

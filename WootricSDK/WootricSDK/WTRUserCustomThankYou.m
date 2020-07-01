//
//  WTRUserCustomThankYou.h
//  WootricSDK
//
// Copyright (c) 2019 Wootric (https://wootric.com)
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

#import "WTRUserCustomThankYou.h"

@implementation WTRUserCustomThankYou

- (instancetype)init {
  if (self = [super init]) {
    _isEmailInURL = -1;
    _isDetractorEmailInURL = -1;
    _isPassiveEmailInURL = -1;
    _isPromoterEmailInURL = -1;
    _isScoreInURL = -1;
    _isDetractorScoreInURL = -1;
    _isPassiveScoreInURL = -1;
    _isPromoterScoreInURL = -1;
    _isCommentInURL = -1;
    _isDetractorCommentInURL = -1;
    _isPassiveCommentInURL = -1;
    _isPromoterCommentInURL = -1;
  }
  
  return self;
}

- (BOOL)userCustomThankYouMainPresent {
  if (_thankYouMain || _detractorThankYouMain || _passiveThankYouMain || _promoterThankYouMain) {
    return YES;
  }
  
  return NO;
}

- (BOOL)userCustomThankYouSetupPresent {
  if (_thankYouSetup || _detractorThankYouSetup || _passiveThankYouSetup || _promoterThankYouSetup) {
    return YES;
  }
  
  return NO;
}

- (BOOL)userCustomLinkPresent {
  if (_thankYouLinkText || _detractorThankYouLinkText || _passiveThankYouLinkText || _promoterThankYouLinkText) {
    return YES;
  }
  
  return NO;
}

- (BOOL)hasShareConfiguration {
  return (_promoterThankYouLinkText && _promoterThankYouLinkURL);
}

- (id)copyWithZone:(NSZone *)zone {
  WTRUserCustomThankYou *userCustomThankYouCopy = [[WTRUserCustomThankYou allocWithZone:zone] init];
  userCustomThankYouCopy.thankYouMain = self.thankYouMain;
  userCustomThankYouCopy.thankYouSetup = self.thankYouSetup;
  userCustomThankYouCopy.detractorThankYouMain = self.detractorThankYouMain;
  userCustomThankYouCopy.detractorThankYouSetup = self.detractorThankYouSetup;
  userCustomThankYouCopy.passiveThankYouMain = self.passiveThankYouMain;
  userCustomThankYouCopy.passiveThankYouSetup = self.passiveThankYouSetup;
  userCustomThankYouCopy.promoterThankYouMain = self.promoterThankYouMain;
  userCustomThankYouCopy.promoterThankYouSetup = self.promoterThankYouSetup;
  userCustomThankYouCopy.thankYouLinkText = self.thankYouLinkText;
  userCustomThankYouCopy.thankYouLinkURL = self.thankYouLinkURL;
  userCustomThankYouCopy.detractorThankYouLinkText = self.detractorThankYouLinkText;
  userCustomThankYouCopy.detractorThankYouLinkURL = self.detractorThankYouLinkURL;
  userCustomThankYouCopy.passiveThankYouLinkText = self.passiveThankYouLinkText;
  userCustomThankYouCopy.passiveThankYouLinkURL = self.passiveThankYouLinkURL;
  userCustomThankYouCopy.promoterThankYouLinkText = self.promoterThankYouLinkText;
  userCustomThankYouCopy.promoterThankYouLinkURL = self.promoterThankYouLinkURL;
  userCustomThankYouCopy.backgroundColor = self.backgroundColor;
  userCustomThankYouCopy.isEmailInURL = self.isEmailInURL;
  userCustomThankYouCopy.isDetractorEmailInURL = self.isDetractorEmailInURL;
  userCustomThankYouCopy.isPassiveEmailInURL = self.isPassiveEmailInURL;
  userCustomThankYouCopy.isPromoterEmailInURL = self.isPromoterEmailInURL;
  userCustomThankYouCopy.isScoreInURL = self.isScoreInURL;
  userCustomThankYouCopy.isDetractorScoreInURL = self.isDetractorScoreInURL;
  userCustomThankYouCopy.isPassiveScoreInURL = self.isPassiveScoreInURL;
  userCustomThankYouCopy.isPromoterScoreInURL = self.isPromoterScoreInURL;
  userCustomThankYouCopy.isCommentInURL = self.isCommentInURL;
  userCustomThankYouCopy.isDetractorCommentInURL = self.isDetractorCommentInURL;
  userCustomThankYouCopy.isPassiveCommentInURL = self.isPassiveCommentInURL;
  userCustomThankYouCopy.isPromoterCommentInURL = self.isPromoterCommentInURL;
  return userCustomThankYouCopy;
}
@end

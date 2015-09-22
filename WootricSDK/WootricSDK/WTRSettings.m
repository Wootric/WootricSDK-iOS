//
//  WTRSettings.m
//  WootricSDK
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

#import "WTRSettings.h"
#import "WTRLocalizedTexts.h"
#import "WTRCustomMessages.h"
#import "WTRCustomThankYou.h"

@interface WTRSettings ()

@property (nonatomic, strong) WTRLocalizedTexts *localizedTexts;
@property (nonatomic, strong) WTRCustomMessages *customMessages;
@property (nonatomic, strong) WTRCustomThankYou *customThankYou;

@end

@implementation WTRSettings

- (instancetype)init {
  if (self = [super init]) {
    _setDefaultAfterSurvey = YES;
    _surveyedDefaultDuration = 90;
    _firstSurveyAfter = 31;
  }
  return self;
}

- (void)parseDataFromSurveyServer:(NSDictionary *)surveyServerSettings {
  NSDictionary *localizedTextsFromSurvey;
  NSDictionary *customMessagesFromSurvey;

  if (surveyServerSettings[@"settings"]) {
    localizedTextsFromSurvey = surveyServerSettings[@"settings"][@"localized_texts"];
    customMessagesFromSurvey = surveyServerSettings[@"settings"][@"messages"];

    if (localizedTextsFromSurvey) {
      _localizedTexts = [[WTRLocalizedTexts alloc] initWithLocalizedTexts:localizedTextsFromSurvey];
    }

    if (customMessagesFromSurvey) {
      _customMessages = [[WTRCustomMessages alloc] initWithCustomMessages:customMessagesFromSurvey];
    }
  }
}

- (NSString *)followupQuestionTextForScore:(int)score {
  if (!_customMessages) {
    return _localizedTexts.followupQuestion;
  }

  if (score <= 6 && _customMessages.detractorQuestion) {
    return _customMessages.detractorQuestion;
  } else if (score <= 8 && _customMessages.passiveQuestion) {
    return _customMessages.passiveQuestion;
  } else if (score <= 10 && _customMessages.promoterQuestion) {
    return _customMessages.promoterQuestion;
  }

  return _localizedTexts.followupQuestion;
}

- (NSString *)followupPlaceholderTextForScore:(int)score {
  if (!_customMessages) {
    return _localizedTexts.followupPlaceholder;
  }

  if (score <= 6 && _customMessages.detractorText) {
    return _customMessages.detractorText;
  } else if (score <= 8 && _customMessages.passiveText) {
    return _customMessages.passiveText;
  } else if (score <= 10 && _customMessages.promoterText) {
    return _customMessages.promoterText;
  }

  return _localizedTexts.followupPlaceholder;
}

- (NSString *)npsQuestionText {
  return _localizedTexts.npsQuestion;
}

- (NSString *)likelyAnchorText {
  return _localizedTexts.likelyAnchor;
}

- (NSString *)notLikelyAnchorText {
  return _localizedTexts.notLikelyAnchor;
}

- (NSString *)finalThankYouText {
  return _localizedTexts.finalThankYou;
}

- (NSString *)sendButtonText {
  return _localizedTexts.send;
}

- (NSString *)dismissButtonText {
  return _localizedTexts.dismiss;
}

- (NSString *)socialShareQuestionText {
  return _localizedTexts.socialShareQuestion;
}

- (NSString *)socialShareDeclineText {
  return _localizedTexts.socialShareDecline;
}

- (void)setThankYouMessage:(NSString *)thankYouMessage {
  _customThankYou.thankYouMessage = thankYouMessage;
}

- (void)setDetractorThankYouMessage:(NSString *)detractorThankYouMessage {
  _customThankYou.detractorThankYouMessage = detractorThankYouMessage;
}

- (void)setPassiveThankYouMessage:(NSString *)passiveThankYouMessage {
  _customThankYou.passiveThankYouMessage = passiveThankYouMessage;
}

- (void)setPromoterThankYouMessage:(NSString *)promoterThankYouMessage {
  _customThankYou.promoterThankYouMessage = promoterThankYouMessage;
}

- (void)setThankYouLinkWithText:(NSString *)thankYouLinkText andURL:(NSURL *)thankYouLinkURL {
  _customThankYou.thankYouLinkText = thankYouLinkText;
  _customThankYou.thankYouLinkURL = thankYouLinkURL;
}

- (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText andURL:(NSURL *)detractorThankYouLinkURL {
  _customThankYou.detractorThankYouLinkText = detractorThankYouLinkText;
  _customThankYou.detractorThankYouLinkURL = detractorThankYouLinkURL;
}

- (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText andURL:(NSURL *)passiveThankYouLinkURL {
  _customThankYou.passiveThankYouLinkText = passiveThankYouLinkText;
  _customThankYou.passiveThankYouLinkURL = passiveThankYouLinkURL;
}

- (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText andURL:(NSURL *)promoterThankYouLinkURL {
  _customThankYou.promoterThankYouLinkText = promoterThankYouLinkText;
  _customThankYou.promoterThankYouLinkURL = promoterThankYouLinkURL;
}

- (NSString *)thankYouMessageDependingOnScore:(int)score {
  if (score <= 6 && _customThankYou.detractorThankYouMessage) {
    return _customThankYou.detractorThankYouMessage;
  } else if (score <= 8 && _customThankYou.passiveThankYouMessage) {
    return _customThankYou.passiveThankYouMessage;
  } else if (score <= 10 && _customThankYou.promoterThankYouMessage) {
    return _customThankYou.promoterThankYouMessage;
  } else if (_customThankYou.thankYouMessage) {
    return _customThankYou.thankYouMessage;
  }

  return nil;
}

- (NSString *)thankYouLinkTextDependingOnScore:(int)score {
  if (score <= 6 && _customThankYou.detractorThankYouLinkText) {
    return _customThankYou.detractorThankYouLinkText;
  } else if (score <= 8 && _customThankYou.passiveThankYouLinkText) {
    return _customThankYou.passiveThankYouLinkText;
  } else if (score <= 10 && _customThankYou.promoterThankYouLinkText) {
    return _customThankYou.promoterThankYouLinkText;
  } else if (_customThankYou.thankYouLinkText) {
    return _customThankYou.thankYouLinkText;
  }

  return nil;
}

- (NSURL *)thankYouLinkURLDependingOnScore:(int)score {
  if (score <= 6 && _customThankYou.detractorThankYouLinkURL) {
    return _customThankYou.detractorThankYouLinkURL;
  } else if (score <= 8 && _customThankYou.passiveThankYouLinkURL) {
    return _customThankYou.passiveThankYouLinkURL;
  } else if (score <= 10 && _customThankYou.promoterThankYouLinkURL) {
    return _customThankYou.promoterThankYouLinkURL;
  } else if (_customThankYou.thankYouLinkURL) {
    return _customThankYou.thankYouLinkURL;
  }

  return nil;
}

@end
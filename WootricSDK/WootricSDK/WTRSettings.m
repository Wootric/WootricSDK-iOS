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
#import "WTRUserCustomMessages.h"
#import "WTRColor.h"

@interface WTRSettings ()

@property (nonatomic, strong) WTRLocalizedTexts *localizedTexts;
@property (nonatomic, strong) WTRCustomMessages *customMessages;
@property (nonatomic, strong) WTRCustomThankYou *customThankYou;
@property (nonatomic, strong) WTRUserCustomMessages *userCustomMessages;

@end

@implementation WTRSettings

- (instancetype)init {
    
  if (self = [super init]) {
    _setDefaultAfterSurvey = YES;
    _surveyedDefaultDuration = 90;
    _surveyedDefaultDurationDecline = 30;
    _firstSurveyAfter = @0;
    _originURL = [[NSBundle mainBundle] bundleIdentifier];
    _customThankYou = [[WTRCustomThankYou alloc] init];
    _userCustomMessages = [[WTRUserCustomMessages alloc] init];
    _timeDelay = 0;
    _surveyType = @"NPS";
    _scale = [self scoreRules][_surveyType][0];
  }
    
  return self;
}

- (void)parseDataFromSurveyServer:(NSDictionary *)surveyServerSettings {
  NSDictionary *localizedTextsFromSurvey;
  NSDictionary *customMessagesFromSurvey;
    
  if (surveyServerSettings[@"settings"]) {
    localizedTextsFromSurvey = surveyServerSettings[@"settings"][@"localized_texts"];
    customMessagesFromSurvey = surveyServerSettings[@"settings"][@"messages"];
    NSString *surveyTypeFromSurvey = surveyServerSettings[@"settings"][@"survey_type"];
    NSInteger surveyTypeScaleFromSurvey = [surveyServerSettings[@"settings"][@"survey_type_scale"] integerValue];
    NSNumber *firstSurvey = surveyServerSettings[@"settings"][@"first_survey"];
    NSNumber *resurveyThrottleFromServer = surveyServerSettings[@"settings"][@"resurvey_throttle"];
    NSNumber *declineResurveyThrottleFromServer = surveyServerSettings[@"settings"][@"decline_resurvey_throttle"];
    NSInteger delay = [surveyServerSettings[@"settings"][@"time_delay"] integerValue];
      
    if (surveyTypeFromSurvey) {
      _surveyType = surveyTypeFromSurvey;
      if (surveyTypeScaleFromSurvey) {
        _surveyTypeScale = surveyTypeScaleFromSurvey;
        _scale = [self scoreRules][_surveyType][surveyTypeScaleFromSurvey];
      } else {
        _surveyTypeScale = 0;
        _scale = [self scoreRules][_surveyType][0];
      }
    }

    if (localizedTextsFromSurvey) {
      _localizedTexts = [[WTRLocalizedTexts alloc] initWithLocalizedTexts:localizedTextsFromSurvey];
    }

    if (customMessagesFromSurvey) {
      _customMessages = [[WTRCustomMessages alloc] initWithCustomMessages:customMessagesFromSurvey];
    }

    if (firstSurvey) {
      _firstSurveyAfter = firstSurvey;
    }

    if (delay > 0) {
      _timeDelay = delay;
    }

    if (resurveyThrottleFromServer) {
      _surveyedDefaultDuration = [resurveyThrottleFromServer intValue];
    }

    if (declineResurveyThrottleFromServer) {
      _surveyedDefaultDurationDecline = [declineResurveyThrottleFromServer intValue];
    }
  }
}

- (NSDictionary *)scoreRules {
    return @{
             @"NPS" : [NSArray arrayWithObjects: @{@"min" : @0, @"max" : @10, @"negative_type_max" : @6, @"neutral_type_max" : @8}, nil],
             @"CES" : [NSArray arrayWithObjects: @{@"min" : @1, @"max" : @7, @"negative_type_max" : @3, @"neutral_type_max" : @5}, nil],
             @"CSAT" : [NSArray arrayWithObjects: @{@"min" : @1, @"max" : @5, @"negative_type_max" : @2, @"neutral_type_max" : @3}, @{@"min" : @1, @"max" : @10, @"negative_type_max" : @6, @"neutral_type_max" : @8}, nil]
             };
}

- (BOOL)negativeTypeScore:(int)score {
    return score <= [_scale[@"negative_type_max"] intValue];
}

- (BOOL)neutralTypeScore:(int)score {
    return score > [_scale[@"negative_type_max"] intValue] && score <= [_scale[@"neutral_type_max"] intValue];
}

- (BOOL)positiveTypeScore:(int)score {
    return score > [_scale[@"neutral_type_max"] intValue];
}

- (int)maximumScore {
    return [_scale[@"max"] intValue];
}

- (int)minimumScore {
    return [_scale[@"min"] intValue];
}

- (NSString *)getEndUserEmailOrUnknown {
  if (!_endUserEmail || ![self validEmailString]) {
    return @"Unknown";
  }
  return _endUserEmail;
}

- (NSString *)followupQuestionTextForScore:(int)score {
  if (!_customMessages && ![_userCustomMessages userCustomQuestionPresent]) {
    return _localizedTexts.followupQuestion;
  }

  if ([self negativeTypeScore:score] && (_customMessages.detractorQuestion || _userCustomMessages.detractorQuestion)) {
    return [self detractorFollowupQuestion];
  } else if ([self neutralTypeScore:score] && (_customMessages.passiveQuestion || _userCustomMessages.passiveQuestion)) {
    return [self passiveFollowupQuestion];
  } else if ([self positiveTypeScore:score] && (_customMessages.promoterQuestion || _userCustomMessages.promoterQuestion)) {
    return [self promoterFollowupQuestion];
  } else if (_customMessages.followupQuestion) {
    return [self mainFollowupQuestion];
  }

  return _localizedTexts.followupQuestion;
}

- (NSString *)followupPlaceholderTextForScore:(int)score {
  if (!_customMessages && ![_userCustomMessages userCustomPlaceholderPresent]) {
    return _localizedTexts.followupPlaceholder;
  }

  if ([self negativeTypeScore:score] && (_customMessages.detractorText || _userCustomMessages.detractorPlaceholderText)) {
    return [self detractorFollowupPlaceholder];
  } else if ([self neutralTypeScore:score] && (_customMessages.passiveText || _userCustomMessages.passivePlaceholderText)) {
    return [self passiveFollowupPlaceholder];
  } else if ([self positiveTypeScore:score] && (_customMessages.promoterText || _userCustomMessages.promoterPlaceholderText)) {
    return [self promoterFollowupPlaceholder];
  } else if (_customMessages.followupText) {
    return _customMessages.followupText;
  }

  return _localizedTexts.followupPlaceholder;
}

- (NSString *)mainFollowupQuestion {
  if (_userCustomMessages.followupQuestion) {
    return _userCustomMessages.followupQuestion;
  }

  return _customMessages.followupQuestion;
}

- (NSString *)detractorFollowupQuestion {
  if (_userCustomMessages.detractorQuestion) {
    return _userCustomMessages.detractorQuestion;
  }

  return _customMessages.detractorQuestion;
}

- (NSString *)passiveFollowupQuestion {
  if (_userCustomMessages.passiveQuestion) {
    return _userCustomMessages.passiveQuestion;
  }
    
  return _customMessages.passiveQuestion;
}

- (NSString *)promoterFollowupQuestion {
  if (_userCustomMessages.promoterQuestion) {
    return _userCustomMessages.promoterQuestion;
  }
    
  return _customMessages.promoterQuestion;
}

- (NSString *)detractorFollowupPlaceholder {
  if (_userCustomMessages.detractorPlaceholderText) {
    return _userCustomMessages.detractorPlaceholderText;
  }
    
  return _customMessages.detractorText;
}

- (NSString *)passiveFollowupPlaceholder {
  if (_userCustomMessages.passivePlaceholderText) {
    return _userCustomMessages.passivePlaceholderText;
  }
    
  return _customMessages.passiveText;
}

- (NSString *)promoterFollowupPlaceholder {
  if (_userCustomMessages.promoterPlaceholderText) {
    return _userCustomMessages.promoterPlaceholderText;
  }
    
  return _customMessages.promoterText;
}

- (NSString *)questionText {
  if (_customQuestion) {
    return _customQuestion;
  }
  return _localizedTexts.question;
}

- (NSString *)likelyAnchorText {
  return _localizedTexts.likelyAnchor;
}

- (NSString *)notLikelyAnchorText {
  return _localizedTexts.notLikelyAnchor;
}

- (NSString *)finalThankYouText {
  if (_customFinalThankYou) {
    return _customFinalThankYou;
  }
  return _localizedTexts.finalThankYou;
}

- (NSString *)sendButtonText {
  return _localizedTexts.send;
}

- (UIColor *)sendButtonBackgroundColor {
  if (_sendButtonBackgroundColor) {
    return _sendButtonBackgroundColor;
  }
  return [WTRColor sendButtonBackgroundColor];
}

- (UIColor *)sliderColor {
  if (_sliderColor) {
    return _sliderColor;
  }
  return [WTRColor sliderValueColor];
}

- (UIColor *)thankYouButtonBackgroundColor {
  if (_customThankYou.backgroundColor) {
    return _customThankYou.backgroundColor;
  }
  return [WTRColor callToActionButtonBackgroundColor];
}

- (UIColor *)socialSharingColor {
  if (_socialSharingColor) {
    return _socialSharingColor;
  }
  return [WTRColor socialShareQuestionTextColor];
}

- (NSString *)dismissButtonText {
  return _localizedTexts.dismiss;
}

- (NSString *)editScoreButtonText {
  return _localizedTexts.editScore;
}

- (NSString *)socialShareQuestionText {
  return _localizedTexts.socialShareQuestion;
}

- (NSString *)socialShareDeclineText {
  return _localizedTexts.socialShareDecline;
}

- (void)setThankYouButtonBackgroundColor:(UIColor *)thankYouButtonBackgroundColor {
  _customThankYou.backgroundColor = thankYouButtonBackgroundColor;
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

- (void)setThankYouLinkWithText:(NSString *)thankYouLinkText URL:(NSURL *)thankYouLinkURL {
  _customThankYou.thankYouLinkText = thankYouLinkText;
  _customThankYou.thankYouLinkURL = thankYouLinkURL;
}

- (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText URL:(NSURL *)detractorThankYouLinkURL {
  _customThankYou.detractorThankYouLinkText = detractorThankYouLinkText;
  _customThankYou.detractorThankYouLinkURL = detractorThankYouLinkURL;
}

- (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText URL:(NSURL *)passiveThankYouLinkURL {
  _customThankYou.passiveThankYouLinkText = passiveThankYouLinkText;
  _customThankYou.passiveThankYouLinkURL = passiveThankYouLinkURL;
}

- (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText URL:(NSURL *)promoterThankYouLinkURL {
  _customThankYou.promoterThankYouLinkText = promoterThankYouLinkText;
  _customThankYou.promoterThankYouLinkURL = promoterThankYouLinkURL;
}

- (void)setCustomFollowupQuestionForPromoter:(NSString *)promoterQuestion passive:(NSString *)passiveQuestion detractor:(NSString *)detractorQuestion {
  _userCustomMessages.promoterQuestion = promoterQuestion;
  _userCustomMessages.passiveQuestion = passiveQuestion;
  _userCustomMessages.detractorQuestion = detractorQuestion;
}

- (void)setCustomFollowupPlaceholderForPromoter:(NSString *)promoterPlaceholder passive:(NSString *)passivePlaceholder detractor:(NSString *)detractorPlaceholder {
  _userCustomMessages.promoterPlaceholderText = promoterPlaceholder;
  _userCustomMessages.passivePlaceholderText = passivePlaceholder;
  _userCustomMessages.detractorPlaceholderText = detractorPlaceholder;
}

- (NSString *)thankYouMessageDependingOnScore:(int)score {
    
  if ([self negativeTypeScore:score] && _customThankYou.detractorThankYouMessage) {
    return _customThankYou.detractorThankYouMessage;
  } else if ([self neutralTypeScore:score] && _customThankYou.passiveThankYouMessage) {
    return _customThankYou.passiveThankYouMessage;
  } else if ([self positiveTypeScore:score] && _customThankYou.promoterThankYouMessage) {
    return _customThankYou.promoterThankYouMessage;
  } else if (_customThankYou.thankYouMessage) {
    return _customThankYou.thankYouMessage;
  }
    
  return nil;
}

- (NSString *)thankYouLinkTextDependingOnScore:(int)score {
    
  if ([self negativeTypeScore:score] && _customThankYou.detractorThankYouLinkText) {
    return _customThankYou.detractorThankYouLinkText;
  } else if ([self neutralTypeScore:score] && _customThankYou.passiveThankYouLinkText) {
    return _customThankYou.passiveThankYouLinkText;
  } else if ([self positiveTypeScore:score] && _customThankYou.promoterThankYouLinkText) {
    return _customThankYou.promoterThankYouLinkText;
  } else if (_customThankYou.thankYouLinkText) {
    return _customThankYou.thankYouLinkText;
  }
    
  return nil;
}

- (NSURL *)thankYouLinkURLDependingOnScore:(int)score andText:(NSString *)text {
    
  if ([self negativeTypeScore:score] && _customThankYou.detractorThankYouLinkURL) {
    if (_passScoreAndTextToURL) {
      return [self url:_customThankYou.detractorThankYouLinkURL withScore:score andText:text];
    }
    return _customThankYou.detractorThankYouLinkURL;
  } else if ([self neutralTypeScore:score] && _customThankYou.passiveThankYouLinkURL) {
    if (_passScoreAndTextToURL) {
      return [self url:_customThankYou.passiveThankYouLinkURL withScore:score andText:text];
    }
    return _customThankYou.passiveThankYouLinkURL;
  } else if ([self positiveTypeScore:score] && _customThankYou.promoterThankYouLinkURL) {
    if (_passScoreAndTextToURL) {
      return [self url:_customThankYou.promoterThankYouLinkURL withScore:score andText:text];
    }
    return _customThankYou.promoterThankYouLinkURL;
  } else if (_customThankYou.thankYouLinkURL) {
    if (_passScoreAndTextToURL) {
      return [self url:_customThankYou.thankYouLinkURL withScore:score andText:text];
    }
    return _customThankYou.thankYouLinkURL;
  }
  
  return nil;
}

- (BOOL)thankYouLinkConfiguredForScore:(int)score {
    
  if ([self negativeTypeScore:score] && [self detractorOrDefaultURL] && [self detractorOrDefaultText]) {
    return YES;
  }
  else if ([self neutralTypeScore:score] && [self passiveOrDefaultURL] && [self passiveOrDefaultText]) {
    return YES;
  }
  else if ([self positiveTypeScore:score] && [self promoterOrDefaultURL] && [self promoterOrDefaultText]) {
    return YES;
  }
  else if (_customThankYou.thankYouLinkURL && _customThankYou.thankYouLinkText) {
    return YES;
  }
  
  return NO;
}

- (BOOL)detractorOrDefaultURL {
  return (_customThankYou.detractorThankYouLinkURL || _customThankYou.thankYouLinkURL);
}

- (BOOL)detractorOrDefaultText {
  return (_customThankYou.detractorThankYouLinkText || _customThankYou.thankYouLinkText);
}

- (BOOL)passiveOrDefaultURL {
  return (_customThankYou.passiveThankYouLinkURL || _customThankYou.thankYouLinkURL);
}

- (BOOL)passiveOrDefaultText {
  return (_customThankYou.passiveThankYouLinkText || _customThankYou.thankYouLinkText);
}

- (BOOL)promoterOrDefaultURL {
  return (_customThankYou.promoterThankYouLinkURL || _customThankYou.thankYouLinkURL);
}

- (BOOL)promoterOrDefaultText {
  return (_customThankYou.promoterThankYouLinkText || _customThankYou.thankYouLinkText);
}

- (BOOL)twitterHandlerSet {
  return !!_twitterHandler;
}

- (BOOL)facebookPageSet {
  return !!_facebookPage;
}

- (void)setCustomResurveyThrottle:(NSNumber *)customResurveyThrottle {
  if ([customResurveyThrottle intValue] < 0) {
    customResurveyThrottle = @0;
  }
  _resurveyThrottle = customResurveyThrottle;
}

- (void)setCustomVisitorPercentage:(NSNumber *)customVisitorPercentage {
  if ([customVisitorPercentage intValue] < 0) {
    customVisitorPercentage = @0;
  } else if ([customVisitorPercentage intValue] > 100) {
    customVisitorPercentage = @100;
  }
  _visitorPercentage = customVisitorPercentage;
}

- (void)setCustomRegisteredPercentage:(NSNumber *)customRegisteredPercentage {
  if ([customRegisteredPercentage intValue] < 0) {
    customRegisteredPercentage = @0;
  } else if ([customRegisteredPercentage intValue] > 100) {
    customRegisteredPercentage = @100;
  }
  _registeredPercentage = customRegisteredPercentage;
}

- (void)setCustomDailyResponseCap:(NSNumber *)customDailyResponseCap {
  if ([customDailyResponseCap intValue] < 0) {
    customDailyResponseCap = @0;
  }
  _dailyResponseCap = customDailyResponseCap;
}

- (BOOL)validEmailString {
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return !([[_endUserEmail stringByTrimmingCharactersInSet:set] length] == 0);
}

- (NSURL *)url:(NSURL *)baseUrl withScore:(int)score andText:(NSString *)text {
  NSString *paramsString;
  NSString *escapedText = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  if (!escapedText) {
    escapedText = @"";
  }
  
  if ([[baseUrl absoluteString] rangeOfString:@"?"].location == NSNotFound) {
    paramsString = [NSString stringWithFormat:@"?wootric_score=%d&wootric_text=%@", score, escapedText];
    return [NSURL URLWithString:paramsString relativeToURL:baseUrl];
  } else {
    paramsString = [NSString stringWithFormat:@"&wootric_score=%d&wootric_text=%@", score, escapedText];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, paramsString]];
  }
}

@end

//
//  WTRSettings.m
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

#import "WTRSettings.h"
#import "WTRLocalizedTexts.h"
#import "WTRCustomMessages.h"
#import "WTRCustomThankYou.h"
#import "WTRCustomSocial.h"
#import "WTRUserCustomMessages.h"
#import "WTRUserCustomThankYou.h"
#import "WTRColor.h"

@interface WTRSettings ()

@property (nonatomic, strong) WTRLocalizedTexts *localizedTexts;
@property (nonatomic, strong) WTRCustomMessages *customMessages;
@property (nonatomic, strong) WTRCustomThankYou *customThankYou;
@property (nonatomic, strong) WTRCustomSocial *customSocial;
@property (nonatomic, strong) WTRUserCustomMessages *userCustomMessages;
@property (nonatomic, strong) WTRUserCustomThankYou *userCustomThankYou;
@property (nonatomic, strong) WTRCustomSocial *userCustomSocial;

@end

@implementation WTRSettings

- (instancetype)init {
  if (self = [super init]) {
    _setDefaultAfterSurvey = YES;
    _surveyedDefaultDuration = 90;
    _surveyedDefaultDurationDecline = 30;
    _firstSurveyAfter = @0;
    _originURL = [SWIFTPM_MODULE_BUNDLE bundleIdentifier];
    _userCustomThankYou = [[WTRUserCustomThankYou alloc] init];
    _userCustomMessages = [[WTRUserCustomMessages alloc] init];
    _userCustomSocial = [[WTRCustomSocial alloc] init];
    _timeDelay = -1;
    _surveyType = @"NPS";
    _scale = [self scoreRules][_surveyType][0];
    _showOptOut = NO;
  }
    
  return self;
}

- (void)parseDataFromSurveyServer:(NSDictionary *)surveyServerSettings {
  NSDictionary *localizedTextsFromSurvey;
  NSDictionary *customMessagesFromSurvey;
  NSDictionary *customThankYouFromSurvey;
  NSDictionary *socialFromSurvey;
    
  if (surveyServerSettings[@"settings"]) {
    localizedTextsFromSurvey = surveyServerSettings[@"settings"][@"localized_texts"];
    customMessagesFromSurvey = surveyServerSettings[@"settings"][@"messages"];
    customThankYouFromSurvey = surveyServerSettings[@"settings"][@"custom_thank_you"];
    socialFromSurvey = surveyServerSettings[@"settings"][@"social"];
    NSString *surveyTypeFromSurvey = surveyServerSettings[@"settings"][@"survey_type"];
    NSInteger surveyTypeScaleFromSurvey = [surveyServerSettings[@"settings"][@"survey_type_scale"] integerValue];
    NSNumber *firstSurvey = surveyServerSettings[@"settings"][@"first_survey"];
    NSNumber *resurveyThrottleFromServer = surveyServerSettings[@"settings"][@"resurvey_throttle"];
    NSNumber *declineResurveyThrottleFromServer = surveyServerSettings[@"settings"][@"decline_resurvey_throttle"];
    NSInteger delay = _timeDelay > -1 ? _timeDelay : [surveyServerSettings[@"settings"][@"time_delay"] integerValue];
      
    if (surveyTypeFromSurvey) {
      _surveyType = surveyTypeFromSurvey;
      if (surveyTypeScaleFromSurvey) {
        _surveyTypeScale = surveyTypeScaleFromSurvey;
        _scale = [self scoreRules][_surveyType][surveyTypeScaleFromSurvey];
      } else {
        _surveyTypeScale = _surveyTypeScale >= ((NSArray *)[self scoreRules][_surveyType]).count ? 0 : _surveyTypeScale;
        _scale = [self scoreRules][_surveyType][_surveyTypeScale];
      }
    }

    if (localizedTextsFromSurvey) {
      _localizedTexts = [[WTRLocalizedTexts alloc] initWithLocalizedTexts:localizedTextsFromSurvey];
    }

    if (customMessagesFromSurvey) {
      _customMessages = [[WTRCustomMessages alloc] initWithCustomMessages:customMessagesFromSurvey];
    }
    
    if (customThankYouFromSurvey) {
      _customThankYou = [[WTRCustomThankYou alloc] initWithCustomThankYou:customThankYouFromSurvey];
    }
    
    if (socialFromSurvey) {
      _customSocial = [[WTRCustomSocial alloc] initWithCustomSocial:socialFromSurvey];
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
  if (_userCustomThankYou.backgroundColor) {
    return _userCustomThankYou.backgroundColor;
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

- (NSString *)socialShareDeclineText {
  return _localizedTexts.socialShareDecline;
}

- (void)setThankYouButtonBackgroundColor:(UIColor *)thankYouButtonBackgroundColor {
  _userCustomThankYou.backgroundColor = thankYouButtonBackgroundColor;
}

- (void)setThankYouMain:(NSString *)thankYouMain {
  _userCustomThankYou.thankYouMain = thankYouMain;
}

- (void)setDetractorThankYouMain:(NSString *)detractorThankYouMain {
  _userCustomThankYou.detractorThankYouMain = detractorThankYouMain;
}

- (void)setPassiveThankYouMain:(NSString *)passiveThankYouMain {
  _userCustomThankYou.passiveThankYouMain = passiveThankYouMain;
}

- (void)setPromoterThankYouMain:(NSString *)promoterThankYouMain {
  _userCustomThankYou.promoterThankYouMain = promoterThankYouMain;
}

- (void)setThankYouSetup:(NSString *)thankYouMain {
  _userCustomThankYou.thankYouMain = thankYouMain;
}

- (void)setDetractorThankYouSetup:(NSString *)detractorThankYouSetup {
  _userCustomThankYou.detractorThankYouSetup = detractorThankYouSetup;
}

- (void)setPassiveThankYouSetup:(NSString *)passiveThankYouSetup {
  _userCustomThankYou.passiveThankYouSetup = passiveThankYouSetup;
}

- (void)setPromoterThankYouSetup:(NSString *)promoterThankYouSetup {
  _userCustomThankYou.promoterThankYouSetup = promoterThankYouSetup;
}

- (void)setThankYouLinkWithText:(NSString *)thankYouLinkText URL:(NSURL *)thankYouLinkURL {
  _userCustomThankYou.thankYouLinkText = thankYouLinkText;
  _userCustomThankYou.thankYouLinkURL = thankYouLinkURL;
}

- (void)setDetractorThankYouLinkWithText:(NSString *)detractorThankYouLinkText URL:(NSURL *)detractorThankYouLinkURL {
  _userCustomThankYou.detractorThankYouLinkText = detractorThankYouLinkText;
  _userCustomThankYou.detractorThankYouLinkURL = detractorThankYouLinkURL;
}

- (void)setPassiveThankYouLinkWithText:(NSString *)passiveThankYouLinkText URL:(NSURL *)passiveThankYouLinkURL {
  _userCustomThankYou.passiveThankYouLinkText = passiveThankYouLinkText;
  _userCustomThankYou.passiveThankYouLinkURL = passiveThankYouLinkURL;
}

- (void)setPromoterThankYouLinkWithText:(NSString *)promoterThankYouLinkText URL:(NSURL *)promoterThankYouLinkURL {
  _userCustomThankYou.promoterThankYouLinkText = promoterThankYouLinkText;
  _userCustomThankYou.promoterThankYouLinkURL = promoterThankYouLinkURL;
}

- (void)setEmailInURL:(int)emailInURL {
  _userCustomThankYou.isEmailInURL = emailInURL;
}

- (void)setPromoterEmailInURL:(int)promoterEmailInURL passiveEmailInURL:(int)passiveEmailInURL detractorEmailInURL:(int)detractorEmailInURL  {
  _userCustomThankYou.isDetractorEmailInURL = detractorEmailInURL;
  _userCustomThankYou.isPassiveEmailInURL = passiveEmailInURL;
  _userCustomThankYou.isPromoterEmailInURL = promoterEmailInURL;
}

- (void)setScoreInURL:(int)scoreInURL {
  _userCustomThankYou.isScoreInURL = scoreInURL;
}

- (void)setPromoterScoreInURL:(int)promoterScoreInURL passiveScoreInURL:(int)passiveScoreInURL detractorScoreInURL:(int)detractorScoreInURL  {
  _userCustomThankYou.isDetractorScoreInURL = detractorScoreInURL;
  _userCustomThankYou.isPassiveScoreInURL = passiveScoreInURL;
  _userCustomThankYou.isPromoterScoreInURL = promoterScoreInURL;
}

- (void)setCommentInURL:(int)commentInURL {
  _userCustomThankYou.isCommentInURL = commentInURL;
}

- (void)setPromoterCommentInURL:(int)promoterCommentInURL passiveCommentInURL:(int)passiveCommentInURL detractorCommentInURL:(int)detractorCommentInURL  {
  _userCustomThankYou.isDetractorCommentInURL = detractorCommentInURL;
  _userCustomThankYou.isPassiveCommentInURL = passiveCommentInURL;
  _userCustomThankYou.isPromoterCommentInURL = promoterCommentInURL;
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

- (NSString *)thankYouMainDependingOnScore:(int)score {
  if ([self negativeTypeScore:score] && (_customThankYou.detractorThankYouMain || _userCustomThankYou.detractorThankYouMain)) {
    return [self detractorThankYouMain];
  } else if ([self neutralTypeScore:score] && (_customThankYou.passiveThankYouMain || _userCustomThankYou.passiveThankYouMain)) {
    return [self passiveThankYouMain];
  } else if ([self positiveTypeScore:score] && (_customThankYou.promoterThankYouMain || _userCustomThankYou.promoterThankYouMain)) {
    return [self promoterThankYouMain];
  } else if (_customThankYou.thankYouMain || _userCustomThankYou.thankYouMain) {
    return [self thankYouMain];
  }
    
  return _localizedTexts.finalThankYou;
}

- (NSString *)thankYouSetupDependingOnScore:(int)score {
  if ([self positiveTypeScore:score]) {
    if (_customThankYou.promoterThankYouSetup || _userCustomThankYou.promoterThankYouSetup) {
      return [self promoterThankYouSetup];
    } else if ([_customThankYou hasShareConfiguration] || [_userCustomThankYou hasShareConfiguration] || _customSocial.twitterHandler || _customSocial.facebookPage) {
      return _localizedTexts.socialShareQuestion;
    }
  } else if ([self negativeTypeScore:score] && (_customThankYou.detractorThankYouSetup || _userCustomThankYou.detractorThankYouSetup)) {
    return [self detractorThankYouSetup];
  } else if ([self neutralTypeScore:score] && (_customThankYou.passiveThankYouSetup || _userCustomThankYou.passiveThankYouSetup)) {
    return [self passiveThankYouSetup];
  }
  
  if (_customThankYou.thankYouSetup || _userCustomThankYou.thankYouSetup) {
    return [self thankYouSetup];
  }
  
  return nil;
}

- (NSString *)thankYouLinkTextDependingOnScore:(int)score {
  if ([self negativeTypeScore:score] && (_customThankYou.detractorThankYouLinkText || _userCustomThankYou.detractorThankYouLinkText)) {
    return [self detractorThankYouLinkText];
  } else if ([self neutralTypeScore:score] && (_customThankYou.passiveThankYouLinkText || _userCustomThankYou.passiveThankYouLinkText)) {
    return [self passiveThankYouLinkText];
  } else if ([self positiveTypeScore:score] && (_customThankYou.promoterThankYouLinkText || _userCustomThankYou.promoterThankYouLinkText)) {
    return [self promoterThankYouLinkText];
  } else if (_customThankYou.thankYouLinkText || _userCustomThankYou.thankYouLinkText) {
    return [self thankYouLinkText];
  }
    
  return nil;
}

- (NSURL *)thankYouLinkURLDependingOnScore:(int)score text:(NSString *)text email:(NSString *)email {
  if ([self negativeTypeScore:score] && (_customThankYou.detractorThankYouLinkURL || _userCustomThankYou.detractorThankYouLinkURL)) {
    return [self detractorThankYouLinkURLWithScore:score text:text email:email];
  } else if ([self neutralTypeScore:score] && (_customThankYou.passiveThankYouLinkURL || _userCustomThankYou.passiveThankYouLinkURL)) {
    return [self passiveThankYouLinkURLWithScore:score text:text email:email];
  } else if ([self positiveTypeScore:score] && (_customThankYou.promoterThankYouLinkURL || _userCustomThankYou.promoterThankYouLinkURL)) {
    return [self promoterThankYouLinkURLWithScore:score text:text email:email];
  } else if (_customThankYou.thankYouLinkURL || _userCustomThankYou.thankYouLinkURL) {
    return [self thankYouLinkURLWithScore:score text:text email:email];
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

- (int)thankYouLinkShouldIncludeEmailDependingOnScore:(int)score {
  if ([self negativeTypeScore:score] && (_customThankYou.isDetractorEmailInURL == 1 || _userCustomThankYou.isDetractorEmailInURL == 1)) {
    return [self isDetractorEmailInURL];
  } else if ([self neutralTypeScore:score] && (_customThankYou.isPassiveEmailInURL == 1 || _userCustomThankYou.isPassiveEmailInURL == 1)) {
    return [self isPassiveEmailInURL];
  } else if ([self positiveTypeScore:score] && (_customThankYou.isPromoterEmailInURL == 1 || _userCustomThankYou.isPromoterEmailInURL == 1)) {
    return [self isPromoterEmailInURL];
  } else if (_customThankYou.isEmailInURL == 1 || _userCustomThankYou.isEmailInURL == 1) {
    return [self isEmailInURL];
  }
  
  return -1;
}

- (int)thankYouLinkShouldIncludeScoreDependingOnScore:(int)score {
  if ([self negativeTypeScore:score] && (_customThankYou.isDetractorScoreInURL == 1 || _userCustomThankYou.isDetractorScoreInURL == 1)) {
    return [self isDetractorScoreInURL];
  } else if ([self neutralTypeScore:score] && (_customThankYou.isPassiveScoreInURL == 1 || _userCustomThankYou.isDetractorScoreInURL == 1)) {
    return [self isPassiveScoreInURL];
  } else if ([self positiveTypeScore:score] && (_customThankYou.isPromoterScoreInURL == 1 || _userCustomThankYou.isPromoterScoreInURL == 1)) {
    return [self isPromoterScoreInURL];
  } else if (_customThankYou.isScoreInURL == 1 || _userCustomThankYou.isScoreInURL == 1) {
    return [self isScoreInURL];
  }
  
  return -1;
}

- (int)thankYouLinkShouldIncludeCommentDependingOnScore:(int)score {
  if ([self negativeTypeScore:score] && (_customThankYou.isDetractorCommentInURL == 1 || _userCustomThankYou.isDetractorCommentInURL == 1)) {
    return [self isDetractorCommentInURL];
  } else if ([self neutralTypeScore:score] && (_customThankYou.isPassiveCommentInURL == 1 || _userCustomThankYou.isPassiveCommentInURL) == 1) {
    return [self isPassiveCommentInURL];
  } else if ([self positiveTypeScore:score] && (_customThankYou.isPromoterCommentInURL == 1 || _userCustomThankYou.isPromoterCommentInURL == 1)) {
    return [self isPromoterCommentInURL];
  } else if (_customThankYou.isCommentInURL == 1 || _userCustomThankYou.isCommentInURL == 1) {
    return [self isCommentInURL];
  }
  
  return -1;
}

- (int)isDetractorEmailInURL {
  if (_userCustomThankYou.isDetractorEmailInURL != -1) {
    return _userCustomThankYou.isDetractorEmailInURL;
  }
  
  return _customThankYou.isDetractorEmailInURL;
}

- (int)isPassiveEmailInURL {
  if (_userCustomThankYou.isPassiveEmailInURL != -1) {
    return _userCustomThankYou.isPassiveEmailInURL;
  }
  
  return _customThankYou.isPassiveEmailInURL;
}

- (int)isPromoterEmailInURL {
  if (_userCustomThankYou.isPromoterEmailInURL != -1) {
    return _userCustomThankYou.isPromoterEmailInURL;
  }
  
  return _customThankYou.isPromoterEmailInURL;
}

- (int)isEmailInURL {
  if (_userCustomThankYou.isEmailInURL != -1) {
    return _userCustomThankYou.isEmailInURL;
  }
  
  return _customThankYou.isEmailInURL;
}

- (int)isDetractorScoreInURL {
  if (_userCustomThankYou.isDetractorScoreInURL != -1) {
    return _userCustomThankYou.isDetractorScoreInURL;
  }
  
  return _customThankYou.isDetractorScoreInURL;
}

- (int)isPassiveScoreInURL {
  if (_userCustomThankYou.isPassiveScoreInURL != -1) {
    return _userCustomThankYou.isPassiveScoreInURL;
  }
  
  return _customThankYou.isPassiveScoreInURL;
}

- (int)isPromoterScoreInURL {
  if (_userCustomThankYou.isPromoterScoreInURL != -1) {
    return _userCustomThankYou.isPromoterScoreInURL;
  }
  
  return _customThankYou.isPromoterScoreInURL;
}

- (int)isScoreInURL {
  if (_userCustomThankYou.isScoreInURL != -1) {
    return _userCustomThankYou.isScoreInURL;
  }
  
  return _customThankYou.isScoreInURL;
}

- (int)isDetractorCommentInURL {
  if (_userCustomThankYou.isDetractorCommentInURL != -1) {
    return _userCustomThankYou.isDetractorCommentInURL;
  }
  
  return _customThankYou.isDetractorCommentInURL;
}

- (int)isPassiveCommentInURL {
  if (_userCustomThankYou.isPassiveCommentInURL != -1) {
    return _userCustomThankYou.isPassiveCommentInURL;
  }
  
  return _customThankYou.isPassiveCommentInURL;
}

- (int)isPromoterCommentInURL {
  if (_userCustomThankYou.isPromoterCommentInURL != -1) {
    return _userCustomThankYou.isPromoterCommentInURL;
  }
  
  return _customThankYou.isPromoterCommentInURL;
}

- (int)isCommentInURL {
  if (_userCustomThankYou.isCommentInURL != -1) {
    return _userCustomThankYou.isCommentInURL;
  }
  
  return _customThankYou.isCommentInURL;
}

- (NSString *)detractorThankYouMain {
  if (_userCustomThankYou.detractorThankYouMain) {
    return _userCustomThankYou.detractorThankYouMain;
  }
  
  return _customThankYou.detractorThankYouMain;
}

- (NSString *)passiveThankYouMain {
  if (_userCustomThankYou.passiveThankYouMain) {
    return _userCustomThankYou.passiveThankYouMain;
  }
  
  return _customThankYou.passiveThankYouMain;
}

- (NSString *)promoterThankYouMain {
  if (_userCustomThankYou.promoterThankYouMain) {
    return _userCustomThankYou.promoterThankYouMain;
  }
  
  return _customThankYou.promoterThankYouMain;
}

- (NSString *)thankYouMain {
  if (_userCustomThankYou.thankYouMain) {
    return _userCustomThankYou.thankYouMain;
  }
  
  return _customThankYou.thankYouMain;
}

- (NSString *)detractorThankYouSetup {
  if (_userCustomThankYou.detractorThankYouSetup) {
    return _userCustomThankYou.detractorThankYouSetup;
  }
  
  return _customThankYou.detractorThankYouSetup;
}

- (NSString *)passiveThankYouSetup {
  if (_userCustomThankYou.passiveThankYouSetup) {
    return _userCustomThankYou.passiveThankYouSetup;
  }
  
  return _customThankYou.passiveThankYouSetup;
}

- (NSString *)promoterThankYouSetup {
  if (_userCustomThankYou.promoterThankYouSetup) {
    return _userCustomThankYou.promoterThankYouSetup;
  }
  
  return _customThankYou.promoterThankYouSetup;
}

- (NSString *)thankYouSetup {
  if (_userCustomThankYou.thankYouSetup) {
    return _userCustomThankYou.thankYouSetup;
  }
  
  return _customThankYou.thankYouSetup;
}

- (NSString *)detractorThankYouLinkText {
  if (_userCustomThankYou.detractorThankYouLinkText) {
    return _userCustomThankYou.detractorThankYouLinkText;
  }
  
  return _customThankYou.detractorThankYouLinkText;
}

- (NSString *)passiveThankYouLinkText {
  if (_userCustomThankYou.passiveThankYouLinkText) {
    return _userCustomThankYou.passiveThankYouLinkText;
  }
  
  return _customThankYou.passiveThankYouLinkText;
}

- (NSString *)promoterThankYouLinkText {
  if (_userCustomThankYou.promoterThankYouLinkText) {
    return _userCustomThankYou.promoterThankYouLinkText;
  }
  
  return _customThankYou.promoterThankYouLinkText;
}

- (NSString *)thankYouLinkText {
  if (_userCustomThankYou.thankYouLinkText) {
    return _userCustomThankYou.thankYouLinkText;
  }
  
  return _customThankYou.thankYouLinkText;
}

- (NSURL *)detractorThankYouLinkURL {
  if (_userCustomThankYou.detractorThankYouLinkURL) {
    return _userCustomThankYou.detractorThankYouLinkURL;
  }
  
  return _customThankYou.detractorThankYouLinkURL;
}

- (NSURL *)passiveThankYouLinkURL {
  if (_userCustomThankYou.passiveThankYouLinkURL) {
    return _userCustomThankYou.passiveThankYouLinkURL;
  }
  
  return _customThankYou.passiveThankYouLinkURL;
}

- (NSURL *)promoterThankYouLinkURL {
  if (_userCustomThankYou.promoterThankYouLinkURL) {
    return _userCustomThankYou.promoterThankYouLinkURL;
  }
  
  return _customThankYou.promoterThankYouLinkURL;
}

- (NSURL *)thankYouLinkURL {
  if (_userCustomThankYou.thankYouLinkURL) {
    return _userCustomThankYou.thankYouLinkURL;
  }
  
  return _customThankYou.thankYouLinkURL;
}

- (NSURL *)detractorThankYouLinkURLWithScore:(int)score text:(NSString *)text email:(NSString *)email {
  if (_userCustomThankYou.detractorThankYouLinkURL) {
    return [self url:_userCustomThankYou.detractorThankYouLinkURL withScore:score comment:text email:email];
  }
  
  return [self url:_customThankYou.detractorThankYouLinkURL withScore:score comment:text email:email];
}

- (NSURL *)passiveThankYouLinkURLWithScore:(int)score text:(NSString *)text email:(NSString *)email {
  if (_userCustomThankYou.passiveThankYouLinkURL) {
    return [self url:_userCustomThankYou.passiveThankYouLinkURL withScore:score comment:text email:email];
  }
  
  return [self url:_customThankYou.passiveThankYouLinkURL withScore:score comment:text email:email];
}
- (NSURL *)promoterThankYouLinkURLWithScore:(int)score text:(NSString *)text email:(NSString *)email {
  if (_userCustomThankYou.promoterThankYouLinkURL) {
    return [self url:_userCustomThankYou.promoterThankYouLinkURL withScore:score comment:text email:email];
  }
  
  return [self url:_customThankYou.promoterThankYouLinkURL withScore:score comment:text email:email];
}
- (NSURL *)thankYouLinkURLWithScore:(int)score text:(NSString *)text email:(NSString *)email {
  if (_userCustomThankYou.thankYouLinkURL) {
    return [self url:_userCustomThankYou.thankYouLinkURL withScore:score comment:text email:email];
  }
  
  return [self url:_customThankYou.thankYouLinkURL withScore:score comment:text email:email];
}

- (BOOL)detractorOrDefaultURL {
  return ([self detractorURL] || [self defaultURL]);
}

- (BOOL)detractorOrDefaultText {
  return ([self detractorText] || [self defaultText]);
}

- (BOOL)passiveOrDefaultURL {
  return ([self passiveURL] || [self defaultURL]);
}

- (BOOL)passiveOrDefaultText {
  return ([self passiveText] || [self defaultText]);
}

- (BOOL)promoterOrDefaultURL {
  return ([self promoterURL] || [self defaultURL]);
}

- (BOOL)promoterOrDefaultText {
  return ([self promoterText] || [self defaultText]);
}

- (BOOL)detractorURL {
  return (_customThankYou.detractorThankYouLinkURL || _userCustomThankYou.detractorThankYouLinkURL);
}

- (BOOL)passiveURL {
  return (_customThankYou.passiveThankYouLinkURL || _userCustomThankYou.passiveThankYouLinkURL);
}

- (BOOL)promoterURL {
  return (_customThankYou.promoterThankYouLinkURL || _userCustomThankYou.promoterThankYouLinkURL);
}

- (BOOL)defaultURL {
  return (_customThankYou.thankYouLinkURL || _userCustomThankYou.thankYouLinkURL);
}

- (BOOL)detractorText {
  return (_customThankYou.detractorThankYouLinkText || _userCustomThankYou.detractorThankYouLinkText);
}

- (BOOL)passiveText {
  return (_customThankYou.passiveThankYouLinkText || _userCustomThankYou.passiveThankYouLinkText);
}

- (BOOL)promoterText {
  return (_customThankYou.promoterThankYouLinkText || _userCustomThankYou.promoterThankYouLinkText);
}

- (BOOL)defaultText {
  return (_customThankYou.thankYouLinkText || _userCustomThankYou.thankYouLinkText);
}

- (void)setTwitterHandler:(NSString *)twitterHandler {
  [_userCustomSocial setTwitterHandler:twitterHandler];
}

- (void)setFacebookPage:(NSURL *)facebookPage {
  [_userCustomSocial setFacebookPage:facebookPage];
}

- (NSString *)twitterHandler {
  if (_userCustomSocial.twitterHandler) {
    return _userCustomSocial.twitterHandler;
  }
  return _customSocial.twitterHandler;
}

- (NSURL *)facebookPage {
  if (_userCustomSocial.facebookPage) {
    return _userCustomSocial.facebookPage;
  }
  return _customSocial.facebookPage;
}

- (BOOL)twitterHandlerSet {
  return !!(_customSocial.twitterHandler || _userCustomSocial.twitterHandler);
}

- (BOOL)facebookPageSet {
  return !!(_customSocial.facebookPage || _userCustomSocial.facebookPage);
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

- (void)setCustomTimeDelay:(NSInteger)customTimeDelay {
  _timeDelay = customTimeDelay < 0 ? 0 : customTimeDelay;
}

- (void)setCustomSurveyTypeScale:(NSInteger)customSurveyTypeScale {
  _surveyTypeScale = customSurveyTypeScale < 0 ? 0 : customSurveyTypeScale;
}

- (BOOL)validEmailString {
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return !([[_endUserEmail stringByTrimmingCharactersInSet:set] length] == 0);
}

- (NSURL *)url:(NSURL *)baseUrl withScore:(int)score comment:(NSString *)comment email:(NSString *)email {
  NSMutableString *paramsString = [NSMutableString new];
  NSString *escapedText = [comment stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  
  if (!escapedText) {
    escapedText = @"";
  }
  
  if ([self thankYouLinkShouldIncludeEmailDependingOnScore:score] == 1) {
    [paramsString appendString:[NSString stringWithFormat:@"wootric_email=%@", email]];
  }
  
  if ([self thankYouLinkShouldIncludeScoreDependingOnScore:score] == 1) {
    if (paramsString.length == 0) {
      [paramsString appendString:[NSString stringWithFormat:@"wootric_score=%i", score]];
    } else {
      [paramsString appendString:[NSString stringWithFormat:@"&wootric_score=%i", score]];
    }
  }
  
  if ([self thankYouLinkShouldIncludeCommentDependingOnScore:score] == 1) {
    if (paramsString.length == 0) {
      [paramsString appendString:[NSString stringWithFormat:@"wootric_comment=%@", escapedText]];
    } else {
      [paramsString appendString:[NSString stringWithFormat:@"&wootric_comment=%@", escapedText]];
    }
  }
  
  if (paramsString.length > 0) {
    if ([[baseUrl absoluteString] rangeOfString:@"?"].location == NSNotFound) {
      return [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", baseUrl, paramsString]];
    } else {
      return [NSURL URLWithString:[NSString stringWithFormat:@"%@&%@", baseUrl, paramsString]];
    }
  } else {
    return baseUrl;
  }
}

- (id)copyWithZone:(NSZone *)zone {
  WTRSettings *settingsCopy = [[WTRSettings allocWithZone:zone] init];

  settingsCopy.endUserEmail = self.endUserEmail;
  settingsCopy.originURL = self.originURL;
  settingsCopy.productName = self.productName;
  settingsCopy.customProductName = self.customProductName;
  settingsCopy.languageCode = self.languageCode;
  settingsCopy.surveyType = self.surveyType;
  settingsCopy.eventName = self.eventName;
  settingsCopy.surveyTypeScale = self.surveyTypeScale;
  settingsCopy.scale = self.scale;
  settingsCopy.customAudience = self.customAudience;
  settingsCopy.customFinalThankYou = self.customFinalThankYou;
  settingsCopy.customQuestion = self.customQuestion;
  settingsCopy.externalId = self.externalId;
  settingsCopy.phoneNumber = self.phoneNumber;
  settingsCopy.registeredPercentage = self.registeredPercentage;
  settingsCopy.visitorPercentage = self.visitorPercentage;
  settingsCopy.resurveyThrottle = self.resurveyThrottle;
  settingsCopy.declineResurveyThrottle = self.declineResurveyThrottle;
  settingsCopy.dailyResponseCap = self.dailyResponseCap;
  settingsCopy.externalCreatedAt = self.externalCreatedAt;
  settingsCopy.firstSurveyAfter = self.firstSurveyAfter;
  settingsCopy.customProperties = self.customProperties;
  settingsCopy.surveyedDefaultDuration = self.surveyedDefaultDuration;
  settingsCopy.surveyedDefaultDurationDecline = self.surveyedDefaultDurationDecline;
  settingsCopy.timeDelay = self.timeDelay;
  settingsCopy.surveyImmediately = self.surveyImmediately;
  settingsCopy.forceSurvey = self.forceSurvey;
  settingsCopy.showOptOut = self.showOptOut;
  settingsCopy.setDefaultAfterSurvey = self.setDefaultAfterSurvey;
  settingsCopy.skipFeedbackScreen = self.skipFeedbackScreen;
  settingsCopy.skipFeedbackScreenForPromoter = self.skipFeedbackScreenForPromoter;
  settingsCopy.passScoreAndTextToURL = self.passScoreAndTextToURL;
  settingsCopy.sendButtonBackgroundColor = self.sendButtonBackgroundColor;
  settingsCopy.sliderColor = self.sliderColor;
  settingsCopy.socialSharingColor = self.socialSharingColor;
  
  settingsCopy.localizedTexts = [self.localizedTexts copy];
  settingsCopy.customMessages = [self.customMessages copy];
  settingsCopy.customThankYou = [self.customThankYou copy];
  settingsCopy.customSocial = [self.customSocial copy];
  settingsCopy.userCustomMessages = [self.userCustomMessages copy];
  settingsCopy.userCustomThankYou = [self.userCustomThankYou copy];
  settingsCopy.userCustomSocial = [self.userCustomSocial copy];
  
  return settingsCopy;
}

@end

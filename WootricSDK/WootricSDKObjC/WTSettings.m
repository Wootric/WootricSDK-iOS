//
//  WTSettings.m
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

#import "WTSettings.h"

@implementation WTSettings

- (instancetype)init {
  if (self = [super init]) {
    _setDefaultAfterSurvey = YES;
    _surveyedDefaultDuration = 90;
    _firstSurveyAfter = 31;
    _tintColorCircle = [UIColor colorWithRed:236.0/255.0 green:104.0/255.0 blue:149.0/255.0 alpha:1];
    _tintColorSubmit = [UIColor colorWithRed:145.0/255.0 green:201.0/255.0 blue:29.0/255.0 alpha:1];
    _language = @"en";
    _defaultWootricQuestion = @"How likely are you to recommend us to a friend or co-worker?";
    _defaultResponseQuestion = @"Thank you! Care to tell us why?";
    _defaultPlaceholderText = @"Help us by explaining your score.";
  }
  return self;
}

- (void)userSettingsFromEligibility:(NSDictionary *)eligibilitySettings {
  NSDictionary *settings = eligibilitySettings[@"settings"];
  NSDictionary *messages = settings[@"messages"];

  if ([settings[@"language"] integerValue] && !_language) {
    _language = [self countryCodeFromLanguageNumber:[settings[@"language"] integerValue]];
  }

  if (messages[@"followup_question"] && !_customQuestion) {
    _customQuestion = messages[@"followup_question"];
  }

  if (messages[@"followup_questions_list"]) {
    NSDictionary *question_list = messages[@"followup_questions_list"];

    if (question_list[@"detractor_question"] && !_detractorQuestion) {
      _detractorQuestion = question_list[@"detractor_question"];
    }

    if (question_list[@"passive_question"] && !_passiveQuestion) {
      _passiveQuestion = question_list[@"passive_question"];
    }

    if (question_list[@"promoter_question"] && !_promoterQuestion) {
      _promoterQuestion = question_list[@"promoter_question"];
    }
  }

  if (messages[@"placeholder_text"] && !_customPlaceholder) {
    _customPlaceholder = messages[@"followup_question"];
  }

  if (messages[@"placeholder_texts_list"]) {
    NSDictionary *placeholder_list = messages[@"placeholder_texts_list"];

    if (placeholder_list[@"detractor_text"] && !_detractorPlaceholder) {
      _detractorPlaceholder = placeholder_list[@"detractor_text"];
    }

    if (placeholder_list[@"passive_text"] && !_passivePlaceholder) {
      _passivePlaceholder = placeholder_list[@"passive_text"];
    }

    if (placeholder_list[@"promoter_text"] && !_promoterPlaceholder) {
      _promoterPlaceholder = placeholder_list[@"promoter_text"];
    }
  }

  if (messages[@"wootric_recommend_target"] && !_wootricRecommendTo) {
    _wootricRecommendTo = messages[@"wootric_recommend_target"];
  }

  if (settings[@"product_name"] && !_wootricRecommendProduct) {
    _wootricRecommendProduct = settings[@"product_name"];
  }
}

- (NSString *)countryCodeFromLanguageNumber:(NSInteger)languageNumber {
  switch (languageNumber) {
  case 0:
    return @"cn_s";
  case 1:
    return @"cn_t";
  case 2:
    return @"nl";
  case 3:
    return @"en";
  case 4:
    return @"fr";
  case 5:
    return @"de";
  case 6:
    return @"it";
  case 7:
    return @"jp";
  case 8:
    return @"pl";
  case 9:
    return @"pt";
  case 10:
    return @"es";
  case 11:
    return @"tr";
  case 12:
    return @"vn";
  case 13:
    return @"ru";
  case 14:
    return @"sv";

  default:
    return @"en";
  }
}

- (void)dealloc {
  NSLog(@"Settings dealloc");
}

@end
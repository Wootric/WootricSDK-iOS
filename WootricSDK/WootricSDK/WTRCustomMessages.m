//
//  WTRCustomMessages.m
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

#import "WTRCustomMessages.h"

@implementation WTRCustomMessages

- (instancetype)initWithCustomMessages:(NSDictionary *)customMessages {
  if (self = [super init]) {
    NSDictionary *followupQuestionList = customMessages[@"followup_questions_list"];
    NSDictionary *placeholderTextList = customMessages[@"placeholder_texts_list"];
    NSDictionary *driverPicklistList = customMessages[@"driver_picklist"];
    NSDictionary *driverPicklistSettingsList = customMessages[@"driver_picklist_settings_list"];

    if (customMessages[@"followup_question"]) {
      _followupQuestion = customMessages[@"followup_question"];
    }

    if (customMessages[@"placeholder_text"]) {
      _followupText = customMessages[@"placeholder_text"];
    }
    
    if (customMessages[@"picklist"]) {
      _driverPicklist = customMessages[@"picklist"];
    }

    if (customMessages[@"driver_picklist_settings"]) {
      _driverPicklistSettings = customMessages[@"driver_picklist_settings"];
    }

    if (followupQuestionList) {
      _detractorQuestion = followupQuestionList[@"detractor_question"];
      _passiveQuestion = followupQuestionList[@"passive_question"];
      _promoterQuestion = followupQuestionList[@"promoter_question"];
    }

    if (placeholderTextList) {
      _detractorText = placeholderTextList[@"detractor_text"];
      _passiveText = placeholderTextList[@"passive_text"];
      _promoterText = placeholderTextList[@"promoter_text"];
    }
    
    if (driverPicklistList) {
      _detractorPicklist = driverPicklistList[@"detractor_picklist"];
      _passivePicklist = driverPicklistList[@"passive_picklist"];
      _promoterPicklist = driverPicklistList[@"promoter_picklist"];
    }

    if (driverPicklistSettingsList) {
      _detractorPicklistSettings = driverPicklistSettingsList[@"detractor"];
      _passivePicklistSettings = driverPicklistSettingsList[@"passive"];
      _promoterPicklistSettings = driverPicklistSettingsList[@"promoter"];
    }
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  WTRCustomMessages *customMessagesCopy = [[WTRCustomMessages allocWithZone:zone] init];
  customMessagesCopy.followupQuestion = self.followupQuestion;
  customMessagesCopy.detractorQuestion = self.detractorQuestion;
  customMessagesCopy.passiveQuestion = self.passiveQuestion;
  customMessagesCopy.promoterQuestion = self.promoterQuestion;
  customMessagesCopy.followupText = self.followupText;
  customMessagesCopy.detractorText = self.detractorText;
  customMessagesCopy.passiveText = self.passiveText;
  customMessagesCopy.promoterText = self.promoterText;
  customMessagesCopy.driverPicklist = self.driverPicklist;
  customMessagesCopy.detractorPicklist = self.detractorPicklist;
  customMessagesCopy.passivePicklist = self.passivePicklist;
  customMessagesCopy.promoterPicklist = self.promoterPicklist;
  customMessagesCopy.driverPicklistSettings = self.driverPicklistSettings;
  customMessagesCopy.detractorPicklistSettings = self.detractorPicklistSettings;
  customMessagesCopy.passivePicklistSettings = self.passivePicklistSettings;
  customMessagesCopy.promoterPicklistSettings = self.promoterPicklistSettings;
  return customMessagesCopy;
}
@end

//
//  WTRCustomMessages.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 07/09/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import "WTRCustomMessages.h"

@implementation WTRCustomMessages

- (instancetype)initWithCustomMessages:(NSDictionary *)customMessages {
  if (self = [super init]) {
    NSDictionary *followupQuestionList = customMessages[@"followup_question_list"];
    NSDictionary *placeholderTextList = customMessages[@"placeholder_texts_list"];

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
  }
  return self;
}

@end

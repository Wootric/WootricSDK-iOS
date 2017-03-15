//
//  WTRLocalizedTexts.m
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

#import "WTRLocalizedTexts.h"
#import "WTRApiClient.h"

@implementation WTRLocalizedTexts

- (instancetype)initWithLocalizedTexts:(NSDictionary *)localizedTexts {
  if (self = [super init]) {
    _question = localizedTexts[@"nps_question"];
    _likelyAnchor = localizedTexts[@"anchors"][@"likely"];
    _notLikelyAnchor = localizedTexts[@"anchors"][@"not_likely"];
    _followupQuestion = localizedTexts[@"followup_question"];
    _followupPlaceholder = localizedTexts[@"followup_placeholder"];
    _finalThankYou = localizedTexts[@"final_thank_you"];
    _send = localizedTexts[@"send"];
    _dismiss = localizedTexts[@"dismiss"];
    _editScore = localizedTexts[@"edit_score"];
    _socialShareQuestion = localizedTexts[@"social_share"][@"question"];
    _socialShareDecline = localizedTexts[@"social_share"][@"decline"];
      
    WTRApiClient *apiClient = [WTRApiClient sharedInstance];
    if ([apiClient.settings.surveyType isEqualToString:@"CES"]) {
      _question = localizedTexts[@"ces_question"];
      _likelyAnchor = localizedTexts[@"ces_anchors"][@"very_easy"];
      _notLikelyAnchor = localizedTexts[@"ces_anchors"][@"very_difficult"];
    } else if ([apiClient.settings.surveyType isEqualToString:@"CSAT"]) {
      _question = localizedTexts[@"csat_question"];
      _likelyAnchor = localizedTexts[@"csat_anchors"][@"very_satisfied"];
      _notLikelyAnchor = localizedTexts[@"csat_anchors"][@"very_unsatisfied"];
    }
  }
  return self;
}

@end

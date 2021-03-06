//
//  WTRCustomThankYou.m
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

#import "WTRCustomThankYou.h"

@implementation WTRCustomThankYou

- (instancetype)initWithCustomThankYou:(NSDictionary *)customThankYou {
  if (self = [super init]) {
    NSDictionary *thankYouMessages = customThankYou[@"thank_you_messages"];
    NSDictionary *thankYouLinks = customThankYou[@"thank_you_links"];

    if (thankYouMessages) {
      _thankYouSetup = thankYouMessages[@"thank_you_setup"] ? thankYouMessages[@"thank_you_setup"] : nil;
      if (thankYouMessages[@"thank_you_main"]) {
        _thankYouMain = thankYouMessages[@"thank_you_main"];
      } else {
        _detractorThankYouMain = thankYouMessages[@"thank_you_main_list"][@"detractor_thank_you_main"];
        _detractorThankYouSetup = thankYouMessages[@"thank_you_setup_list"][@"detractor_thank_you_setup"];
        _passiveThankYouMain = thankYouMessages[@"thank_you_main_list"][@"passive_thank_you_main"];
        _passiveThankYouSetup = thankYouMessages[@"thank_you_setup_list"][@"passive_thank_you_setup"];
        _promoterThankYouMain = thankYouMessages[@"thank_you_main_list"][@"promoter_thank_you_main"];
        _promoterThankYouSetup = thankYouMessages[@"thank_you_setup_list"][@"promoter_thank_you_setup"];
      }
    }

    if (thankYouLinks) {
      if (thankYouLinks[@"thank_you_link_text"] && thankYouLinks[@"thank_you_link_url"]) {
        _thankYouLinkText = thankYouLinks[@"thank_you_link_text"];
        _thankYouLinkURL = [NSURL URLWithString:thankYouLinks[@"thank_you_link_url"]];
        _isEmailInURL = [thankYouLinks[@"thank_you_link_url_settings"][@"add_email_param_to_url"] intValue];
        _isScoreInURL = [thankYouLinks[@"thank_you_link_url_settings"][@"add_score_param_to_url"] intValue];
        _isCommentInURL = [thankYouLinks[@"thank_you_link_url_settings"][@"add_comment_param_to_url"] intValue];
      } else {
        NSDictionary *thankYouLinkUrlSettingsList = thankYouLinks[@"thank_you_link_url_settings_list"];
        NSDictionary *detractorThankYouLinkUrlSettings = thankYouLinkUrlSettingsList[@"detractor_thank_you_link_url_settings"];
        NSDictionary *passiveThankYouLinkUrlSettings = thankYouLinkUrlSettingsList[@"passive_thank_you_link_url_settings"];
        NSDictionary *promoterThankYouLinkUrlSettings = thankYouLinkUrlSettingsList[@"promoter_thank_you_link_url_settings"];
        
        _detractorThankYouLinkText = thankYouLinks[@"thank_you_link_text_list"][@"detractor_thank_you_link_text"];
        _detractorThankYouLinkURL = [NSURL URLWithString:thankYouLinks[@"thank_you_link_url_list"][@"detractor_thank_you_link_url"]];
        _isDetractorEmailInURL = [detractorThankYouLinkUrlSettings[@"add_email_param_to_url"] intValue];
        _isDetractorScoreInURL = [detractorThankYouLinkUrlSettings[@"add_score_param_to_url"] intValue];
        _isDetractorCommentInURL = [detractorThankYouLinkUrlSettings[@"add_comment_param_to_url"] intValue];
        
        _passiveThankYouLinkText = thankYouLinks[@"thank_you_link_text_list"][@"passive_thank_you_link_text"];
        _passiveThankYouLinkURL = [NSURL URLWithString:thankYouLinks[@"thank_you_link_url_list"][@"passive_thank_you_link_url"]];
        _isPassiveEmailInURL = [passiveThankYouLinkUrlSettings[@"add_email_param_to_url"] intValue];
        _isPassiveScoreInURL = [passiveThankYouLinkUrlSettings[@"add_score_param_to_url"] intValue];
        _isPassiveCommentInURL = [passiveThankYouLinkUrlSettings[@"add_comment_param_to_url"] intValue];
        
        _promoterThankYouLinkText = thankYouLinks[@"thank_you_link_text_list"][@"promoter_thank_you_link_text"];
        _promoterThankYouLinkURL = [NSURL URLWithString:thankYouLinks[@"thank_you_link_url_list"][@"promoter_thank_you_link_url"]];
        _isPromoterEmailInURL = [promoterThankYouLinkUrlSettings[@"add_email_param_to_url"] intValue];
        _isPromoterScoreInURL = [promoterThankYouLinkUrlSettings[@"add_score_param_to_url"] intValue];
        _isPromoterCommentInURL = [promoterThankYouLinkUrlSettings[@"add_comment_param_to_url"] intValue];
      }
    }
  }
  return self;
}

- (BOOL)hasShareConfiguration {
  return (_promoterThankYouLinkText && _promoterThankYouLinkURL);
}

- (id)copyWithZone:(NSZone *)zone {
  WTRCustomThankYou *customThankYouCopy = [[WTRCustomThankYou allocWithZone:zone] init];
  customThankYouCopy.thankYouMain = self.thankYouMain;
  customThankYouCopy.thankYouSetup = self.thankYouSetup;
  customThankYouCopy.detractorThankYouMain = self.detractorThankYouMain;
  customThankYouCopy.detractorThankYouSetup = self.detractorThankYouSetup;
  customThankYouCopy.passiveThankYouMain = self.passiveThankYouMain;
  customThankYouCopy.passiveThankYouSetup = self.passiveThankYouSetup;
  customThankYouCopy.promoterThankYouMain = self.promoterThankYouMain;
  customThankYouCopy.promoterThankYouSetup = self.promoterThankYouSetup;
  customThankYouCopy.thankYouLinkText = self.thankYouLinkText;
  customThankYouCopy.thankYouLinkURL = self.thankYouLinkURL;
  customThankYouCopy.detractorThankYouLinkText = self.detractorThankYouLinkText;
  customThankYouCopy.detractorThankYouLinkURL = self.detractorThankYouLinkURL;
  customThankYouCopy.passiveThankYouLinkText = self.passiveThankYouLinkText;
  customThankYouCopy.passiveThankYouLinkURL = self.passiveThankYouLinkURL;
  customThankYouCopy.promoterThankYouLinkText = self.promoterThankYouLinkText;
  customThankYouCopy.promoterThankYouLinkURL = self.promoterThankYouLinkURL;
  customThankYouCopy.isEmailInURL = self.isEmailInURL;
  customThankYouCopy.isDetractorEmailInURL = self.isDetractorEmailInURL;
  customThankYouCopy.isPassiveEmailInURL = self.isPassiveEmailInURL;
  customThankYouCopy.isPromoterEmailInURL = self.isPromoterEmailInURL;
  customThankYouCopy.isScoreInURL = self.isScoreInURL;
  customThankYouCopy.isDetractorScoreInURL = self.isDetractorScoreInURL;
  customThankYouCopy.isPassiveScoreInURL = self.isPassiveScoreInURL;
  customThankYouCopy.isPromoterScoreInURL = self.isPromoterScoreInURL;
  customThankYouCopy.isCommentInURL = self.isCommentInURL;
  customThankYouCopy.isDetractorCommentInURL = self.isDetractorCommentInURL;
  customThankYouCopy.isPassiveCommentInURL = self.isPassiveCommentInURL;
  customThankYouCopy.isPromoterCommentInURL = self.isPromoterCommentInURL;
  return customThankYouCopy;
}
@end

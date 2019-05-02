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
      } else {
        _detractorThankYouLinkText = thankYouLinks[@"thank_you_link_text_list"][@"detractor_thank_you_link_text"];
        _detractorThankYouLinkURL = [NSURL URLWithString:thankYouLinks[@"thank_you_link_url_list"][@"detractor_thank_you_link_url"]];
        _passiveThankYouLinkText = thankYouLinks[@"thank_you_link_text_list"][@"passive_thank_you_link_text"];
        _passiveThankYouLinkURL = [NSURL URLWithString:thankYouLinks[@"thank_you_link_url_list"][@"passive_thank_you_link_url"]];
        _promoterThankYouLinkText = thankYouLinks[@"thank_you_link_text_list"][@"promoter_thank_you_link_text"];
        _promoterThankYouLinkURL = [NSURL URLWithString:thankYouLinks[@"thank_you_link_url_list"][@"promoter_thank_you_link_url"]];
      }
    }
  }
  return self;
}

- (BOOL)hasShareConfiguration {
  return (_promoterThankYouLinkText && _promoterThankYouLinkURL);
}

@end

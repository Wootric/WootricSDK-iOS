//
//  WTRSurvey.m
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

#import "WTRSurvey.h"
#import "WTRApiClient.h"
#import "WTRDefaults.h"

@interface WTRSurvey ()

@property (nonatomic, strong) WTRApiClient *apiClient;

@end

@implementation WTRSurvey

- (instancetype)init {
  if (self = [super init]) {
    _apiClient = [WTRApiClient sharedInstance];
  }
  return self;
}

- (void)endUserDeclined {
  [[WTRApiClient sharedInstance] endUserDeclined];
  [WTRDefaults setSurveyed];
}

- (void)endUserVotedWithScore:(NSInteger)score andText:(NSString *)text {
  [[WTRApiClient sharedInstance] endUserVotedWithScore:score andText:text];
  [WTRDefaults setSurveyed];
}

- (void)survey:(void (^)())showSurvey {
  [WTRDefaults setLastSeenAt];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  if (_apiClient.settings.forceSurvey || [self needsSurvey]) {
    [_apiClient checkEligibility:^{
      [_apiClient authenticate:^{
        showSurvey();
      }];
    }];
  }
}

- (BOOL)needsSurvey {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults boolForKey:@"surveyed"]) {
    return NO;
  } else {
    if (_apiClient.settings.firstSurveyAfter != 0) {
      NSInteger age = [[NSDate date] timeIntervalSince1970] - _apiClient.settings.externalCreatedAt;
      if (age > (_apiClient.settings.firstSurveyAfter * 60 * 60 * 24)) {
        return YES;
      } else {
        if (([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"lastSeenAt"]) >= (_apiClient.settings.firstSurveyAfter * 60 * 60 * 24)) {
          return YES;
        }
      }
    } else {
      return YES;
    }
  }
  return NO;
}

@end

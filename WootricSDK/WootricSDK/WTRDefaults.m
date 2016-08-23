//
//  WTRDefaults.m
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

#define DAYS_IN_MILLIS 60 * 60 * 24

#import "WTRDefaults.h"
#import "WTRApiClient.h"

@implementation WTRDefaults

+ (void)setLastSeenAt {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults doubleForKey:@"lastSeenAt"] == 0) {
    [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"lastSeenAt"];
  } else {
    double ninetyDaysTimestamp = 90 * DAYS_IN_MILLIS;
    if ([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"lastSeenAt"] >= ninetyDaysTimestamp) {
      [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"lastSeenAt"];
    }
  }
}

+ (void)setSurveyedWithType:(NSString *)type {
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];

  if (apiClient.settings.setDefaultAfterSurvey) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setBool:YES forKey:@"surveyed"];
    [defaults setObject:type forKey:@"type"];
    if([type isEqualToString:@"decline"]){
      [defaults setInteger:apiClient.settings.surveyedDefaultDurationDecline forKey:@"resurvey_days"];;
    } else {
      [defaults setInteger:apiClient.settings.surveyedDefaultDuration forKey:@"resurvey_days"];
    }
    [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"surveyedAt"];
  }
}

+ (void)checkIfSurveyedDefaultExpired {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  
  double surveyedDurationTimestamp = apiClient.settings.surveyedDefaultDuration;
  if ([defaults objectForKey:@"resurvey_days"] && [defaults integerForKey:@"resurvey_days"] >= 0) {
    surveyedDurationTimestamp = [defaults integerForKey:@"resurvey_days"];
  } else if([[defaults objectForKey:@"type"] isEqualToString:@"decline"]){
    surveyedDurationTimestamp = apiClient.settings.surveyedDefaultDurationDecline;
  }
  
  surveyedDurationTimestamp = surveyedDurationTimestamp * DAYS_IN_MILLIS;
  
  if ([[NSDate date] timeIntervalSince1970] - [defaults doubleForKey:@"surveyedAt"] >= surveyedDurationTimestamp) {
    [defaults setBool:NO forKey:@"surveyed"];
    [defaults setInteger:-1 forKey:@"resurvey_days"];
  }
}

@end

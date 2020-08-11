//
//  WTREvent.m
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

#import "WTREvent.h"
#import "WTRApiClient.h"
#import "WTRLogger.h"

@interface WTREvent ()

@property (nonatomic, copy) void (^completion)(WTRSettings *settings);
@property (nonatomic, strong) NSDictionary *request;
@property (nonatomic, strong) NSArray *eventList;

@end

@implementation WTREvent

#pragma mark - Init

- (instancetype)initWithRequest:(NSDictionary *)request eventList:(NSArray *)eventList completion:(void (^)(WTRSettings *settings))completion {
  self = [super init];
  if (self) {
    self.request = request;
    self.eventList = eventList;
    self.completion = completion;
    self.name = @"Wootric-Event";
  }
  return self;
}

#pragma mark - Start

- (void)start {
  [super start];
  
  if ([self isCancelled]) { return; }
  
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.clientID = [self.request valueForKey:@"clientID"];
  apiClient.clientSecret = [self.request valueForKey:@"clientSecret"];
  apiClient.accountToken = [self.request valueForKey:@"accountToken"];
  apiClient.settings = [self.request valueForKey:@"settings"];
  
  if (apiClient.settings.eventName) {
    if ([self isRegisteredEvent:apiClient.settings.eventName]) {
      [self checkEligibility:apiClient];
    } else {
      [WTRLogger logError:@"Event name not registered"];
      self.completion(nil);
      [self finish];
    }
  } else {
    [self checkEligibility:apiClient];
  }
}

- (void)checkEligibility:(WTRApiClient *)apiClient {
  [apiClient checkEligibility:^(BOOL eligible){
    if (eligible) {
      [apiClient authenticate:^(BOOL succeeded){
        self.completion(succeeded? apiClient.settings : nil);
        [self finish];
      }];
    } else {
      self.completion(nil);
      [self finish];
    }
  }];
}

- (BOOL)isRegisteredEvent:(NSString *)eventName {
  if (((int)[self.eventList indexOfObject:eventName]) == -1) {
    return NO;
  } else {
    return YES;
  }
}

#pragma mark - Cancel

- (void)cancel {
  [super cancel];
  
  [self finish];
}

@end

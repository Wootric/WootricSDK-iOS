//
//  WTRSurvey.m
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

#import "WTRSurvey.h"
#import "WTRApiClient.h"
#import "WTRDefaults.h"
#import "WTRLogger.h"
#import "WTREvent.h"
#import "WTREventListOperation.h"
#import "UIItems.h"

@interface WTRSurvey ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSArray *eventList;
@property (nonatomic, strong) WTREventListOperation *eventListOperation;

@end

@implementation WTRSurvey

+ (instancetype)sharedInstance {
  static WTRSurvey *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}

- (instancetype)init {
  if (self = [super init]) {
    [UIItems dynamicallyAddFont];
    _settings = [[WTRSettings alloc] init];
    _operationQueue = [NSOperationQueue new];
    [_operationQueue setMaxConcurrentOperationCount:1];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(applicationWillResign)
        name:UIApplicationWillResignActiveNotification
        object:nil];
  }
  return self;
}

- (void)applicationWillResign {
  if ([_operationQueue operationCount] == 0) {
    _eventListOperation = nil;
    _eventList = nil;
  }
}

- (BOOL)checkConfiguration {
  if ([_accountToken length] != 0) {
    return YES;
  }
  return NO;
}

- (void)stopSurvey {
  [self->_operationQueue cancelAllOperations];
}

- (void)endUserDeclined {
  [[WTRApiClient sharedInstance] endUserDeclined];
  [WTRDefaults setSurveyedWithType:@"decline"];
}

- (void)endUserVotedWithScore:(NSInteger)score text:(NSString *)text picklistAnswers:(NSDictionary *)picklistAnswers {
  [[WTRApiClient sharedInstance] endUserVotedWithScore:score andText:text picklistAnswers:picklistAnswers];
  [WTRDefaults setSurveyedWithType:@"response"];
}

- (void)survey:(void (^)(WTRSettings *))showSurvey {
  [WTRDefaults setLastSeenAt];
  [WTRDefaults checkIfSurveyedDefaultExpired];
  
  NSMutableDictionary *request = [NSMutableDictionary new];
  [request setValue:self.clientID forKey:@"clientID"];
  [request setValue:self.clientSecret forKey:@"clientSecret"];
  [request setValue:self.accountToken forKey:@"accountToken"];
  WTRSettings *requestSettings = [self.settings copy];
  [request setValue:requestSettings forKey:@"settings"];
  
  if (_eventListOperation == nil) {
    _eventListOperation = [[WTREventListOperation alloc] initWithAccountToken:self.accountToken completion:^(NSArray * _Nonnull eventList) {
      self.eventList = eventList;
    }];
    [_operationQueue addOperation:_eventListOperation];
  }
  
  WTREvent *event = [[WTREvent alloc] initWithRequest:request eventList:self.eventList completion:^(WTRSettings *settings) {
    if (settings != nil) {
      [self->_operationQueue cancelAllOperations];
      showSurvey(settings);
    }
  }];
  
  [event addDependency:_eventListOperation];
  [_operationQueue addOperation:event];
}

@end

//
//  WTREventListOperation.m
//  WootricSDK
//
//  Created by Diego Serrano on 3/23/20.
//  Copyright © 2020 Wootric. All rights reserved.
//

#import "WTREventListOperation.h"
#import "WTRApiClient.h"

@interface WTREventListOperation ()

@property (nonatomic, copy) void (^completion)(NSArray *eventList);
@property (nonatomic, strong) NSString *accountToken;

@end

@implementation WTREventListOperation

- (instancetype)initWithAccountToken:(NSString *)accountToken completion:(void (^)(NSArray *eventList))completion {
  self = [super init];
  if (self) {
    self.accountToken = accountToken;
    self.completion = completion;
  }
  return self;
}

- (void)start {
  [super start];
  
  WTRApiClient *apiClient = [WTRApiClient sharedInstance];
  apiClient.accountToken = self.accountToken;
  
  [apiClient getRegisteredEventList:^(NSArray *eventList){
    self.completion([NSArray arrayWithArray:eventList]);
    [self finish];
  }];
}

- (void)cancel {
  [super cancel];
  
  [self finish];
}

@end

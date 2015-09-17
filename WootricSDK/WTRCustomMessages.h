//
//  WTRCustomMessages.h
//  WootricSDK
//
//  Created by Łukasz Cichecki on 07/09/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTRCustomMessages : NSObject

@property (nonatomic, strong) NSString *detractorQuestion;
@property (nonatomic, strong) NSString *passiveQuestion;
@property (nonatomic, strong) NSString *promoterQuestion;
@property (nonatomic, strong) NSString *detractorText;
@property (nonatomic, strong) NSString *passiveText;
@property (nonatomic, strong) NSString *promoterText;

- (instancetype)initWithCustomMessages:(NSDictionary *)customMessages;

@end

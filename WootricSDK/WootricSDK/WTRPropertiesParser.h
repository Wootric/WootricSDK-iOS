//
//  WTRPropertiesParser.h
//  WootricSDK
//
//  Created by Łukasz Cichecki on 21/09/15.
//  Copyright © 2015 Wootric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTRPropertiesParser : NSObject

+ (NSString *)parseToStringFromDictionary:(NSDictionary *)dictionary;

@end

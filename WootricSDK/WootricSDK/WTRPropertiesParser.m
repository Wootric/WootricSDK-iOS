//
//  WTRPropertiesParser.m
//  WootricSDK
//
//  Created by Łukasz Cichecki on 21/09/15.
//  Copyright © 2015 Wootric. All rights reserved.
//

#import "WTRPropertiesParser.h"

@implementation WTRPropertiesParser

+ (NSString *)parseToStringFromDictionary:(NSDictionary *)dictionary {
  NSString *parsedProperties = @"";
  for (NSString *key in dictionary) {
    NSString *escapedValue = [self percentEscapeString:[NSString stringWithFormat:@"%@", [dictionary objectForKey:key]]];
    parsedProperties = [NSString stringWithFormat:@"%@&%@", parsedProperties, [NSString stringWithFormat:@"properties[%@]=%@", key, escapedValue]];
  }

  return parsedProperties;
}

+ (NSString *)percentEscapeString:(NSString *)string {
  NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                               (CFStringRef)string,
                                                                               (CFStringRef)@" ",
                                                                               (CFStringRef)@":/?@!$&'()*+,;=",
                                                                               kCFStringEncodingUTF8));
  return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

@end

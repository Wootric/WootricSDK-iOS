//
//  WTRUtils.m
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

#import "WTRUtils.h"
#import "UIItems.h"

@implementation WTRUtils

+ (NSString *)percentEscapeString:(NSString *)string {
  NSString *result = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
  result = [result stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
  return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+ (NSString *)getTokenTLD:(NSString *)aString {
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"NPS-(EU-|AU-)"
                                                                    options:0
                                                                      error:nil];
  if (aString != nil && [regex numberOfMatchesInString:aString options:0 range:NSMakeRange(0, [aString length])] > 0) {
    return [[aString substringWithRange:NSMakeRange(4, 2)] lowercaseString];
  }
  return @"com";
}

+ (NSArray *)shuffleArray:(NSArray *)array {
  int count = (int)[array count];
  NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
  for (int i = 0; i < count - 1; ++i) {
      int nElements = count - i;
      int n = arc4random_uniform(nElements) + i;
      [newArray exchangeObjectAtIndex:i withObjectAtIndex:n];
  }
  return newArray;
}

+ (CGSize)sizeForText:(NSString *)text fontSize:(int)fontSize {
  NSDictionary *attributes = @{NSFontAttributeName: [UIItems boldFontWithSize:fontSize]};
  return CGSizeMake([text sizeWithAttributes:attributes].width + 10, [text sizeWithAttributes:attributes].height + 10);
}

@end

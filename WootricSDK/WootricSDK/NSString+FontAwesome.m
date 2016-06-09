//
//  NSString+FontAwesome.m
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

#import "NSString+FontAwesome.h"

@implementation NSString (FontAwesome)

#pragma mark - Public methods

+ (FAIcon)fontAwesomeEnumForIconIdentifier:(NSString*)string {
  NSDictionary *enums = [self enumDictionary];
  return [enums[string] integerValue];
}

+ (NSString*)fontAwesomeIconStringForEnum:(FAIcon)value {
  return [NSString fontAwesomeUnicodeStrings][value];
}

+ (NSString*)fontAwesomeIconStringForIconIdentifier:(NSString*)identifier {
  return [self fontAwesomeIconStringForEnum:[self fontAwesomeEnumForIconIdentifier:identifier]];
}

#pragma mark - data structures

+ (NSArray *)fontAwesomeUnicodeStrings {
  
  static NSArray *fontAwesomeUnicodeStrings;
    
  static dispatch_once_t unicodeStringsOnceToken;
  dispatch_once(&unicodeStringsOnceToken, ^{
        
    fontAwesomeUnicodeStrings = @[@"\uf099",
                                  @"\uf09a",
                                  @"\uf081",
                                  @"\uf082",
                                  @"\uf230",
                                  @"\uf164",
                                  @"\uf087"];
  });
  
  return fontAwesomeUnicodeStrings;
}

+ (NSDictionary *)enumDictionary {
    
  static NSDictionary *enumDictionary;
    
  static dispatch_once_t enumDictionaryOnceToken;
  dispatch_once(&enumDictionaryOnceToken, ^{
        
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        
    tmp[@"fa-twitter"] = @(FATwitter);
    tmp[@"fa-facebook"] = @(FAFacebook);
    tmp[@"fa-twitter-square"] = @(FATwitterSquare);
    tmp[@"fa-facebook-square"] = @(FAFacebookSquare);
    tmp[@"fa-facebook-official"] = @(FAFacebookOfficial);
    tmp[@"fa-thumbs-up"] = @(FAThumbsUp);
    tmp[@"fa-thumbs-o-up "] = @(FAThumbsOUp);
        
      enumDictionary = tmp;
  });
    
  return enumDictionary;
}

@end

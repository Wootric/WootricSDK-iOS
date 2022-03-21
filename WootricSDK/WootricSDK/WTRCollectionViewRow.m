//
//  WTRCollectionViewRow.m
//  WootricSDK
//
//  Created by Diego Serrano on 11/16/22.
//  Copyright © 2022 Wootric. All rights reserved.
//

#import "WTRCollectionViewRow.h"

@implementation WTRCollectionViewRow

-(instancetype)initWithSpacing:(CGFloat)spacing {
  if (self = [super init]) {
    self.spacing = spacing;
    self.attributes = [NSMutableArray new];
  }
  return self;
}

-(void)addAttribute:(UICollectionViewLayoutAttributes *)attribute {
  [self.attributes addObject:attribute];
}

-(CGFloat)rowWidth {
  CGFloat result = 0;
  for (UICollectionViewLayoutAttributes* attribute in self.attributes) {
    result += attribute.frame.size.width;
  }
  return result + (self.attributes.count - 1) * self.spacing;
}

-(void)centerLayoutWithCollectionViewWidth:(CGFloat)collectionViewWidth {
  CGFloat padding = (collectionViewWidth - [self rowWidth]) / 2;
  CGFloat offset = padding;
  for (UICollectionViewLayoutAttributes* attribute in self.attributes) {
    [attribute setFrame:CGRectMake(offset, attribute.frame.origin.y, attribute.frame.size.width, attribute.frame.size.height)];
    offset += attribute.frame.size.width + self.spacing;
  }
}

@end

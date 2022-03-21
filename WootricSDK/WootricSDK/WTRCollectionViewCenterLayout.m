//
//  WTRCollectionViewCenterLayout.m
//  WootricSDK
//
//  Created by Diego Serrano on 11/16/22.
//  Copyright © 2022 Wootric. All rights reserved.
//

#import "WTRCollectionViewCenterLayout.h"
#import "WTRCollectionViewRow.h"

@implementation WTRCollectionViewCenterLayout

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
  if (!attributes) {
    return nil;
  }
  NSMutableArray *rows = [NSMutableArray new];
  NSMutableArray *mutableArray = [NSMutableArray new];
  CGFloat currentRowY = -1;
  
  for (UICollectionViewLayoutAttributes* attribute in attributes) {
    if (currentRowY != CGRectGetMidY(attribute.frame)) {
      currentRowY = CGRectGetMidY(attribute.frame);
      [rows addObject:[[WTRCollectionViewRow alloc] initWithSpacing:5.0f]];
    }
    [(WTRCollectionViewRow *)[rows lastObject] addAttribute:[attribute copy]];
  }
  for (WTRCollectionViewRow *row in rows) {
    [row centerLayoutWithCollectionViewWidth:self.collectionView.frame.size.width];
    [mutableArray addObjectsFromArray:row.attributes];
  }
  return [mutableArray copy];
}

@end

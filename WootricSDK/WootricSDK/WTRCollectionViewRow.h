//
//  WTRCollectionViewRow.h
//  WootricSDK
//
//  Created by Diego Serrano on 11/16/22.
//  Copyright © 2022 Wootric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTRCollectionViewRow : NSObject

@property CGFloat spacing;
@property(strong, nonatomic) NSMutableArray *attributes;

- (instancetype)initWithSpacing:(CGFloat)spacing;
- (void)addAttribute:(UICollectionViewLayoutAttributes *)attribute;
- (void)centerLayoutWithCollectionViewWidth:(CGFloat)collectionViewWidth;
@end

NS_ASSUME_NONNULL_END

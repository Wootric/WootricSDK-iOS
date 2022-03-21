//
//  WTRDriverPicklistCollectionViewCell.h
//  WootricSDK
//
//  Created by Diego Serrano on 8/26/22.
//  Copyright © 2022 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTRDriverPicklistCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UILabel *titleLabel;

- (void)setText:(NSString *)text;
- (BOOL)selectedValue;

@end

NS_ASSUME_NONNULL_END

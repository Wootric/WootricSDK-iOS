//
//  WTRDriverPicklistCollectionViewCell.m
//  WootricSDK
//
//  Created by Diego Serrano on 8/26/22.
//  Copyright © 2022 Wootric. All rights reserved.
//

#import "WTRDriverPicklistCollectionViewCell.h"
#import "UIItems.h"

@interface WTRDriverPicklistCollectionViewCell (){
  BOOL selected;
}

@property (nonatomic, strong) UIColor *customColor;
@end

@implementation WTRDriverPicklistCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    selected = false;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [_customColor colorWithAlphaComponent:1.0f].CGColor;
    self.contentView.clipsToBounds = YES;
    
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.font = [UIItems regularFontWithSize:14];
    _titleLabel.contentMode = UIViewContentModeScaleToFill;
    _titleLabel.autoresizesSubviews = @YES;
    _titleLabel.adjustsFontSizeToFitWidth = @NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:_titleLabel];
  }
  
  return self;
}

- (void)setText:(NSString *)text {
  NSDictionary *attributes = @{NSFontAttributeName: [UIItems regularFontWithSize:14]};
  [_titleLabel setFrame:CGRectMake(0, 0, [text sizeWithAttributes:attributes].width + 20, 29.0f)];
  _titleLabel.text = text;
  selected = false;
  self.contentView.layer.borderColor = [_customColor colorWithAlphaComponent:1.0f].CGColor;
  self.contentView.backgroundColor = [UIColor whiteColor];
  _titleLabel.textColor = self.customColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  self.customColor = backgroundColor;
  self.layer.borderColor = [self.customColor colorWithAlphaComponent:1.0f].CGColor;
  _titleLabel.textColor = self.customColor;
}

- (void)setHighlighted:(BOOL)highlighted {
  if (highlighted) {
    return;
  }
  selected = !selected;
  if (selected) {
    self.contentView.backgroundColor = self.customColor;
    _titleLabel.textColor = [UIColor whiteColor];
  } else {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [_customColor colorWithAlphaComponent:1.0f].CGColor;
    _titleLabel.textColor = self.customColor;
  }
}

- (BOOL)selectedValue {
  return selected;
}

- (void)unselect {
  selected = false;
  self.contentView.backgroundColor = [UIColor whiteColor];
  _titleLabel.textColor = self.customColor;
}

@end

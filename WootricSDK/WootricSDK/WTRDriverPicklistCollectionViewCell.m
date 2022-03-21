//
//  WTRDriverPicklistCollectionViewCell.m
//  WootricSDK
//
//  Created by Diego Serrano on 8/26/22.
//  Copyright © 2022 Wootric. All rights reserved.
//

#import "WTRDriverPicklistCollectionViewCell.h"
#import "WTRColor.h"
#import "UIItems.h"

@interface WTRDriverPicklistCollectionViewCell () {
  BOOL selected;
}

@property (nonatomic, strong) UIColor *customColor;
@end

@implementation WTRDriverPicklistCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    selected = false;
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [WTRColor wootricTextColor].CGColor;
    
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.font = [UIItems regularFontWithSize:WTRFontSize];
    _titleLabel.contentMode = UIViewContentModeScaleToFill;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    _titleLabel.adjustsFontSizeToFitWidth = @NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:_titleLabel];
    [[_titleLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor] setActive:true];
    [[_titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor] setActive:true];
    [_titleLabel setNeedsLayout];
  }
  
  return self;
}

- (void)setText:(NSString *)text {
  NSDictionary *attributes = @{NSFontAttributeName: [UIItems regularFontWithSize:WTRFontSize]};
  [_titleLabel setFrame:CGRectMake(0, 0, [text sizeWithAttributes:attributes].width, [text sizeWithAttributes:attributes].height)];
  _titleLabel.text = text;
  selected = false;
  self.contentView.backgroundColor = [UIColor whiteColor];
  self.contentView.layer.borderColor = [WTRColor wootricTextColor].CGColor;
  _titleLabel.textColor = [WTRColor wootricTextColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  self.customColor = backgroundColor;
  self.contentView.layer.borderColor = [self.customColor colorWithAlphaComponent:1.0f].CGColor;
  _titleLabel.textColor = self.customColor;
}

- (void)setHighlighted:(BOOL)highlighted {
  if (highlighted) {
    return;
  }
  selected = !selected;
  if (selected) {
    self.contentView.backgroundColor = self.customColor;
    self.contentView.layer.borderColor = self.customColor.CGColor;
    _titleLabel.textColor = [UIColor whiteColor];
  } else {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.borderColor = [WTRColor wootricTextColor].CGColor;
    _titleLabel.textColor = [WTRColor wootricTextColor];
  }
}

- (BOOL)selectedValue {
  return selected;
}

- (void)unselect {
  selected = false;
  self.contentView.backgroundColor = [UIColor whiteColor];
  self.contentView.layer.borderColor = [WTRColor wootricTextColor].CGColor;
  _titleLabel.textColor = [WTRColor wootricTextColor];
}

@end

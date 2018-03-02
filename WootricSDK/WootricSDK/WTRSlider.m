//
//  WTRSlider.m
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

#import "WTRSlider.h"
#import "WTRColor.h"
#import "UIImage+ImageFromColor.h"
#import "WTRSliderDot.h"

static const CGFloat DotRadius = 8.0;
static const CGFloat ThumbSize = 24.0;

@interface WTRSlider ()

@property (nonatomic, assign) int currentValue;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) WTRSettings *settings;


@end

@implementation WTRSlider
{
  NSArray<WTRSliderDot *> * dots;
  NSArray<UIView *> * dotSpacers;
}

- (instancetype)initWithSuperview:(UIView *)superview viewController:(UIViewController *)viewController settings:(WTRSettings *)settings  {
    return [self initWithSuperview:superview viewController:viewController settings:(WTRSettings *)settings color:[WTRColor sliderValueColor]];
}

- (instancetype)initWithSuperview:(UIView *)superview viewController:(UIViewController *)viewController settings:(WTRSettings *)settings color:(UIColor *)color {
  if (self = [super init]) {
    _settings = settings;
    _sliderColor = color;
    _currentValue = -1;
    
    self.minimumValue = [_settings minimumScore];
    self.maximumValue = [_settings maximumScore];
    self.value = [_settings minimumScore];
    self.tintColor = [WTRColor sliderBackgroundColor];
    UIImage *image = [[UIImage alloc] init];
    UIImage *greyBackground = [UIImage imageFromColor:[WTRColor sliderBackgroundColor] withSize:24];
    UIImage *selectedBackground = [UIImage imageFromColor:[_sliderColor colorWithAlphaComponent:0.65f] withSize:24];
    [self setMaximumTrackImage:[greyBackground resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
    [self setMinimumTrackImage:[selectedBackground resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
    [self setThumbImage:image forState:UIControlStateNormal];
    [self setThumbImage:image forState:UIControlStateHighlighted];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addTarget:superview action:NSSelectorFromString(@"updateSliderScore:") forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:viewController action:NSSelectorFromString(@"sliderTapped:")];
    [self addGestureRecognizer:gr];
  }
  return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
  [super trackRectForBounds:bounds];
  CGRect customBounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
  return customBounds;
}

- (void)didAddSubview:(UIView *)subview {
  if ([subview isKindOfClass:[UIImageView class]]) {
    if (!_thumbAdded) {
      [self sendSubviewToBack:subview];
      _thumbAdded = YES;
    }
  } else if ([subview isKindOfClass:[UIView class]]) {
    [self sendSubviewToBack:subview];
  }
}

- (NSUInteger) numberOfDots
{
  return (self.maximumValue - self.minimumValue + 1);
}

- (void)addDots {
  // Remove any previous dots
  [dots enumerateObjectsUsingBlock:^(WTRSliderDot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj removeFromSuperview];
  }];
  [dotSpacers enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj removeFromSuperview];
  }];
  
  // Sanity check
  NSUInteger dotCount = [self numberOfDots];
  if (dotCount < 2) {
    return;
  }
  
  NSMutableArray<WTRSliderDot *> * newDots = [[NSMutableArray alloc] initWithCapacity:dotCount];
  NSMutableArray<UIView *> * newDotSpacers = [[NSMutableArray alloc] initWithCapacity:dotCount - 1];
  
  for (NSUInteger i = 0; i < dotCount; i++) {
    WTRSliderDot * dot = [[WTRSliderDot alloc] initWithColor:_sliderColor];
    [newDots addObject:dot];
    [self addSubview:dot];
    [self bringSubviewToFront:dot];
    
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:DotRadius];
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:DotRadius];
    [self addConstraints:@[centerY, width, height]];
  }

  // Pin edge dots to edges
  CGFloat margin = DotRadius;
  NSLayoutConstraint * leftmostDotLeftness = [NSLayoutConstraint constraintWithItem:[newDots firstObject] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin];
  NSLayoutConstraint * rightmostDotRightness = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[newDots lastObject] attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:margin];
  [self addConstraints:@[leftmostDotLeftness, rightmostDotRightness]];
  
  // Put invisible spacers between dots
  UIView * firstSpacer = nil;
  
  for (NSUInteger i = 0; i < (dotCount - 1); i++) {
    WTRSliderDot * leftDot = newDots[i];
    WTRSliderDot * rightDot = newDots[i + 1];
    
    UIView * spacer = [[UIView alloc] init];
    spacer.translatesAutoresizingMaskIntoConstraints = NO;
    spacer.hidden = YES;
    
    [self addSubview:spacer];
    [newDotSpacers addObject:spacer];
    
    // 1 pt tall for no particular reason
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:spacer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0];
    
    // Hold on to those dots
    NSLayoutConstraint * leftDotHandhold = [NSLayoutConstraint constraintWithItem:spacer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftDot attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint * rightDotHandhold = [NSLayoutConstraint constraintWithItem:spacer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightDot attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    [self addConstraints:@[height, leftDotHandhold, rightDotHandhold]];

    // Same width for all spacers
    if (i == 0) {
      firstSpacer = spacer;
    } else {
      NSLayoutConstraint * sameWidth = [NSLayoutConstraint constraintWithItem:spacer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstSpacer attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
      [self addConstraint:sameWidth];
    }
  }
  
  dots = newDots;
  dotSpacers = newDotSpacers;
}

- (void)updateDots {
  int intValue = (int)self.value;
  NSUInteger dotIndex = intValue - self.minimumValue;
  
  [dots enumerateObjectsUsingBlock:^(WTRSliderDot * _Nonnull dot, NSUInteger idx, BOOL * _Nonnull stop) {
    if (idx == dotIndex) {
      [dot setAsSelected];
    } else {
      [dot setAsUnselected];
    }
  }];
}

- (void)showThumb {
  [self setThumbImage:[UIImage imageFromColor:_sliderColor withSize:ThumbSize]
             forState:UIControlStateNormal];
  [self setThumbImage:[UIImage imageFromColor:_sliderColor withSize:ThumbSize]
              forState:UIControlStateHighlighted];
}

- (void)tappedAtPoint:(CGPoint)point {
  if (self.highlighted)
    return;
  CGFloat percentage = point.x / self.bounds.size.width;
  CGFloat delta = percentage * (self.maximumValue - self.minimumValue);
  CGFloat value = self.minimumValue + delta;
  [self setValue:value animated:YES];
}

@end

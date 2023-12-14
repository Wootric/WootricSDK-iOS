//
//  WTRiPADFooterView.m
//  WootricSDK
//
//  Created by Diego Serrano on 2/20/24.
//  Copyright © 2024 Wootric. All rights reserved.
//

#import "WTRiPADFooterView.h"
#import "SimpleConstraints.h"
#import "WTRColor.h"
#import "UIItems.h"

static NSString *const kPoweredBy = @"powered by ";
static NSString *const kInMoment = @"InMoment";
static NSString *const kInMomentOptOut = @"InMoment •";

@interface WTRiPADFooterView ()

@property (nonatomic, strong) UIButton *poweredByWootric;
@property (nonatomic, strong) UIButton *optOutButton;
@property (nonatomic, strong) UILabel *disclaimerLabel;

@end

@implementation WTRiPADFooterView

- (instancetype)initWithSettings:(WTRSettings *)settings {
  if (self = [super init]) {
    _settings = settings;
    self.backgroundColor = [UIColor whiteColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }

  return self;
}

- (void)initializeSubviewsWithTargetViewController:(UIViewController *)viewController {
    if ([self.settings showPoweredBy] && ([self.settings showOptOut] || [self.settings showDisclaimer])) {
      [self setupPoweredByWootric:[NSString stringWithFormat:@"%@%@", kPoweredBy, kInMomentOptOut] targetViewController:viewController];
    } else if ([self.settings showPoweredBy]) {
      [self setupPoweredByWootric:[NSString stringWithFormat:@"%@%@", kPoweredBy, kInMoment] targetViewController:viewController];
    }
  
    if ([self.settings showOptOut]) {
      [self setupOptOutButtonWithTargetViewController:viewController];
    }
  
    if ([self.settings showDisclaimer]) {
      [self setupDisclaimerWithTargetViewController:viewController];
    }
  [self addSubviews];
}

- (void)setupSubviewsConstraints {
  if ([self.settings showPoweredBy]) {
    [self setupPoweredByWootricConstraints];
    if ([self.settings showOptOut]) {
      [self setupOptOutButtonConstraintsWithSecondViewRight:self.poweredByWootric];
      if ([self.settings showDisclaimer]) {
        [self setupDisclaimerConstraintsWithSecondViewRight:self.optOutButton];
      }
    } else {
      if ([self.settings showDisclaimer]) {
        [self setupDisclaimerConstraintsWithSecondViewRight:self.poweredByWootric];
      }
    }
  } else if ([self.settings showOptOut]) {
    [self setupOptOutConstraints];
    if ([self.settings showDisclaimer]) {
      [self setupDisclaimerConstraintsWithSecondViewRight:self.optOutButton];
    }
  } else if ([self.settings showDisclaimer]) {
    [self setupDisclaimerConstraints];
  }
}

- (void)layoutSubviews{
  [super layoutSubviews];
  CGFloat maxXPlusWidth = 0.0;
  for (UIView *subview in self.subviews) {
    CGFloat subviewXPlusWidth = CGRectGetMaxX(subview.frame);
    if (subviewXPlusWidth > maxXPlusWidth) {
      maxXPlusWidth = subviewXPlusWidth;
    }
  }
  
  if (maxXPlusWidth == self.frame.size.width) {
    return;
  }
  [self wtr_constraintWidth:maxXPlusWidth];
}

- (void)addSubviews {
  [self addSubview:self.poweredByWootric];
  [self addSubview:self.optOutButton];
  [self addSubview:self.disclaimerLabel];
}

#pragma mark - Setup Views

- (void)setupPoweredByWootric:(NSString *)text targetViewController:(UIViewController *)viewController {
  self.poweredByWootric = [[UIButton alloc] init];
  [self.poweredByWootric setTranslatesAutoresizingMaskIntoConstraints:NO];
  NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
  if ([WTRColor poweredByColor] != nil && [WTRColor iPadPoweredByWootricTextColor] != nil && [UIItems regularFontWithSize:10] != nil  && kPoweredBy.length > 1 && kInMoment.length > 1) {
    [attrStr addAttribute:NSForegroundColorAttributeName value:[WTRColor poweredByColor] range:NSMakeRange(0, kPoweredBy.length - 1)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[WTRColor iPadPoweredByWootricTextColor] range:NSMakeRange(kPoweredBy.length, kInMoment.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIItems regularFontWithSize:10] range:NSMakeRange(0, text.length)];
  } else {
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:37/255 green:55/55 blue:70/255 alpha:1.0] range:NSMakeRange(0, 10)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:37/255 green:55/55 blue:70/255 alpha:1.0] range:NSMakeRange(11, 8)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 19)];
  }
  [self.poweredByWootric setAttributedTitle:attrStr forState:UIControlStateNormal];
  [self.poweredByWootric addTarget:viewController
                            action:NSSelectorFromString(@"openWootricHomepage:")
                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupOptOutButtonWithTargetViewController:(UIViewController *)viewController {
  self.optOutButton = [[UIButton alloc] init];
  [self.optOutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  if ([self.settings showDisclaimer]) {
    [self.optOutButton setTitle:NSLocalizedString(@"opt out •", "") forState:UIControlStateNormal];
  } else {
    [self.optOutButton setTitle:NSLocalizedString(@"opt out", "") forState:UIControlStateNormal];
  }
  [self.optOutButton setTitleColor:[WTRColor optOutTextColor] forState:UIControlStateNormal];
  [self.optOutButton.titleLabel setFont:[UIItems regularFontWithSize:10]];
  [self.optOutButton addTarget:viewController
                        action:NSSelectorFromString(@"optOutButtonPressed:")
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupDisclaimerWithTargetViewController:(UIViewController *)viewController {
  self.disclaimerLabel = [[UILabel alloc] init];
  NSString *fullText = [NSString stringWithFormat:@"%@ %@", self.settings.disclaimerText, self.settings.disclaimerLinkText];
  
  [self.disclaimerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullText];
  [attrStr addAttribute:NSForegroundColorAttributeName value:[WTRColor poweredByColor] range:NSMakeRange(0, attrStr.length)];
  [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, attrStr.length)];
  [attrStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[fullText rangeOfString:self.settings.disclaimerLinkText]];
  self.disclaimerLabel.attributedText = attrStr;
  self.disclaimerLabel.userInteractionEnabled = YES;
  self.disclaimerLabel.textAlignment = NSTextAlignmentCenter;
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:viewController action:NSSelectorFromString(@"openDisclaimerLink:")];
  [self.disclaimerLabel addGestureRecognizer:tapGesture];
}

#pragma mark - Setup Constraints

- (void)setupPoweredByWootricConstraints {
  [self.poweredByWootric wtr_constraintHeight:12];
  [[[self.poweredByWootric wtr_leftConstraint] toSecondViewLeft:self] addToView:self];
  [[[[self.poweredByWootric wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-14] addToView:self];
}

- (void)setupOptOutConstraints {
  [self.optOutButton wtr_constraintHeight:12];
  [[[self.optOutButton wtr_leftConstraint] toSecondViewLeft:self] addToView:self];
  [[[[self.optOutButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-14] addToView:self];
}

- (void)setupDisclaimerConstraints {
  [self.disclaimerLabel wtr_constraintHeight:12];
  [[[self.poweredByWootric wtr_leftConstraint] toSecondViewLeft:self] addToView:self];
  [[[[self.disclaimerLabel wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-14] addToView:self];
}

- (void)setupOptOutButtonConstraintsWithSecondViewRight:(UIView *)secondViewRight {
  [self.optOutButton wtr_constraintHeight:12];
  [[[[self.optOutButton wtr_leftConstraint] toSecondViewRight:secondViewRight] withConstant:4] addToView:self];
  [[[[self.optOutButton wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-14] addToView:self];
}

- (void)setupDisclaimerConstraintsWithSecondViewRight:(UIView *)secondViewRight {
  [[[[self.disclaimerLabel wtr_leftConstraint] toSecondViewRight:secondViewRight] withConstant:4] addToView:self];
  [[[[self.disclaimerLabel wtr_bottomConstraint] toSecondViewBottom:self] withConstant:-14] addToView:self];
}

@end

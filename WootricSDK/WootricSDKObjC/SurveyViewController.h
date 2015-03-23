//
//  SurveyViewController.h
//  WootricSDKObjC
//
//  Created by Łukasz Cichecki on 04/03/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyViewController : UIViewController

@property (nonatomic, strong) NSLayoutConstraint *constTopToModal;
@property (nonatomic, strong) UIImage *imageToBlur;
@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UISlider *scoreSlider;
@property (nonatomic, strong) UIButton *voteButton;
@property (nonatomic, strong) UIButton *sendFeedbackButton;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *commentTitleText;
@property (nonatomic, strong) UIImage *blurredImage;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *heartImageView;
@property (nonatomic, strong) UIImageView *dismissImageView;
@property (nonatomic, strong) UIImageView *sliderBackgroundView;
@property (nonatomic, strong) UIImageView *sliderCheckedBackgroundView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *askForFeedbackLabel;
@property (nonatomic, strong) UILabel *dragToChangeLabel;
@property (nonatomic, strong) UILabel *poweredByWootricLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *notLikelyLabel;
@property (nonatomic, strong) UILabel *extremelyLikelyLabel;

@end

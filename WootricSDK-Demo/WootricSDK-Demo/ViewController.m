//
//  ViewController.m
//  WootricSDK-Demo
//
//  Created by Łukasz Cichecki on 17/08/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import "ViewController.h"
@import WootricSDK;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRed:58.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:1];

  NSString *clientID = @"ad023bc6ae9ed1b3b023dfa5fb9def6c966486834389c7339dad3b8c96651932";
  NSString *clientSecret = @"425518e1062f1e8db3ab2e904fb69889f3c7fb48a2e7b5024ea617c1686c845b";
  NSString *accountToken = @"NPS-ee2cc4bb";

  [WootricSDK configureWithClientID:clientID clientSecret:clientSecret accountToken:accountToken];
  [WootricSDK setEndUserEmail:@"emailiorex@email.com"];
  [WootricSDK setEndUserCreatedAt:@1444449600];
  //  [WootricSDK setOriginUrl:originUrl];
  [WootricSDK forceSurvey:YES];
  [WootricSDK setThankYouLinkWithText:@"Get 20% off your next purchase!" URL:[NSURL URLWithString:@"http://google.com"]];
  [WootricSDK setCustomFollowupPlaceholderForPromoter:nil passive:nil detractor:@"Detractor Placeholder"];
  [WootricSDK setCustomFollowupQuestionForPromoter:nil passive:nil detractor:@"Detractor Question"];
  [WootricSDK setFacebookPage:[NSURL URLWithString:@"https://facebook.com/pjes"]];
  [WootricSDK setTwitterHandler:@"JOHNSON666"];
  //  [WootricSDK setCustomLanguage:@"PL"];
  [WootricSDK setThankYouMessage:@"We have something for you!"];
  //  [WootricSDK setDetractorThankYouMessage:@"DETRACTOR MESYDZ"];
  //  [WootricSDK setCustomProductName:@"SAMOWARY"];
  //  [WootricSDK setCustomAudience:@"KOLEGUM"];
  [WootricSDK showSurveyInViewController:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end

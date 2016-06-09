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
  NSString *clientID = @"YOUR_CLIENT_ID";
  NSString *clientSecret = @"YOUR_CLIENT_SECRET";
  NSString *accountToken = @"YOUR_ACCOUNT_TOKEN";
  
  [Wootric configureWithClientID:clientID clientSecret:clientSecret accountToken:accountToken];
  [Wootric setEndUserEmail:@"END_USER_EMAIL"];
  [Wootric setEndUserCreatedAt:@1234567890];
  
  [Wootric forceSurvey:YES];
  
  [Wootric showSurveyInViewController:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end

//
//  ViewController.m
//  WootricSDK-ObjCDemo
//
//  Created by Łukasz Cichecki on 04/03/15.
//  Copyright (c) 2015 Wootric. All rights reserved.
//

#import "ViewController.h"
@import WootricSDK;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  NSString *clientId = @"YOUR_CLIENT_ID";
  NSString *clientSecret = @"YOUR_CLIENT_SECRET";
  NSString *endUserEmail = @"EMAIL_OF_THE_USER_YOU_WANT_TO_SURVEY";
  NSString *accountToken = @"YOUR_ACCOUNT_TOKEN";
  NSString *originURL = @"URL_OF_YOUR_CHOICE";

  [WootricSDK configureWithClientID:clientId clientSecret:clientSecret andAccountToken:accountToken];
  [WootricSDK setEndUserEmail:endUserEmail andOriginURL:originURL];
  [WootricSDK surveyImmediately:YES];

  [WootricSDK showSurveyInViewController:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)showSurvey:(id)sender {
  [WootricSDK showSurveyInViewController:self];
}

@end

#import "WTRDelegateMockViewController.h"
#import "WTRSurveyDelegate.h"

@interface WTRDelegateMockViewController () <WTRSurveyDelegate>
@end

@implementation WTRDelegateMockViewController

- (void)willPresentSurvey {
  _willPresentSurveyBool = YES;
}

- (void)didPresentSurvey {
  _didPresentSurveyBool = YES;
}

- (void)willHideSurvey {
  _willHideSurveyBool = YES;
}

- (void)didHideSurvey:(NSDictionary *)data {
  _didHideSurveyBool = YES;
}

@end

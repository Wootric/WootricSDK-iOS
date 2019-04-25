#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTRDelegateMockViewController : UIViewController

@property (nonatomic, assign) BOOL willPresentSurveyBool;
@property (nonatomic, assign) BOOL didPresentSurveyBool;
@property (nonatomic, assign) BOOL willHideSurveyBool;
@property (nonatomic, assign) BOOL didHideSurveyBool;

@end

NS_ASSUME_NONNULL_END

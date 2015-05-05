#WootricSDK for iOS
##Requirements
- iOS 7.0+

##Installation
---
###Using CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

```bash
$ gem install cocoapods
```
To integrate WootricSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
pod "WootricSDK", "~> 0.1"
```
Then, run the following command:

```bash
$ pod install
```
##Usage
---
WootricSDK task is to present a fully functional survey view with just a few lines of code.

First import the SDK's header:
```objective-c
#import "WootricSDK.h"
```
Then you need to configure the SDK with your client ID, secret and account token:
```objective-c
[WootricSDK configureWithClientID:<YOUR_CLIENT_ID> clientSecret:<YOUR_CLIENT_SECRET> andAccountToken:<YOUR_TOKEN>];
```
Next thing to do is to set the surveyed end user's email and origin URL:
```objective-c
[WootricSDK setEndUserEmail:<END_USER_EMAIL> andOriginURL:<ORIGIN_URL>];
```
And you are good to go! To display the survey (if user is eligible - this check is built in the method) use:
```objective-c
[WootricSDK showSurveyInViewController:<YOUR_VIEW_CONTROLLER>];
```

####Additional configuration:
---
```objective-c
[WootricSDK forceSurvey:<BOOL>];
```
If forceSurvey is set to YES, the survey is displayed skipping eligibility check AND even if user was already surveyed. (This is for test purposes only as it will display the survey everytime and for every user)

```objective-c
[WootricSDK surveyImmediately:<BOOL>];
```
If surveyImmediately is set to YES and user wasn't surveyed yet - the survey is displayed skipping eligibility check.

```objective-c
//You can pass nil value for any of the parameters - it will use defaults for eligibility check if you do so.
[WootricSDK setCustomValueForResurveyThrottle:<NUMBER_OF_DAYS> visitorPercentage:<0-100> registeredPercentage:<0-100> andDailyResponseCap:<0-...>];
```
This method will alter the values of resurvey throttle, tested visitor, registered users percentage and daily response cap used for eligibility check.

```objective-c
[WootricSDK endUserCreatedAt:<UNIX Timestamp>];
```
When creating a new end user for survey, it will set his/hers external creation date (so for example, date, when end user was created in your iOS application).
This value is also used in eligibility check, to determine if end user should be surveyed.

```objective-c
[WootricSDK productName:<YOUR_PRODUCT_NAME>];
```
Adds 'product_name' property to end user.

```objective-c
[WootricSDK endUserProperties:<PROPERTIES_DICTIONARY>];
```
Adds custom properties to end user.

```objective-c
[WootricSDK firstSurveyAfter:<NUMBER_OF_DAYS>];
```
Specify number of days, end user will be checked for survey eligibility, only, after the specified time has passed since his/hers creation date within your iOS application (which is set with [WootricSDK endUserCreatedAt:];). Defaults to 31 days.

```objective-c
[WootricSDK setSurveyedDefaultAfterSurvey:<BOOL>];
[WootricSDK setSurveyedDefaultAfterSurvey:<BOOL> withDuration:<NUMBER_OF_DAYS>];
```
By default, after end user is surveyed, the SDK sets a "cookie" (NSUserDefaults) valid for 90 days, during which end user won't be checked if eligible for survey.

```objective-c
[WootricSDK setCustomQuestion:<CUSTOM_QUESTION>];
```
This method allows you to set custom question instead of default: "Thank you! Care to tell us why?".

```objective-c
[WootricSDK setCustomPlaceholder:<CUSTOM_PLACEHOLDER>];
```
This method allows you to set custom placeholder instead of default: "Help us by explaining your score."

```objective-c
[WootricSDK setCustomDetractorQuestion:<CUSTOM_QUESTION> passiveQuestion:<CUSTOM_QUESTION> andPromoterQuestion:<CUSTOM_QUESTION>];
```
This method allows you to set custom question for each type of end user (detractor, passive or promoter). Default question asked after end user submits the score is "Thank you! Care to tell us why?". Passing ```nil``` for any of the parameters will result in using default for that type of end user. Be advised that this setting takes precedence over ```[WootricSDK setCustomQuestion]```

```objective-c
[WootricSDK setCustomDetractorPlaceholder:<CUSTOM_PLACEHOLDER> passivePlaceholder:<CUSTOM_PLACEHOLDER> andPromoterPlaceholder:<CUSTOM_PLACEHOLDER>];
```
Same as with custom question, it allows you to set custom placeholder text in feedback text view for each type of end user. Be advised that this setting takes precedence over ```[WootricSDK setCustomPlaceholder]```

```objective-c
[WootricSDK setCustomWootricRecommendTo:<RECOMMEND_TO>];
```
You can use this method to modify the default "How likely are you to recommend us to a friend or co-worker?" question. The ```friend or co-worker``` is replaced by RECOMMEND_TO value.

```objective-c
[WootricSDK setCustomWootricRecommendProduct:<RECOMMEND_PRODUCT>];
```
You can use this method to modify the default "How likely are you to recommend us to a friend or co-worker?" question. The ```us``` is replaced by RECOMMEND_PRODUCT value.

####Additional information:
---
#####"Forcing" eligibility check:
If you want to check end user for survey eligibility everytime the ```showSurveyInViewController:``` method is fired, set ```firstSurveyAfter``` to "0" and ```setSurveyedDefaultAfterSurvey``` to "NO". This doesn't mean your end user will be surveyed everytime, it is just forcing eligibility check.
#####First survey after & end user created at setting:
While it is not required, setting ```endUserCreatedAt``` is highly recommended for proper checking if end user needs survey and skipping uneccessary eligibility checks.

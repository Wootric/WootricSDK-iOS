#WootricSDK for iOS

##Installation
---
###Using CocoaPods
####Podfile
```ruby
pod "WootricSDK"
```

##Usage
---
WootricSDK's most important feature, beside making Wootric API requests, is to present a fully functional survey view with just a few lines of code.

First import the SDK to your view controller where you want to show the survey:
```objective-c
// For embedded framework
@import WootricSDK;

// For CocoaPods 
#import "WootricSDK.h"
```
Then you need to configure the SDK with your client ID, secret and account token:
```objective-c
[WootricSDK configureWithClientID:<YOUR_CLIENT_ID> clientSecret:<YOUR_CLIENT_SECRET> andAccountToken:<YOUR_TOKEN>];
```
Next thing to do is to set the surveyed user's email and origin URL:
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
[WootricSDK surveyImmediately:<BOOL>];
```
If surveyImmediately is set to YES, the survey is displayed skipping eligibility check. (This is for test purposes only as it will display the survey everytime and for every user)

```objective-c
//You can pass nil value for any of the parameters - it will use defaults for eligibility check if you do so.
[WootricSDK setCustomValueForResurveyThrottle:<THROTTLE_NUMBER_OF_DAYS> visitorPercentage:<0-100> andRegisteredPercentage:<0-100>];
```
This method will alter the values of resurvey throttle, tested visitor and registered users percentage used for eligibility check.

```objective-c
[WootricSDK endUserCreatedAt:<UNIX Timestamp>];
```
When creating a new end user for survey, it will set its external creation date (so for example, date, when end user was created in your application).
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
Specify number of days, end user will be checked for survey eligibility, only, after the specified time has passed since his/hers creation date within your application (which is set with [WootricSDK endUserCreatedAt:];). Defaults to 31 days.

```objective-c
[WootricSDK setSurveyedDefaultAfterSurvey:<BOOL> withDuration:<NUMBER_OF_DAYS>];
```
By default, after end user is surveyed, the SDK sets a "cookie" (NSUserDefaults) valid for 90 days, during which end user won't be checked if eligible for survey.

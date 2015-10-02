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
pod "WootricSDK", "~> 0.2"
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
[WootricSDK setEndUserEmail:<END_USER_EMAIL>];
[WootricSDK setOriginUrl:<ORIGIN_URL>];
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
If forceSurvey is set to YES, the survey is displayed skipping eligibility check AND even if user was already surveyed. (This is for test purposes only as it will display the survey every time and for every user)

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
[WootricSDK setCustomFollowupQuestionForPromoter:<CUSTOM_QUESTION> passive:<CUSTOM_QUESTION> andDetractor:<CUSTOM_QUESTION>];
```
This method allows you to set custom question for each type of end user (detractor, passive or promoter). Passing ```nil``` for any of the parameters will result in using default returned from admin panel for that type of end user.

```objective-c
[WootricSDK setCustomFollowupPlaceholderForPromoter:<CUSTOM_PLACEHOLDER> passive:<CUSTOM_PLACEHOLDER> andDetractor:<CUSTOM_PLACEHOLDER>];
```
Same as with custom question, it allows you to set custom placeholder text in feedback text view for each type of end user. Be advised that this setting takes precedence over values returned from admin panel.

####Custom Thank You

```objective-c
// Social share setup
[WootricSDK setFacebookPage:<NSURL>];
[WootricSDK setTwitterHandler:<NSSTRING>];

// Custom thank you messages setup
[WootricSDK setThankYouMessage:<NSSTRING>];
[WootricSDK setDetractorThankYouMessage:<NSSTRING>];
[WootricSDK setPassiveThankYouMessage:<NSSTRING>];
[WootricSDK setPromoterThankYouMessage:<NSSTRING>];

// Custom thank you button setup
[WootricSDK setThankYouLinkWithText:<NSSTRING> andURL:<NSURL>];
[WootricSDK setDetractorThankYouLinkWithText:<NSSTRING> andURL:<NSURL>];
[WootricSDK setPassiveThankYouLinkWithText:<NSSTRING> andURL:<NSURL>];
[WootricSDK setPromoterThankYouLinkWithText:<NSSTRING> andURL:<NSURL>];

```
####Additional information:
---
#####First survey after & end user created at setting:
While it is not required, setting ```endUserCreatedAt``` is highly recommended for proper checking if end user needs survey and skipping uneccessary eligibility checks.

#Wootric SDK for iOS

## Installation

TODO

##Usage
WootricSDK's most important feature, beside making Wootric API requests, is to present a fully functional survey view with just a few lines of code.

First import the SDK to your view controller where you want to show the survey:
```objective-c
@import WootricSDKObjC;
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
// yourViewController will be 'self' in this case
[WootricSDK showSurveyInViewController:<YOUR_VIEW_CONTROLLER>];
```

Additional configuration:
```objective-c
[WootricSDK forceSurvey:<FLAG>];
```
If forceSurvey is set to true the survey is displayed skipping eligibility check.
use this before calling ```[WootricSDK showSurveyInViewController:<YOUR_VIEW_CONTROLLER>];``` (obviously)

```objective-c
//You can pass nil value for any of the parameters - it will use defaults for eligibility check if you do so.
[WootricSDK setCustomValueForResurveyThrottle:<THROTTLE_NUMBER_OF_DAYS> visitorPercentage:<0-100> andRegisteredPercentage:<0-100>]
```

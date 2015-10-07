#WootricSDK for iOS
##Requirements
- iOS 7.0+

##Demo
- View the iOS demo video [here.](http://cl.ly/3N0N2n0F1i0N) 

##Installation
---
###Using CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

```bash
$ gem install cocoapods
```
To integrate WootricSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
pod "WootricSDK", "~> 0.2.6"
```
Then, run the following command:

```bash
$ pod install
```

##Usage
---

####Currently available methods for WootricSDK:

```objective-c
+ configureWithClientID:clientSecret:accountToken:
+ showSurveyInViewController:
+ setEndUserEmail:
+ setEndUserCreatedAt:
+ setOriginUrl:
+ setProductNameForEndUser:
+ setEndUserProperties:
+ setCustomLanguage:
+ setCustomAudience:
+ setCustomProductName:
+ setCustomFinalThankYou:
+ setCustomNPSQuestion:
+ setFirstSurveyAfter:
+ forceSurvey:
+ surveyImmediately:
+ setFacebookPage:
+ setTwitterHandler:
+ setThankYouMessage:
+ setDetractorThankYouMessage:
+ setPassiveThankYouMessage:
+ setPromoterThankYouMessage:
+ setThankYouLinkWithText:URL:
+ setDetractorThankYouLinkWithText:URL:
+ setPassiveThankYouLinkWithText:URL:
+ setPromoterThankYouLinkWithText:URL:
+ setCustomFollowupPlaceholderForPromoter:passive:detractor:
+ setCustomFollowupQuestionForPromoter:passive:detractor:
+ setCustomValueForResurveyThrottle:visitorPercentage:registeredPercentage:dailyResponseCap:
```

####Required configuration:
---

#####ATS notice:

WootricSDK is communicating with three endpoints:

* https://api.wootric.com/
* http://wootric-eligibility.herokuapp.com/
* https://*.cloudfront.net/

either "enable" them in NSAppTransportSecurity or allow all loads by adding to your .plist:

```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

---

WootricSDK task is to present a fully functional survey view with just a few lines of code.

First import the SDK's header:
```objective-c
#import "WootricSDK.h"
```
Then you need to configure the SDK with your client ID, secret and account token:
```objective-c
[WootricSDK configureWithClientID:<YOUR_CLIENT_ID> clientSecret:<YOUR_CLIENT_SECRET> accountToken:<YOUR_TOKEN>];
```
Next thing to do is to set origin URL:
```objective-c
[WootricSDK setOriginUrl:<ORIGIN_URL>];
```
And you are good to go! To display the survey (if user is eligible - this check is built in the method) use:
```objective-c
[WootricSDK showSurve]InViewController:<YOUR_VIEW_CONTROLLER>];
```

####Additional configuration:
---

```objective-c
[WootricSDK setEndUserEmail:<END_USER_EMAIL>];
```
While end user email is not required it is HIGHLY recommended to set it if possible.

```objective-c
[WootricSDK forceSurvey:<BOOL>];
```
If forceSurvey is set to YES, the survey is displayed skipping eligibility check AND even if user was already surveyed. This is for test purposes only as it will display the survey every time and for every user.

```objective-c
[WootricSDK surveyImmediately:<BOOL>];
```
If surveyImmediately is set to YES and user wasn't surveyed yet - eligibility check will return "true" and survey will be displayed. This shouldn't be used on production.

```objective-c
[WootricSDK setEndUserCreatedAt:<UNIX Timestamp>];
```
When creating a new end user for survey, it will set his/hers external creation date (so for example, date, when end user was created in your iOS application).
This value is also used in eligibility check, to determine if end user should be surveyed.

```objective-c
[WootricSDK setFirstSurveyAfter:<NUMBER_OF_DAYS>];
```
If not set, defaults to 31 days. Used to check if end user was created/last seen earlier than <NUMBER_OF_DAYS> ago and therefore if survey is required.

```objective-c
[WootricSDK setEndUserProperties:<NSDICTIONARY>];
```
Adds properties object to end user.

```objective-c
[WootricSDK setProductNameForEndUser:<PRODUCT_NAME>];
```
Directly adds a product name to end user's properties.

####Per view configuration:

While WootricSDK is using values you have set in admin panel, it is possible to override these values directly in code.

---

```objective-c
[WootricSDK setCustomNPSQuestion:<NPS_QUESTION>];
```
Changes NPS Question from admin panel to provided value (English default is "How likely are you to recommend this product or service to a friend or co-worker?").

```objective-c
[WootricSDK setCustomFinalThankYou:<FINAL_THANK_YOU>];
```

Changes final thank you from admin panel to provided value (English default is "Thank you for your response, and your feedback!).

```objective-c
// You can pass nil value for any of the parameters - it will use defaults for eligibility check if you do so.
[WootricSDK setCustomValueForResurveyThrottle:<NUMBER_OF_DAYS> visitorPercentage:<0-100> registeredPercentage:<0-100> dailyResponseCap:<0-...>];
```
This method will alter the values of resurvey throttle, tested visitor, registered users percentage and daily response cap used for eligibility check.

```objective-c
[WootricSDK setCustomFollowupQuestionForPromoter:<CUSTOM_QUESTION> passive:<CUSTOM_QUESTION> detractor:<CUSTOM_QUESTION>];
```
This method allows you to set custom question for each type of end user (detractor, passive or promoter). Passing ```nil``` for any of the parameters will result in using defaults set in Wootric's admin panel for that type of end user.

```objective-c
[WootricSDK setCustomFollowupPlaceholderForPromoter:<CUSTOM_PLACEHOLDER> passive:<CUSTOM_PLACEHOLDER> detractor:<CUSTOM_PLACEHOLDER>];
```
Same as with custom question, it allows you to set custom placeholder text in feedback text view for each type of end user. Be advised that this setting takes precedence over values set in Wootric's from admin panel.

####Custom language, audience text and product name configuration:
---
```objective-c
[WootricSDK setCustomLanguage:<LANGUAGE_CODE>];
[WootricSDK setCustomAudience:<CUSTOM_AUDIENCE>];
[WootricSDK setCustomProductName:<CUSTOM_PRODUCT_NAME>];
```
Please refer to our [docs](http://docs.wootric.com/install/#custom-language-setting) for available languages.

Custom audience and/or product name modifies the default NPS question e.g. default question in English looks like this:
"How likely are you to recommend this product or service to a friend or co-worker?"
if custom product name is set it will substitute "this product or service" text, while custom audience will substitute "friend or co-worker". It also takes precedence over values set in admin panel.

####Custom Thank You
---

```objective-c
// Social share setup
[WootricSDK setFacebookPage:<FACEBOOK_PAGE_URL>];
[WootricSDK setTwitterHandler:<TWITTER_HANDLER>];

// Custom thank you messages setup
[WootricSDK setThankYouMessage:<THANK_YOU_MESSAGE>];
[WootricSDK setDetractorThankYouMessage:<THANK_YOU_MESSAGE>];
[WootricSDK setPassiveThankYouMessage:<THANK_YOU_MESSAGE>];
[WootricSDK setPromoterThankYouMessage:<THANK_YOU_MESSAGE>];

// Custom thank you button setup
[WootricSDK setThankYouLinkWithText:<THANK_YOU_TEXT> URL:<THANK_YOU_URL>];
[WootricSDK setDetractorThankYouLinkWithText:<THANK_YOU_TEXT> URL:<THANK_YOU_URL>];
[WootricSDK setPassiveThankYouLinkWithText:<THANK_YOU_TEXT> URL:<THANK_YOU_URL>];
[WootricSDK setPromoterThankYouLinkWithText:<THANK_YOU_TEXT> URL:<THANK_YOU_URL>];

```

If configured, social share will display third screen for promoters (score 9-10, also twitter displays only if there is a feedback text provided), while custom thank you message and/or button will display for each type of end user that is configured (where ```setThankYouMessage:``` and ```setThankYouLinkWithText:URL:``` being default for any score).

For detailed information please refer to [js docs](http://docs.wootric.com/install/#social-media-share-settings).
####Additional information:
---
#####First survey after & end user created at setting:
While it is not required, setting ```setEndUserCreatedAt``` is highly recommended for proper checking if end user needs survey and skipping uneccessary eligibility checks.

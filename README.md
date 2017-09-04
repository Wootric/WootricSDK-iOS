<p align="center" >
  <img src="https://cloud.githubusercontent.com/assets/1431421/16471739/4e28eec8-3e24-11e6-8ee1-39d36bbf679e.png" alt="Wootric" title="Wootric">
</p>

<p align="center" >
  <img src="https://cloud.githubusercontent.com/assets/1431421/16506354/73eb99e4-3ee7-11e6-8396-0e6591eb6671.gif" alt="Wootric survey" title="Wootric">
</p>


[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Wootric/WootricSDK-iOS/master/LICENSE.md) [![GitHub release](https://img.shields.io/github/release/Wootric/WootricSDK-iOS.svg)](https://github.com/Wootric/WootricSDK-iOS/releases) [![Build Status](https://img.shields.io/circleci/project/Wootric/WootricSDK-iOS.svg)](https://img.shields.io/circleci/project/Wootric/WootricSDK-iOS.svg) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WootricSDK.svg)](https://img.shields.io/cocoapods/v/WootricSDK.svg) [![Platform](https://img.shields.io/cocoapods/p/WootricSDK.svg?style=flat)](http://cocoadocs.org/docsets/WootricSDK) [![Twitter](https://img.shields.io/badge/twitter-@Wootric-blue.svg?style=flat)](http://twitter.com/Wootric)


## Requirements
- iOS 8.0+

## Demos
- View the iOS demo video with referral prompt [here.](http://cl.ly/1Q1l0w242f05)
- View the iOS demo with App Store rating prompt [here.](http://cl.ly/2R3j0T283k2p)

## Installation

### Using CocoaPods
The easiest way to get Wootric into your iOS project is to use [CocoaPods](http://cocoapods.org).

1. You can install CocoaPods using 
	```bash
	$ gem install cocoapods
	```

2. Create a file in your Xcode project called Podfile and add the following line:
	```ruby
	pod "WootricSDK", "~> 0.6.2"
	```

3. In your Xcode project directory run the following command:
	```bash
	$ pod install
	``` 

4. CocoaPods should download and install the Wootric SDK, and create a new Xcode `.xcworkspace` file. Close your Xcode project and open the new `.xcworkspace` file.


### Manually
If you want to, you can download the SDK and add it to your project without using any dependency manager.
*Note: Make sure you are using the latest version of Xcode and targeting iOS 8.0 or higher.*

1. [Download](https://github.com/Wootric/WootricSDK-iOS/releases) & unzip the Wootric SDK

2. In your Xcode project, go to **General** and drop the WootricSDK.framework on **Embedded Binaries**

![Xcode](https://cloud.githubusercontent.com/assets/1431421/16505349/238edd62-3ee2-11e6-8f91-9d3c978a10cf.png)

*Make sure the "Copy items if needed" checkbox is checked.*


## Initializing Wootric
WootricSDK task is to present a fully functional survey view with just a few lines of code.

1. Import the SDK's header:
	```objective-c
	#import <WootricSDK/WootricSDK.h>
	```

2. Configure the SDK with your client ID, secret and account token
	```objective-c
	[Wootric configureWithClientID:<YOUR_CLIENT_ID> clientSecret:<YOUR_CLIENT_SECRET> accountToken:<YOUR_TOKEN>];
	``` 
	*You can find the client ID and client secret on your [Wootric's account settings](https://app.wootric.com/account_settings/edit?) on the API section.*

3. To display the survey (if user is eligible - this check is built in the method) use:
	```objective-c
	[Wootric showSurveyInViewController:<YOUR_VIEW_CONTROLLER>];
	```

And that's it! You're good to go and start receiving customer's feedback from your iOS app.

For more information on class methods, please refer to [Wootric's docs](http://cocoadocs.org/docsets/WootricSDK/0.5.6/Classes/Wootric.html).

## Example

```objective-c
// Import Wootric
@import WootricSDK;

// Inside your view controller's viewDidLoad method

[Wootric configureWithClientID:YOUR_CLIENT_ID clientSecret:YOUR_CLIENT_SECRET accountToken:YOUR_ACCOUNT_TOKEN];
[Wootric setEndUserEmail:@"nps@example.com"];
[Wootric setEndUserCreatedAt:@1234567890];
// Use only for testing
[Wootric forceSurvey:YES];
// show survey
[Wootric showSurveyInViewController:self];

```

## License

The WootricSDK is released under the MIT license. See LICENSE for details.

## Contribute

If you want to contribute, report a bug or request a feature, please see CONTRIBUTING for details.


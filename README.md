<p align="center" >
  <img src="https://user-images.githubusercontent.com/1431421/114659755-ff80c500-9ca8-11eb-9960-8f55a18d03cb.png" alt="Wootric" title="Wootric">
</p>

<p align="center" >
  <img src="https://user-images.githubusercontent.com/1431421/114664156-28f11f00-9cb0-11eb-8a8a-d9fb92d25b12.gif" alt="Wootric survey" title="Wootric">
</p>


[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Wootric/WootricSDK-iOS/master/LICENSE.md) [![GitHub release](https://img.shields.io/github/release/Wootric/WootricSDK-iOS.svg)](https://github.com/Wootric/WootricSDK-iOS/releases) [![Build Status](https://img.shields.io/circleci/project/Wootric/WootricSDK-iOS.svg)](https://img.shields.io/circleci/project/Wootric/WootricSDK-iOS.svg) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WootricSDK.svg)](https://img.shields.io/cocoapods/v/WootricSDK.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Platform](https://img.shields.io/cocoapods/p/WootricSDK.svg?style=flat)](http://cocoadocs.org/docsets/WootricSDK) [![Twitter](https://img.shields.io/badge/twitter-@Wootric-blue.svg?style=flat)](http://twitter.com/Wootric)


## Requirements
- iOS 12.0+

## Demos
- View the iOS demo video with referral prompt [here.](https://share.getcloudapp.com/rRuGkdBA)

## Installation

### Using CocoaPods
The easiest way to get Wootric into your iOS project is to use [CocoaPods](http://cocoapods.org).

1. You can install CocoaPods using 
	```bash
	$ gem install cocoapods
	```

2. Create a file in your Xcode project called Podfile and add the following line:
	```ruby
	pod "WootricSDK", "~> 0.21.1"
	```

3. In your Xcode project directory run the following command:
	```bash
	$ pod install
	``` 

4. CocoaPods should download and install the Wootric SDK, and create a new Xcode `.xcworkspace` file. Close your Xcode project and open the new `.xcworkspace` file.


### Manually
If you want to, you can download the SDK and add it to your project without using any dependency manager.
*Note: Make sure you are using the latest version of Xcode and targeting iOS 9.0 or higher.*

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

2. Configure the SDK with your account token
	```objective-c
	[Wootric configureWithAccountToken:<YOUR_TOKEN>];
	``` 
	*You can find the account token in your [Wootric's account settings](https://app.wootric.com/account_settings/edit?#!/account)*

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

[Wootric configureWithAccountToken:YOUR_ACCOUNT_TOKEN];
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


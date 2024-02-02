## 0.27.1 (2024-03-22)

### Changes:

- Fix crash in checkEligibility

## 0.27.0 (2024-02-28)

### Changes:

- Add disclaimer support

## 0.26.3 (2024-01-22)

### Changes:

- Fix encoding issue on iOS 17

## 0.26.2 (2023-08-08)

### Changes:

- Fix smartphone survey UI when application becomes active again

## 0.26.1 (2023-06-08)

### Changes:

- Fix DriverPicklist ampersand bug
- Fix second screen placeholder bug

## 0.26.0 (2023-06-01)

### Changes:

- Add support for AU tokens

## 0.25.0 (2023-02-21)

### Changes:

- Add support for custom first question

## 0.24.1 (2023-02-16)

### Changes:

- Update "powered by InMoment" text

## 0.24.0 (2023-01-31)

### Changes:

- Add option to hide "powered by InMoment"

## 0.23.0 (2023-01-19)

### Changes:

- Add support for driver picklist feature

## 0.22.1 (2022-10-24)

### Changes:

- Default to system font when IBM font not found (https://github.com/Wootric/react-native-wootric/issues/27)

## 0.22.0 (2022-09-01)

### Changes:

- Send language on response creation
- Update lowest supported version to iOS 12 and fix deprecated code
- Update build phases to fix cycle in dependencies
- Remove incorrect tests. These tests were basically testing Apple's implementation of NSOperationQueue
- Update social sharing to fix SLServiceTypeTwitter & SLServiceTypeFacebook deprecation (https://github.com/Wootric/WootricSDK-iOS/issues/55)
- Fix SPM support (https://github.com/Wootric/WootricSDK-iOS/pull/96 & https://github.com/Wootric/WootricSDK-iOS/issues/86)

## 0.21.1 (2021-11-08)

### Changes:

- Fix updateExistingEndUser bug

## 0.21.0 (2021-08-04)

### Changes:

- Add support for EU tokens

## 0.20.1 (2021-07-07)

### Changes:

- Fix dismiss X color

## 0.20.0 (2021-04-19)

### Changes:

- Reskin
- Update demo project
- Fix deprecations

## 0.19.1 (2020-09-21)

### Changes:
  
- Fix slider bug

## 0.19.0 (2020-08-27)

### Changes:
  
- Add stop method

## 0.18.2 (2020-08-11)

### Changes:

- Fix authenticate bug
- Fix User-Agent in all requests

## 0.18.1 (2020-07-07)

### Changes:

- Fix copy for CustomMessages, CustomSocial, CustomThankYou and LocalizedText objects

## 0.18.0 (2020-05-29)

### Changes:

- Fix deprecated method warnings
- Add new configuration method with only accountToken param
- Update SEGWootric class

## 0.17.0 (2020-03-26)

### Changes:

- Add support for events (Targeted Sampling)

## 0.16.0 (2019-12-04)

### Changes:

- Add support of admin panel values for adding email, score and comment to thank you link

## 0.15.0 (2019-10-18)

### Changes:

- Add button to Demo project to start the survey
- Add support of admin panel values for 3rd screen

## 0.14.0 (2019-08-12)

### Changes:

- Add skipFeedbackScreen method
- Fix promoter bug for non NPS scales

## 0.13.0 (2019-06-21)

### Changes:

- Add support for custom scales

## 0.12.1 (2019-06-04)

### Changes:

- Fix slider bug
- Remove tracking pixel

## 0.12.0 (2019-05-02)

### Changes:

- Add delegate pattern

## 0.11.1 (2019-03-21)

### Changes:

- Fix email param bug

## 0.11.0 (2018-12-18)

### Changes:

- Add support for Property Based Sampling
- Update eligibility logs to show more info

## 0.10.2 (2018-11-27)

### Fixed:

- Percentage escape strings to prevent NSURL errors

## 0.10.1 (2018-09-26)

### Fixed:

- Force left-to-right in slider

## 0.10.0 (2018-06-25)

### Changes:

- Add notifications for `appear` events (willAppear, didAppear, willDisappear, didDisappear)

## 0.9.0 (2018-05-21)

### Changes:

- Add opt out option

## 0.8.0 (2018-05-15)

### Changes:

- Add WTRLogger to allow setting log level so logs can be disabled
- Add new setters to Wootric.h to set the WTRLogger mode
- Update license comment in all files

## 0.7.0 (2018-05-03)

### Changes:

- Add new method that just needs client_id & doesn't require the client_secret

## 0.6.6 (2017-12-15)

### Fixed:

- Check for setDefaultAfterSurvey when checking defaults values

## 0.6.5 (2017-12-14)

### Fixed:

- Fix char escaping when updating end user with product_name

## 0.6.4 (2017-11-24)

### Changes:

- Add setCustomTimeDelay method

## 0.6.3 (2017-10-31)

### Changes:

- Fix Carthage compatibility
- Update project for Xcode9
- Fix iOS 11 keyboard bug
- Fix warnings

## 0.6.2 (2017-09-05)

### Fixed:

- Fix followup question and placeholder bug
- Update demo project settings
- Refactor code
- Update Deployment Target = 8.0

## 0.6.1 (2017-05-16)

### Fixed:

- Fix 'User-Agent' bug

## 0.6.0 (2017-03-29)

### Added:

- CES and CSAT support

## 0.5.12 (2016-11-17)

### Fixed:

- Change method names in category to avoid conflict
- Update project settings

## 0.5.11 (2016-10-12)

### Fixed:

- "Edit Score" string for different languages
- Demo project

## 0.5.10 (2016-10-11)

### Fixed:

- Bundle Info.plist to correct submission issues

## 0.5.9 (2016-09-27)

### Fixed:

- SDK version bug
- Escape customProduct and customAudience
- Don't show survey if accountToken is wrong

## 0.5.8 (2016-09-07)

### Added:

- Pass external_id & phone_number
- Update tests

## 0.5.7 (2016-08-31)

### Changed:

- Accept resurvey_throttle and decline_resurvey_throttle
- Fix last button long text adjustment
- Update tests
- Add tests for WTRDefaults

## 0.5.6 (2016-06-29)

### Added:

- Send Wootric SDK, OS version and OS name

## 0.5.5 (2016-06-10)

### Fixed:

- Add end_user_last_seen to eligibility requests
- Code cleanup
- Add documentation
- Change resources for new logo

## 0.5.4 (2016-06-01)

### Added:

- Color customization support for Segment integration

## 0.5.3 (2016-05-23)

### Added:

- Concurrent Survey Processing

## 0.5.2 (2016-03-31)

### Fixed:

- Fix crash at getEndUserEmail when receiving a dictionary.

## 0.5.1 (2016-03-31)

### Fixed:

- Add fontawesome-webfont.ttf to podspec resources.

## 0.5.0 (2016-03-31)

### Added:

- Add color customization feature

## 0.4.7 (2016-02-15)

### Fixed:

- Cast externalCreatedAt to long while building eligibility check URL.

## 0.4.6 (2016-01-12)

### Fixed:

- Invalidate NSURLSession after tracking pixel get request.

## 0.4.5 (2016-01-07)

### Fixed:

- There will be no email send to eligibility server if no email is provided, instead of sending "Unknown" email.

## 0.4.4 (2015-12-18)

### Added:

- Tweak for mParticle integration.

## 0.4.3 (2015-11-27)

### Added:

- Option to skip feedback screen for promoters.
- Passing score and feedback text as "thank you URL" params.

### Changed:

- Small constraints tweaks.

## 0.4.2 (2015-11-17)

### Added:

- Public header files to podspec.

## 0.4.1 (2015-11-16)

### Hotfix:

- Renamed SegmentWootric to SEGWootric.

## 0.4.0 (2015-11-16)

### Added:

- SegmentWootric class for convenience while integrating WootricSDK using [Segment-Wootric](https://github.com/Wootric/segment-wootric-ios)

### Changed:

##### important!

- Renamed WootricSDK class to Wootric. WootricSDK is no longer available and all methods should be called on Wootric instead.

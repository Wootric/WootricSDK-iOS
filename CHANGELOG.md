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

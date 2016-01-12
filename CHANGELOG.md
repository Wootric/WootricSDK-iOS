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

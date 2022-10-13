Pod::Spec.new do |s|
  s.name     = 'WootricSDK'
  s.version  = '0.22.1'
  s.license  = 'MIT'
  s.summary  = 'Wootric SDK for displaying survey for end user.'
  s.homepage = 'https://github.com/Wootric/WootricSDK-iOS'
  s.documentation_url = 'http://docs.wootric.com/ios/'
  s.social_media_url = 'https://twitter.com/Wootric'
  s.authors  = { 'Wootric' => 'support@wootric.com' }
  s.source   = { :git => 'https://github.com/Wootric/WootricSDK-iOS.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '12.0'

  s.source_files = "WootricSDK/WootricSDK/**/*.{h,m}"
  s.resources = "WootricSDK/WootricSDK/fontawesome-webfont.ttf", "WootricSDK/WootricSDK/IBMPlexSans-Bold.ttf", "WootricSDK/WootricSDK/IBMPlexSans-Italic.ttf", "WootricSDK/WootricSDK/IBMPlexSans-Medium.ttf", "WootricSDK/WootricSDK/IBMPlexSans-Regular.ttf"
  s.public_header_files = "WootricSDK/WootricSDK/WootricSDK.h", "WootricSDK/WootricSDK/Public/Wootric.h", "WootricSDK/WootricSDK/Public/SEGWootric.h", "WootricSDK/WootricSDK/WTRLogger.h", "WootricSDK/WootricSDK/WTRLogLevel.h", "WootricSDK/WootricSDK/Public/WTRSurveyDelegate.h"
end

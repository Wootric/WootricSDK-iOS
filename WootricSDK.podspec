Pod::Spec.new do |s|
  s.name     = 'WootricSDK'
  s.version  = '0.2.8'
  s.license  = 'MIT'
  s.summary  = 'Wootric SDK for displaying survey for end user'
  s.homepage = 'https://github.com/Wootric/WootricSDK-iOS'
  s.authors  = { 'Łukasz Cichecki' => 'lukasz@copper.io' }
  s.source   = { :git => 'https://github.com/Wootric/WootricSDK-iOS.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '7.0'

  s.source_files = "WootricSDK/WootricSDK/*.{h,m}"
  s.resources = "WootricSDK/WootricSDK/Images.xcassets"
  s.public_header_files = "WootricSDK/WootricSDK/WootricSDK.h"
end

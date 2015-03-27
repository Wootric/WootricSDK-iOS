Pod::Spec.new do |s|
  s.name     = 'WootricSDK'
  s.version  = '0.1'
  s.license  = 'MIT'
  s.summary  = 'Wootric SDK for displaying automated survey for end user'
  s.homepage = 'https://github.com/Wootric/WootricSDK-iOS'
  s.authors  = { 'Łukasz Cichecki' => 'lukasz@copper.io' }
  s.source   = { :git => 'https://github.com/Wootric/WootricSDK-iOS.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '7.0'

  s.source_files = "WootricSDK/*.{h,m}", "WootricSDK/WootricSDKObjC/*.{h,m}"
  s.resources = "WootricSDK/WootricSDKObjC/Images.xcassets"
  s.public_header_files = "WootricSDK/WootricSDKObjC/WootricSDK.h"
end

Pod::Spec.new do |s|
  s.name         = "JSONJoy-Swift"
  s.version      = "3.0.2"
  s.summary      = "Convert JSON to Swift objects."
  s.homepage     = "https://github.com/daltoniam/JSONJoy-Swift"
  s.license      = 'Apache License, Version 2.0'
  s.author       = {'Dalton Cherry' => 'http://daltoniam.com'}
  s.source       = { :git => 'https://github.com/daltoniam/JSONJoy-Swift.git',  :tag => "#{s.version}"}
  s.social_media_url = 'http://twitter.com/daltoniam'
  s.module_name = "JSONJoy"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.source_files = 'Source/*.swift'
end

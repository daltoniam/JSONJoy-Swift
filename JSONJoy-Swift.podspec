Pod::Spec.new do |s|
  s.name         = "JSONJoy-Swift"
  s.version      = "0.9.1"
  s.summary      = "Convert JSON to Swift objects."
  s.homepage     = "https://github.com/daltoniam/JSONJoy-Swift"
  s.license      = 'Apache License, Version 2.0'
  s.author       = {'Dalton Cherry' => 'http://daltoniam.com'}
  s.source       = { :git => 'https://github.com/daltoniam/JSONJoy-Swift.git',  :tag => '0.9.1'}
  s.platform     = :ios, 8.0
  s.source_files = '*.{h,swift}'
end

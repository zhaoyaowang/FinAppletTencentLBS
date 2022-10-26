Pod::Spec.new do |s|
  s.name         = "FinAppletTencentLBS"
  s.version      = "1.0.1"
  s.summary      = "FinApplet TencentLBS sdk."
  s.description  = <<-DESC
                    this is FinApplet TencentLBS sdk
                   DESC
  s.homepage     = "https://www.finclip.com"
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright 2017 finogeeks.com. All rights reserved.
      LICENSE
  }
  s.author             = { "finclip" => "contact@finogeeks.com" }
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/zhaoyaowang/FinAppletTencentLBS.git", :tag => "#{s.version}" }
  s.source_files  = "TencentLBS/**/*.{h,m,c}"
  s.vendored_frameworks = 'TencentLBS.framework'
  s.libraries = 'z.1.2.5'
  s.requires_arc = true
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

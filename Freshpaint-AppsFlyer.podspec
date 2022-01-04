Pod::Spec.new do |s|
  s.name             = 'Freshpaint-AppsFlyer'
  s.version          = '0.1.0'
  s.summary          = "AppsFlyer Integration for Freshpaints's freshpaint-ios library."

  s.description      = <<-DESC
                       AppsFlyer is the market leader in mobile advertising attribution & analytics, helping marketers to pinpoint their targeting, optimize their ad spend and boost their ROI.
                       DESC

  s.homepage         = 'https://github.com/freshpaint-io/freshpaint-ios-integration-appsflyer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Freshpaint' => 'james@freshpaint.io' }
  s.source           = { :git => 'https://github.com/freshpaint-io/freshpaint-ios-integration-appsflyer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.static_framework = true

  s.source_files = 'Freshpaint-AppsFlyer/Classes/**/*'

  s.dependency 'Freshpaint', '~> 0.2.1'

  s.subspec 'Main' do |ss|
    ss.ios.dependency 'AppsFlyerFramework','~> 6.4.4'
    ss.tvos.dependency 'AppsFlyerFramework', '~> 6.4.4'
  end

  # s.subspec 'Strict' do |ss|
  #   ss.ios.dependency 'AppsFlyerFramework/Strict', '~> 6.4.4'
  #   ss.tvos.dependency 'AppsFlyerFramework/Strict', '~> 6.4.4'
  # end
end

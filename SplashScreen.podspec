#
# Be sure to run `pod lib lint SplashScreen.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SplashScreen'
  s.version          = '1.0.0'
  s.summary          = 'Make your apps new features visible to your clients with SplashScreen'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Your apps great new features were buried deep inside on the new AppStore. SplashScreen makes those features visible to your clients.
                       DESC

  s.homepage         = 'https://github.com/marcelmendesfilho/SplashScreen'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'marcel.mendes@gmail.com' => 'marcel.mendes@gmail.com' }
  s.source           = { :git => 'https://github.com/marcelmendesfilho/SplashScreen.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'SplashScreen/Classes/**/*'
  s.resource_bundles = {
    'SplashScreen' => ['SplashScreen/Assets/**/*.{storyboard,xib}']
  }
  
  # s.resource_bundles = {
  #   'SplashScreen' => ['SplashScreen/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end

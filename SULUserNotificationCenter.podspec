#
# Be sure to run `pod lib lint SULUserNotificationCenter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SULUserNotificationCenter'
  s.version          = '0.1.3'
  s.summary          = 'A Drop in replacement for NSUserNotification with a few handy tweaks, written in Swift 3.0!'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A Drop in replacement for NSUserNotification with a few handy tweaks, written in Swift 3.0!
  See Example for more detail!
  DESC

  s.homepage         = 'https://github.com/sunuslee/SULUserNotificationCenter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunuslee' => 'sunuslee@gmail.com' }
  s.source           = { :git => 'https://github.com/sunuslee/SULUserNotificationCenter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.osx.deployment_target = '10.9'

  s.source_files = 'SULUserNotificationCenter/Classes/**/*'

  s.resources = ['SULUserNotificationCenter/Assets/*.xib']


#s.resource_bundles = {
#   'SULUserNotificationCenter' => ['SULUserNotificationCenter/Assets/*.xib']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

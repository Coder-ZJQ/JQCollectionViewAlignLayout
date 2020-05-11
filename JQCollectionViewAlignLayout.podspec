#
# Be sure to run `pod lib lint JQCollectionViewAlignLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JQCollectionViewAlignLayout'
  s.version          = '0.2.1'
  s.summary          = 'A custom layout object based on flow layout, that supports setting horizontal, vertical alignment and RTL(right to left) direction of collection view items.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A custom layout object based on flow layout, that supports setting horizontal, vertical alignment and RTL(right to left) direction of collection view items.
(available for both UICollectionView and NSCollectionView)
                       DESC

  s.homepage         = 'https://github.com/coder-zjq/JQCollectionViewAlignLayout'
  s.screenshots      = 'https://raw.githubusercontent.com/Coder-ZJQ/JQCollectionViewAlignLayout/master/images/h-left.png',
                       'https://raw.githubusercontent.com/Coder-ZJQ/JQCollectionViewAlignLayout/master/images/h-center.png',
                       'https://raw.githubusercontent.com/Coder-ZJQ/JQCollectionViewAlignLayout/master/images/h-right.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'coder-zjq' => 'zjq_joker@163.com' }
  s.source           = { :git => 'https://github.com/coder-zjq/JQCollectionViewAlignLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.source_files = 'JQCollectionViewAlignLayout/Classes/*'
  
  s.ios.frameworks = 'Foundation', 'UIKit'
  s.tvos.frameworks = 'Foundation', 'UIKit'
  s.osx.frameworks = 'Foundation', 'AppKit'

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  
end

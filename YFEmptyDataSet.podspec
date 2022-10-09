#
# Be sure to run `pod lib lint YFEmptyDataSet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YFEmptyDataSet'
  s.version          = '1.0.0'
  s.summary          = 'A drop-in UIView extension for showing empty datasets whenever the view has no content to display'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Customble and Configable, can used in Any UIView
  It will work automatically, by just conforming to YFEmptyDataSet, and returning the data you want to show. The -reloadData call will be observed so the empty dataset will be configured whenever needed
                       DESC

  s.homepage         = 'https://github.com/yonfong/YFEmptyDataSet'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yonfong' => 'yongfongzhang@163.com' }
  s.source           = { :git => 'https://github.com/yonfong/YFEmptyDataSet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version         = '5.0'

  s.source_files = 'YFEmptyDataSet/Classes/**/*'

end

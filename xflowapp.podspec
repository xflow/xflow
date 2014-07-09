#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "xflowapp"
  s.version          = "0.1.0"
  s.summary          = "A short description of xflowapp."
  s.description      = <<-DESC
                       An optional longer description of xflowapp

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/xflowapp/xflowapp"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Mohammed O. Tillawy" => "tillawy@gmail.com" }
  s.source           = { :git => "https://github.com/xflowapp/xflowapp.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/xflowapp'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{h,m,c}'
  s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Mantle', '~> 1.5'
  s.dependency 'OHHTTPStubs', '~> 3.1.2'

end


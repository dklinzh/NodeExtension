#
# Be sure to run `pod lib lint NodeExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NodeExtension'
  s.version          = '0.2.10'
  s.summary          = 'A swift extension framework of `AsyncDisplayKit`.'
  s.description      = <<-DESC
                        A swift extension framework of `AsyncDisplayKit`. It also includes some convenient extensions of UIKit.
                       DESC
  s.homepage         = 'https://github.com/dklinzh/NodeExtension'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Lin' => 'linzhdk@gmail.com' }
  s.source           = { :git => 'https://github.com/dklinzh/NodeExtension.git', :tag => s.version.to_s, :submodules => true }

  s.requires_arc = true
  s.swift_version = '4.2'
  s.ios.deployment_target = '9.0'
  s.default_subspecs = 'Default'

  s.subspec 'Default' do |ss|
    ss.dependency 'NodeExtension/Node'
    ss.dependency 'NodeExtension/UIKit'
    ss.dependency 'NodeExtension/HUD'
  end

  s.subspec 'UIKit' do |ss|
    ss.source_files = 'NodeExtension/Classes/UIKit/*.swift'
  end
  
  s.subspec 'Node' do |ss|
      ss.dependency 'NodeExtension/UIKit'
      ss.dependency 'Texture', '~> 2.7'
      ss.source_files = 'NodeExtension/Classes/Node/**/*.swift'
  end

  s.subspec 'HUD' do |ss|
    ss.dependency 'NodeExtension/UIKit'
    ss.dependency 'MBProgressHUD', '~> 1.1'
    ss.source_files = 'NodeExtension/Classes/UIKit/HUD/*.swift'
  end
  
end

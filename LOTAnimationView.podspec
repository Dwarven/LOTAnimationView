Pod::Spec.new do |s|

  s.name             = 'LOTAnimationView'
  s.version          = '0.0.1'
  s.summary          = 'lottie api in LOTAnimationView style based on lottie-ios'
  s.homepage         = 'https://github.com/Dwarven/LOTAnimationView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dwarven' => 'prison.yang@gmail.com' }
  s.platform         = :ios, '11.0'
  s.swift_versions   = '5'
  s.source           = { :git => 'https://github.com/Dwarven/LOTAnimationView.git', :tag => s.version }
  s.requires_arc     = true
  s.framework        = 'UIKit', 'CoreGraphics', 'QuartzCore'
  s.source_files     = 'LOTAnimationView/*.swift'
  s.module_name      = 'LOTAnimationView'
  s.dependency 'lottie-ios', '~> 4.0'

end
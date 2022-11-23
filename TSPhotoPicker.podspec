#
# Be sure to run `pod lib lint TSPhotoPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html

Pod::Spec.new do |s|
  s.name             = 'TSPhotoPicker'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TSPhotoPicker.'
  s.swift_version    = ['5.0']
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/leetangsong/TSPhotoPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leetangsong' => 'leetangsong@icloud.com' }
  s.source           = { :git => 'https://github.com/leetangsong/TSPhotoPicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  
  s.subspec 'Core' do |core|
      core.source_files = "Sources/TSPhotoPicker/Core/**/*.{swift}"
      core.resources      = "Sources/TSPhotoPicker/Resources/*.{bundle}"
  end
  
  s.subspec 'Picker' do |picker|
      picker.source_files = "Sources/TSPhotoPicker/Picker/**/*.{swift}"
      picker.dependency "TSPhotoPicker/Core"
  end
  
  s.subspec 'Editor' do |editor|
      editor.source_files = "Sources/TSPhotoPicker/Editor/**/*.{swift}"
      editor.dependency "TSPhotoPicker/Core"
  end
  
  
  
   s.pod_target_xcconfig = {
     'CODE_SIGN_IDENTITY' => ''
   }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'AVFoundation', 'Photos', 'PhotosUI', 'CoreGraphics', 'CoreServices'
  s.dependency 'Handy' 
  s.dependency 'Kingfisher', '~> 6.3.1'
end


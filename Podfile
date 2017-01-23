# atnlie@gmail.com
# platform :ios, '8.0'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!


def common_pods
  pod 'AFNetworking', '~> 3.1.0'
  pod 'RestKit',  '~> 0.27.0'
  pod 'SwiftyJSON'
  pod 'TTGSnackbar'
  pod 'ReactiveSwift', '~> 1.0.0'
end

target 'First Step' do
  common_pods
end

target 'First StepTests' do
  common_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end

    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

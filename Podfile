# atnlie@gmail.com
# Uncomment the next line to define a global platform for your project
# platform :ios, '8.0'

use_frameworks!

def common_pods
  pod 'AFNetworking', '~> 3.1.0'
  #pod 'ReactiveSwift', '~> 1.0.0'
  pod 'RestKit',  '~> 0.27.0'
  pod 'APAddressBook/Swift'
  
  #pod "JLPermissions/Contacts"
  #pod 'JLPermissions/Notification'
  #pod 'ComponentKit', '~> 0.14'
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
    end

    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end

  # prevent automatic c++ headers inclusion in Objective-C files which causes compile errors
  #  clear_component_kit_umbrella_header

end

#def clear_component_kit_umbrella_header
#    file = File.open('./Pods/Target Support Files/ComponentKit/ComponentKit-umbrella.h', 'w')
#    file.close
#end


#target 'First Step' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  #use_frameworks!
  # Pods for First Step

  #target 'First StepTests' do
  #  inherit! :search_paths
    # Pods for testing
    #pod 'ReactiveCocoa'
    
  #end

  #target 'First StepUITests' do
  #  inherit! :search_paths
    # Pods for testing
    #pod 'ReactiveCocoa', '~>5'
  #end
#end

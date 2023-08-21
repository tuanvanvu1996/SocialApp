# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SocialAppTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SocialAppTest
  pod 'Alamofire'
  pod 'SwiftHEXColors'
  pod 'ObjectMapper', '~> 3.5'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'FBSDKLoginKit'
end
post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target, |
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end


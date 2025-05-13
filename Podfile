# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'Virtual Closeout' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Virtual Closeout
  pod 'FSCalendar'

  # Webservice
  pod 'Alamofire', '~> 5.6.4'
  pod 'SwiftyJSON'
  
  # For image
  pod 'SDWebImage'

  # For chat text view
  pod 'GrowingTextView', :git => 'https://github.com/KennethTsang/GrowingTextView.git'

  # For gif
  pod 'SwiftGifOrigin'
  
  # For confetti
  pod 'SPConfetti'
  
  # For multiple image
  pod 'BSImagePicker', '~> 3.1'
  pod 'OpalImagePicker'
    
  # Crop image
  pod 'QCropper'
  
  # Firebase
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'
  
  # Stripe (supports iOS 11+ up to version 19.4)
  pod 'Stripe', '~> 19.4.0'
  
  pod 'PaddingLabel', '~> 1.0'
  # pod 'NeuKit'

  target 'Virtual CloseoutTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Virtual CloseoutUITests' do
    # Pods for testing
  end

  # 🔧 Post-install hook for architecture and active arch issues
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end
end

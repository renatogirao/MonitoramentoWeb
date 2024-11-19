# Uncomment the next line to define a global platform for your project
#  platform :ios, '13.0'


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Excluir arm64 apenas para versões de simulador em arquiteturas Intel
      if config.name == 'Debug'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end
end

target 'Monit2019' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Monit2019
  pod 'Firebase'
  pod 'FirebaseAnalytics'
  pod 'FirebaseCore'
  pod 'FirebaseRemoteConfig'
  pod 'FirebaseMessaging'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GoogleUtilities'
  pod 'GoogleDataTransport'
  pod 'Protobuf'
  pod 'FirebaseMessaging'
  

end

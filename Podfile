platform :ios, '9.0'
use_frameworks!

target 'Upupu' do
  pod 'Alamofire', '~> 4.0'
  pod 'Cartography', '~> 3.0'
  pod 'InAppSettingsKit', '~> 2.8'
  pod 'MBProgressHUD', '~> 1.0'
  pod 'SwiftyDropbox', '~> 4.3'

  target 'UpupuTests' do
    inherit! :search_paths

    pod 'Quick'
    pod 'Nimble'
  end
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Upupu/Pods-Upupu-Acknowledgements.plist',
                 'Upupu/Settings.bundle/Acknowledgements.plist',
                 :remove_destination => true)
end

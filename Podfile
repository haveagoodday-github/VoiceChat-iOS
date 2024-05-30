# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
source "https://gitlab.linphone.org/BC/public/podspec.git"
source "https://github.com/CocoaPods/Specs.git"

target 'VoiceChatApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for VoiceChatApp
  # pod 'WechatOpenSDK'
  pod 'WechatOpenSDK'
  pod 'WechatOpenSDK-XCFramework'
  pod  'AGConnectAPIAuthQQ'
  pod  'TencentOpenAPI-Mirror'
  pod 'AGConnectCore','~> 1.9.0.300'
  pod 'AGConnectAuth', '~> 1.9.0.300'
  
  
#  融云
#  pod 'RongCloudIM/IMKit', '~> 5.3.7'
# 名片 framework
#  pod 'RongCloudIM/ContactCard'
  
  # 七牛 Dependencies
  # pod "Qiniu", "~> 8.6.0"
  
  
  
  # 声网 Dependencies: https://github.com/AgoraIO/AgoraRtcEngine_iOS.git
  # 集成 RTC SDK
#  pod 'AgoraRtcEngine_iOS'
  
  
  # 集成即时通讯 SDK
#  pod 'Agora_Chat_iOS'
#  pod 'AgoraRtm_iOS', '1.5.1'
  pod 'SDWebImage'
  pod 'SDWebImageSwiftUI'
  pod 'AGEVideoLayout', '~> 1.0.2'
  
  
#  pod 'SVGAPlayer', '~> 2.5'
  
  
  # PromiseKit
  pod 'PromiseKit'
  pod 'PromiseKit/Alamofire'
  
  
  #支付宝
  pod  'AlipaySDK-iOS'
#  pod 'Pay'

  pod 'Protobuf', '= 3.22.1'
  pod 'lottie-ios'
  pod 'SSZipArchive'
  pod 'SnapKit'
  
  
  # Agora RTM
#  pod 'AgoraRtm_Special_iOS'

  # 悬浮窗口
#  pod 'JPSuspensionEntrance'
  
  pod 'linphone-sdk', '~> 5.2.66'
  

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end

  
  
end

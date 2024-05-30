//
//  AppDelegate.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/16.
//

import SwiftUI
import UIKit
import Foundation
import AGConnectCore
import AGConnectAuth
import Defaults

//import RongIMLib
//import RongPublicService
//import RongCustomerService
//import RongChatRoom
//import RongDiscussion
// 

import Alamofire


class AppDelegate: NSObject, UIApplicationDelegate, WXApiLogDelegate {
//    @State private var api = myAPI()
    @ObservedObject var tutorialContext = IncomingCallTutorialContext()
    
    var window: UIWindow?
    func onLog(_ log: String, logLevel level: WXLogLevel) {
        print("WeChat log: \(log)")
    }
    var qq: TencentOAuth!
    private let userKey = "com.VoiceChatApp.usermateInfo"
    @State private var isGoToCustomTabBar: Bool = false
    
    // 定义 localView 变量
    var localView: UIView!
    // 定义 remoteView 变量
    var remoteView: UIView!

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Socket.shared.connect() // 连接IM
//        Socket.shared.write(with: "")
        
        PaySDK.wxAppid = "wxbd30180703096d6d"
        PaySDK.alipayAppid = "2021004129675888"
        
        WXApi.startLog(by: WXLogLevel.detail, logDelegate: self)
        let isReg = WXApi.registerApp(Utility.AppID, universalLink: Utility.AppLink)
        print("微信注册: \(isReg)")
        print("是否安装微信: \(WXApi.isWXAppInstalled())")
        print("是否安装腾讯QQ: \(TencentOAuth.iphoneQQInstalled())")
        
        AGCInstance.startUp() // 初始化
        AGCInstance.setAccessNetworkStatus(true) // 配置 SDK 联网能力
        AGCApplicationDelegate.sharedInstance().didFinishLaunching(options: launchOptions)
        
        
//        initRoot()
//        initRCIM()
        
        // 金融级实名认证
        AliyunFaceAuthFacade.initSDK() // 金融级实名认证 - 初始化SDK。
        let metaInfo = AliyunFaceAuthFacade.getMetaInfo()
        print("getMetaInfo result: \(metaInfo)")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: metaInfo),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON 字符串: \(jsonString)")
            UserDefaults.standard.setValue(jsonString, forKey: userKey)
        } else {
            print("将数据转换为 JSON 字符串时出错")
        }
        

        
        
        resetDefaults()

        return isReg
    }
    
    
    
    private func resetDefaults() {
        Defaults.reset(.page_home_nest_isRefresh_progress)
        Defaults.reset(.me_dress_preview_svga_url)
    }
    
    
    

    func registerQQ() {
//        qq = TencentOAuth(appId: QQUtility.AppID, enableUniveralLink: true, universalLink: QQUtility.AppLink2, delegate: self)
        qq = TencentOAuth(appId: QQUtility.AppID, enableUniveralLink: true, universalLink: QQUtility.AppLink, delegate: self)
        qq!.authorize(["all"])
    }

    // 授权回调
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        return TencentOAuth.handleOpen(url)
//    }


    // send sign in request with credential
    func signIn(credential:AGCAuthCredential?) {
        if let credential = credential {
            AGCAuth.instance().signIn(credential: credential).onSuccess {  (result) in
                print("QQ登陆成功")
                self.isGoToCustomTabBar = true
                NavigationLink(destination: CustomTabBar(), isActive: self.$isGoToCustomTabBar) { }
            }.onFailure { (error) in
                print("QQ ====sign in failed\(error)")
            }
        }else{
            print("no credential")
        }
    }


//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        pushToken = deviceToken.description
//        pushToken = pushToken.replacingOccurrences(of: "<", with: "")
//        pushToken = pushToken.replacingOccurrences(of: ">", with: "")
//        pushToken = pushToken.replacingOccurrences(of: " ", with: "")
//        RCIMClient.shared().setDeviceToken(pushToken)
//    }

    

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("哈哈哈哈号")
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}







// FIXME: 已失效，调用SceneDelegate
// MARK: 微信登陆
extension AppDelegate : WXApiDelegate{
    // WeChat Login
    func onReq(_ req: BaseReq) {
        //微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用 sendRsp 返回。在调用 sendRsp 返回时，会切回到微信终端程序界面。
    }
    
    
    func onResp(_ resp: BaseResp) {
        
        if resp.isKind(of: SendAuthResp.self){
            let arsp = resp as! SendAuthResp
            if !(arsp.code?.isEmpty ?? true) {
                print("code====> \(arsp.code)")
                setIsSuccessLogin(forKey: .weChat, value: true)
                NotificationCenter.default.post(name: Notification.Name("code"), object: arsp.code)
            }
        }
        
        print("微信支付errCode: \(resp.errCode)")
        switch resp.errCode {
        case WXSuccess.rawValue:
            print("微信支付成功")
        case WXErrCodeUserCancel.rawValue:
            print("已取消付款")
        case WXErrCodeSentFail.rawValue:
            print("微信支付发送失败")
        case WXErrCodeAuthDeny.rawValue:
            print("微信支付授权失败")
        case WXErrCodeUnsupport.rawValue:
            print("微信不支持")
        default:
            print("微信支付失败")
        }
        
    }

}


// MARK: QQ登陆
extension AppDelegate : TencentSessionDelegate{
    func tencentDidLogin() {
        // 这里把true传递给我QQLoginView
        let credential = AGCQQAuthProvider.credential(withToken: qq!.accessToken, openId: qq!.openId)
        signIn(credential: credential)
        
        print("OpenID: \(qq!.openId ?? "No OpenID Available")")
        
        
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        print("zhlei")
    }
    
    func tencentDidNotNetWork() {
        print("zhleixxxx")
    }
    
    func onReq(_ req: QQBaseReq!) {
        print("zhleixxxx111")
    }
    
    func onResp(_ resp: QQBaseResp!) {
        print("zhleixxxx111xxxxx")
    }
    
    
}

//extension AppDelegate: RCIMClientReceiveMessageDelegate {
//    func onReceived(_ message: RCMessage, left nLeft: Int32, object: Any?) {
//        print(message)
//        print(nLeft)
//        print(object)
//    }
//    
//    func onRCIMReceived(_ message: RCMessage!, left nLeft: Int32, offline: Bool, hasPackage: Bool) {
//        print(message)
//        print(nLeft)
//        print(offline)
//        print(hasPackage)
//    }
//    
//}

//extension AppDelegate: RCMessageExpansionDelegate {
//    func messageExpansionDidUpdate(_ expansionDic: [String : String], message: RCMessage) {
//        print(message)
//    }
//    
//    func messageExpansionDidRemove(_ keyArray: [String], message: RCMessage) {
//        print(message)
//    }
//    
//}






extension NSURLRequest {
    static func allowsAnyHTTPSCertificateForHost(host: String) -> Bool {
        print("Allowing illegal stuff for: \(host)")
        return true
    }
}

extension URLRequest {
    static func allowsAnyHTTPSCertificateForHost(_ host:String) -> Bool{
        return false
    }
}







//protocol RCConnectionStatusChangeDelegate: AnyObject {
//    /**
//     IMLib连接状态的监听器
//     - Parameter status: SDK与融云服务器的连接状态
//     如果您设置了IMLib 连接监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
//     */
//    func onConnectionStatusChanged(_ status: RCConnectionStatus)
//    
//}


// MARK: - 支付回调
extension AppDelegate {

    // iOS 8 及以下请用这个
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: nil)
        
        if url.host == "safepay"{ //支付宝
            //支付回调
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: nil)

            //授权回调
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { res in
                print(res)
            })
            return true
        }else{//微信
            return WXApi.handleOpen(url, delegate: self)
        }
        
    }
    
    // iOS 9 以上请用这个
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: nil)
        
        if url.host == "safepay"{ //支付宝
            //支付回调
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: nil)
            //授权回调
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { res in
                print(res)
            })
            return true
        }else{//微信
            return WXApi.handleOpen(url,delegate: self)
        }
        
    }
    
    
    
    
}




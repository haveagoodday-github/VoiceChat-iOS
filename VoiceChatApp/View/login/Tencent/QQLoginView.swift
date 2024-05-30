//
//  QQLoginView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/16.
//

import SwiftUI
import UIKit
import Foundation

struct QQLoginView: View {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            Button(action: {
                LHFTencentShare.shared.login(
                    { info in
                        // 登录成功回调
                        print("Login success: \(info)")
                    },
                    failsure: { error in
                        // 登录失败回调
                        print("Login failed: \(error)")
                    }
                )
            }, label: {
                Text("QQ Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            })
        }

    }
    
    
//    func QQLogin() {
//        var oauth: TencentOAuth!
//        oauth = TencentOAuth(appId: QQUtility.AppID, enableUniveralLink: true, universalLink: QQUtility.AppLink, delegate: self)
//        if QQApiInterface.isQQInstalled() && QQApiInterface.isQQSupportApi() {
//            let permissions: [Any] = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
////            appDelegate.tencentAuth?.authorize(permissions)
//        } else {
//            print("当前设备未安装QQ应用或版本过低")
//        }
//        
//    }
    
    
    
}

typealias LHFTencentShare_loginFailedhandle = (_ error: String) -> Void
typealias LHFTencentShare_loginSuccessHandle = (_ info: [String: Any]) -> Void
typealias LHFTencentShare_resultHandle = (_ isSuccess: Bool, _ description: String) -> Void

class LHFTencentShare: NSObject, TencentSessionDelegate {
    
    static let shared: LHFTencentShare = LHFTencentShare()
    
    private override init() { }
    
    
    fileprivate var appID: String = ""
    fileprivate var accessToken: String = ""
    fileprivate var tencentAuth: TencentOAuth!
    var authInstance: TencentOAuth {
        if tencentAuth == nil {
            tencentAuth = TencentOAuth(appId: QQUtility.AppID, andDelegate: self)
        }
        return tencentAuth
    }
    fileprivate var loginSuccess: LHFTencentShare_loginSuccessHandle? = nil
    fileprivate var loginFailsure: LHFTencentShare_loginFailedhandle? = nil
    fileprivate var shareResult: LHFTencentShare_resultHandle? = nil
    
    /// 是否安装QQ客户端
        ///
        /// - Returns: true: 安装; false: 未安装
    func isQQInstall() -> Bool {
            
            return TencentOAuth.iphoneQQInstalled()
        }
    
    /// QQ是否支持SSO授权登录
        ///
        /// - Returns: true: 支持; false: 不支持
//        func isQQSupportSSO() -> Bool {
//            return TencentOAuth.iphoneQQSupportSSOLogin()
//        }
    
    
    
    func registeApp(_ appID: String) {
        LHFTencentShare.shared.appID = appID
//        LHFTencentShare.shared.tencentAuth = TencentOAuth(appId: QQUtility.AppID, andDelegate: self)
//        LHFTencentShare.shared.tencentAuth = TencentOAuth(appId: QQUtility.AppID, enableUniveralLink: true, universalLink: QQUtility.AppLink, delegate: self)
        LHFTencentShare.shared.tencentAuth = TencentOAuth(appId: QQUtility.AppID, andDelegate: LHFTencentShare.shared)
        print("LHFTencentShare.shared.tencentAuth: \(LHFTencentShare.shared.tencentAuth)")
        
    }
    
    func handle(_ url: URL) -> Bool {
        print("7777")
        
        // host: qzapp ; schem: tencent1105013800
        // response_from_qq    tencent1105013800
        
        if url.host == "qzapp" {
            print("授权登陆")
            // QQ授权登录
            return TencentOAuth.handleOpen(url)
            
        } else if url.host == "response_from_qq" {
            // QQ 分享
//            return QQApiInterface.handleOpen(url, delegate: LHFTencentShare.shared)
        }
        
        return  true
    }
    
    func login(_ success: LHFTencentShare_loginSuccessHandle? = nil, failsure: LHFTencentShare_loginFailedhandle? = nil) {
        
        // 需要获取的用户信息
        let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
//        let permissions = [kOPEN_PERMISSION_GET_USER_INFO]
        LHFTencentShare.shared.tencentAuth.authorize(permissions)
        
        LHFTencentShare.shared.loginSuccess = success
        LHFTencentShare.shared.loginFailsure = failsure
    }
    
    
}

//    MARK: - TencentSessionDelegate
extension LHFTencentShare {
    
    func tencentDidLogin() {
        
        self.tencentAuth.getUserInfo()
        if let accessToken = self.tencentAuth.accessToken {
            // 获取accessToken
            self.accessToken = accessToken
        }
    }
    
    func tencentDidNotNetWork() {
        if let closure = self.loginFailsure {
            closure("网络异常")
        }
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        var strMsg: String = ""
        if cancelled {
            // 用户取消登录
            if let closure = self.loginFailsure {
                closure("用户取消登录")
                strMsg = "用户取消登录"
            }
        } else {
            // 登录失败
            if let closure = self.loginFailsure {
                closure("登录失败")
                strMsg = "登录失败"
            }
        }
        //        MBProgressHUD.showAutoDismissHUD(message: strMsg)
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        
        let queue = DispatchQueue(label: "aaLoginQueue")
        queue.async {
            
            if response.retCode == 0 {
                
                if let res = response.jsonResponse {
                    
                    var info: [String: Any] = [:]
                    
                    info["rawData"] = res as? Dictionary<String, Any>
                    
                    if let uid = self.tencentAuth.getUserOpenID() {
                        info["uid"] = uid
                    }
                    
                    if let name = res["nickname"] as? String {
                        info["nickName"] = name
                    }
                    
                    if let sex = res["gender"] as? String {
                        info["sex"] = sex
                    }
                    
                    if let img = res["figureurl_qq_2"] as? String {
                        info["advatarStr"] = img
                    }
                    
                    DispatchQueue.main.async {
                        if let closure = self.loginSuccess {
                            
                            closure(info)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let closure = self.loginFailsure {
                        closure("获取授权信息异常")
                    }
                }
            }
        }
    }
    
    
    
}



//func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//    return TencentOAuth.handleOpen(url)
//}
//
//func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
//    return TencentOAuth.handleOpen(url)
//}



#Preview {
    QQLoginView()
}

//
//  SceneDelegate.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/1/7.
//

import Foundation
import UIKit
import SwiftUI
import Alamofire
import ProgressHUD
import Defaults
import OSLog

class SceneDelegate: UIResponder, UIWindowSceneDelegate, WXApiDelegate {
    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("scene 初始化")
        
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let contentView = SIPView(tutorialContext: delegate.tutorialContext)
        
        Defaults[.sceneDidDisconnect] = false
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("/===")
        Defaults[.sceneDidDisconnect] = true
        //        RCIM.shared().disconnect() // 断开连接 /// 自动会断开
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("/===没有离开app - 场景变得活跃起来")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("/===场景将退出活动")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        ProgressHUD.animate("Loading...")
        ProgressHUD.dismiss()
        print("/===从其他App跳转回来-场景将进入前景")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("/===app在后台运行 - 场景确实进入了背景")
    }
    
    func parseUrlQueryString(string: String) -> [String:Any] {
        let arr = string.components(separatedBy:"&")
        var data = [String:Any]()
        for row in arr {
            let pairs = row.components(separatedBy:"=")
            data[pairs[0]] = pairs[1]
        }
        return data
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        print(url)
        
        AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: nil)
        if url.host == "safepay"{//支付宝
            //支付回调
            print("支付宝支付回调 outside")
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: nil)
            
            //授权回调
            AlipaySDK.defaultService().processAuth_V2Result(url) { back in
                let response = back!
                let resultStatus = response["resultStatus"] as! String
                let memo = response["memo"]
                let result = response["result"] as! String
                
                let data = self.parseUrlQueryString(string: result)
                let success = data["success"]
                let result_code = data["result_code"] as! String
                let auth_code = data["auth_code"] as! String
                let user_id = data["user_id"] as! String
                if resultStatus == "9000" && result_code == "200" {
                    print(auth_code)
                    let temp_url: String = "\(baseUrl.url)api/ali_oauth_token?auth_code=\(String(auth_code))&user_id=\(UserCache.shared.getUserInfo()?.userId)"
                    print(temp_url)
                    AF.request(temp_url, method: .get
                    ).responseDecodable(of: alipayUserinfoModel.self) { res in
                        switch res.result {
                        case .success(let result):
                            if let temp_data = result.data {
                                print("---- \(temp_data)")
                                print("---- \(temp_data.nick_name)")
                                Defaults[.alipay_userinfo] = temp_data
                            }
                            ProgressHUD.succeed(result.message)
                        case .failure(let error):
                            print("getAlipayUserinfo result error: \(error.localizedDescription)")
                            ProgressHUD.failed(error.localizedDescription)
                        }
                    }
                }
            }
        } else { //微信
//            WXApi.handleOpen(url,delegate: WXApiManager.shared)
            WXApi.handleOpen(url, delegate: self)
        }
    }
    
}





extension SceneDelegate {
    func sendNotificationContent(senderName: String, message: String) {
        // 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = senderName
        content.body = message
        content.sound = UNNotificationSound.default

        // 设置触发条件，例如1秒后触发
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // 创建通知请求
        let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)

        // 将通知请求添加到通知中心
        center.add(request) { (error) in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
//                print("Notification added successfully")
            }
        }
    }
}

// MARK: 微信支付/登陆
extension SceneDelegate {
    
    func onReq(_ req: BaseReq) {
        //微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用 sendRsp 返回。在调用 sendRsp 返回时，会切回到微信终端程序界面。
    }
    
    
    func onResp(_ resp: BaseResp) {
        
        if resp.isKind(of: SendAuthResp.self){
            let arsp = resp as! SendAuthResp
            if !(arsp.code?.isEmpty ?? true) {
                print("code====>2: \(arsp.code)")
//                setIsSuccessLogin(forKey: .weChat, value: true)
                NotificationCenter.default.post(name: Notification.Name("code"), object: arsp.code)
            }
        } else {
            print("微信支付errCode: \(resp.errCode)")
            switch resp.errCode {
            case WXSuccess.rawValue:
                ProgressHUD.succeed("微信支付成功")
                print("微信支付成功")
            case WXErrCodeUserCancel.rawValue:
                ProgressHUD.failed("已取消付款")
                print("已取消付款")
            case WXErrCodeSentFail.rawValue:
                ProgressHUD.failed("微信支付发送失败")
                print("微信支付发送失败")
            case WXErrCodeAuthDeny.rawValue:
                ProgressHUD.failed("微信支付授权失败")
                print("微信支付授权失败")
            case WXErrCodeUnsupport.rawValue:
                ProgressHUD.error("微信不支持")
                print("微信不支持")
            default:
                ProgressHUD.error("微信支付失败")
                print("微信支付失败")
            }
        }
        
        
        
    }
}


struct alipayUserinfoModel: Decodable {
    let code: Int
    let message: String
    let data: data?
    
    struct data: Codable, Defaults.Serializable {
        let code: String
        let msg: String
        let avatar: String
        let nick_name: String
        let user_id: String
    }
}

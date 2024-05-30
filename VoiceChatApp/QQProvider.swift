//
//  QQProvider.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/18.
//

import Foundation
import UIKit
import AGConnectAuth

class QQProvider: BaseProvider, TencentSessionDelegate {
    static let sharedInstance = QQProvider()
    
    var qq: TencentOAuth? = nil

    
    private override init() {}
    
    override func startUp() {
//        qq = TencentOAuth(appId: QQUtility.AppID, andDelegate: self)
        qq = TencentOAuth(appId: QQUtility.AppID, enableUniveralLink: true, universalLink: QQUtility.AppLink2, delegate: self)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return TencentOAuth.handleOpen(url)
    }
    
    override func fetchCredential(controller: UIViewController, completion: @escaping CredentialBlock) {
        credentialBlock = completion
        qq?.authorize(["all"])
    }
    
    // TencentSessionDelegate
    func tencentDidLogin() {
        print("123")
        if let accessToken = qq?.accessToken, let openId = qq?.openId {
            let credential = AGCQQAuthProvider.credential(withToken: accessToken, openId: openId)
            if let credentialBlock = credentialBlock {
                credentialBlock(credential)
            }
        }
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        print("123失败")
        // 处理登录失败的情况
    }
    
    func tencentDidNotNetWork() {
        print("123网络问题")
        // 处理网络连接问题
    }
}

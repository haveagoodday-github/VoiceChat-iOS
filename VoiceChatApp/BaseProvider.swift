//
//  BaseProvider.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/18.
//

import Foundation
import UIKit
import AGConnectAuth

typealias CredentialBlock = (_ credential: AGCAuthCredential?) -> Void

class BaseProvider: NSObject {
    var credentialBlock: CredentialBlock?
    
    func startUp() {
        // 你可以在这里实现启动逻辑
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return false // 可根据需要返回不同的值
    }
    
    func fetchCredential(controller: UIViewController, completion: @escaping CredentialBlock) {
        // 你可以在这里实现获取凭据的逻辑，并在获取成功后调用 completion
    }
    
    static func sendVerifyCode(countryCode: String, phoneNumber: String, action: AGCVerifyCodeAction) {
        let setting = AGCVerifyCodeSettings(action: action, locale: nil, sendInterval: 30)
        AGCPhoneAuthProvider.requestVerifyCode(withCountryCode: countryCode, phoneNumber: phoneNumber, settings: setting).onSuccess { result in
            print("send verification code success")
        }.onFailure { error in
            print("send verification code failed")
        }
    }
    
    static func sendVerifyCode(email: String, action: AGCVerifyCodeAction) {
        let setting = AGCVerifyCodeSettings(action: action, locale: nil, sendInterval: 30)
        AGCEmailAuthProvider.requestVerifyCode(withEmail: email, settings: setting).onSuccess { result in
            print("send verification code success")
        }.onFailure { error in
            print("send verification code failed")
        }
    }
}

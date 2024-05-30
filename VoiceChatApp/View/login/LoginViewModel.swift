//
//  LoginViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/7.
//

import Foundation
import ProgressHUD


class LoginViewModel: ObservableObject {
    @Published var selectedCountryCode: String = "+86"
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var isLoginSucceed: Bool = false
    
    func login() {
        NetworkTools.requestAPI(convertible: "/user/login",
                                method: .post,
                                parameters: [
                                    "phone": phoneNumber,
                                    "password": password
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0, let data = result.data {
                UserDefaults.standard.setValue(data, forKey: "Authorization")
                self.setUserInfo()
                self.isLoginSucceed.toggle()
                // 初始化用户信息
                UserRequest.getMyUserInfo { _ in
                }
                ProgressHUD.succeed("登陆成功")
            } else {
                ProgressHUD.failed("登陆失败")
            }
        } failure: { _ in
            ProgressHUD.failed("登陆失败")
        }
    }
    
    private func setUserInfo() {
        
    }
}

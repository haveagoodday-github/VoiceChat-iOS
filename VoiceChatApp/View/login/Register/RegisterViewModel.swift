//
//  RegisterViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation
import SwiftUI
import ProgressHUD


class RegisterViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var phone: String = ""
    @Published var nickname: String = ""
    @Published var isLogin: Bool = false
    
    init() {
        
    }
    
    func register() {
        NetworkTools.requestAPI(convertible: "/user/register",
                                method: .post,
                                parameters: [
                                    "password": password,
                                    "nickname": nickname,
                                    "phone": phone
                                ],
                                responseDecodable: baseModel.self) { result in
            print(result.code)
            print(result.message)
            if result.code == 0 {
                self.login()
                self.isLogin.toggle()
                ProgressHUD.success("注册成功")
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { error in
            ProgressHUD.error("注册失败")
        }
    }
    
    private func login() {
        NetworkTools.requestAPI(convertible: "/user/login",
                                method: .post,
                                parameters: [
                                    "phone": phone,
                                    "password": password
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0, let data = result.data {
                UserDefaults.standard.setValue(data, forKey: "Authorization")
                self.setUserInfo()
            }
            ProgressHUD.failed("登陆失败")
        } failure: { _ in
            ProgressHUD.failed("登陆失败")
        }
    }
    
    
    private func setUserInfo() {
        NetworkTools.requestAPI(convertible: "/user/getMySelfUserInfo", responseDecodable: UserInfoRequestModel.self) { result in
            if result.code == 0 {
                UserCache.shared.saveUserInfo(result.data)
            }
        } failure: { _ in
            
        }

    }
    
    
    
}

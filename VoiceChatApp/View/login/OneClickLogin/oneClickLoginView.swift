//
//  oneClickLoginView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/19.
//

import SwiftUI
import Foundation
import Combine

struct oneClickLoginView: View {
    let loginModel = oneClickLoginModel()
    // 创建一个函数来查找当前视图控制器
    private func getCurrentViewController() -> UIViewController? {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        guard var topController = keyWindow.rootViewController else {
            return nil
        }
        while let presentedController = topController.presentedViewController {
            topController = presentedController
        }
        return topController
    }
    
    
    
    @State private var isSuccessOneClickLogin = false 
    
    @State private var returnString: String = ""
    var body: some View {
        ZStack(alignment: .center) {
            Button(action: {
                if let currentController = getCurrentViewController() {
                    loginModel.getLoginToken(controller: currentController) { result in
                        returnString = result ?? "返回数据为空"
                        if returnString == "用户信息获取成功" {
                            isSuccessOneClickLogin = true
                        }
                    }
                }
            }, label: {
                Text("本机号码一键登录")
                    .padding()
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color("Button for sign"))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            })
            
            
        }
        .background {
            NavigationLink(destination: CustomTabBar(), isActive: $isSuccessOneClickLogin, label: {
                EmptyView()
            })
        }
    }
    
    
}




struct oneClickLoginView_Previews: PreviewProvider {
    static var previews: some View {
        oneClickLoginView()
        
    }
}



struct AccessTokenChangePhoneNumberModel: Decodable {
    let data: Data?
    let code: Int
    let status: String?
    let timestamp: Int?
    let message: String

    struct Data: Decodable {
        let mobile: String
    }
}


// 返回的用户数据
struct ResultUserInfoModel: Codable {
    let code: Int
    let message: String
    let data: UserInfo
}

struct UserInfoRequestModel: Decodable {
    let code: Int
    let message: String
    let data: UserInfo
}
struct UserInfo: Codable {
//    let userId: Int
//    let avatar: String
//    let avatarBox: String?
//    let nickname: String
//    let phone: String?
//    let sex: Int
//    let birthday: String?
//    
//    let isFollow: Int?
//    
//    let goldImg: String?
//    let starsImg: String?
//    let vipImg: String?
//    
//    let fansNum: Int?
//    let dynamicNum: Int?
//    
//    
//    let createTime: String
//    let updateTime: String
//    
    let ry_uid: String?
    let ry_token: String?
    let starsImg: String?
    let goldImg: String?
    
    
    
    let userId: Int
    let username: String?
    let nickname: String
    let avatarBox: String?
    let email: String?
    let avatar: String
    let sex: Int
    let phone: String
    let birthday: String
    var isFollow: Int
    let fansNum: Int
    let followsNum: Int
    let dynamicNum: Int
    let createTime: String
    let updateTime: String
    
    let visitorNum: Int?
    let mibi: String?
    let balance: String?
}




class UserCache: ObservableObject {
    @Published var userInfo: UserInfo?
    static let shared = UserCache()

    private let userDefaults = UserDefaults.standard

    private let userKey = "com.VoiceChatApp.userinfo"

    func saveUserInfo(_ userInfo: UserInfo) {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(userInfo)
            userDefaults.set(userData, forKey: userKey)
        } catch {
            print("Error encoding user info: \(error)")
        }
    }

    func getUserInfo() -> UserInfo? {
        if let userData = userDefaults.data(forKey: userKey) {
            do {
                let decoder = JSONDecoder()
                let userInfo = try decoder.decode(UserInfo.self, from: userData)
                return userInfo
            } catch {
                print("Error decoding user info: \(error)")
            }
        }
        return nil
    }

    func clearUserInfo() {
        userDefaults.removeObject(forKey: userKey)
    }
}


//class UserCache: ObservableObject {
//    @Published var userInfo: UserInfo
//    static let shared = UserCache()
//
//    private let userDefaults = UserDefaults.standard
//
//    private let userKey = "com.VoiceChatApp.userinfo"
//
//    init() {
//        // Initialize userInfo with a default value if it's not already saved in UserDefaults
//        userInfo = UserInfo(id: 3, headimgurl: "https://mmbiz.qpic.cn/sz_mmbiz_jpg/IhB6Hhm1o7ePJiavV7zqakVTqnua7IogpxuicTEEecdFkup5UGPVLmstpEj7CpddUo72Oj5gPZqE9kz97Nd2KzQA/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1", nickname: "test", phone: "test", ry_uid: "1111", ry_token: "test", token: "test", user_id: "1111268", createtime: 1111111, expiretime: 111111, expires_in: 111111)
//        userInfo = getUserInfo()
//    }
//
//    func saveUserInfo(_ userInfo: UserInfo) {
//        do {
//            let encoder = JSONEncoder()
//            let userData = try encoder.encode(userInfo)
//            userDefaults.set(userData, forKey: userKey)
//            self.userInfo = userInfo // Update userInfo property
//        } catch {
//            print("Error encoding user info: \(error)")
//        }
//    }
//
//    func getUserInfo() -> UserInfo {
//        if let userData = userDefaults.data(forKey: userKey) {
//            do {
//                let decoder = JSONDecoder()
//                let userInfo = try decoder.decode(UserInfo.self, from: userData)
//                return userInfo
//            } catch {
//                print("Error decoding user info: \(error)")
//            }
//        }
//        return UserInfo(id: 3, headimgurl: "https://mmbiz.qpic.cn/sz_mmbiz_jpg/IhB6Hhm1o7ePJiavV7zqakVTqnua7IogpxuicTEEecdFkup5UGPVLmstpEj7CpddUo72Oj5gPZqE9kz97Nd2KzQA/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1", nickname: "test", phone: "test", ry_uid: "1111", ry_token: "test", token: "test", user_id: "1111268", createtime: 1111111, expiretime: 111111, expires_in: 111111)
//    }
//
//    func clearUserInfo() {
//        userDefaults.removeObject(forKey: userKey)
//        userInfo = UserInfo(id: 3, headimgurl: "https://mmbiz.qpic.cn/sz_mmbiz_jpg/IhB6Hhm1o7ePJiavV7zqakVTqnua7IogpxuicTEEecdFkup5UGPVLmstpEj7CpddUo72Oj5gPZqE9kz97Nd2KzQA/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1", nickname: "test", phone: "test", ry_uid: "1111", ry_token: "test", token: "test", user_id: "1111268", createtime: 1111111, expiretime: 111111, expires_in: 111111)
//    }
//}




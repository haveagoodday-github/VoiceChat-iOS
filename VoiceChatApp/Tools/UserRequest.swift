//
//  UserRequest.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/26.
//

import Foundation
import ProgressHUD
import SwiftUI
import Alamofire
import SwiftyJSON

class UserRequest {
    // MARK: 关注用户
    class func followUser(followedUserId: Int, completion: @escaping (Int) -> Void) {
        
        NetworkTools.requestAPI(convertible: "/user/followed",
                                method: .post,
                                parameters: [
                                    "beUserId": followedUserId,
                                    "state": 1
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                ProgressHUD.succeed("关注成功", delay: 1)
            } else {
                ProgressHUD.succeed("关注失败", delay: 1)
            }
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    // MARK: 取消关注用户
    class func cancelFollowedUser(cancelFollowedUserId: Int, completion: @escaping (Int) -> Void) {
        
        NetworkTools.requestAPI(convertible: "/user/followed",
                                method: .post,
                                parameters: [
                                    "beUserId": cancelFollowedUserId,
                                    "state": 0
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                ProgressHUD.succeed(result.message, delay: 1)
            } else {
                ProgressHUD.succeed(result.message, delay: 1)
            }
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    
    class func getUserInfo(userId: Int = UserCache.shared.getUserInfo()?.userId ?? 0, completion: @escaping (UserInfo) -> Void) {
        NetworkTools.requestAPI(convertible: "/user/getUserInfoById",
                                method: .post,
                                parameters: [
                                    "userId": userId
                                ],
                                responseDecodable: UserInfoRequestModel.self) { result in
            if result.code == 0 {
                completion(result.data)
            }
        } failure: { _ in
            
        }
    }
    
    class func getMyUserInfo(completion: @escaping (UserInfo) -> Void) {
        NetworkTools.requestAPI(convertible: "/user/getMySelfUserInfo", responseDecodable: UserInfoRequestModel.self) { result in
            if result.code == 0 {
                Socket.shared.write(with: "{'uid':'\(result.data.userId)'}")
                UserCache.shared.saveUserInfo(result.data)
                completion(result.data)
            }
        } failure: { _ in
            
        }
    }
    
    class func sendMsg(beUserId: Int, msg: String, completion: @escaping (Bool) -> Void) {
        var headers = HTTPHeaders()
        if let token = UserDefaults.standard.string(forKey: "Authorization") {
            headers.add(HTTPHeader.authorization(token))
        }
        
        let sendMessage = UserRequest.baseMessage(beUserId: beUserId, msg: msg)
        
        AF.request("http://192.168.31.214:8082/push/\(String(beUserId))",
                   method: .get, parameters: ["message": sendMessage],
                   headers: headers).response { response in
            if response.response?.statusCode == 200 {
                print("发送成功")
                completion(true)
            } else {
                ProgressHUD.error("发送失败")
                print("发送失败 \(msg)")
                completion(false)
            }
        }
    }
    
    
    class func sendMsgToRoom(roomId: Int, msg: String?, completion: @escaping (Bool) -> Void) {
        var headers = HTTPHeaders()
        if let token = UserDefaults.standard.string(forKey: "Authorization") {
            headers.add(HTTPHeader.authorization(token))
        }
        
        
        AF.request("http://192.168.31.214:8082/push/room/\(String(roomId))",
                   method: .get,
                   parameters: ["message": msg],
                   headers: headers).response { response in
            if response.response?.statusCode == 200 {
                print("发送成功")
                completion(true)
            } else {
                ProgressHUD.error("发送失败")
                print("发送失败 \(msg)")
                completion(false)
            }
        }
    }
    
    
    class func baseMessage(userId: Int = UserCache.shared.getUserInfo()?.userId ?? 0, beUserId: Int, msg: String) -> String? {
        let dict = [
            "userId": UserCache.shared.getUserInfo()?.userId ?? 0,
            "beUserId": beUserId,
            "msg": msg
        ] as [String: Any?]
        let json = JSON(dict)
        let sendMessage = json.rawString()
        debugPrint(sendMessage)
        return sendMessage
    }
    
    
}




struct MessageRequestModel: Decodable {
    let code: Int?
    let message: String?
}

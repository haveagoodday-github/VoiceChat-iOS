//
//  RoomRequest.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/26.
//

import Foundation
import ProgressHUD

class RoomRequest {
    class func enterRoom(roomId: Int, roomPass: String, isDefault: Int, hostId: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "api/enter_room",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "roomPass": roomPass,
                                    "isDefault": isDefault,
                                    "hostId": hostId
                                ],
                                responseDecodable: baseModel.self) { result in
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    class func exitRoom(roomId: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "api/quit_room",
                                method: .post,
                                parameters: [
                                    "roomId": roomId
                                ],
                                responseDecodable: baseModel.self) { result in
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    class func upMic(userId: Int, roomId: Int, position: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "api/up_microphone",
                                method: .post,
                                parameters: [
                                    "userId": userId,
                                    "roomId": roomId,
                                    "position": position
                                ],
                                responseDecodable: UpMicrophoneModel.self) { result in
            if result.code == 0 {
                ProgressHUD.succeed("上麦成功", delay: 1)
            } else {
                ProgressHUD.failed("上麦失败", delay: 1)
            }
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    
    class func downMic(roomId: Int, roomAdminId: Int, userId: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "api/go_microphone",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "userId": userId,
                                    "roomAdminId": roomAdminId
                                ],
                                responseDecodable: baseModel.self) { result in
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    class func lockMic(roomId: Int, position: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "api/shut_microphone",
                                method: .post,
                                parameters: [
                                    "position": position,
                                    "roomId": roomId
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                ProgressHUD.succeed("锁定麦位成功", delay: 1)
            } else {
                ProgressHUD.failed("锁定麦位失败", delay: 1)
            }
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    class func unlockMic(roomId: Int, position: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "api/open_microphone",
                                method: .post,
                                parameters: [
                                    "position": position,
                                    "roomId": roomId
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                ProgressHUD.succeed("解锁麦位成功", delay: 1)
            } else {
                ProgressHUD.failed("解锁麦位失败", delay: 1)
            }
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    // MARK: 打开用户麦克风（No Token）
    class func openUserMic(userId: Int, roomId: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "api/remove_sound",
                                method: .post,
                                parameters: [
                                    "userId": userId,
                                    "roomId": roomId
                                ],
                                responseDecodable: baseModel.self) { result in
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }

    }
    
    // MARK: 关闭用户麦克风（No Token）
    class func closeUserMic(userId: Int, roomId: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "api/is_sound",
                                method: .post,
                                parameters: [
                                    "userId": userId,
                                    "roomId": roomId
                                ],
                                responseDecodable: baseModel.self) { result in
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
    
    
    class func updateRoomInfo(cover: String, intro: String, roomName: String, roomPass: String, roomBackgroudID: Int) {
        
    }
    
    
    class func updateRoomBackground(roomId: Int, backgroundId: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "", responseDecodable: baseModel.self) { result in
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }

    }
    
}


// MARK: 礼物内容
extension RoomRequest {
    
    class func sendGift(roomId: Int, giftId: Int, userIds: String, num: Int, packType: Int, completion: @escaping (Int) -> Void) {
        NetworkTools.requestAPI(convertible: "/gift/sendGift", responseDecodable: baseModel.self) { result in
            completion(result.code)
        } failure: { _ in
            completion(-1)
        }
    }
}

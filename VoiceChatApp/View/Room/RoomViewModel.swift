//
//  RoomViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/26.
//

import Foundation
import SwiftyJSON
import ProgressHUD
import SwiftUI
import Defaults

extension RoomModel {
    
    func lockMic(position: Int) {
        NetworkTools.requestAPI(convertible: "/room/lockMic",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "position": position
                                ],
                                responseDecodable: MicrophoneRequestModel.self) { result in
            self.sendMsgToRoomByType(7, "锁麦")
            DispatchQueue.main.async {
                self.microphoneList = result.data
            }
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
    
    func unlockMic(position: Int) {
        NetworkTools.requestAPI(convertible: "/room/unlockMic",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "position": position
                                ],
                                responseDecodable: MicrophoneRequestModel.self) { result in
            self.sendMsgToRoomByType(8, "解锁麦")
            DispatchQueue.main.async {
                self.microphoneList = result.data
            }
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
    
    func banSpeak(userId: Int) {
        NetworkTools.requestAPI(convertible: "/room/banSpeak",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "userId": userId
                                ],
                                responseDecodable: baseModel.self) { result in
            self.sendMsgToRoomByType(17, "禁麦")
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
    
    func unbanSpeak(userId: Int) {
        NetworkTools.requestAPI(convertible: "/room/unbanSpeak",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "userId": userId
                                ],
                                responseDecodable: baseModel.self) { result in
            self.sendMsgToRoomByType(18, "解禁麦")
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
    
    func banMessage(userId: Int) {
        NetworkTools.requestAPI(convertible: "/room/banMessage",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "userId": userId
                                ],
                                responseDecodable: baseModel.self) { result in
            self.sendMsgToRoomByType(9, "禁言")
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
    
    func unbanMessage(userId: Int) {
        NetworkTools.requestAPI(convertible: "/room/unbanMessage",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "userId": userId
                                ],
                                responseDecodable: baseModel.self) { result in
            self.sendMsgToRoomByType(10, "解禁言")
            ProgressHUDTool.showHUD(result.code, message: result.message)
            
        } failure: { _ in
            
        }
    }
    
    func upMic(userId: Int, position: Int) {
        NetworkTools.requestAPI(convertible: "/room/upMic",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "userId": userId,
                                    "position": position
                                ],
                                responseDecodable: MicrophoneRequestModel.self) { result in
            self.sendMsgToRoomByType(3, "上麦")
            DispatchQueue.main.async {
                withAnimation(.spring) {
                    self.microphoneList = result.data
                    // 显示麦克风icon
                    self.isShowMicrophoneIcon = true
                    // 打开麦克风
                    self.isOpenMicrophone = true
                }
            }
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
    
    func downMic(userId: Int) {
        NetworkTools.requestAPI(convertible: "/room/downMic",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "userId": userId
                                ],
                                responseDecodable: MicrophoneRequestModel.self) { result in
            self.sendMsgToRoomByType(4, "下麦")
            DispatchQueue.main.async {
                withAnimation(.spring) {
                    self.microphoneList = result.data
                    // 显示麦克风icon
                    self.isShowMicrophoneIcon = false
                    // 打开麦克风
                    self.isOpenMicrophone = false
                }
            }
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
}

struct RoomMessageTypeModel: Identifiable, Equatable, Hashable, Decodable {
    var id: String = UUID().uuidString
    
    let type: Int
    let roomId: Int
    let senderUserId: Int
    let beUserId: Int
    let sex: Int
    
    let goldImg: String
    let nickname: String
    let avatar: String
    let avatarBox: String
    let starsImg: String
    
    let ControlName: String
    let content: String
    let emoji: String
    
}

class RoomModel: ObservableObject {
    @Published var roomId: Int = 0
    @Published var roomInfo: RoomInfoModel? = nil // 房间信息
    
    @Published var roomBackgroundArray: [RoomBackgroundModel] = [] // 获取房间背景列表
    @Published var microphoneList: [MicrophoneModel] = [] // 麦位列表
    @Published var roomHistoryUserList: [RoomHistoryUserModel] = [] // 历史用户
    @Published var emojiList: [EmojiModel] = [] // 表情列表
    
    @Published var isShowRoomIntro: Bool = false
    @Published var isShowCloseRoom: Bool = false
    @Published var isShowHistoryUserList: Bool = false
    @Published var isShowSettingBackground: Bool = false
    @Published var isShowBlackList: Bool = false
    @Published var isShowRoomSettingFullCover: Bool = false
    // 卡片控制
    @Published var isShowUserInfoCard: Bool = false
    @Published var currentShowUserInfoCardUserId: Int = 0
    @Published var isShowRoomSettingCard: Bool = false
    @Published var isShowRoomGiftCard: Bool = false
    // 底部内容
    @Published var isShowMicrophoneIcon: Bool = false
    @Published var isShowSoundIcon: Bool = false
    @Published var isOpenMicrophone: Bool = false
    @Published var isOpenSound: Bool = false
    @Published var text: String = ""
    
    
    // 球化
    @Published var isShowFloatBall: Bool = false
    
    // Message
    @Published var roomMessageType: RoomMessageTypeEnum = .room
    
    // 房间设置
    @Published var currentBg: RoomBackgroundModel? = nil
    
    
    
    @Published var joinRoomData: joinRoomModel.DataItem? = nil
    

    @Published var isForbadMic: Bool = false
    
//
//    @Published var RoomGiftRecordList: [RoomGiftRecordModel.data.list] = []
    @Published var currentPage: Int = 1
    @Published var total: Int = 0
    @Published var publicScreenContent: [RoomMessageTypeModel] = []
    
    
    
    func joinRoom(roomId: Int) {
        self.roomId = roomId
        enterRoom() // 进入房间
        getRoomBackgroundArray()
        getSmileyList()
        getMicrophoneList()
        
        NotificationCenter.default.addObserver(forName: .receiveNewRoomMessage, object: nil, queue: .main) { message in
            let roomMessage = Defaults[.roomMessage]
            debugPrint("NotificationCenter Room: \(roomMessage)")
            
            if let dataFromString = roomMessage.data(using: .utf8, allowLossyConversion: false) {
                let json = try? JSON(data: dataFromString)
                
                debugPrint("NotificationCenter Room JSON : \(json)")
                
                let type = json?["type"].int ?? 0
                let roomId = json?["roomId"].int ?? 0
                let senderUserId = json?["senderUserId"].int ?? 0
                let beUserId = json?["beUserId"].int ?? 0
                
                let goldImg = json?["senderUserInfo"]["goldImg"].string ?? ""
                let nickname = json?["senderUserInfo"]["nickname"].string ?? ""
                let avatar = json?["senderUserInfo"]["avatar"].string ?? ""
                let avatarBox = json?["senderUserInfo"]["avatarBox"].string ?? ""
                let starsImg = json?["senderUserInfo"]["starsImg"].string ?? ""
                let sex = json?["senderUserInfo"]["sex"].int ?? 0
                
                let ControlName = json?["ControlName"].string ?? ""
                let content = json?["content"].string ?? ""
                let emoji = json?["emoji"].string ?? ""
                
                self.publicScreenContent.append(RoomMessageTypeModel(type: type, roomId: roomId, senderUserId: senderUserId, beUserId: beUserId, sex: sex, goldImg: goldImg, nickname: nickname, avatar: avatar, avatarBox: avatarBox, starsImg: starsImg, ControlName: ControlName, content: content, emoji: emoji))
            }

        }
        
    }
    
    
    
    func sendMsgToRoomByType(_ type: Int,_ ControlName: String? = nil, _ beUserId: Int? = nil, content: String? = nil, emoji: String? = nil) {
        if let u = UserCache.shared.getUserInfo() {
            let msg: JSON = [
                "roomId": roomId,
                "type": type,
                "senderUserId": UserCache.shared.getUserInfo()?.userId ?? 0,
                "ControlName": ControlName,
                "beUserId": beUserId,
                "senderUserInfo": [
                    "avatar": u.avatar,
                    "avatarBox": u.avatarBox,
                    "nickname": u.nickname,
                    "sex": u.sex,
                    "starsImg": u.starsImg,
                    "goldImg": u.goldImg
                ],
                "content": content,
                "emoji": emoji
            ]
            UserRequest.sendMsgToRoom(roomId: roomId, msg: msg.rawString()) { isSuccess in }
        }
    }
    
    func sendWelcomeMessage(_ nickname: String) {
        sendMsgToRoomByType(0, "发送欢迎消息", content: "欢迎 \(nickname)")
    }
    
    
    // 进入房间
    func enterRoom() {
        NetworkTools.requestAPI(convertible: "/room/enterRoom",
                                method: .post,
                                parameters: ["roomId": roomId],
                                responseDecodable: RoomInfoRequestModel.self) { result in
            DispatchQueue.main.async {
                self.roomInfo = result.data
                print("Room: \(result.data)")
            }
            self.sendMsgToRoomByType(5, "进入房间")
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
    
    // 退出房间
//    func exitRoom() {
//        NetworkTools.requestAPI(convertible: "/room/enterRoom",
//                                method: .post,
//                                parameters: ["roomId": roomId],
//                                responseDecodable: baseModel.self) { result in
//            self.sendMsgToRoomByType(6)
//            ProgressHUDTool.showHUD(result.code, message: result.message)
//        } failure: { _ in
//            
//        }
//    }
    
    
    
    // MARK: 获取房间背景列表(No Token)
    func getRoomBackgroundArray() {
        NetworkTools.requestAPI(convertible: "/background/getAllRoomBackground",
                                method: .get,
                                responseDecodable: RoomBackgroundRequestModel.self) { result in
            if result.code == 0 {
                self.roomBackgroundArray = result.data
            }
        } failure: { _ in
            
        }
    }
    
    
    
    // MARK: 获取房间信息(No Token)
    func getRoomInfo() {
        NetworkTools.requestAPI(convertible: "/room/getRoomInfo",
                                method: .get,
                                parameters: [
                                    "roomId": roomId
                                ],
                                responseDecodable: RoomInfoRequestModel.self) { result in
            DispatchQueue.main.async {
                self.roomInfo = result.data
            }
        } failure: { _ in
            
        }

    }
    
    // MARK: 获取麦序列表
    /// 第一个是房主麦克风
    func getMicrophoneList() {
        NetworkTools.requestAPI(convertible: "/room/getMicList",
                                method: .get,
                                parameters: [
                                    "roomId": roomId
                                ],
                                responseDecodable: MicrophoneRequestModel.self) { result in
            DispatchQueue.main.async {
                self.microphoneList = result.data
            }
        } failure: { _ in
            
        }
    }
    

    // MARK: 获取房间礼物记录
    func get_gift_record(roomId: Int, page: Int = 1, pageSize: Int = 20, isRefresh: Bool = false, completion: @escaping (String) -> Void) {
        
    }
    
    func getRoomHistoryUser(state: Int, isOnline: Int = 1, sort: Int = 0, page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/room/getRoomHistoryUser",
                                method: .get,
                                parameters: [
                                    "roomId": roomId,
                                    "state": state,
                                    "isOnline": 0,
                                    "sort": 0,
                                    "page": 1
                                ],
                                responseDecodable: RoomHistoryUserRequestModel.self) { result in
            DispatchQueue.main.async {
                self.roomHistoryUserList = result.data
            }
        } failure: { _ in
            
        }
    }
    
    
    func closeRoom() {
        // TODO: 下麦操作(服务端完成) / 退出通话 /  Default(.go_to_room).reset()
        NetworkTools.requestAPI(convertible: "/room/exitRoom",
                                method: .post,
                                parameters: ["roomId": roomId],
                                responseDecodable: baseModel.self) { result in
            self.sendMsgToRoomByType(6, "退出房间")
            ProgressHUDTool.showHUD(result.code, message: result.message)
        } failure: { _ in
            
        }
    }
    
    
    func updateBackground(backgroundId: Int, completion: @escaping (String) -> Void) {
        NetworkTools.requestAPI(convertible: "/background/updateRoomBackground",
                                method: .post,
                                parameters: [
                                    "roomBackgroundId": backgroundId,
                                    "roomId": roomId
                                ],
                                responseDecodable: baseModel.self) { result in
            debugPrint("backgroundId: \(backgroundId)")
            if result.code == 0 {
                self.sendMsgToRoomByType(16, "更新背景")
                
            } else {
                ProgressHUD.failed(result.message)
            }
        } failure: { _ in
            
        }
    }
    
    // 关闭心动值
    func closeXDZ() {
        NetworkTools.requestAPI(convertible: "/room/updateXDZStatus",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "state": 0
                                ],
                                responseDecodable: baseModel.self) { result in
            self.sendMsgToRoomByType(15, "关闭心动值")
        } failure: { _ in
            
        }
    }
    // 打开心动值
    func openXDZ() {
        NetworkTools.requestAPI(convertible: "/room/updateXDZStatus",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "state": 1
                                ],
                                responseDecodable: baseModel.self) { result in
            self.sendMsgToRoomByType(14, "打开心动值")
        } failure: { _ in
            
        }
    }
    
    // 清理公屏
    func clearPublicScreen() {
        self.sendMsgToRoomByType(13, "清理公屏")
    }
    
    
}

// MARK: IS
extension RoomModel {
    func isHost() -> Bool {
        if let isHost = self.roomInfo?.isHost {
            return isHost == 1
        }
        return false
    }
    
    
    func isUpMic() -> Bool {
        return self.microphoneList.map({ $0.userId == UserCache.shared.getUserInfo()?.userId ?? 0 }).isEmpty
    }
    func isShowXDZ() -> Bool {
        if let xdz = self.roomInfo?.isOpenXDZ {
            return xdz == 1
        }
        return false
    }
    func isBanSpeak() -> Bool {
        if let isBanSpeak = self.roomInfo?.isBanSpeak, let isBanSpeakMsg = self.roomInfo?.isBanSpeakMsg {
            return isBanSpeak == 1 || isBanSpeakMsg == 1
        }
        return false
    }
    func isBanMessage() -> Bool {
        if let isBanMsg = self.roomInfo?.isBanMsg, let isBanSpeakMsg = self.roomInfo?.isBanSpeakMsg {
            return isBanMsg == 1 || isBanSpeakMsg == 1
        }
        return false
    }
}


extension RoomModel {
    func sendMsg() {
        if !text.isEmpty {
            // 发送消息
            sendMsgToRoomByType(0, "发送普通消息", content: text)
            text = ""
        }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



// TODO: 待完成的Func
extension RoomModel {
    // MARK: 获取表情列表
    func getSmileyList() {
        NetworkTools.requestAPI(convertible: "/emoji/getEmojiList",
                                method: .get,
                                responseDecodable: EmojiRequestModel.self) { result in
            self.emojiList = result.data
        } failure: { _ in
            
        }
    }
    
}

//
//  RoomModel.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/8/30.
//

import Foundation
import SwiftUI
import Alamofire

// 获取房间背景列表
struct GetRoomBackgroundModel: Decodable {
    let code: Int
    let message: String
    let data: [RoomBackground]
    
    struct RoomBackground: Decodable {
        let id: Int
        let img: String
        let bname: String
    }
}

// 获取房间信息(No Token)
struct RoomInfoRequestModel: Decodable {
    let code: Int
    let message: String
    let data: RoomInfoModel
}
struct RoomInfoModel: Decodable {
    let roomId: Int
    let roomUid: Int
    let roomName: String
    var roomBackground: String
    let welcome: String? // 新增
    let intro: String
    let onlineNum: Int
    let hot: Int
    let roomCover: String
    let type: Int
    let isBanSpeak: Int
    let isBanMsg: Int
    let isBanSpeakMsg: Int
    let isHost: Int
    let createTime: String
    let updateTime: String
    
    let xdz: Int
    let roomPassword: String
    let isOpenXDZ: Int
}

// 麦位列表
struct MicrophoneRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [MicrophoneModel]
}
struct MicrophoneModel: Decodable {
    let state: Int
    let position: Int
    let userId: Int
    let nickname: String?
    let avatar: String?
    let avatarBox: String?
    let xdzNum: Int?
}


// 房间历史用户
struct RoomHistoryUserRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [RoomHistoryUserModel]
}
struct RoomHistoryUserModel: Decodable {
    let userId: Int
    let nickname: String
    let avatar: String
    let avatarBox: String?
    let state: Int
    let isOnline: Int
    let updateTime: String
}


struct RoomBackgroundRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [RoomBackgroundModel]
}
struct RoomBackgroundModel: Decodable, Equatable {
    let backgroundId: Int
    let backgroundUrl: String
    let backgroundName: String
    let createTime: String
    let updateTime: String
}

struct RoomBackgroundRequestSingleModel: Decodable {
    let code: Int
    let message: String
    let data: RoomBackgroundModel
}

// Emoji表情
struct EmojiRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [EmojiModel]
}
struct EmojiModel: Decodable {
    let emojiId: Int
    let name: String
    let gifUrl: String
    let type: Int
}




// MARK: enum
enum RoomMessageTypeEnum: String {
    case room = "房间"
    case tale = "传说"
    case broadcast = "广播"
}


// 获取房间人员(No Token)
struct GetRoomPersonModel: Decodable {
    let code: Int
    let message: String
    let data: RoomData
    
    struct RoomData: Decodable {
        let roomId: String
        let admin: [personInfo]?
        let visitor: [personInfo]?
    }
    struct personInfo: Decodable, Hashable {
        let id: Int
        let nickname: String
        let headimgurl: String
        let is_admin: Int
    }
}

// 上麦(No Token)
struct UpMicrophoneModel: Decodable {
    let code: Int                       // 响应状态码
    let message: String                 // 响应消息
    let data: dataDetails?
    
    struct dataDetails: Decodable {
//        let cp: [Any]                   // 未提供说明的数据，暂时使用 Any 类型
        let user: User
        
        struct User: Decodable {
            let id: Int                 // 用户ID
            let nickname: String        // 用户昵称
            let headimgurl: String      // 用户头像URL
            let nick_color: String?     // 用户昵称颜色，可能为空
        }
    }
}



struct MicrophoneListModel: Decodable {
    let code: Int
    let message: String
    let data: dataDetail
    
    struct dataDetail: Decodable {
        let userId: Int?
        let microphone: [microphoneList]
    }
    
    struct microphoneList: Decodable, Identifiable, Hashable {
        let id: String = UUID().uuidString
        let shut_sound: Int
        let status: Int
        let is_sound: Int
        let userId: Int?
        let avatar: String?
        let ml: Int?
        let nickname: String?
        let sex: Int?
        let txk: String?
        let mic_color: String?
        let price: Int?
        let is_play: Int?
        let is_master: Int?
    }
}

enum JoinRoomData {
    case dataItem(joinRoomModel.DataItem)
    case stringData(String)
}


struct joinRoomModel: Decodable {
    let code: Int
    let message: String
    let data: DataItem
    
    struct DataItem: Decodable {
        let id: Int
        let numid: String
        let uid: Int
        let roomStatus: Int
        let room_name: String
        let room_cover: String
        let name: String
        let room_intro: String
        let room_pass: String
        let room_type: String
        let hot: Int
        let room_background: Int
        let roomAdmin: String?
        let roomSpeak: String?
        let roomSound: String?
        let microphone: String
        let roomJudge: String?
        let is_afk: Int
        let nickname: String
        let headimgurl: String
        let sex: Int
        let roomVisitor: String
        let play_num: Int
        let room_leixing: Int
        let giftPrice: Int
        let ml: Int
        let user_type: Int
        let is_sound: Int
        let is_jinyan: Int
        let uid_sound: Int
        let uid_black: Int
        let is_mykeep: Int
        let back_img: String
        let room_welcome: String
        let txk: String?
        let mic_color: String
        let gap: Int
    }
}


struct micModel: Decodable, Hashable {
    let shut_sound: Int
    let is_sound: Int
    let status: Int
}


struct smileyModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable, Hashable {
        let id: Int
        let pid: Int
        let name: String
        let emoji: String
        let t_length: Int
    }
}

struct singleSmileyModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable {
        let id: Int
        let pid: Int
        let name: String
        let emoji: String
        let t_length: Int
        let enable: Int
        let sort: Int
        let addtime: Int
        let is_answer: Int
    }
}


struct RoomGiftRecordModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let list: [list]
        let currentPage: Int
        let limit: Int
        let total: Int
        
        struct list: Decodable {
            let id: Int
            let type: Int
            let giftId: Int
            let uid: Int
            let roomId: Int
            let guild_id: Int
            let giftName: String
            let giftNum: Int
            let giftPrice: Int
            let gift: gift
            let to_user: to_user_from_user
            let from_user: to_user_from_user
            let created_at: String
            
            struct gift: Decodable {
                let id: Int
                let name: String
                let img: String
                let gifurl: String?
            }
            
            struct to_user_from_user: Decodable {
                let id: Int
                let nickname: String
                let sex: Int
                let headimgurl: String
                let city: String
            }
            

        }
    }
}





struct onlineModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let data: [data]
        let num: Int
        
        struct data: Decodable {
            let id: Int
            let headimgurl: String
            let nickname: String
            let signature: String
            let sex: Int
        }
    }
}






struct baseModel: Decodable {
    let code: Int
    let message: String
    let data: String?
}

struct baseModel2: Decodable {
    let code: Int
    let message: String
}


struct RoomPersonInfoModel: Decodable {
    let code: Int
    let message: String
    let data: dataItem
    
    struct dataItem: Decodable {
        let admin: [personItem]
        let visitor: [personItem]
        
        struct personItem: Decodable {
            let selfID: String = UUID().uuidString
            let id: Int
            let nickname: String
            let headimgurl: String
            let is_admin: Int
        }
    }
}

// MARK: 抱人上麦/获取房间人员
class holdingUpMicModel: ObservableObject {
    @Published var visitorArray: [RoomPersonInfoModel.dataItem.personItem] = []
    @Published var adminArray: [RoomPersonInfoModel.dataItem.personItem] = []
    
    
    // 获取房间人员(No Token)
    func getRoomPerson(roomId: Int) {
        
        NetworkTools.requestAPI(convertible: "api/getRoomUsers",
                                method: .post,
                                parameters: [
                                    "roomId": roomId
                                ],
                                responseDecodable: RoomPersonInfoModel.self) { result in
            DispatchQueue.main.async {
                debugPrint("getRoomPerson function Success result：\(result)")
                self.adminArray = result.data.admin
                self.visitorArray = result.data.visitor
            }
        } failure: { _ in
            
        }

    }

}



//
//  RoomSettingModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/11/18.
//

import Foundation
import Defaults

class RoomSettingModel: ObservableObject {
    @Published var RoomBackgroundList: [RoomBackgroundModel] = [] // TODAY
    
    
    @Published var adminList: [GetRoomPersonModel2.personInfo] = []
    @Published var visitorList: [GetRoomPersonModel2.personInfo] = []
    @Published var typeListArray: [RoomTypeModel] = []
    
    @Published var gameListData: [GameListModel.data] = []
    
    @Published var selected: RoomTypeModel = RoomTypeModel(roomTypeId: -1, name: "全部", typeType: -1)
    
    init() {
        self.getRoomBackground() { msg in }
        self.getType()
        self.getGameList() { msg in }
    }
    
    // MARK: 设置房间
    func settingRoom(uid: Int, coverURL: String, room_intro: String, room_name: String, room_pass: String, room_type: Int, room_backgroundID: Int, roomId: Int, completion: @escaping (String) -> Void) {
        
        NetworkTools.requestAPI(convertible: "api/edit_room?uid=\(String(uid))&cover=\(coverURL)&room_intro=\(room_intro)&room_name=\(room_name)&room_pass\(room_pass)&room_type=\(room_type)&room_background=\(room_backgroundID)&id=\(roomId)", responseDecodable: baseModel.self) { result in
            completion(result.message)
        } failure: { _ in
            completion("设置房间失败")
        }
    }
    
    
    func getRoomPerson(roomId: Int, completion: @escaping (String) -> Void) {
        
        NetworkTools.requestAPI(convertible: "api/getRoomUsers?id=\(roomId)", responseDecodable: GetRoomPersonModel2.self) { result in
            DispatchQueue.main.async {
                debugPrint("getRoomPerson function Success result：\(result)")
                self.adminList = result.data.admin
                self.visitorList = result.data.visitor
            }
        } failure: { _ in
            
        }

    }
    
    func getRoomBackground(completion: @escaping (String) -> Void) {
        NetworkTools.requestAPI(convertible: "/background/getAllRoomBackground", responseDecodable: RoomBackgroundRequestModel.self) { result in
            DispatchQueue.main.async {
                self.RoomBackgroundList = result.data
            }
        } failure: { _ in
            
        }
    }
    
    // MARK: 修改背景
    func changeBackground(roomId: Int, imgUrl: String, backgroundName: String, completion: @escaping (String) -> Void) {
        
        NetworkTools.requestAPI(convertible: "api/background/upload",
                                method: .post,
                                parameters: [
                                    "imgUrl": imgUrl,
                                    "backgroundName": backgroundName,
                                    "roomId": roomId
                                ],
                                responseDecodable: baseModel.self) { result in
            completion(result.message)
        } failure: { _ in
            completion("修改背景失败")
        }
    }
    
    
    // MARK: 获取房间类型列表(No Token)
    func getType() {
//        NetworkTools.requestAPI(convertible: "api/room_t_categories",
//                                responseDecodable: RoomTypeRequestModel.self) { result in
//            DispatchQueue.main.async {
//                debugPrint("getType function Success result：\(result.message)")
//                self.typeListArray = result.data
//            }
//        } failure: { _ in
//            
//        }
    }
    
    
    // MARK: 游戏列表
    func getGameList(completion: @escaping (String) -> Void) {
//        NetworkTools.requestAPI(convertible: "api/Game888/game_List",
//                                method: .post,
//                                responseDecodable: GameListModel.self) { result in
//            DispatchQueue.main.async {
//                self.gameListData = result.data
//            }
//        } failure: { _ in
//            completion("获取游戏列表失败")
//        }

    }
    
    
    
    @Published var settingArray: [item] = [
        item(img: "admin_jiami", oimg: "admin_jiemi", name: "房间上锁", oname: "房间解锁", status: false, action: .alert), // 1
        item(img: "aadmin_xdz", oimg: "admin_noxdz", name: "心动打开", oname: "心动关闭", status: false, action: .change),
        item(img: "admin_clean", oimg: "admin_clean", name: "清理公屏", oname: "清理公屏", status: false, action: .empty),
        item(img: "admin_bg", oimg: "admin_bg", name: "房间背景", oname: "房间背景", status: false, action: .navigation),
        item(img: "admin_admin", oimg: "admin_admin", name: "管理员", oname: "管理员", status: false, action: .navigation), // 1
        item(img: "admin_black", oimg: "admin_black", name: "黑名单", oname: "黑名单", status: false, action: .navigation),
        item(img: "room_music", oimg: "room_music", name: "房间音乐", oname: "房间音乐", status: false, action: .empty),
        item(img: "admin_setting", oimg: "admin_setting", name: "房间设置", oname: "房间设置", status: false, action: .navigation),
    ]
    
    let playCenterArray: [item] = [
        item(img: "", oimg: "", name: "幸运摩天轮", oname: "幸运摩天轮", status: false, action: .empty),
        item(img: "1", oimg: "", name: "梦神一族", oname: "梦神一族", status: false, action: .empty),
        item(img: "2", oimg: "", name: "游神一族", oname: "幸运摩天轮", status: false, action: .empty),
    ]
    
    
    let moreFunction: [item] = [
        item(img: "admin_zhuangban", oimg: "admin_zhuangban", name: "装扮", oname: "装扮", status: false, action: .empty),
        item(img: "admin_texiao", oimg: "admin_texiao", name: "关闭特效", oname: "关闭特效", status: false, action: .empty),
    ]
}


struct GameListModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable {
        let game_flag: String
        let title: String
        let game_list: [game_list]?
        
        
        struct game_list: Decodable {
            let id: Int?
            let name: String?
            let game_flag: String?
            let imges: String?
            let game_url: String?
            let money: Int?
            let status: Int?
            let rule_content: String?
        }
    }
}



// 获取房间人员(No Token)
struct GetRoomPersonModel2: Decodable {
    let code: Int
    let message: String
    let data: RoomData
//
    struct RoomData: Decodable {
        let roomId: String
        let admin: [personInfo]
        let visitor: [personInfo]
    }
    struct personInfo: Decodable, Hashable {
        let id: Int
        let nickname: String
        let rztaxt: Int?
        let headimgurl: String
        let goldImg: String?
        let star_img: String?
        let is_admin: Int
        let is_owner: Int
    }
}



struct item {
    let img: String
    let oimg: String
    let name: String
    let oname: String
    var status: Bool
    let action: item_action
}

enum item_action {
    case change
    case alert
    case navigation
    case sheet
    case empty
}



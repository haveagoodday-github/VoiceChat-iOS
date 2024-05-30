//
//  CreateRoomViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/8.
//

import Foundation
import ProgressHUD
import SwiftUI

struct CreateRoomModel {
    var roomName: String
    var roomPassword: String
    var selectedImage: UIImage?
    var selectedRoomTypeName: String
    var roomBackgroundSelected: RoomBackgroundModel?
    var welcome: String
    var intro: String
}

extension CreateRoomModel {
//    static var empty: CreateRoomModel = CreateRoomModel(roomName: "", announcement: "", roomPassword: "", selectedImage: nil, selectedRoomTypeName: "", roomBackgroundSelected: nil, welcome: "", intro: "", roomCover: "")
    static var empty: CreateRoomModel = CreateRoomModel(roomName: "房间名称123", roomPassword: "123456", selectedImage: nil, selectedRoomTypeName: "男生", roomBackgroundSelected: nil, welcome: "欢迎欢迎", intro: "")
}



class CreateRoomViewModel: ObservableObject {
    @Published var createRoomModel: CreateRoomModel = .empty
    @Published var roomTypeList: [RoomTypeModel] = []
    @Published var isSetPassword: Bool = false
    
    @Published var roomBackgroundList: [RoomBackgroundModel] = []
    
    // 控制Sheet
    @Published var isImagePickerPresented = false
    @Published var isShowBackgroundSelect: Bool = false
    
    @Published var selectedTypeId: Int? = nil
    @Published var roomBackgroundSelectedUrl: String? = nil
    @Published var roomCover: String? = nil
    
    
    init() {
        getRoomTypeList()
    }
    
    private func getRoomTypeList() {
        NetworkTools.requestAPI(convertible: "/room/getPartyType",
                                method: .get,
                                responseDecodable: RoomTypeRequestModel.self) { result in
            DispatchQueue.main.async {
                self.roomTypeList = result.data
                self.createRoomModel.selectedRoomTypeName = result.data.last?.name ?? ""
            }
        } failure: { _ in
            
        }
    }
    
    
    func getRoomBackgroundList() {
        NetworkTools.requestAPI(convertible: "/background/getAllRoomBackground", responseDecodable: RoomBackgroundRequestModel.self) { result in
            DispatchQueue.main.async {
                self.roomBackgroundList = result.data
                self.createRoomModel.roomBackgroundSelected = result.data.first
            }
        } failure: { _ in
            
        }
    }

    
    func createRoomAction() {
        if verify() {
            ProgressHUD.error("不可创建，请完善房间信息")
            return
        }
        if let image = createRoomModel.selectedImage {
            NetworkTools.uploadImage(image: image) { url in
                NetworkTools.requestAPI(convertible: "/room/createRoom",
                                        method: .post,
                                        parameters: [
                                            "roomName": self.createRoomModel.roomName,
                                            "roomPassword": self.isSetPassword ? self.createRoomModel.roomPassword : "",
                                            "roomBackgroundId": self.createRoomModel.roomBackgroundSelected?.backgroundId ?? 0,
                                            "intro": self.createRoomModel.intro,
                                            "welcome": self.createRoomModel.welcome,
                                            "roomCover": url,
                                            "type": self.typeIdByName()
                                        ],
                                        responseDecodable: baseModel.self) { result in
                    
                    ProgressHUDTool.showHUD(result.code, message: result.message)
                } failure: { _ in
                    ProgressHUD.error("创建失败")
                }
            }
        } else {
            ProgressHUD.error("没有上传封面")
        }
    }
    
    func typeIdByName() -> Int? {
        return self.roomTypeList.filter({$0.name == createRoomModel.selectedRoomTypeName}).first?.roomTypeId
    }
    
    
    func verify() -> Bool {
        return typeIdByName() == nil || createRoomModel.roomName.isEmpty || createRoomModel.intro.isEmpty || createRoomModel.roomBackgroundSelected == nil
    }
    
    
    func updateRoomAction(roomId: Int) {
        if let image = createRoomModel.selectedImage {
            
            
            NetworkTools.uploadImage(image: image) { url in
                NetworkTools.requestAPI(convertible: "/room/updateRoom",
                                        method: .post,
                                        parameters: [
                                            "roomName": self.createRoomModel.roomName,
                                            "roomPassword": self.isSetPassword ? self.createRoomModel.roomPassword : "",
                                            "roomBackgroundId":
                                                self.roomBackgroundSelectedUrl != nil ? self.backgroundIdByBackgroundUrl() : self.createRoomModel.roomBackgroundSelected?.backgroundId ?? 1,
                                            "intro": self.createRoomModel.intro,
                                            "welcome": self.createRoomModel.welcome,
                                            "roomCover": url,
                                            "type": self.typeIdByName(),
                                            "roomId": roomId
                                        ],
                                        responseDecodable: baseModel.self) { result in
                    
                    ProgressHUDTool.showHUD(result.code, message: result.message)
                } failure: { _ in
                    ProgressHUD.error("更新失败")
                }
            }
            
        } else {
            NetworkTools.requestAPI(convertible: "/room/updateRoom",
                                    method: .post,
                                    parameters: [
                                        "roomName": self.createRoomModel.roomName,
                                        "roomPassword": self.isSetPassword ? self.createRoomModel.roomPassword : "",
                                        "roomBackgroundId":
                                            self.roomBackgroundSelectedUrl != nil ? self.backgroundIdByBackgroundUrl() : self.createRoomModel.roomBackgroundSelected?.backgroundId ?? 1,
                                        "intro": self.createRoomModel.intro,
                                        "welcome": self.createRoomModel.welcome,
                                        "roomCover": self.roomCover ?? "",
                                        "type": self.typeIdByName() ?? 8,
                                        "roomId": roomId
                                    ],
                                    responseDecodable: baseModel.self) { result in
                
                ProgressHUDTool.showHUD(result.code, message: result.message)
            } failure: { _ in
                ProgressHUD.error("更新失败")
            }
        }
    }
    
    
    func backgroundIdByBackgroundUrl() -> Int {
        self.roomBackgroundList.filter({$0.backgroundUrl == self.roomBackgroundSelectedUrl}).first?.backgroundId ?? 1
    }
    
}

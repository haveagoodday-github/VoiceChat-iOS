//
//  PartViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/17.
//

import Foundation
import ProgressHUD
import Alamofire


class PartyViewModel: ObservableObject {
    @Published var typeList: [RoomTypeModel] = []
    @Published var partContentArray: [NewHallRecommendModel] = [] // 派对内容
    @Published var currentType: RoomTypeModel = RoomTypeModel(roomTypeId: -1, name: "", typeType: 1)
    @Published var currentPage: Int = 1
    
    init() {
        self.getTypeList()
        self.getPartyContent(currentType: currentType)
    }

    
    private func getTypeList() {
        NetworkTools.requestAPI(convertible: "/room/getPartyType",
                                method: .get,
                                responseDecodable: RoomTypeRequestModel.self) { result in
            DispatchQueue.main.async {
                self.typeList = result.data
                self.typeList.append(RoomTypeModel(roomTypeId: -1, name: "全部", typeType: -1))
            }
        } failure: { _ in
            
        }
    }
    
    func getPartyContent(page: Int = 1, currentType: RoomTypeModel) {
        ProgressHUD.animate("Loading...")
        NetworkTools.requestAPI(convertible: "/room/getPartyRoomList",
                                parameters: [
                                    "page": page,
                                    "type": currentType.roomTypeId
                                ],
                                responseDecodable: NewHallRecommendRequestModel.self) { result in
            DispatchQueue.main.async {
                self.partContentArray = result.data
            }
            ProgressHUD.dismiss()
        } failure: { _ in
            ProgressHUD.dismiss()
        }
    }
    
    func refresh() {
        getPartyContent(page: 1, currentType: currentType)
    }
    
    
    
}

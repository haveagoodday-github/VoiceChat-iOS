//
//  EditRoomInfoModel.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/9/11.
//

import Foundation
import Defaults


struct editRoomInfoModel: Decodable {
    let code: Int
    let message: String
}

struct editRoomBackgroundModel: Decodable {
    let code: Int
    let message: String
}

class EditRoomInfoModel: ObservableObject {
    @Published var typeListArray: [RoomTypeModel] = []
    @Published var currentType: RoomTypeModel = RoomTypeModel(roomTypeId: -1, name: "全部", typeType: -1)
    
    init() {
        getTypeList()
    }
    
    // MARK: 获取房间类型列表(No Token)
    private func getTypeList() {
        NetworkTools.requestAPI(convertible: "/room/getNestType",
                                method: .get,
                                responseDecodable: RoomTypeRequestModel.self) { result in
            DispatchQueue.main.async {
                self.typeListArray = result.data
                self.typeListArray.append(RoomTypeModel(roomTypeId: -1, name: "全部", typeType: -1))
            }
        } failure: { _ in
            
        }
    }
    
    
    // MARK: 修改房间信息(No Token)
    func editRoomInfo(adminID: String, coverURL: String, room_intro: String, room_name: String, room_pass: String, room_type: RoomTypeModel, room_background: Int, roomId: String, completion: @escaping (String) -> Void) {
        
        
        
//        guard let url = URL(string: "\(baseUrl.url)api/edit_room?uid=\(adminID)&cover=\(coverURL)&room_intro=\(room_intro)&room_name=\(room_name)&room_pass=\(room_pass)&room_type=\(room_type)&room_background=\(room_background)&id=\(roomId)") else { return }
//        
//        do {
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                do {
//                    if let data = data {
//                        let result = try JSONDecoder().decode(editRoomInfoModel.self, from: data)
//                        debugPrint("editRoomInfo Success result：\(result)")
//                        completion(result.message)
//                    } else {
//                        debugPrint("editRoomInfo other result：No data")
//                    }
//                } catch(let error) {
//                    debugPrint("editRoomInfo function Error result：\(error.localizedDescription)")
//                }
//                
//            }.resume()
//        } catch {
//            debugPrint("editRoomInfo错误返回：", error.localizedDescription)
//        }
    }
    
    
    // MARK: 修改房间背景
    func editRoomBackground(roomId: String, backgroundId: Int, completion: @escaping (String) -> Void) {
        
        NetworkTools.requestAPI(convertible: "room/updateBackground",
                                method: .post,
                                parameters: [
                                    "roomId": roomId,
                                    "backgroundId": backgroundId
                                ],
                                responseDecodable: editRoomBackgroundModel.self) { result in
            completion(result.message)
        } failure: { _ in
            
        }

    }
    
    
}

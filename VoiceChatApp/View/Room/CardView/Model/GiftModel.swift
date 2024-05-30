//
//  Model.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/5.
//

import Foundation
import Defaults
import Alamofire

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


class GiftModel: ObservableObject {
    @Published var giftListArray: [GiftListModel.dataItem.list] = []
    @Published var giftLuckListArray: [GiftLuckListModel.data] = []
    
    
    @Published var giftListArray2: [[[GiftListModel.dataItem.list]]] = []
    @Published var giftListArray_for_luck: [[[GiftLuckListModel.data]]] = []
    @Published var giftListArray_for_bag: [[[GiftBagListModel.data.list]]] = []
    
    init() {
        self.getGiftList(type: 1)
        self.getBagGift()
        self.getLuckGift()
    }
    
    // MARK: 获取礼物列表
    func getGiftList(type: Int) {
        
        
//        guard let url = URL(string: "\(baseUrl.newurl)api/gift/index?type=\(type)") else { return }
//        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
//        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
//            guard let self = self else { return }
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(GiftListModel.self, from: data)
//                    DispatchQueue.main.async {
//                        debugPrint("getGiftList function Success result：\(result.message)")
////                            self.giftListArray = result.data.list // 更新数据
//                        let originalArray: [GiftListModel.dataItem.list] = result.data.list
//
//                        let chunkedArray = originalArray.chunked(into: 8) // 拆分成长度为 8 的子数组
//
//                        var resultArray: [[[GiftListModel.dataItem.list]]] = []
//
//                        for chunk in chunkedArray {
//                            let subChunkedArray = chunk.chunked(into: 4) // 每个子数组再拆分成长度为 4 的子数组
//                            resultArray.append(subChunkedArray)
//                        }
//                        self.giftListArray2 = resultArray
//                        
//                    }
//                } else {
//                    debugPrint("getGiftList other result：No data")
//                }
//            } catch(let error) {
//                debugPrint("getGiftList function Error result：\(error.localizedDescription)")
//            }
//            
//        }.resume()
    }
    
    
    
    func getBagGift() {
        NetworkTools.requestAPI(convertible: "/gift/myBagGift",
                                method: .post,
                                parameters: [
                                    "type": 2
                                ],
                                responseDecodable: GiftBagListModel.self) { result in
            DispatchQueue.main.async {
                let originalArray: [GiftBagListModel.data.list] = result.data.list

                let chunkedArray = originalArray.chunked(into: 8) // 拆分成长度为 8 的子数组

                var resultArray: [[[GiftBagListModel.data.list]]] = []

                for chunk in chunkedArray {
                    let subChunkedArray = chunk.chunked(into: 4) // 每个子数组再拆分成长度为 4 的子数组
                    resultArray.append(subChunkedArray)
                }
                
                self.giftListArray_for_bag = resultArray
            }
        } failure: { _ in
            
        }

    }
    
    
    func getLuckGift() {
        
        NetworkTools.requestAPI(convertible: "/gift/luckGift", responseDecodable: GiftLuckListModel.self) { result in
            DispatchQueue.main.async {
                let originalArray: [GiftLuckListModel.data] = result.data

                let chunkedArray = originalArray.chunked(into: 8) // 拆分成长度为 8 的子数组

                var resultArray: [[[GiftLuckListModel.data]]] = []

                for chunk in chunkedArray {
                    let subChunkedArray = chunk.chunked(into: 4) // 每个子数组再拆分成长度为 4 的子数组
                    resultArray.append(subChunkedArray)
                }
                
                self.giftListArray_for_luck = resultArray
            }
        } failure: { _ in
            
        }

    }
    
}



struct sendGiftModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let nick_color: String?
        let is_first: Int?
        let userId: Int?
        let avatar: String?
        let gift_name: String?
        let price: Int?
        let img: String?
        let img1: String?
        let num: String?
    }
}

struct GiftListModel: Decodable {
    let code: Int
    let message: String
    let data: dataItem
    
    struct dataItem: Decodable {
        let list: [list]
        
        struct list: Decodable, Hashable {
            let selfID: String = UUID().uuidString
            let id: Int
            let name: String
            let e_name: String?
            let type: Int
            let vip_level: Int
            let hot: Int
            let is_play: Int
            let price: Int
            let sfxs: String
            let img: String
            let show_img: String
            let show_img2: String
            let gifts_xq: String?
            let gifts_url: String?
            let sort: Int
            let enable: Int
            let addtime: Int
        }
    }
    
}

struct GiftLuckListModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    
    struct data: Decodable, Hashable {
        let selfID: String = UUID().uuidString
        let box_type: Int
        let price: Int
        let img: String
        let name: String
        let url: String
        let liwu: [liwu]
        
        
        struct liwu: Decodable, Hashable {
            let id: Int
            let name: String
            
            let type: Int
            let vip_level: Int
            let hot: Int
            let is_play: Int
            let price: Int
            let img: String
            let show_img: String
            let show_img2: String
        }
        
    }
    
}

struct GiftBagListModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let list: [list]
        
        struct list: Decodable, Hashable {
            let id: Int
            let user_id: Int
            let type: Int
            let target_id: Int
            let name: String
            let show_img: String
            let gifurl: String
            let num: Int
            let price: Int
        }
    }
}



//struct RoomPersonInfoModel: Decodable {
//    let code: Int
//    let message: String
//    let data: dataItem
//    
//    struct dataItem: Decodable {
//        let admin: [personItem]
//        let visitor: [personItem]
//        
//        struct personItem: Decodable {
//            let selfID: String = UUID().uuidString
//            let id: Int
//            let nickname: String
//            let headimgurl: String
//            let is_admin: Int
//        }
//    }
//}
//
//// MARK: 抱人上麦/获取房间人员
//class holdingUpMicModel: ObservableObject {
//    @Published var visitorArray: [RoomPersonInfoModel.dataItem.personItem] = []
//    @Published var adminArray: [RoomPersonInfoModel.dataItem.personItem] = []
//    
//    
//    // 获取房间人员(No Token)
//    func getRoomPerson(roomId: Int) {
//        guard let url = URL(string: "\(baseUrl.url)api/getRoomUsers?id=\(roomId)") else { return }
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
//            guard let self = self else { return }
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(RoomPersonInfoModel.self, from: data)
//                    DispatchQueue.main.async {
//                        debugPrint("getRoomPerson function Success result：\(result)")
//                        self.adminArray = result.data.admin
//                        self.visitorArray = result.data.visitor
//                        
////                        self.roomPersonArray = result.data
//                    }
//                } else {
//                    debugPrint("getRoomPerson other result：No data")
//                }
//            } catch(let error) {
//                debugPrint("getRoomPerson function Error result：\(error.localizedDescription)")
//            }
//        }.resume()
//    }
//
//}


//

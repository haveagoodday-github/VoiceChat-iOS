//
//  RecommendViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/23.
//

import Foundation
import Alamofire
import ProgressHUD

// 轮播图
struct GetCarouselModel: Decodable {
    let code: Int
    let message: String
    let data: [CarouselData]
    
    struct CarouselData: Decodable, Identifiable, Equatable {
        let id: Int
        let img: String
        let contents: String
        let url: String
        let enable: Int
        let sort: Int
        let type: Int
        let updated_at: String
        let created_at: String
    }
}
// 新厅推荐(无Token)
struct GetNewHallRecommendationModel: Decodable{
    let code: Int
    let message: String
    let data: [RoomData]
    
    struct RoomData: Decodable, Identifiable, Equatable {
        static func == (lhs: GetNewHallRecommendationModel.RoomData, rhs: GetNewHallRecommendationModel.RoomData) -> Bool {
            return lhs.id == rhs.id
        }
        
        let room_name: String
        let numid: String
        let openid: String?
        let week_star: Int
        let uid: Int
        let id: Int
        let room_cover: String
        let room_type: String
        let nickname: String
        let sex: Int
        let name: String?
        let is_top: Int
        let roomStatus: Int
        let room_leixing: Int
        let roomVisitor: [Visitor]?
        let cate_img: String?
        let online_num: Int
    }
    
    struct Visitor: Decodable {
        
    }
}
// 热门推荐
struct GetNewReceptionModel: Decodable {
    let code: Int
//    let timestamp: Int
    let message: String
    let data: ReceptionData
    
    struct ReceptionData: Decodable {
        let list: [RoomData]
        let currentPage: Int
        let total: Int
        let limit: Int
    }
    
    struct RoomData: Decodable, Equatable {
        static func == (lhs: GetNewReceptionModel.RoomData, rhs: GetNewReceptionModel.RoomData) -> Bool {
            return lhs.id == rhs.id
        }
        
        let id: Int
        let numid: String
        let uid: Int
        let roomStatus: Int
        let room_name: String
        let room_cover: String
        let room_intro: String
        let room_welcome: String
        let week_star: Int
        let ranking: Int
        let is_afk: Int
        let is_popular: Int
        let secret_chat: Int
        let is_top: Int
        let room_background: Int
        let microphone: String
        let hot: Int
        let roomVisitor: [Visitor]?
        let room_class: String
        let room_type: String
    }
    
    struct Visitor: Decodable {
        let id: Int
        let headimgurl: String
    }
}

// 热门推荐
struct GetPopularActivitiesModel: Decodable {
    let data: DataContainer // 数据容器
    let code: Int // 响应状态码
    let message: String // 响应消息
    
    struct DataContainer: Decodable {
        let list: [RoomData] // 房间数据列表
        let currentPage: Int // 当前页数
        let total: Int // 总条目数
        let limit: Int // 每页条目限制数
    }
    
    struct RoomData: Decodable, Equatable {
        static func == (lhs: GetPopularActivitiesModel.RoomData, rhs: GetPopularActivitiesModel.RoomData) -> Bool {
            return lhs.id == rhs.id
        }
        
        let id: Int // 房间ID
        let numid: String // 房间编号
        let uid: Int // 用户ID
        let roomStatus: Int // 房间状态
        let room_name: String // 房间名称
        let room_cover: String // 房间封面图片URL
        let room_intro: String // 房间介绍
        let room_welcome: String // 欢迎词
        let week_star: Int // 周星等级
        let ranking: Int // 排名
        let is_afk: Int // 是否挂机
        let is_popular: Int // 是否热门
        let secret_chat: Int // 是否允许私聊
        let is_top: Int // 是否置顶
        let room_background: Int // 房间背景
        let microphone: String // 麦克风状态
        let hot: Int // 热度
        let roomVisitor: [VisitorData]? // 房间访客列表
        let room_class: String // 房间分类
        let room_type: String // 房间类型
        let category_class: CategoryData // 房间分类信息
        let category_type: CategoryData // 房间类型信息
    }
    
    struct VisitorData: Decodable {
        let id: Int // 访客ID
        let headimgurl: String // 访客头像URL
    }
    
    struct CategoryData: Decodable {
        let id: Int // 分类ID
        let name: String // 分类名称
        let cate_img: String // 分类图片URL
    }
}

// 新厅推荐(无Token)
struct GetRecommendedByTheNewHallModel: Decodable {
    let code: Int
    let message: String
    let data: [RoomData]
    
    struct RoomData: Decodable, Equatable {
        static func == (lhs: GetRecommendedByTheNewHallModel.RoomData, rhs: GetRecommendedByTheNewHallModel.RoomData) -> Bool {
            return lhs.numid == rhs.numid
        }
        
        let room_name: String
        let numid: String
        let openid: String?
        let week_star: Int
        let uid: Int
        let id: Int
        let room_cover: String
        let room_type: String
        let nickname: String
        let sex: Int
        let name: String?
        let is_top: Int
        let roomStatus: Int
        let room_leixing: Int
        let roomVisitor: [Visitor]
        let cate_img: String?
        let online_num: Int
    }
    
    struct Visitor: Decodable {
        // 如果需要定义符合 roomVisitor 数据结构的属性，可以在这里添加
    }
}


// 推荐Class
class RecommendViewModel: ObservableObject {
    @Published var carouselData: [CarouselModel] = [] // 轮播图
    @Published var newHallRecommend: [NewHallRecommendModel] = [] // 新厅推荐(无Token)
    @Published var receptionDataRoomData: [HotRecommendModel] = [] // 热门推荐
    
    @Published var popularActivitiesRoomData: [GetPopularActivitiesModel.RoomData] = [] // 热门活动
    @Published var recommendedByTheNewHallRoomData: [GetRecommendedByTheNewHallModel.RoomData] = [] // 新厅推荐(无Token)
    @Published var page: Int = 1
    
    
    init() {
        getCarousel() // 轮播图
        getNewHallRecommendation() // 新厅推荐(无Token)
        // 热门推荐
        getNewReception()
        
        getPopularActivities(page: 1, pageSize: 15) // 热门活动
        getRecommendedByTheNewHall() // 新厅推荐(无Token)
    }
    
    // MARK: 轮播图(无Token)
    func getCarousel() {
        NetworkTools.requestAPI(convertible: "/home/getCarousel", responseDecodable: CarouselRequestModel.self) { result in
            if result.code == 0 {
                self.carouselData = result.data
            }
        } failure: { _ in
            
        }
    }
    
    
    // MARK: 新厅推荐(无Token)
    func getNewHallRecommendation() {
        NetworkTools.requestAPI(convertible: "/home/getNewHallRecommend",
                                method: .get,
                                responseDecodable: NewHallRecommendRequestModel.self) { result in
            if result.code == 0 {
                self.newHallRecommend = result.data
            }
        } failure: { _ in
            
        }
    }
    
    // MARK: 热门推荐
    func getNewReception() {
        NetworkTools.requestAPI(convertible: "/home/getHotHallRecommend",
                                method: .get,
                                responseDecodable: HotRecommendRequestModel.self) { result in
            if result.code == 0 {
                self.receptionDataRoomData = result.data
            }
        } failure: { _ in
            
        }
        
    }
    
    // MARK: 热门活动
    func getPopularActivities(page: Int, pageSize: Int) {
//        guard let url = URL(string: "\(baseUrl.newurl)api/room/activity?page=\(page)&pageSize=\(pageSize)") else { return }
//        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
//        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
//            guard let self = self else { return }
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(GetPopularActivitiesModel.self, from: data)
//                    DispatchQueue.main.async {
//                        if self.popularActivitiesRoomData != result.data.list {
//                            debugPrint("getPopularActivities function Success result：\(result.message)")
//                            self.popularActivitiesRoomData = result.data.list  // 更新数据
//                        }
//                    }
//                } else {
//                    debugPrint("getPopularActivities other result：No data")
//                }
//            } catch(let error) {
//                debugPrint("getPopularActivities function Error result：\(error.localizedDescription)")
//            }
//        }.resume()
    }
    
    // 新厅推荐(无Token)
    func getRecommendedByTheNewHall() {
        
//        AF.request("\(baseUrl.url)api/is_aop", method: .get).responseDecodable(of: GetRecommendedByTheNewHallModel.self) { res in
//            switch res.result {
//            case .success(let result):
//                DispatchQueue.main.async {
//                    
//                    if !self.recommendedByTheNewHallRoomData.elementsEqual(result.data) {
//                        debugPrint("getRecommendedByTheNewHall function Success result：\(result.message)")
//                        self.recommendedByTheNewHallRoomData = result.data
//                    }
//                }
//            case .failure(let error):
//                print("getRecommendedByTheNewHall result error: \(error.localizedDescription)")
//            }
//        }
        
    }
    
    
    func loadMorePartContent(room_type: Int, completion: @escaping (Bool) -> Void) {
        self.page = self.page + 1
//        self.getPartContent(categories: 1, page: self.page, room_category: 1, room_type: room_type) { res in
//            completion(res == "Empty Data")
//        }
    }
    
    
    func areArraysEqual<T>(_ array1: [T], _ array2: [T], compare: (T, T) -> Bool) -> Bool {
        guard array1.count == array2.count else {
            return false
        }

        for (element1, element2) in zip(array1, array2) {
            if !compare(element1, element2) {
                return false
            }
        }

        return true
    }
    
    
    
    
}

// MARK: 获取广播消息
class GetAllStationRadioMessageModel: ObservableObject {
    @Published var msgArray: [AllStationRadioMessageModel] = []
    
    
    init () {
        getDefMsg()
    }
    
    func addMessages(headimg: String, msg: String) {
//        debugPrint("\(msg)")
        self.msgArray.append(AllStationRadioMessageModel(headimg: headimg, messages: msg))
        
    }
    
    func getDefMsg() {
        self.msgArray.append(AllStationRadioMessageModel(headimg: "https://img02.mockplus.cn/image/2022-07-01/ec040860-ec0d-11ec-8894-ff8664082813.jpg", messages: "官方提倡绿色交友，对房间内容24小时在线巡查。任何传播违规、违法、低俗、暴力等不良信息将会封停账号。"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.msgArray.append(AllStationRadioMessageModel(headimg: "https://img02.mockplus.cn/image/2022-07-01/ec040860-ec0d-11ec-8894-ff8664082813.jpg", messages: "房间公告"))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.msgArray.append(AllStationRadioMessageModel(headimg: "https://img02.mockplus.cn/image/2022-07-01/ec040860-ec0d-11ec-8894-ff8664082813.jpg", messages: "房间公告"))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.msgArray.append(AllStationRadioMessageModel(headimg: "https://img02.mockplus.cn/image/2022-07-01/ec040860-ec0d-11ec-8894-ff8664082813.jpg", messages: "房间公告"))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.msgArray.append(AllStationRadioMessageModel(headimg: "https://img02.mockplus.cn/image/2022-07-01/ec040860-ec0d-11ec-8894-ff8664082813.jpg", messages: "房间公告etsts"))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.msgArray.append(AllStationRadioMessageModel(headimg: "https://img02.mockplus.cn/image/2022-07-01/ec040860-ec0d-11ec-8894-ff8664082813.jpg", messages: "房间公告房间公告房间公告房间公告房间公告房间公告房间公告"))
            
        }
    }
    
    
    
}

//class TokenUtility {
//    static let token: String = "U+vQtlZtO/EC8XJimMkmrl923PICE3ty/auHk7M3bkkwn2ve7c/xn25AEVeRKsAV"
//}




// ================================================================================================================================


// 小窝内容
/*
 categories    是    string    第二分类，默认1，如电台、娱乐
 page    是    string    1
 room_category    是    string    默认1，如小窝1、派对2
 room_type    是    string    如，交友、相亲，默认1
 */
struct GetNestContentModel: Decodable {
    let code: Int
    let message: String
    let data: [NestContentData]
    
    struct NestContentData: Decodable {
        let room_name: String
        let room_cover: String
        let uid: Int
        let numid: String
        let hot: Int
        let openid: String
        let room_type: String
        let room_class: String
        let room_leixing: Int
        let roomStatus: Int
        let week_star: Int
        let nickname: String
        let sex: Int
        let name: String
        let roomVisitor: [RoomVisitorData]
        let cate_img: String
        let online_num: Int
    }
    
    struct RoomVisitorData: Decodable {
        let id: Int
        let headimgurl: String
    }
}



// 小窝Class
class NestViewModel: ObservableObject {
    @Published var nestContentArray: [NewHallRecommendModel] = [] // 小窝内容
    @Published var typeListArray: [RoomTypeModel] = []
    @Published var currentType: RoomTypeModel = RoomTypeModel(roomTypeId: -1, name: "全部", typeType: -1)
    
    init() {
        self.getNestContent(currentType: currentType)
        self.getTypeList()
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
    
    func getNestContent(page: Int = 1, currentType: RoomTypeModel) {
        ProgressHUD.animate("Loading...")
        NetworkTools.requestAPI(convertible: "/room/getNestRoomList",
                                parameters: [
                                    "page": page,
                                    "type": currentType.roomTypeId
                                ],
                                responseDecodable: NewHallRecommendRequestModel.self) { result in
            DispatchQueue.main.async {
                self.nestContentArray = result.data
            }
            ProgressHUD.dismiss()
        } failure: { _ in
            ProgressHUD.dismiss()
        }
    }
    
    
    
    
    
}
    

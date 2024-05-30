
import SwiftUI

struct GetModel_Newlyweds: Decodable {
    let data: NewlywedsData
    let code: Int
    let message: String
}
struct NewlywedsData: Decodable {
    let list: [NewlywedsItem]
    let currentPage: Int
    let total: Int
    let limit: Int
}
struct NewlywedsItem: Decodable, Identifiable {
    let id: Int               // 房间ID
    let numid: String         // 房间编号
    let uid: Int              // 用户ID
    let roomStatus: Int   // 房间状态
    let room_name: String     // 房间名称
    let room_cover: String    // 房间封面图片URL
    let room_intro: String    // 房间简介
    let room_welcome: String  // 房间欢迎词
    let week_star: Int        // 周星级
    let ranking: Int          // 排名
    let is_afk: Int           // 是否离开
    let is_popular: Int       // 是否热门
    let secret_chat: Int      // 是否私聊
    let is_top: Int           // 是否置顶
    let room_background: Int  // 房间背景
    let microphone: String    // 麦克风状态
    let hot: Int              // 热度
    let roomVisitor: [RoomVisitor] // 房间访客
    let room_class: String   // 房间分类
    let room_type: String    // 房间类型

    struct RoomVisitor: Decodable, Identifiable {
        let id: Int               // 访客ID
        let headimgurl: String    // 访客头像URL
    }
}




class NewlywedsViewModel: ObservableObject {
//    @State private var api = myAPI()
    @Published var newlywedsItem: [NewlywedsItem] = []
    init() {
        getNewlyweds()
    }
    
    func getNewlyweds() {
        NetworkTools.requestAPI(convertible: "api/room/reception?page=1&pageSize=10", responseDecodable: GetModel_Newlyweds.self) { resutl in
            self.newlywedsItem = resutl.data.list
        } failure: { _ in
            
        }

        
        
//        api.loadAPI(getUrl: "\(baseUrl.newurl)api/room/reception?page=1&pageSize=10", resultType: GetModel_Newlyweds.self) { (result: Result<GetModel_Newlyweds, Error>) in
//            switch result {
//            case .success(let response):
//                print("Success:", response)
//                self.newlywedsItem = response.data.list
//            case .failure(let error):
//                print("Error:", error)
//            }
//        }
        
    }
}

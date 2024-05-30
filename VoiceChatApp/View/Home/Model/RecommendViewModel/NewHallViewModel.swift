
import SwiftUI

struct GetModel_getNewHall: Decodable {
    let code: Int
    let message: String
    let data: [RoomItem]
}

struct RoomItem: Decodable, Identifiable {
    var id: String = UUID().uuidString
//    let id: String
    let room_name: String          // 房间名称
    let numid: String              // 房间编号
    let openid: String             // 房主 openid
    let week_star: Int             // 周星级
    let uid: Int                   // 用户 ID
    let room_cover: String         // 房间封面图片 URL
    let room_type: String          // 房间类型
    let nickname: String           // 房主昵称
    let sex: Int                   // 房主性别
    let name: String               // 房间分类名称
    let is_top: Int                // 是否置顶
    let roomStatus: Int        // 房间状态
    let room_leixing: Int          // 房间类型（另一种表述）
//    let roomVisitor: [String]      // 房间访客（根据实际数据类型调整）
    let cate_img: String           // 分类图片 URL
    let online_num: Int            // 在线人数
}


class NewHallViewModel: ObservableObject {
//    @State private var api = myAPI()
    @Published var roomItem: [RoomItem] = []
    init() {
        getNewHall()
    }
    
    func getNewHall() {
        
        NetworkTools.requestAPI(convertible: "api/is_aop", responseDecodable: GetModel_getNewHall.self) { result in
            self.roomItem = result.data
        } failure: { _ in
            
        }

        
//        api.loadAPI(getUrl: "\(baseUrl.url)api/is_aop", resultType: GetModel_getNewHall.self) { (result: Result<GetModel_getNewHall, Error>) in
//            switch result {
//            case .success(let response):
////                print("Success:", response)
//                self.roomItem = response.data
//            case .failure(let error):
//                print("Error:", error)
//            }
//        }
    }
}


import SwiftUI




// 表示房间访客的结构体
struct RoomVisitor: Decodable, Identifiable {
    let id: Int           // 访客ID
    let headimgurl: String  // 访客头像URL
}

// 表示分类类型的结构体
struct CategoryType: Decodable {
    let id: Int           // 分类ID
    let name: String      // 分类名称
    let cate_img: String  // 分类图像URL
}

// list 数据
struct PersonRoomData: Decodable, Identifiable {
    let id: Int                 // 房间ID
    let numid: String           // 房间编号
    let uid: Int                // 用户ID
    let roomStatus: Int     // 房间状态
    let room_name: String       // 房间名称
    let room_cover: String      // 房间封面图URL
    let room_intro: String      // 房间介绍
    let room_welcome: String    // 欢迎语
    let week_star: Int          // 周星级别
    let ranking: Int            // 排名
    let is_afk: Int             // 是否离开
    let is_popular: Int         // 是否热门
    let secret_chat: Int        // 是否私聊
    let is_top: Int             // 是否置顶
    let room_background: Int    // 房间背景
    let microphone: String      // 麦克风设置
    let hot: Int                // 热度
    let roomVisitor: [RoomVisitor]    // 房间访客数组
    let room_class: String       // 房间类别
    let room_type: String        // 房间类型
    let category_class: String?  // 分类类别
    let category_type: CategoryType  // 分类类型
}

// data 数据
struct GetModel_PersonInfoViewData: Decodable {
    let list: [PersonRoomData]    // 房间数据列表
    let currentPage: Int    // 当前页码
    let total: Int          // 总数
    let limit: Int          // 每页限制
}

// 表示获取活动的结构体
struct GetModel_PersonInfoViewModel: Decodable {
    let data: GetModel_PersonInfoViewData  // 活动数据
    let code: Int             // 状态码
    let timestamp: Int        // 时间戳
    let message: String       // 消息
}





class PersonInfoViewModel: ObservableObject{
//    @State private var api = myAPI()
    @Published var personRoomData: [PersonRoomData] = []
    
    init() {
        getPersonInfo()
    }
    
    func getPersonInfo() {
//        NetworkTools.requestAPI(convertible: "api/room/activity?page=1&pageSize=15", responseDecodable: GetModel_PersonInfoViewModel.self) { result in
//            self.personRoomData = result.data.list
//        } failure: { _ in
//            
//        }

        
    }
}


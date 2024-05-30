import Foundation


//struct UserInfoModel: Identifiable, Codable {
//    var id: String
//    
//    let username: String
//    let avatarImgURL: String
//    let sex: String
//    let age: String
//    let honor: String
//    let accessories: [accessoriesModel]
//    
//    init(id: String = UUID().uuidString, username: String, avatarImgURL: String, sex: String, age: String, honor: String, accessories: [accessoriesModel]) {
//        self.id = id
//        self.username = username
//        self.avatarImgURL = avatarImgURL
//        self.sex = sex
//        self.age = age
//        self.honor = honor
//        self.accessories = accessories
//    }
//    
//    func updataUserInfo() -> UserInfoModel {
//        return UserInfoModel(id: id, username: username, avatarImgURL: avatarImgURL, sex: sex, age: age, honor: honor, accessories: accessories)
//    }
//}
//
//struct accessoriesModel: Identifiable, Codable {
//    let id: String
//    let car: String
//    let avatarFrame: String
//    
//}
//
//class UserInfoViewModel: ObservableObject {
//    @Published var items: [UserInfoModel] = []
//    
//    init() {
//        getUserInfo()
//    }
//    
//    func getUserInfo() -> [UserInfoModel]? {
//        guard
//            let data = UserDefaults.standard.data(forKey: "user_info"),
//            let savedUserInfo = try? JSONDecoder().decode([UserInfoModel].self, from: data)
//        else {
//            return nil
//        }
//        
//        return savedUserInfo
//    }
//
//    
//    func saveUserInfo() {
//        if let encodedData = try? JSONEncoder().encode("") {
//            UserDefaults.standard.set(encodedData, forKey: "user_info")
//        }
//    }
//}




enum LoginType: String {
    // 微信
    case weChat = "isSuccessWeChat"
    // QQ
    case qq = "isSuccessQQ"
    // 一键登陆
    case oneClickLogin = "isSuccessOneClickLogin"
}


func loadIsSuccessWeChat() -> Bool {
    return UserDefaults.standard.bool(forKey: "isSuccessWeChat")
}
func loadIsSuccessQQ() -> Bool {
    return UserDefaults.standard.bool(forKey: "isSuccessQQ")
}
func loadIsSuccessOneClickLogin() -> Bool {
    return UserDefaults.standard.bool(forKey: "isSuccessOneClickLogin")
}



func setIsSuccessLogin(forKey key: LoginType, value: Bool = false) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
}




// 个人信息
class UserPhoneNumber: ObservableObject {
    @Published var phoneNumber: String = ""
}

func saveDataToCache(data: Any, forKey key: String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
    userDefaults.synchronize()
}



// 是否成功登陆信息


class SharedData: ObservableObject {
    @Published var message: Bool = false
    static let shared = SharedData()
}


class AppSettings: ObservableObject {
    @Published var isSuccessQQ: String = "获取参数成功"
}

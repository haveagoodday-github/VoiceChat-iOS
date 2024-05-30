//
//  AppInitialize.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/9/7.
//

import Foundation
import SwiftUI


// 初始化融云
//class defAppDelegate: NSObject, UIApplicationDelegate, RCIMReceiveMessageDelegate {
//    
//    func initRCIM2() {
//        print("融云测试: 初始化成功")
//        print("融云测试: \(UserCache.shared.getUserInfo())===================")
////        RCIM.shared().initWithAppKey(ryUtility.appKey)
//        
////        RCIM.shared()?.currentUserInfo = RCUserInfo(userId: UserCache.shared.getUserInfo()?.ry_uid ?? "", name: UserCache.shared.getUserInfo()?.nickname, portrait: UserCache.shared.getUserInfo()?.headimgurl)
//        
//        configRCIM()
//    }
//    
//    func configRCIM() {
//        print("融云测试:2 执行了configRCIM")
//        // 设置语音消息采样率为 16KHZ
//        RCIMClient.shared().sampleRate = RCSampleRate._Rate_16000
//        // 设置导航按钮字体颜色 返回按钮是颜色
//        
////        RCIM.shared()?.globalNavigationBarTintColor = .blue;
//        RCIM.shared().globalNavigationBarTintColor = .black
//        
//        // SDK 会话列表界面中显示的头像大小，高度必须大于或者等于36
//        RCIM.shared().globalConversationPortraitSize = CGSize(width: 46, height: 46) // 头像大小
//        //设置会话列表头像和会话页面头像
//        RCIM.shared().globalMessageAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE // 圆形头像
//        RCIM.shared().globalConversationAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE // 圆形头像
//        
//        
//        ///是否将用户信息和群组信息在本地持久化存储
//        RCIM.shared().enablePersistentUserInfoCache = true
//        ///是否在发送的所有消息中携带当前登录的用户信息
//        RCIM.shared().enableMessageAttachUserInfo = true
//        ///收到信息的代理
//        RCIM.shared().receiveMessageDelegate = self
//        ///用户信息提供代理
////        RCIM.shared().userInfoDataSource = self
//        RCIM.shared().userInfoDataSource = RCIMDataSource.shared
//        RCIM.shared().groupInfoDataSource = RCIMDataSource.shared
//        
//        
//        
//        //设置名片消息功能中联系人信息源和群组信息源
////                [RCContactCardKit shareInstance].contactsDataSource = RCIMDataSource.shared
////                [RCContactCardKit shareInstance].groupDataSource = RCIMDataSource.shared
//        
//        
////        RCContactCardKit.shareInstance().contactsDataSource = RCIMDataSource.shared
////        RCContactCardKit.shareInstance().groupDataSource = RCIMDataSource.shared
//        
//        //设置群组内用户信息源。如果不使用群名片功能，可以不设置
//        //  [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
//        RCIM.shared().enableMessageAttachUserInfo = true
//        //设置接收消息代理
//        RCIM.shared().receiveMessageDelegate = self
//        //开启输入状态监听
//        RCIM.shared().enableTypingStatus = true
//        //开启发送已读回执
////        RCIM.shared().enabledReadReceiptConversationTypeList = [RCConversationType.ConversationType_PRIVATE.rawValue, RCConversationType.ConversationType_DISCUSSION.rawValue, RCConversationType.ConversationType_GROUP.rawValue]
////        RCKitConfigCenter.message.enabledReadReceiptConversationTypeList = [NSNumber(value: ConversationType_PRIVATE)]
//        RCIM.shared().enabledReadReceiptConversationTypeList = [NSNumber(value: RCConversationType.ConversationType_PRIVATE.rawValue)]
//        
//        
//        // 开启消息 @ 功能（只支持群聊和讨论组，App 需要实现群成员数据源 groupMemberDataSource）
//        RCIM.shared()?.enableMessageMentioned = true
//        
//        
//        //开启多端未读状态同步
//        RCIM.shared().enableSyncReadStatus = true
//        
//        //设置显示未注册的消息
//        //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
//        RCIM.shared().showUnkownMessage = true
//        RCIM.shared().showUnkownMessageNotificaiton = true
//        //群成员数据源
////        RCIM.shared().groupMemberDataSource = RCIMDataSource.shared
//        //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
//        RCIM.shared().enableMessageMentioned = true
//        //开启消息撤回功能
//        RCIM.shared().enableMessageRecall = true
//        //选择媒体资源时，包含视频文件
//        RCIM.shared().isMediaSelectorContainVideo = true
//        
//        
//        // 阅读回执开关 [已读]
//        RCIM.shared().enableSyncReadStatus = true
//        // 个人/群聊
//        RCIM.shared().enabledReadReceiptConversationTypeList = [RCConversationType.ConversationType_PRIVATE.rawValue, RCConversationType.ConversationType_GROUP.rawValue]
//        
//
//        
//        
//        
////        设置优先使用 WebView 打开 URL
//        RCIM.shared()?.embeddedWebViewPreferred = true
//        
//        // 设置 Log 级别，开发阶段打印详细 log
//        RCIMClient.shared().logLevel = RCLogLevel.log_Level_Info
//        // 设置断线重连时是否踢出重连设备
//        RCIMClient.shared().setReconnectKickEnable(true)
//        
//        // 请在 SDK 初始化之后，连接融云服务器之前设置代理委托。
//        connectToRongCloud(withToken: UserCache.shared.getUserInfo()?.ry_token ?? "")
//    }
//    
//    // 在适当的地方调用此方法来连接融云服务器
//    func connectToRongCloud(withToken token: String) {
//        RCIM.shared().connect(withToken: token, dbOpened: { code in
//            // 消息数据库打开，可以进入到主页面
//            print("融云测试: 消息数据库打开，可以进入到主页面")
//        }, success: { userId in
//            print("融云测试: 连接成功")
//            // 连接成功
//        }, error: { status in
//            if status == RCConnectErrorCode.RC_CONN_TOKEN_INCORRECT {
//                // 从 APP 服务获取新 token，并重连
//            } else {
//                print("融云测试: 连接失败，应该是Token问题")
//                // 无法连接到 IM 服务器，请根据相应的错误码作出对应处理
//            }
//        })
//    }
//    
//    
//    func didReceiveMessageNotification(_ notification: Notification) {
//        print("融云测试: 在这里处理收到新消息的事件2")
//        // 在这里处理收到新消息的事件
//        guard let userInfo = notification.userInfo else {
//            return
//        }
//        guard let identifier = userInfo["identifier"] as? String else {
//            return
//        }
//
//
//    }
//    
//
//}






// MARK: 获取我的小窝
class MyNestInfo: ObservableObject {
    @Published var isHasMyNest: Bool = false
    @Published var MyNestRoomID: Int?
    
    init() {
        getMyNestInfo()
    }
    
    // 获取我的小窝
    func getMyNestInfo() {
//        NetworkTools.requestAPI(convertible: "api/room/manage?page=1&pageSize=3", responseDecodable: MyNestInfoModel.self) { result in
//            DispatchQueue.main.async {
//                debugPrint("getMyNestInfo function Success result：\(result.message)")
//                self.isHasMyNest = true
//                UserCacheMyNestInfo.shared.saveUserMyNestInfo(result.data.list)
//            }
//        } failure: { _ in
//            
//        }
    }
}



class UserCacheMyNestInfo: ObservableObject {
    @Published var userMyNestInfo: [MyNestInfoModel.datalist.listArray]?
    static let shared = UserCacheMyNestInfo()
    
    private let userDefaults = UserDefaults.standard

    private let userKey = "com.VoiceChatApp.usermynestinfo"
    
    
    func saveUserMyNestInfo(_ userMyNestInfo: [MyNestInfoModel.datalist.listArray]) {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(userMyNestInfo)
            userDefaults.set(userData, forKey: userKey)
        } catch {
            print("Error encoding user info: \(error)")
        }
    }

    func getUserMyNestInfo() -> [MyNestInfoModel.datalist.listArray]? {
        if let userData = userDefaults.data(forKey: userKey) {
            do {
                let decoder = JSONDecoder()
                let userInfo = try decoder.decode([MyNestInfoModel.datalist.listArray].self, from: userData)
                return userInfo
            } catch {
                print("Error decoding user info: \(error)")
            }
        }
        return nil
    }

    func clearUserMyNestInfo() {
        userDefaults.removeObject(forKey: userKey)
    }
    
}

// 获取我的小窝
struct MyNestInfoModel: Codable {
    let code: Int
    let message: String
    let data: datalist
    
    struct datalist: Codable {
        let list: [listArray]
        
        struct listArray: Codable {
            let id: Int
            let room_name: String
            let room_cover: String?
            let uid: Int
            let room_class: String
            let room_type: String
            let room_category: category
            let user: user
            let category_class: category
            let category_type: category
            
            struct category: Codable {
                let id: Int
                let name: String
                let cate_img: String?
            }
            struct user: Codable {
                let id: Int
                let nickname: String
                let sex: Int
                let headimgurl: String
                let city: String
                let constellation: String
            }
        }
    }
    
    
    
    
}

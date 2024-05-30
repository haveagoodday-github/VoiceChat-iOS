//
//  ForDefaultsModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/12/10.
//

import Foundation
import Defaults





struct for_gift_label: Codable, Defaults.Serializable {
    let formUserName: String
    let acceptUserName: String
    let giftName: String
    let gfitNum: String
    let giftImg: String
}

extension Defaults.Keys {
    // MARK: Card
    static let room_message_card = Key<Bool>("room_message_card", default: false)
    static let room_gift_status = Key<Bool>("room_gift_status", default: false)
    static let room_gift_card = Key<Bool>("room_gift_card", default: false)
    static let room_user_data_card = Key<Bool>("room_user_data_card", default: false)
    static let room_setting_card = Key<Bool>("room_setting_card", default: false)

    static let room_setting_full_sheet = Key<Bool>("room_setting_full_sheet", default: false)
    static let room_ishost = Key<Bool>("room_ishost", default: false)
    static let room_smiley_card = Key<Bool>("room_smiley_card", default: false)
//    static let room_message_type = Key<RoomMessageTypeEnum>("room_message_type", default: .room)
    static let room_online_user_list = Key<Bool>("room_for_online_user_list", default: false)
    static let room_announcement = Key<Bool>("room_announcement", default: false)
    static let room_send_message_keyboard_status = Key<Bool>("room_send_message_keyboard_status", default: false)
    static let room_gift_list = Key<Bool>("room_gift_list", default: false)
    static let room_show_gift_animation_img = Key<Bool>("room_show_gift_animation", default: false)
    static let room_show_gift_animation_svga = Key<Bool>("room_show_gift_animation_svga", default: false)
    static let room_xdz = Key<Bool>("room_xdz", default: false)
    
    static let page_home_nest_isRefresh_progress = Key<Bool>("page_home_nest_isRefresh_progress", default: false)
//    static let page_home_nest_type = Key<RoomTypeModel.dataItem>("page_home_nest_isRefresh_progress", default: .init(id: 8, name: "交友"))
    
    static let me_bag_avatar_border_selected_id = Key<Int>("me_bag_avatar_border_selected_id", default: 0)
    static let me_bag_join_effect_selected_id = Key<Int>("me_bag_join_effect_selected_id", default: 0)
    static let me_bag_mic_status_effect_selected_id = Key<Int>("me_bag_mic_status_effect_selected_id", default: 0)
    static let me_bag_info_float_selected_id = Key<Int>("me_bag_info_float_selected_id", default: 0)
    static let me_bag_dynamic_card_selected_id = Key<Int>("me_bag_dynamic_card_selected_id", default: 0)
    
    static let me_dress_preview_svga_url = Key<String>("me_dress_preview_svga_url", default: "")
    static let me_dress_preview_svga_url_over = Key<String>("me_dress_preview_svga_url_over", default: "")
    static let game_url = Key<String>("game_url", default: "")
    
    
    static let global_float_ball = Key<Bool>("global_float_ball", default: false)
    static let global_float_ball_value = Key<floatModel>("global_float_ball_value", default: floatModel(headimgurl: "", roomName: "", roomId: 0, status: false))
    
    static let go_to_room = Key<GotoRoomModel>("go_to_room", default: GotoRoomModel(roomStatus: 0, roomId: 0, roomUid: 0, is_default: 0, room_pass: ""))
    
    
    static let alipay_userinfo = Key<alipayUserinfoModel.data>("alipay_userinfo", default: .init(code: "", msg: "", avatar: "", nick_name: "", user_id: ""))
    
    static let def_avatar = Key<String>("def_avatar", default: "\(baseUrl.url)upload/cover/20230719/07c3f0bfb5555a31bce4bb50d7666e7d.jpg")
    
    
    static let test_is = Key<Bool>("text_is", default: false)
    
    
    static let sceneDidDisconnect = Key<Bool>("sceneDidDisconnect", default: false)
    
    
    static let notification = Key<NotificationModel>("notification", default: NotificationModel(id: 1, headurlimg: "https://mmbiz.qpic.cn/sz_mmbiz_jpg/IhB6Hhm1o7ePJiavV7zqakVTqnua7IogpxuicTEEecdFkup5UGPVLmstpEj7CpddUo72Oj5gPZqE9kz97Nd2KzQA/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1", name: "Notification", message: "This is a sample notification.", time: "1999-12-31"))
    
    
    // 是否打开消息通知
    static let isNotificationForReceiveNewMessage = Key<Bool>("isNotificationForReceiveNewMessage" , default: true)
    
    static let roomMessage = Key<String>("roomMessage", default: "")
    
}



struct NotificationModel: Codable, Defaults.Serializable {
    let id: Int
    let headurlimg: String
    let name: String
    let message: String
    let time: String
}

//
//  Notification.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/10.
//

import Foundation


// 定义通知的名称，确保它是唯一的
extension Notification.Name {
    static let receiveNewMessage = Notification.Name("receiveNewMessage")
    static let receiveNewRoomMessage = Notification.Name("receiveNewRoomMessage")
}

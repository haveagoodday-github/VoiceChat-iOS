//
//  RoomTypeModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/7.
//

import Foundation

struct RoomTypeRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [RoomTypeModel]
}
struct RoomTypeModel: Decodable, Equatable, Hashable {
//struct RoomTypeModel: Decodable {
    var roomTypeId: Int
    var name: String
    var typeType: Int
}

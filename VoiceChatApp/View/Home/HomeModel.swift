//
//  HomeModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/6.
//

import Foundation

// 轮播图
struct CarouselRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [CarouselModel]
}

struct CarouselModel: Decodable {
    let id: Int
    let title: String
    let imageUrl: String
    let linkUrl: String
}

struct NewHallRecommendRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [NewHallRecommendModel]
}
struct NewHallRecommendModel: Decodable {
    let roomId: Int
    let roomUid: Int
    let roomName: String
    let roomBackground: String
    let intro: String
    let onlineNum: Int
    let hot: Int
    let roomCover: String
    let type: Int
    let isBanSpeak: Int?
    let isBanMsg: Int?
    let isBanSpeakMsg: Int?
    let xdz: Int
    let isHost: Int?
    let createTime: String
    let updateTime: String
    let welcome: String
}

struct HotRecommendRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [HotRecommendModel]
}
struct HotRecommendModel: Decodable {
    let roomId: Int
    let roomUid: Int
    let roomName: String
    let roomBackground: String
    let intro: String
    let onlineNum: Int?
    let hot: Int?
    let roomCover: String
    let type: Int
    let isBanSpeak: Int?
    let isBanMsg: Int?
    let isBanSpeakMsg: Int?
    let xdz: Int
    let isHost: Int?
    let createTime: String
    let updateTime: String
}

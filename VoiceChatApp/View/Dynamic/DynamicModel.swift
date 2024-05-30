//
//  DynamicModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/17.
//

import Foundation

// 推荐动态/最新动态/关注动态/我的动态
struct DynamicModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable {
        let dynamicId: Int
        let userId: Int
        let images: String
        let content: String
        let tags: String?
        let state: Int
        let updateTime: String
        let avatar: String
        let sex: Int
        let nickname: String
        let avatarBox: String?
        let goldImg: String?
        let starsImg: String?
        
        let isLiked: Int
        let likeCount: Int
        let commentCount: Int
    }
}

// 评论列表
struct DynamicCommentsRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [DynamicCommentsModel]?
    
}
struct DynamicCommentsModel: Decodable {
    let commentId: Int
    let dynamicId: Int
    let userId: Int
    let content: String
    let createTime: String
    let nickname: String
    let avatar: String
    let sex: Int
//    let starsImg: String?
//    let goldImg: String?
//    let vipImg: String?
//    let avatarBox: String?
}

struct DynamicTagsRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [DynamicTagsModel]
}


struct DynamicTagsModel: Decodable {
    let tagId: Int
    let tagContent: String
    let state: Int?
    let createTime: String?
}

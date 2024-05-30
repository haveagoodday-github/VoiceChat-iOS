//
//  ActivityModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/17.
//

import Foundation

// 表示从 API 获取的模型，包括 code、message 和 data 部分
struct ActivityModel: Decodable {
    let code: Int
    let message: String
    let data: [ActivityData]  // 这里表示 "data" 数组部分
    
    struct ActivityData: Decodable, Identifiable {
        let id: Int             // 活动的唯一标识符
        let title: String       // 活动标题
        let img: String         // 图片链接
        let url: String         // 活动链接
        let enable: Int         // 是否启用
        let sort: Int           // 排序值
        let addtime: String     // 添加时间
        let start_time: String  // 开始时间
        let end_time: String    // 结束时间
    }
}

// 表示活动的模型，遵循 Decodable 协议，同时也添加了 Identifiable 协议


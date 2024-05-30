//
//  PartModel.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/8/29.
//

import Foundation
import Alamofire

// 派对顶部轮播图
struct GetPartCarouselModel: Decodable {
    struct CarouselItem: Decodable, Identifiable {
        let id: Int
        let img: String
        let contents: String
        let url: String
        let enable: Int
        let sort: Int
        let type: Int
        let updated_at: String
        let created_at: String
    }
    
    let data: [CarouselItem]
    let code: Int
    let message: String
}



// 派对内容
struct PartContentModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable {
        let id: Int
        let room_name: String
        let room_cover: String
        let uid: Int
        let numid: String
        let hot: Int
        let openid: String?
        let room_type: String
        let room_class: String
        let room_leixing: Int
        let is_aop: String?
        let roomStatus: Int
        let week_star: Int
        let nickname: String?
        let sex: Int
        let name: String
        let roomVisitor: [roomVisitor]?
        
        struct roomVisitor: Decodable {
            let id: Int
            let headimgurl: String
        }
        let cate_img: String
        let online_num: Int
    }
}



struct partyTypeModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable, Hashable {
        let id: Int
        let name: String
    }
}

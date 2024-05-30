//
//  DynamicRequest.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/4.
//

import Foundation
import ProgressHUD

class DynamicRequest {
    // 点赞
    class func likeDynamic(dynamicId: Int) {
        NetworkTools.requestAPI(convertible: "/dynamic/likeDynamic",
                                 method: .post,
                                 parameters: ["dynamicId" : dynamicId],
                                 responseDecodable: baseModel.self) { result in
//            ProgressHUD.succeed(result.message)
        } failure: { _ in
            ProgressHUD.error("点赞失败")
        }
    }
    
    // 取消点赞
    class func unlikeDynamic(dynamicId: Int) {
        NetworkTools.requestAPI(convertible: "/dynamic/unlikeDynamic",
                                 method: .post,
                                 parameters: ["dynamicId" : dynamicId],
                                 responseDecodable: baseModel.self) { result in
//            ProgressHUD.succeed(result.message)
        } failure: { _ in
            ProgressHUD.error("取消点赞失败")
        }
    }
}

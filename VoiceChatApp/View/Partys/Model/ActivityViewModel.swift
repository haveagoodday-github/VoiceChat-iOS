//
//  ActivityViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/17.
//

import Foundation

class ActivityViewModel: ObservableObject {

    @Published var activityArray: [ActivityModel.ActivityData] = []
    init() {
        GetActivity()
    }
    
    // 派对内容
    func GetActivity() {
        
        NetworkTools.requestAPI(convertible: "api/activeList",
                                responseDecodable: ActivityModel.self) { result in
            DispatchQueue.main.async {
                debugPrint("GetActivity function Success result：\(result)")
                self.activityArray = result.data // 更新数据
            }
        } failure: { _ in
            
        }

    }
    
}

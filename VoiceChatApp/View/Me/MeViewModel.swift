//
//  MeViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/7.
//

import Foundation

class MeViewModel: ObservableObject {
    @Published private(set) var userinfo: UserInfo? = nil
    @Published var userProfileFullSheet: Bool = false
    
    @Published var topUpList: [TopUpListModel2] = []
    
    init() {
        getMyUserInfo()
    }
    
    func refreshData() {
        UserRequest.getUserInfo { userinfo in
            self.userinfo = userinfo
        }
    }

    
    private func getMyUserInfo() {
        UserRequest.getMyUserInfo { userinfo in
            self.userinfo = userinfo
        }
    }
    
    
    
    
}

// 充值
extension MeViewModel {
    func getTopUpList() {
        NetworkTools.requestAPI(convertible: "/topup/getTopUpList", responseDecodable: TopUpListRequestModel.self) { result in
            if result.code == 0 {
                self.topUpList = result.data
            }
        } failure: { _ in
            
        }

    }
}

struct TopUpListRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [TopUpListModel2]
}

struct TopUpListModel2: Decodable {
    let topUpId: Int
    let price: Int
    let balance: Int
}

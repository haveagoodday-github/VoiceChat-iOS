//
//  RealNameAuthenticationModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/31.
//

import Foundation
import SwiftUI


struct authModel: Decodable {
    let code: Int
    let message: String
    let data: CertifyData
    
    struct CertifyData: Decodable {
        let CertifyId: String
    }
}


class AuthModel: ObservableObject {
    @Published var CertifyId: String = ""
//    @State private var api = myAPI()
    private let userKey = "com.VoiceChatApp.usermateInfo"
    
    func getCertifyId(name: String, certNo: String) {
        let metaInfo = UserDefaults.standard.string(forKey: userKey)
//        print("userToken：----------\(UserCache.shared.getUserInfo()?.token)")
//        print("metaInfo：-------\(metaInfo)")
        
        NetworkTools.requestAPI(convertible: "api/real_auth/token",
                                method: .post,
                                parameters: ["name" : name,
                                              "certNo" : certNo,
                                              "metaInfo" : metaInfo
                                            ],
                                responseDecodable: authModel.self) { result in
            DispatchQueue.main.async {
                self.CertifyId = result.data.CertifyId
            }
        } failure: { _ in
            
        }
        
    }

    
}



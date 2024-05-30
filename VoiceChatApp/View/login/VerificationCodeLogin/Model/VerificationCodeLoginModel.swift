//
//  VerificationCodeLoginModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/29.
//

import Foundation


struct VerificationCodeModel: Decodable {
    let data: Bool
    let code: Int
    let status: String
    let timestamp: Int
    let message: String
}

class VerificationCodeLoginModel: ObservableObject {
    func getVerificationCode(mobile: String, completion: @escaping (String?) -> Void) { // 返回message的回调
//        guard let url = URL(string: "\(baseUrl.newurl)api/sms/code") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST" // 更改请求方法为POST
//
//        // 创建要发送的参数
//        let parameters = ["mobile": mobile]
//
//        // 将参数编码为x-www-form-urlencoded格式
//        let parameterString = parameters.map { (key, value) in
//            return "\(key)=\(value)"
//        }.joined(separator: "&")
//
//        if let parameterData = parameterString.data(using: .utf8) {
//            request.httpBody = parameterData
//        }
//
//        // 更新请求标头
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
//            guard let self = self else { return }
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(VerificationCodeModel.self, from: data)
//                    DispatchQueue.main.async {
//                        debugPrint("getVerificationCode function Success result：\(result)")
//                        completion(result.message) // 返回message
//                    }
//                } else {
//                    debugPrint("getVerificationCode other result：No data")
//                    completion(nil)
//                }
//            } catch(let error) {
//                debugPrint("getVerificationCode function Error result：\(error.localizedDescription)")
//                completion(nil)
//            }
//        }.resume()
    }
}





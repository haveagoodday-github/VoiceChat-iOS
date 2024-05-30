//
//  NetworkTools.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/3/28.
//

import Foundation
import Alamofire
import ProgressHUD



let BASE_URL = "http://172.20.250.236:8082"

class NetworkTools {
    private class func getHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders()
        if let token = UserDefaults.standard.string(forKey: "Authorization") {
            headers.add(HTTPHeader.authorization(token))
        }
        return headers
    }
    class func requestAPI<T: Decodable>(convertible: URLConvertible,
                           method: HTTPMethod = .get,
                           parameters: Parameters? = nil,
                                         responseDecodable: T.Type,
                                         success: @escaping (T) -> Void,
                                         failure: @escaping (String) -> Void) {
        let url = "\(BASE_URL)\(convertible)"
        AF.request(url, method: method, parameters: parameters, headers: getHeaders())
            .responseDecodable(of: responseDecodable) { res in
            switch res.result {
            case .success(let result):
                success(result)
            case .failure(let error):
                failure(error.localizedDescription)
                debugPrint("\(convertible) result error: \(error.localizedDescription)")
                debugPrint(parameters)
                ProgressHUD.error("网络异常! ErrorCode:\(convertible)")
            }
        }

    }
    
    class func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        ProgressHUD.animate("上传中...")
        let defAvatarUrl = "https://voicechat.oss-cn-shenzhen.aliyuncs.com/logo.jpg"
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData,
                                     withName: "file",
                                     fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
        },
                  to: "\(BASE_URL)/upload",
                  method: .post,
                  headers: getHeaders()
        ).responseDecodable(of: baseModel.self) { response in
            ProgressHUD.dismiss()
            switch response.result {
            case .success(let result):
                completion(result.data ?? defAvatarUrl)
            case .failure(_):
                completion(defAvatarUrl)
            }
        }
    }
}




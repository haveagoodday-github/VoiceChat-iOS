//
//  CreateRoomModel.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/9/3.
//

import Foundation



//extension UIImage {
//    
//    class func generateRandomString() -> String {
//        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
//        var randomString = ""
//        
//        for _ in 0..<4 {
//            let randomIndex = Int(arc4random_uniform(UInt32(letters.count)))
//            let randomLetter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
//            randomString.append(randomLetter)
//        }
//        
//        return randomString
//    }
//    
//    class func getCurrentDate() -> String {
//        let currentDate = Date()
//        let calendar = Calendar.current
//
//        let year = calendar.component(.year, from: currentDate)
//        let month = calendar.component(.month, from: currentDate)
//        let day = calendar.component(.day, from: currentDate)
//
//        let formattedDate = String(format: "%04d%02d%02d", year, month, day)
//        return formattedDate
//    }
//    
//    class func qiniuUploadImage(image: UIImage, imageName: String, completion: @escaping (String) -> Void) {
//        let createRoomModel = CreateRoomModel()
//        let currentDate = getCurrentDate()
//        let filePath = cacheImage(image, imageName: imageName)
//        let timestamp = NSDate().timeIntervalSince1970
//        let generateRandomWord = generateRandomString()
//        // 文件名/当前年月日/时间戳-/4位随机字母.jpg
//        // filename/20230903/xxxxxx-ABCD.jpg
//        let key = "ios/\(imageName)/\(currentDate)/\(Int(timestamp))-\(generateRandomWord).jpg"
//        let qiniuManager = QNUploadManager()
////        var imageurl: String = ""
//        DispatchQueue.global().async {
//            while createRoomModel.token.isEmpty {
//                // 等待token不为空
//                usleep(500000) // 每0.5秒检查一次
//            }
//
//            let token = createRoomModel.token
//            
//            qiniuManager?.putFile(filePath, key: key, token: token, complete: { (info, key, resp) in
//                if resp == nil {
//                    return
//                }
//                let respDic: NSDictionary? = resp as NSDictionary?
//                let value: String? = respDic!.value(forKey: "key") as? String
//                let imageUrl = "\(QNUtility.qiniuHost)\(value!)"
//                print("imageUrl=====\(imageUrl)")
////                imageurl = imageUrl
//                completion(imageUrl)
//            }, option: nil)
//        }
//        
////        return imageurl
//        
//        
//    }
//    /**
//     缓存图片
//     
//     - parameter image:     图片
//     - parameter imageName: 图片名
//     - returns: 图片沙盒路径
//     */
//    class func cacheImage(_ image: UIImage ,imageName: String) -> String {
//        let data = image.jpegData(compressionQuality: 0.5) // ==
//        let homeDirectory = NSHomeDirectory()
//        let documentPath = homeDirectory + "/Documents/"
//        let fileManager: FileManager = FileManager.default
//        do {
//            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
//        }
//        catch _ {
//        }
//        let key = "\(imageName).jpg"
//        fileManager.createFile(atPath: documentPath + key, contents: data, attributes: nil)
//        //得到选择后沙盒中图片的完整路径
//        let filePath: String = String(format: "%@%@", documentPath, key)
//        return filePath
//    }
//    
//    
//    
//    
//}

struct GetQNTokenModel: Decodable {
    let code: Int
    let data: BucketAndToken
    
    struct BucketAndToken: Decodable {
        let token: String
        let bucket: String
    }
}



//class CreateRoomModel: ObservableObject {
//    @Published var token: String = ""
//    @Published var resultID: Int = 1111
//    
//    init() {
//        getQNToken()
//    }
//    
//    
//    func getQNToken() {
//        guard let url = URL(string: "\(baseUrl.newurl)api/upload/token") else { return }
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
//            guard let self = self else { return }
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(GetQNTokenModel.self, from: data)
//                    DispatchQueue.main.async {
//                        debugPrint("getQNToken function Success result：\(result)")
////                        self.microphoneList = result.data.microphone
//                        self.token = result.data.token
//                    }
//                } else {
//                    debugPrint("getQNToken other result：No data")
//                }
//            } catch(let error) {
//                debugPrint("getQNToken function Error result：\(error.localizedDescription)")
//            }
//        }.resume()
//    }
//    
//    
//    
//    func updata(cover: String, roomIntro: String, roomName: String, roomPass: String, roomBackgroudID: Int) {
//        let uid = UserCache.shared.getUserInfo()?.userId
//        
//        NetworkTools.requestAPI(convertible: "api/create_room",
//                                method: .post,
//                                parameters: [
//                                    "uid": uid,
//                                    "cover": cover,
//                                    "roomIntro": roomIntro,
//                                    "roomName": roomName,
//                                    "roomPass": roomPass,
//                                    "roomBackgroudID": roomBackgroudID
//                                ],
//                                responseDecodable: baseModel.self) { result in
//            
////            DispatchQueue.main.async {
////                if result.message == "创建成功" {
////                    self.resultID = 1000
////                } else if result.message.contains("已有") {
////                    self.resultID = 2001
////                } else {
////                    self.resultID = result.code
////                }
////            }
//        } failure: { _ in
//            
//        }
//    }
//}



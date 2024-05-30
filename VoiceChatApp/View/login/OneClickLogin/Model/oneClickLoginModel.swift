//
//  oneClickLoginModel.swift
//  VoiceChatApp#imageLiteral(resourceName: "12481696004173_.pic.jpg")
//
//  Created by 吕海锋 on 2023/8/20.
//
import SwiftUI
import Foundation



struct quickLoginModel: Decodable {
    let code: Int
    let message: String
    let data: userinfo
    
    struct userinfo: Decodable {
        let id: Int
        let headimgurl: String
        let nickname: String?
        let birthday: String
        let phone: String
        let ry_uid: String
        let ry_token: String
        let token: String
        let user_id: Int
        let createtime: Int
        let expiretime: Int
        let expires_in: Int
    }
}

struct quickLoginGetMobileModel: Decodable {
    let code: Int
    let message: String
    let data: mobile
    
    struct mobile: Decodable {
        let mobile: String
    }
}

class QuickLogin: ObservableObject {
    @Published var result: quickLoginModel? = nil
    
    // 一键登陆(无Token)
    func quickLogin(mobile: String, completion: @escaping (String) -> Void) {
//        let body: [String: Any] = [ "mobile" : mobile]
        
        // =============POST==================
        guard let url = URL(string: "\(baseUrl.url)api/message/quick_login?mobile=\(mobile)") else { return }
        
        do {
//            let finalData = try JSONSerialization.data(withJSONObject: body)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
//            request.httpBody = finalData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
            
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(quickLoginModel.self, from: data)
                        debugPrint("quickLogin Success result：\(result)")
                        completion(result.message)
                        
//                        let userInfo = UserInfo(id: result.data.id,
//                                                headimgurl: result.data.headimgurl,
//                                                nickname: result.data.nickname ?? "",
//                                                phone: result.data.phone,
//                                                ry_uid: result.data.ry_uid,
//                                                ry_token: result.data.ry_token,
//                                                token: result.data.token,
//                                                user_id: String(result.data.user_id),
//                                                createtime: result.data.createtime,
//                                                expiretime: result.data.expiretime,
//                                                expires_in: result.data.expires_in)
//                        self.saveUserinfo(userinfo: userInfo) // 存储用户信息
                    } else {
                        debugPrint("quickLogin result: No data")
                    }
                } catch(let error) {
                    debugPrint("quickLogin error result: ", error.localizedDescription)
                }
                
            }.resume()
        } catch {
            debugPrint("quickLogin error result: ", error.localizedDescription)
        }
    }
    
    
    // 获取手机号码(无Token)
    func getPhoneNumber(token: String, completion: @escaping (String) -> Void) {
//        NetworkTools.requestAPI(convertible: "/token/mobile",
//                                method: .post,
//                                responseDecodable: baseModel.self) { result in
//            self.quickLogin(mobile: result.data.mobile) { message in
////                            print("userinfo: \(userinfo)")
//                completion(message)
//            }
//        } failure: { _ in
//            
//        }

        
        let body: [String: Any] = [ "token" : token]
        
        // =============POST==================
        guard let url = URL(string: "\(baseUrl.newurl)api/login/mobile") else { return }
        
        do {
            let finalData = try JSONSerialization.data(withJSONObject: body)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(quickLoginGetMobileModel.self, from: data)
                        debugPrint("getPhoneNumber Success result：\(result)")
                        completion(result.message)
                        // 直接登陆
                        self.quickLogin(mobile: result.data.mobile) { message in
//                            print("userinfo: \(userinfo)")
                            completion(message)
                        }
                    } else {
//                        completion("关注失败\(userId)")
                        debugPrint("getPhoneNumber result: No data")
                    }
                } catch(let error) {
//                    completion("关注失败\(userId)")
                    debugPrint("getPhoneNumber error result: ", error.localizedDescription)
                }
                
            }.resume()
        } catch {
//            completion("网络异常,关注失败\(userId)")
            debugPrint("getPhoneNumber error result: ", error.localizedDescription)
        }
    }
    
    func saveUserinfo(userinfo: UserInfo) {
        UserCache.shared.saveUserInfo(userinfo)
    }
}

class oneClickLoginModel {
    let handler = TXCommonHandler.sharedInstance()
    var resultCode: String = ""
    var currentCarrierName: String = ""
//    @State private var api = myAPI()
    var quick = QuickLogin()
    init() {
        
        initSdk()
//        getCurrentCarrierName()
        
    }
    
    
    // MARK: - 一键登录获取Token（getLoginTokenWithTimeout）
    public func getLoginToken(controller: UIViewController,  completion: @escaping (String?) -> Void) {

//        model.checkBoxImages
//        model.logoImage = UIImage(imageLiteralResourceName: "mainLogo")

//        completion("开始身份验证")
        TXCommonHandler.sharedInstance().getLoginToken(withTimeout: 3.0, controller: controller, model: self.CustomOneKeyLoginPage()) { (resultDic) in
            if let tempResultCode = resultDic["resultCode"] as? String, tempResultCode == "600000" {
                
                print("一键登录获取Token: \(resultDic)")
                completion("手机号码验证中...")
//                let body: [String: Any] = [ "token" : resultDic["token"] ]
                
                self.quick.getPhoneNumber(token: resultDic["token"] as! String) { msg in
                    if msg == "登录成功" {
                        DispatchQueue.main.async {
                            self.handler.cancelLoginVC(animated: true, complete: nil)
                            completion("用户信息获取成功")
                            print("Attempting to push CustomTabBar to navigation controller.") // 添加日志消息
                            let swiftUIView = CustomTabBar() // 替换为您的 SwiftUI 视图名称
                            let hostingController = UIHostingController(rootView: swiftUIView)
                            if let navigationController = controller.navigationController {
                                // 找到了有效的导航控制器，可以执行推送操作
                                navigationController.pushViewController(hostingController, animated: true)
                            } else {
                                // 未找到有效的导航控制器，需要进行进一步的调试
                                print("No valid navigation controller found.")
                            }
                        }
                        

                        
                    }
                        
                }

//                self.api.requestAPI(httpMethod: "POST", apiurl: "\(baseUrl.newurl)api/login/mobile", body: body, resultType: AccessTokenChangePhoneNumberModel.self) { (result: Result<AccessTokenChangePhoneNumberModel, Error>) in
//                    switch result {
//                    case .success(let response):
//                        print("Success:", response)
//                        saveDataToCache(data: response.data?.mobile, forKey: "User_AccessTokenChangePhoneNumberModel")
//                        completion("手机号验证成功")
//                        
//                        
//                        if let mobilePhoneNumber = response.data?.mobile {
//                            self.quick.quickLogin(mobile: String(Int(mobilePhoneNumber) ?? 0)) { result in
//                                print("-----\(String(Int(mobilePhoneNumber) ?? 0))========\(result)")
//                            }
//                        }
//                        
//                        
//                        self.api.requestAPI(httpMethod: "POST", apiurl: "\(baseUrl.url)api/message/quick_login?mobile=\(response.data?.mobile)", body: [:], resultType: ResultUserInfoModel.self) { (result: Result<ResultUserInfoModel, Error>) in
//                            switch result {
//                            case .success(let response2):
//                                let userInfo = UserInfo(id: response2.data?.id,
//                                                        headimgurl: response2.data?.headimgurl,
//                                                        nickname: response2.data?.nickname,
//                                                        phone: response2.data?.phone,
//                                                        ry_uid: response2.data?.ry_uid,
//                                                        ry_token: response2.data?.ry_token,
//                                                        token: response2.data?.token,
//                                                        user_id: response2.data?.user_id,
//                                                        createtime: response2.data?.createtime,
//                                                        expiretime: response2.data?.expiretime,
//                                                        expires_in: response2.data?.expires_in)
//                                UserCache.shared.saveUserInfo(userInfo)
//                                print("UserCache.shared.getUserInfo(): \(UserCache.shared.getUserInfo())")
//                                setIsSuccessLogin(forKey: .oneClickLogin, value: true)
//                                completion("用户信息获取成功")
//                                // 这里跳转页面
//                                DispatchQueue.main.async {
//                                    self.handler.cancelLoginVC(animated: true, complete: nil)
//                                }
//                                
//                                DispatchQueue.main.async {
//                                    // 在主线程上更新您的 SwiftUI 视图
//                                    let swiftUIView = CustomTabBar() // 替换为您的 SwiftUI 视图名称
//                                    let hostingController = UIHostingController(rootView: swiftUIView)
//                                    controller.navigationController?.pushViewController(hostingController, animated: true)
//                                }
//
//                                
//                                print("用户信息获取成功")
//                            case .failure(let error2):
//                                print("Error:", error2)
//                                completion("用户信息获取失败")
//                            }
//                        }
//                        
//                        
//                    case .failure(let error):
//                        print("Error:", error)
//                        completion("手机号验证失败")
//                    }
//                }
                
                
            }
        }
//        completion("验证失败")
    }
    

    

    
    
    private func CustomOneKeyLoginPage() -> TXCustomModel {
        let model = TXCustomModel.init()
        model.prefersStatusBarHidden = false // 隐藏顶部栏
//        model.navIsHidden = false
        
        model.hideNavBackItem = false // 设置导航栏返回按钮是否隐藏。
        model.navColor = UIColor(Color.clear)
        model.navBackImage = UIImage(systemName: "chevron.backward") ?? UIImage()
        model.navTitle = NSAttributedString(string: "", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20.0)
        ])
        model.logoImage = UIImage(named: "mainLogo") ?? UIImage()
        
        model.changeBtnIsHidden = true // 切换到其他方式 是否隐藏，默认NO。
        
        
        
        // circle
        model.checkBoxImages = [UIImage(systemName: "circle") ?? UIImage(), UIImage(systemName: "circle.circle.fill") ?? UIImage()]
        model.privacyPreText = "点击一键登陆表示您已阅读并同意"
        model.checkBoxIsChecked = true //  checkBox是否勾选，默认NO。

        
        
        return model
    }
    
    
    public func httpAuthority() {
        // MARK: - 检查联网
        if let testUrl = URL(string: "https://www.baidu.com") {
            let urlRequest = URLRequest(url: testUrl)
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["Content-type": "application/json"]
            config.timeoutIntervalForRequest = 20
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            let session = URLSession(configuration: config)
            session.dataTask(with: urlRequest) { _, _, error in
                print("FlutterAliAuthPlugin: 联网\(error == nil ? "成功" : "失败")")
            }.resume()
        } else {
//            print("FlutterAliAuthPlugin: 联网失败")
            return
        }
    }
    
    // MARK: - 获取SDK版本号（getVersion）
    public func getVersion() {
        let version = TXCommonHandler.sharedInstance().getVersion()
        print("阿里云一键登录版本:\(version)")
    }
    
    
    // MARK: - 设置SDK密钥（setAuthSDKInfo）
    
    public func initSdk() {
        handler.setAuthSDKInfo(AliUtility.alikey) { resultDic in
//            print("为后面获取本机号码校验Token加个速，加速结果222：\(resultDic)")
            if let tempResultCode = resultDic["resultCode"] as? String, tempResultCode == "600000" {
                self.getToken()
            }
//            print(resultDic["msg"] ?? "")
        }
    }
    
    // MARK: - 一键登录预取号（accelerateLoginPageWithTimeout）
    private func getToken() {
        handler.accelerateVerify(withTimeout: 3.0) { resultDic in
//            print("为后面获取本机号码校验Token加个速，加速结果：\(resultDic)")
            if let tempResultCode = resultDic["resultCode"] as? String, tempResultCode == "600000" {
//                print("获取Token成功")
                self.getVerifyTokenWithTimeout()
            } else {
                print("一键登录预取号: 获取Token失败")
            }
        }
    }
    
    // MARK: - 本机号码校验获取Token（getVerifyTokenWithTimeout）
    private func getVerifyTokenWithTimeout() {
        handler.getVerifyToken(withTimeout: 3.0) { resultDic in
//            print("本机号码校验获取Token：\(resultDic["token"])")
            self.resultCode = resultDic["token"] as! String
            self.httpAuthority()
            self.getVersion()
            self.environmentalInspection()
        }

    }

    
    
    // MARK: - 环境检查（environmentalInspection）
    private func environmentalInspection() {
        handler.checkEnvAvailable(with: .verifyToken) { resultDic in
//            print("环境检查结果：\(resultDic ?? [:])")
            self.setCheckboxSelected()
        }
    }
    
    
    // MARK: - 设置checkbox选中状态（setCheckboxSelected）
    private func setCheckboxSelected() {
        handler.setCheckboxIsChecked(true)
    }
    
    // MARK: - 获取当前上网卡运营商名称（getCurrentCarrierName）
    private func getCurrentCarrierName() {
        currentCarrierName = TXCommonUtils.getCurrentCarrierName()
        print(currentCarrierName) // UNKNOW
        
    }
    
    
    func saveUserInfoToCache(userInfo: ResultUserInfoModel) {
        do {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(userInfo) {
                UserDefaults.standard.set(encodedData, forKey: "userInfoKey")
            }
        }
    }

    
}


// UIImage的扩展函数，用于将SwiftUI视图渲染为UIImage
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: snapshotImage.cgImage!)
    }
}

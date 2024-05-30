//
//  QQLoginView2.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/17.
//

import SwiftUI

struct QQLoginView2: View {
    var xqq = XQQ.default // Assuming you have XQQ instance configured with appKey
    init() {
        
        xqq = XQQ.default
        xqq.register(AppID: QQUtility.AppID)
        print("xqq.isQQInstalled() \(xqq.isQQInstalled())")
        print("xqq.isInstalled() \(xqq.isInstalled())")
    }
    var body: some View {
        
        VStack {
            Button(action: {
//                if let url = URL(string: QQUtility.AppLink2) {
//                    xqq.handleOpen(url: url)
//                    print("转换后的URL: \(url)")
//                }
                
//                xqq.auth { error, entity, jsonResponse in
//                    if let error = error {
//                        // Handle login error
//                        print("QQ login error: \(error)")
//                    } else if let entity = entity {
//                        // Handle successful login with AuthEntity
//                        print("QQ login successful. OpenID: \(entity.openid ?? "")")
//                    } else {
//                        // Handle unknown response
//                        print("QQ login response: \(jsonResponse ?? [:])")
//                    }
//                }
            }) {
                Text("QQ登录")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        
    }
    
}

struct testView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            Button(action: {
                if let appURL = URL(string: "https://qm.qq.com/") {
                    UIApplication.shared.open(appURL) { success in
                        if success {
                            print("The URL was delivered successfully.")
                        } else {
                            print("The URL failed to open.")
                        }
                    }
                } else {
                    print("Invalid URL specified.")
                }
            }, label: {
                Text("QQ")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
        }
    }
}

#Preview {
    QQLoginView2()
}


final public class XQQ: NSObject {
    
    public static let `default` = XQQ()
    private override init() {}
    
    /** MARK: 登录回调
     *  @param  error: 错误
     *  @param  entity: 解析后的数据
     *  @param  jsonResponse: 未解析的数据
     */
    public typealias AuthHandler = ((_ error: Error?, _ entity: AuthEntity?, _ jsonResponse: [AnyHashable: Any]?) -> Void)
    private var authHandler: AuthHandler?
    
    private var _auth: TencentOAuth?

    // 在调用前必须注册
    public func register(AppID: String) {
        _auth = TencentOAuth(appId: AppID, andDelegate: self)
//        _auth = TencentOAuth(appId: AppID, enableUniveralLink: true, universalLink: QQUtility.AppLink, delegate: self)
        print("注册函数已执行")
    }
    
    public func isInstalled() -> Bool {
        return QQApiInterface.isQQInstalled() && QQApiInterface.isQQSupportApi()
    }
    
    public func handleOpen(url: URL) -> Bool {
        if TencentOAuth.handleOpen(url) {
            return true
        } else {
            return QQApiInterface.handleOpen(url, delegate: self)
        }
    }
    
    public func isQQInstalled() -> Bool {
        print("QQApiInterface.isQQInstalled(): \(QQApiInterface.isQQInstalled())")
        return QQApiInterface.isQQInstalled()
    }
    
    public func isQZoneSupported() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "mqqopensdkapiV3://")!)
    }
    
}

/// MARK: 认证
public extension XQQ {
    
    public func auth(with handler: AuthHandler? = nil) {
        self.authHandler = handler
        _auth?.authorize([kOPEN_PERMISSION_GET_SIMPLE_USER_INFO])
        print("auth这个函数运行了")
    }
    
    private func _handle(error: Error?, response: APIResponse?) {
        if let jsonResponse = response?.jsonResponse {
            var tmpJsonResponse = jsonResponse
            tmpJsonResponse["openid"] = _auth?.openId
            tmpJsonResponse["unionid"] = _auth?.unionid ?? _auth?.openId
            tmpJsonResponse["appid"] = _auth?.appId
            print("fuck  --- qq   \(tmpJsonResponse)")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: tmpJsonResponse, options: [])
                let decoder = JSONDecoder()
                let entity = try decoder.decode(AuthEntity.self, from: jsonData)
                authHandler?(nil, entity, tmpJsonResponse)
            } catch {
                authHandler?(error, nil, nil)
            }
        } else {
            authHandler?(error, nil, nil)
        }
    }

    
    final public class AuthEntity: NSObject, Codable {
        var openid: String?
        var nickname: String?
        var headImgUrl: String?
        var gender: Gender?
        var province: String?
        var city: String?
        var country: String?
        var unionid: String?
        
        enum CodingKeys: String, CodingKey {
            case openid
            case nickname
            case headImgUrl = "figureurl_qq_2"
            case gender
            case province
            case city
            case country
            case unionid
        }
        
        enum Gender: String {
            case unknown = "未知"
            case male = "男"
            case female = "女"
            
            var chineseDescription: String {
                switch self {
                case .male:
                    return "男"
                case .female:
                    return "女"
                default:
                    return "未知"
                }
            }
            
            var englishDescription: String {
                switch self {
                case .male:
                    return "male"
                case .female:
                    return "female"
                default:
                    return "unknown"
                }
            }
        }
        
        public init(from decoder: Decoder) throws {
            var container = try decoder.container(keyedBy: CodingKeys.self)
            openid = try container.decodeIfPresent(String.self, forKey: .openid)
            nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
            headImgUrl = try container.decodeIfPresent(String.self, forKey: .headImgUrl)
            let genderString = try container.decodeIfPresent(String.self, forKey: .gender)
            gender = Gender(rawValue: genderString ?? "未知") ?? .unknown
            province = try container.decodeIfPresent(String.self, forKey: .province)
            city = try container.decodeIfPresent(String.self, forKey: .city)
            country = try container.decodeIfPresent(String.self, forKey: .country)
            unionid = try container.decodeIfPresent(String.self, forKey: .unionid)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = try encoder.container(keyedBy: CodingKeys.self)
            try container.encode(openid, forKey: .openid)
            try container.encode(nickname, forKey: .nickname)
            try container.encode(headImgUrl, forKey: .headImgUrl)
            try container.encode(gender?.rawValue, forKey: .gender)
            try container.encode(province, forKey: .province)
            try container.encode(city, forKey: .city)
            try container.encode(country, forKey: .country)
            try container.encode(unionid, forKey: .unionid)
        }
        
    }
    
}

extension XQQ: TencentSessionDelegate {
    
    public func tencentDidLogin() {
        if _auth?.requestUnionId() == true, _auth?.getUserInfo() == true {
            #if DEBUG
            NSLog("com.SwiftX.OpenSDK.XQQ   --   login success")
            #endif
        } else {
//            _handle(error: NSError(domain: "com.SwiftX.OpenSDK.QQ", code: -1, description: "QQ登录失败"), response: nil)
            _handle(error: NSError(domain: "com.project.VoiceChatApp.View.login.Tencent", code: -1), response: nil)
        }
    }
    
    public func tencentDidNotLogin(_ cancelled: Bool) {
//        _handle(error: NSError(domain: "com.SwiftX.OpenSDK.QQ", code: -1, description: "QQ登录失败"), response: nil)
        _handle(error: NSError(domain: "com.project.VoiceChatApp.View.login.Tencent", code: -1), response: nil)
    }
    
    public func tencentDidNotNetWork() {
//        _handle(error: NSError(domain: "com.SwiftX.OpenSDK.QQ", code: -1, description: "网络连接错误"), response: nil)
        _handle(error: NSError(domain: "com.project.VoiceChatApp.View.login.Tencent", code: -1), response: nil)
    }
    
    public func getUserInfoResponse(_ response: APIResponse!) {
        _handle(error: nil, response: response)
    }
    
}

extension XQQ: QQApiInterfaceDelegate {
    
    public func onReq(_ req: QQBaseReq!) {
        print("123")
        
    }
    
    public func onResp(_ resp: QQBaseResp!) {
        print("321")
        
    }
    
    public func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        print("32133")
    }
    
}

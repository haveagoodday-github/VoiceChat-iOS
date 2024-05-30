//
//  ForAlipay.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/1/3.
//

import Foundation

import Alamofire
//import Pay



struct AlipayModel: Decodable {
    let code: Int
    let message: String
    let data: String?
}


extension PaySDK {
    public func getAlipayPaySign(goods_id: Int, type: Int, user_id: Int) -> Void {
        if let signUrl = self.signUrl {

            NetworkTools.requestAPI(convertible: "api/rechargePay",
                                    method: .post,
                                    parameters: ["goods_id": goods_id, "type": type, "user_id": user_id],
                                    responseDecodable: AlipayModel.self) { result in
                if let str = result.data {
                    self.payDelegate?.alipayPaySign(str: str)
                }
            } failure: { error in
                self.payDelegate?.payRequestError(error: error)
            }

        } else {
            self.payDelegate?.payRequestError(error: "签名地址不存在！")
        }
    }
    
    public func alipayPayRequest(sign: String) {
        AlipaySDK.defaultService().payOrder(sign, fromScheme: PaySDK.alipayAppid) { (result) in
            print("检查支付结果\(result)")
            // 检查支付结果
        }
    }
}




// PaySDK.swift

public protocol PayRequestDelegate {
    func wechatPaySign(data: NSDictionary) -> Void
    func alipayPaySign(str: String) -> Void
    func payRequestSuccess(data: Any) -> Void
    func payRequestError(error: String) -> Void
}

public protocol AuthRequestDelegate {
    func authRequestSuccess(code: String) -> Void
    func authRequestError(error: String) -> Void
}

public class PaySDK: NSObject {
    public static let instance: PaySDK = PaySDK()
    public var signUrl: String? = nil
    public static var alipayAppid: String? = nil

    public var authDelegate: AuthRequestDelegate?
    public var payDelegate: PayRequestDelegate?
    
    // - MARK: 微信相关设置
    var state = "wx_oauth_authorization_state"
    public static var wxAppid: String! {
        didSet {
            WXApi.registerApp(wxAppid, universalLink: Utility.AppLink)
        }
    }
    
    public func isInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
    
    public func handleOpenURL(_ url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: PaySDK.instance as! WXApiDelegate)
    }
}



//  WechatAuth.swift

extension PaySDK {
    public func sendAuthRequest() -> Void {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = state
        WXApi.send(req)
    }
}



extension PaySDK: WXApiDelegate {
    public func onResp(_ resp: BaseResp!) {
        if type(of: resp) == SendAuthReq.self {
            let authResp = resp as! SendAuthResp
            if 0 == authResp.errCode && state == authResp.state {
                self.authDelegate?.authRequestSuccess(code: authResp.code!) // Edit
            } else {
                self.authDelegate?.authRequestError(error: authResp.errStr)
            }
        } else if (type(of: resp) == PayResp.self) {
            let payResp = resp as! PayResp
            if 0 == payResp.errCode {
                payDelegate?.payRequestSuccess(data: payResp.returnKey)
            } else {
                payDelegate?.payRequestError(error: payResp.errStr)
            }
        }
    }
}



//  WechatPay.swift

extension PaySDK {
    public func getWechatPaySign(goods_id: Int, type: Int, userId: Int) -> Void {
        if let signUrl = self.signUrl {
//            let params: Parameters = ["totalAmount": totalAmount, "subject": subject, "body": body, "appKey": PaySDK.wxAppid]
            
            NetworkTools.requestAPI(convertible: "/pay/rechargePay",
                                    method: .post,
                                    parameters: [
                                        "goods_id": goods_id,
                                        "type": type,
                                        "userId": userId
                                    ],
                                    responseDecodable: WechatPayModel.self) { result in
                let dictionary: NSDictionary = [
                    "package": result.data.package,
                    "partnerid": result.data.partnerid,
                    "prepayid": result.data.prepayid,
                    "sign": result.data.sign,
                    "timestamp": result.data.timestamp,
                    "noncestr": result.data.noncestr
                ]
                self.payDelegate?.wechatPaySign(data: dictionary)
            } failure: { error in
                self.payDelegate?.payRequestError(error: error)
            }

            
//            AF.request("\(baseUrl.url)api/rechargePay", method: .post, parameters: params, headers: headers).responseDecodable(of: WechatPayModel.self) { response in
//                switch response.result {
//                case .success(let data):
//                    print(data)
//                    let dictionary: NSDictionary = [
//                        "package": data.data.package,
//                        "partnerid": data.data.partnerid,
//                        "prepayid": data.data.prepayid,
//                        "sign": data.data.sign,
//                        "timestamp": data.data.timestamp,
//                        "noncestr": data.data.noncestr
//                    ]
//                    self.payDelegate?.wechatPaySign(data: dictionary)
//                case .failure(let error):
//                    self.payDelegate?.payRequestError(error: error.localizedDescription)
//                }
//            }
        } else {
            self.payDelegate?.payRequestError(error: "签名地址不存在")
        }
    }
    
    public func wechatPayRequest(signData: NSDictionary) {
        let payReq = PayReq()
        
        payReq.nonceStr = signData.object(forKey: "noncestr") as! String
        payReq.partnerId = signData.object(forKey: "partnerid") as! String
        payReq.prepayId = signData.object(forKey: "prepayid") as! String
        payReq.timeStamp = signData.object(forKey: "timestamp") as! UInt32
        payReq.package = signData.object(forKey: "package") as! String
        payReq.sign = signData.object(forKey: "sign") as! String
        WXApi.send(payReq)
    }
}




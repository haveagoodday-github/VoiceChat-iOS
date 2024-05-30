//
//  Utility.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/16.
//

import Foundation
import Alamofire


class TokenUtility {
    static let token: String = "U+vQtlZtO/EC8XJimMkmrl923PICE3ty/auHk7M3bkkwn2ve7c/xn25AEVeRKsAV"
}

/// 第三方登陆-微信登陆(WeChat)
class Utility {
    static let AppID: String = "wxbd30180703096d6d"
//    static let AppSecret: String = "56123d91a8b4473c6d7e3ba2ae8f7414"
    static let AppSecret: String = "2f5e6fef13b9b293661cb63ff4ba05c3"
    static let AppLink: String = "https://open.weixin.qq.com/"
}

/// 第三方登陆-QQ登陆
class QQUtility {
    static let AppID: String = "1108004742"
    static let AppKey: String = "IgHFu5xbaV3Cx2eQ"
    static let AppLink: String = "https://qm.qq.com/"
    static let AppLink2: String = "https://qm.qq.com/1108004742"
    
}


/// 一键登陆-阿里云
class AliUtility {
    /// 密钥
    static let alikey: String = "cB4BHNMXPYCMewsDgZgMRrhJeeSdS7FKHs2J3rzhBzYJdYopSdfL3d1R8jkxAXBnXSouNANfQuXKg+1oGKy7njZkB0j5T3xw/CY+wdzPPQNcqtaHCoLwh+f1nLOs6T+NCQ+ptXYR/M35H067ZWbz+8WgfzR2QhG/S33pyhVrAFXGf2yK+yll1amcjzxl6kCNB5CcKaS5n+0Hhe6F5EfbTPWbpxLWY6tBEeMkRebrak2saQC855fOiMvJ+iYATYgyFDYqgKPoNAAjEN+u3vAOsA=="
}


/// 融云
class ryUtility {
//    static let appKey: String = "4z3hlwrv4os4t" // 测试
//    static let appSecret: String = "f6L0jj8GL0wv" // 测试
//    static let appKey: String = "25wehl3u2sp2w" // 上线
//    static let appSecret: String = "BIyDoWU9cMg" // 上线
    
//    static let appKey: String = "82hegw5u8npox" // 上线
//    static let appSecret: String = "ZMTMvZKmY5" // 上线
    
    
    static let appKey = "82hegw5u864ex" // lhf test
    static let appSecret = "q67lfYpKlvwC" // lhf test
    
    
}



class QNUtility {
    static let qiniuHost: String = "http://cdn.msyuyin.cn/"
}



class ShengWangUtility{
    static let appKey: String = "3446385984024f00bf355940bf113400"
    static let testRoomID: String = "672"
    static let testToken: String = "0063446385984024f00bf355940bf113400IAANUfK2Dcm6Z6dNGLKEbwuIZnDGFP775U5RC1TPgXBRHoSxd4cAAAAAEAA+vwABL8n+ZAEA6AO/hf1k"
}



class AlipayUtility {
    static let appId: String = "2021004129675888"
    static let privateKey: String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApt7gwI50sK44Kj5rpC9ZRyV/FHtmnvG5HgMZ9MFDS3xgjW+HrTbOkrPVC3HFKJ4zWqmW1VpIO30kT55/XEBXK46FGhnQmdwEMPVgt1SP7p0vPPVMJRiCP6Yv4Pxfs95CuMfivXfa+MOyjQ/S5Q4zeptUWrhu6JNHgNz1KOio/rQuiaJmLWBTYqGEZH7b6oOxa7tNW6yjjdrkLGnYa938humXe4I3n2LWxMyYpLjHqzuUdLsupAcP9Toj372J5TeFlbuWx6BsBK34jseeaORFayLGCY00anJf7oIC9BpMqzoJO7lMS8lGHxeiKkh6OOxc5V+uTxuIJMoaOIzacutYqQIDAQAB"
}







class baseUrl {
    static let urls: String = "https://api.msyuyin.cn/"
    static let newurls: String = "https://service.msyuyin.cn/"
    
    static let url: String = "http://api.msyuyin.cn/"
    static let newurl: String = "http://service.msyuyin.cn/"
}

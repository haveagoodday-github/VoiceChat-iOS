//
//  RealNameAuthentication.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/8/30.
//

import SwiftUI
import SafariServices
import AliyunOSSiOS



struct RealNameAuthentication: View {
    @State var username: String = ""
    @State var userId: Int = 0
    var body: some View {
//        NavigationView {
//            RealNameAuthenticationMainView()
//        }
        
        StartAuthView(username: $username, userId: $userId)
        
    }
    

}

struct RealNameAuthenticationMainView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            HStack(alignment: .center, spacing: 0)  {
                Image(.shimingIconRenzheng)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }
            .frame(width: .infinity, height: 200)
            
            NavigationLink(destination: Text("开始认证")) {
                Text("开始认证")
                    .foregroundColor(.white)
                    .frame(maxWidth: 260)
                    .padding(.vertical, 12)
                    .background(LinearGradient(colors: [Color(red: 0.83, green: 0.47, blue: 1.002), Color(red: 1.002, green: 0.637, blue: 0.873)], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(30)
            }
            
            
            NavigationLink(destination: Text("人工认证")) {
                Text("认证失败？进入人工认证>")
                    .foregroundColor(.black)
                    .font(.system(size: 12))
            }
            
            VStack(alignment: .leading, spacing: 6)  {
                Text("温馨提示")
                VStack(alignment: .leading, spacing: 8)  {
                    Text("1.根据相关法律法规，在使用直播、提现等平台服务前请您使用本人真实信息进行实名认证")
                    Text("2.您提交的实名认证信息将用作身份识别、判定您的账号使用权归属的重要依据，您的认证信息一经通过既与用户ID绑定，不可修改或换绑。")
                    Text("3.您提交的用于认证身份的信息我们将严格保密，不会用作其他用途。")
                    Text("4.平台自动为实名认证年龄低于18岁用户开启青少年保护，为实名认证年龄高于40岁用户开启疑似青少年用户保护")
                }
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .regular))
            }
            .padding(.horizontal, 6)
            .padding(.top, 32)
            Spacer()
        }
    }
}

// 开始认证
struct StartAuthView: View {
    @StateObject var auth = AuthModel()
    @Binding var username: String
    @Binding var userId: Int
    @State private var isShowingSafari = false
    private let url1: String = "www.baidu.com"
    private let url2: String = "www.baidu.com"
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            Form {
                Section(header: Text("姓名"), content: {
                    TextField("填写真实姓名", text: $username)
                })
                Section(header: Text("身份证号码"), content: {
                    TextField("填写身份证号码", text: $username)
                })
                
                Section(content: {
                    Button(action: {
                        isShowingSafari = true
                    }) {
                        Text("查看《御声实名认证须知》")
                    }
                    .sheet(isPresented: $isShowingSafari) {
                        if url1.lowercased().hasPrefix("http") {
                            SafariView(url: URL(string: url1)!)
                        } else {
                            SafariView(url: URL(string: "http://\(url1)")!)
                        }
                    }
                    
                    
                    Button(action: {
                        isShowingSafari = true
                    }) {
                        Text("了解《御声未成年人保护计划》")
                    }
                    .sheet(isPresented: $isShowingSafari) {
                        if url2.lowercased().hasPrefix("http") {
                            SafariView(url: URL(string: url2)!)
                        } else {
                            SafariView(url: URL(string: "http://\(url2)")!)
                        }
                    }
                    
                    
                })
                .foregroundColor(.purple)
                .font(.system(size: 15))
                
            }
            
            
            
            Button(action: {
                auth.getCertifyId(name: "吕海锋", certNo: "440703200203127219")
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    DispatchQueue.main.async {
                        StartAuth()
                    }
                }
                
            }, label: {
                Text("下一步")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(LinearGradient(colors: [Color(red: 0.83, green: 0.47, blue: 1.002), Color(red: 1.002, green: 0.637, blue: 0.873)], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(30)
            })
            .padding()
            Text("*若实名认证为未成年人，将开启【青少年模式】")
                .foregroundColor(.gray)
                .font(.system(size: 14))
            
        }
        
    }
    
    
    func StartAuth() {
        // 创建一个 Dispatch Group
        let dispatchGroup = DispatchGroup()
        if !auth.CertifyId.isEmpty {
            dispatchGroup.enter()
            let extParams: [String : Any] = ["currentCtr": UIApplication.shared.delegate?.window??.rootViewController]
            
            
            AliyunFaceAuthFacade.verify(with: auth.CertifyId, extParams: extParams) { (response) in
                DispatchQueue.main.async {
                    print(response.code.rawValue)
                    var resString = ""
                    switch response.code {
                    case .ZIMResponseSuccess:
                        resString = "认证成功"
                    case .ZIMInterrupt:
                        resString = "初始化失败"
                    case .ZIMTIMEError:
                        resString = "设备时间错误"
                    case .ZIMNetworkfail:
                        resString = "网络错误"
                    case .ZIMInternalError:
                        resString = "用户退出"
                    case .ZIMResponseFail:
                        resString = "刷脸失败 "
                    default:
                        break
                    }
                    NSLog("%@", resString)
                    
                    dispatchGroup.leave() // 当操作完成时离开 Dispatch Group
                }
            }
        }
        
    }

    
    
}


struct StartAuthBackgroundView: View {
    var body: some View {
        Image(.myHeadBg2)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}




struct RealNameAuthentication_Previews: PreviewProvider {
    static var previews: some View {
        RealNameAuthentication()
        
    }
}

//
//  DiamondTopUpView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/25.
//

import SwiftUI
import Alamofire
import ProgressHUD




struct DiamondTopUpView: View {
    @StateObject var viewModel: MeViewModel
    @State private var payAmount: TopUpListModel2 = TopUpListModel2(topUpId: 0, price: 0, balance: 0)
    @State private var payMethod: payMethodEnum = .none
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.982, green: 0.982, blue: 0.997).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 12)  {
                balance
                OptionAmountView
                PaymentMethodView
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(LinearGradient(colors: [Color(red: 0.993, green: 0.628, blue: 0.879), Color(red: 0.834, green: 0.474, blue: 0.997)], startPoint: .trailing, endPoint: .leading))
                    .frame(height: 45)
                    .overlay {
                        Text("确认支付")
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        if payMethod == .alipay {
                            let params: Parameters = ["goods_id": payAmount.topUpId, "type": 1, "user_id": UserCache.shared.getUserInfo()?.userId]
                            AF.request("\(baseUrl.url)api/rechargePay", method: .post, parameters: params).responseDecodable(of: AlipayModel.self) { res in
                                switch res.result {
                                case .success(let data):
                                    print(data.data)
                                    if let str = data.data {
                                        AlipaySDK.defaultService().payOrder(str, fromScheme: "alipayalipay", callback: { resultDic in
                                            print("Alipay Payment Callback: \(resultDic)")
                                            if let dic = resultDic as? [String:Any] {
                                                let resultStatus: String = dic["resultStatus"] as! String
                                                var resultMap = Dictionary<String, Any>();
                                                resultMap["code"] = resultStatus;
                                                if resultStatus == "9000" {
                                                    ProgressHUD.succeed("支付成功！", delay: 1)
                                                } else if resultStatus == "6001" {
                                                    ProgressHUD.failed("支付失败，用户取消支付！", delay: 1.5)
                                                } else if resultStatus == "6002" {
                                                    ProgressHUD.error("支付失败，网络连接出错！", delay: 1.5)
                                                } else if resultStatus == "4000" {
                                                    ProgressHUD.error("支付失败，系统异常！", delay: 1.5)
                                                } else {
                                                    ProgressHUD.error("支付失败，请您重新支付！", delay: 1.5)
                                                }
                                            }
                                        })
                                    }
                                case .failure(let error):
                                    print("Alipay result error: \(error.localizedDescription)")
                                }
                            }
                        } else if payMethod == .wechat {
                            getWechatPaySign(goods_id: payAmount.topUpId, type: 2, user_id: UserCache.shared.getUserInfo()?.userId ?? 0)
                        } else {
                            if payAmount.price != 0 {
                                ProgressHUD.error("请选择支付方式")
                            } else {
                                ProgressHUD.error("请选择充值的金额")
                            }
                        }
                    }
                
                VStack(alignment: .leading, spacing: 6)  {
                    Text("温馨提示")
                    Text("1.充值前请确定已满18周岁，未成年人不允许充值和打赏")
                    Text("2.一切刷单、低价充值等类似言论都是骗人的")
                    Text("3.充值遇到问题，请联系官方客服")
                }
                .foregroundColor(.gray)
                .font(.system(size: 14))
                
            }
            .padding(.horizontal, 12)
        }
        .navigationTitle("钻石")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray)
        .navigationBarItems(trailing: trailingButton)
        .onAppear {
            viewModel.getTopUpList()
        }
//        .environmentObject(vm)
    }
    
    
    var balance: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(colors: [Color(red: 0.993, green: 0.628, blue: 0.879), Color(red: 0.834, green: 0.474, blue: 0.997)], startPoint: .bottomTrailing, endPoint: .topLeading)
                .frame(height: 120)
                .cornerRadius(10)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "star.circle")
                        .resizable()
                        .foregroundColor(.white.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-30))
                        .offset(x: 35, y: 35)
                        .clipped()
                }
            
            VStack(alignment: .leading, spacing: 18)  {
                Text("钻石余额")
                    .font(.system(size: 18))
                Text(viewModel.userinfo?.balance ?? "0")
                    .font(.system(size: 24, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(12)
        }
        
    }
        
}


extension DiamondTopUpView {
    
    var PaymentMethodView: some View {
        VStack(alignment: .leading, spacing: 12)  {
            Text("支付方式：")
            HStack(alignment: .center, spacing: 8)  {
                Image(.payIcWechat)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text("微信")
                    .foregroundColor(.black)
                Spacer()
             
                
                
                if payMethod == .wechat {
                    Image(.shimingIconDuigou)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                } else {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 18, height: 18)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                    
                
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
            .onTapGesture {
                payMethod = .wechat
            }
            
            HStack(alignment: .center, spacing: 8)  {
                Image(.payIcAlipay)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text("支付宝")
                    .foregroundColor(.black)
                Spacer()
             
                
                
                if payMethod == .alipay {
                    Image(.shimingIconDuigou)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                } else {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 18, height: 18)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                    
                
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
            .onTapGesture {
                payMethod = .alipay
            }
            
            
            
            
            
            
        }
    }
    
    var OptionAmountView: some View {
        VStack(alignment: .leading, spacing: 8)  {
            Text("选择充值金额")
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 3), content: {
                ForEach(viewModel.topUpList, id: \.topUpId) { item in
                    OptionAmountViewItem(item: item, isSelected: payAmount.topUpId == item.topUpId) {
                        payAmount = item
                    }
                }
            })
        }
    }
}



struct OptionAmountViewItem: View {
    let item: TopUpListModel2
    var isSelected: Bool
    var action: () -> ()
    var body: some View {
        VStack(alignment: .center, spacing: 8)  {
            Text("钻石 \(String(item.balance))")
                .foregroundColor(isSelected ? .purple : .black)
                .font(.system(size: 16))
            Text("\(String(item.price))元")
                .foregroundColor(isSelected ? .purple.opacity(0.6) : .black.opacity(0.6))
                .font(.system(size: 14))
        }
        .frame(width: UIScreen.main.bounds.width * 0.3 , height: 70)
        .background(Color.white)
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1.0)
                    .fill(Color.purple.opacity(0.2))
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.purple)
                    .frame(width: 20, height: 12)
                    .overlay {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                    }
            }
        }
    }
}




enum payMethodEnum {
    case none
    case wechat
    case alipay
}



extension DiamondTopUpView {
    var trailingButton: some View {
        NavigationLink(destination: DiamondDetailView()) {
            Text("明细")
                .foregroundColor(.black)
        }

    }
    
    
    
    private func getWechatPaySign(goods_id: Int, type: Int, user_id: Int) {
        let params: Parameters = ["goods_id": goods_id, "type": type, "user_id": user_id]
        AF.request("\(baseUrl.url)api/rechargePay", method: .post, parameters: params).responseDecodable(of: WechatPayModel.self) { response in
            switch response.result {
            case .success(let data):
//                print(data)
                let dictionary: NSDictionary = [
                    "package": data.data.package,
                    "partnerid": data.data.partnerid,
                    "prepayid": data.data.prepayid,
                    "sign": data.data.sign,
                    "timestamp": data.data.timestamp,
                    "noncestr": data.data.noncestr
                ]
                if WXApi.isWXAppInstalled() {
                    if !WXApi.isWXAppSupport() {
                        ProgressHUD.error("当前微信版本不支持支付", delay: 1.5)
                    } else {
                        wechatPayRequest(signData: dictionary)
                    }
                } else {
                    ProgressHUD.error("微信未安装", delay: 1.5)
                }
            case .failure(let error):
                print("WeChatPay result error: \(error.localizedDescription)")
            }
        }
    }
    
    private func wechatPayRequest(signData: NSDictionary) {
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


class TopUpList: ObservableObject {
    @Published var list: [TopUpListModel.data.goods] = []
    @Published var mizuan: String = "0"
    
    init() {
        self.getTopUpList()
    }
    
    // MARK: 获取充值列表
    func getTopUpList() {
//        guard let url = URL(string: "\(baseUrl.url)api/androidGoodsList?user_id=\(UserCache.shared.getUserInfo()?.userId)") else { return }
//        
//        do {
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
//            
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                do {
//                    if let data = data {
//                        let result = try JSONDecoder().decode(TopUpListModel.self, from: data)
//                        debugPrint("androidGoodsList Success result：\(result.message)")
//                        DispatchQueue.main.sync {
//                            self.list = result.data.goods
//                            self.mizuan = result.data.mizuan
//                        }
//                    } else {
//                        debugPrint("androidGoodsList result: No data")
//                    }
//                } catch(let error) {
//                    debugPrint("androidGoodsList error result: ", error.localizedDescription)
//                }
//                
//            }.resume()
//        } catch {
//            debugPrint("androidGoodsList error result: ", error.localizedDescription)
//        }
    }
    
}

struct WechatPayModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let appid: String
        let noncestr: String
        let package: String
        let partnerid: String
        let prepayid: String
        let timestamp: Int
        let sign: String
    }
}


struct TopUpListModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let mizuan: String
        let goods: [goods]
        
        struct goods: Decodable {
            let id: Int
            let price: Int
            let mizuan: Int
            let ratio: String
            let give: Int
        }
    }
}

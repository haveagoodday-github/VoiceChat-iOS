//
//  PointWithdrawalView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/28.
//

import SwiftUI
import Alamofire
import ProgressHUD

struct PointWithdrawalViewFullCover: ViewModifier {
    @State var PointsNumber: String
    @State var isOpenMyPointsViewFullCover: Bool = false
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                isOpenMyPointsViewFullCover = true
            }
            .fullScreenCover(isPresented: $isOpenMyPointsViewFullCover) {
                PointWithdrawalView(PointsNumber: PointsNumber) {
                    isOpenMyPointsViewFullCover = false
                }
            }
    }
    
}

struct PointWithdrawalView: View {
    @StateObject private var vm: alipay = alipay()
    var PointsNumber: String
    @State private var text: String = ""
    var closeAction: (() -> ())
    var body: some View {
        VStack(alignment: .center, spacing: 8)  {
            
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                Text("积分提现")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .overlay(alignment: .leading) {
                Button {
                    closeAction()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            
            ZStack(alignment: .top) {
                Color(red: 0.982, green: 0.982, blue: 0.997).ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 16)  {
                    Points
                    WithdrawalAmountView
                    if let arr = vm.aliinfo.first {
                        PaymentMethodView_PointWithdrawalView(name: arr.ali_nick_name.isEmpty ? "绑定" : vm.aliinfo.first?.ali_nick_name ?? "") {
                            if vm.aliinfo.first?.is_ali != 1 {
                                vm.withdraw()
                            }
                        }
                    }
                    Text("温馨提示：申请提现后，将在1-3个工作日内到账，节假日延后，造成的不便，望多多谅解。")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 12)
            }
        }
        .navigationTitle("积分提现")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            enterWithdraw
        }
        .onChange(of: vm.aliinfo, perform: { newValue in
            ProgressHUD.dismiss()
        })
        .onDisappear {
            ProgressHUD.dismiss()
        }
    }
    
}





extension PointWithdrawalView {
    
    var Points: some View {
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
                Text("可使用积分余额")
                    .font(.system(size: 18))
                Text(PointsNumber)
                    .font(.system(size: 24, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(12)
        }
    }
    
    var enterWithdraw: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(LinearGradient(colors: [Color(red: 0.993, green: 0.628, blue: 0.879), Color(red: 0.834, green: 0.474, blue: 0.997)], startPoint: .trailing, endPoint: .leading))
            .frame(height: 45)
            .overlay {
                Text("确认提现")
                    .foregroundColor(.white)
            }
            .onTapGesture {
                if vm.aliinfo.first?.is_ali == 1 {
                    vm.WithdrawalApplication(text) { res in
                        closeAction()
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
    }
    
    var WithdrawalAmountView: some View {
        VStack(alignment: .leading, spacing: 12)  {
            Text("提现金额")
            TextField("请输入提现金额", text: $text)
                .keyboardType(.numberPad)
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack(alignment: .center, spacing: 0)  {
                            Spacer()
                            Button(action: {
                                hideKeyboard()
                            }, label: {
                                Image(systemName: "keyboard.chevron.compact.down")
                                    .font(.system(size: 14))
                            })
                        }
                    }
                }
        }
    }
}

struct PaymentMethodView_PointWithdrawalView: View {
    var name: String
    let action: () -> ()
    var body: some View {
        VStack(alignment: .leading, spacing: 12)  {
            
            HStack(alignment: .center, spacing: 8)  {
                Image(.payIcAlipay)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text("支付宝")
                    .foregroundColor(.black)
                Spacer()
                
                Text(name)
                    .foregroundColor(.black)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
            .onTapGesture {
                action()
            }
            
        }

    }
    
    
    
    
}



final class alipay: ObservableObject {
    @Published var aliinfo: [AlipayUserinfoModel.data] = []
    
    init() {
        self.getWallet()
    }
    
    private func getWallet() {
        ProgressHUD.animate("Loading...")
        AF.request("\(baseUrl.url)api/my_store?user_id=\(UserCache.shared.getUserInfo()?.userId)",
                   method: .get
        ).responseDecodable(of: AlipayUserinfoModel.self) { res in
            ProgressHUD.dismiss()
            switch res.result {
            case .success(let result):
                print(result.data)
                DispatchQueue.main.async {
                    self.aliinfo = result.data
                }
            case .failure(let error):
                print("GetUserAliPayInfo result error: \(error.localizedDescription)")
            }
        }
    }
    
    func withdraw() {
        AF.request("\(baseUrl.url)api/ali_oauth_code", method: .get).responseDecodable(of: ali_oauth_code_Model.self) { res in
            switch res.result {
            case .success(let result):
                AlipaySDK.defaultService().auth_V2(withInfo: result.data.sign, fromScheme: "alipay", callback: nil)
            case .failure(let error):
                print("ali_oauth_code Error result: \(error.localizedDescription)")
            }
        }
    }
    
    func WithdrawalApplication(_ text: String, completion: @escaping (String) -> Void) {
        ProgressHUD.animate("Loading...")
        AF.request("\(baseUrl.url)api/tixian?user_id=\(UserCache.shared.getUserInfo()?.userId)&money=\(text)",
                   method: .post
        ).responseDecodable(of: baseModel.self) { res in
            switch res.result {
            case .success(let result):
                if result.code == 1 {
                    ProgressHUD.succeed(result.message)
                } else {
                    ProgressHUD.failed(result.message)
                }
                completion(result.message)
            case .failure(let error):
                completion(error.localizedDescription)
                ProgressHUD.dismiss()
                print("WithdrawalApplication result error: \(error.localizedDescription)")
            }
        }
    }
}


struct AlipayUserinfoModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable, Equatable {
        let id: Int
        let ali_user_id: String
        let ali_avatar: String
        let ali_nick_name: String
        let mizuan: String
        let mibi: String
        let r_mibi: String
        let is_ali: Int
    }
}


struct ali_oauth_code_Model: Decodable {
    let code: Int
    
    let message: String
    let data: data
    
    struct data: Decodable {
        let sign: String
    }
}



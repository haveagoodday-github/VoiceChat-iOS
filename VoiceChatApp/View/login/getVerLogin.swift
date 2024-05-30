//
//  VerificationCodeView.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/8/29.
//

import SwiftUI
import Alamofire
import ProgressHUD

struct VerificationCodeView: View {
    @StateObject var viewModel: LoginModel = LoginModel()
    
    @FocusState private var focusField: Bool?
    var body: some View {
        ZStack(alignment: .center) {
            Color.clear.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 32)  {
                titleText
                inputPhoneNumberView
                getVerificationCodeButtonView
                VerificationCodeBottomTextView
            }
            .padding(.horizontal)
        }
        .navigationTitle("登陆")
        
        
    }
}




extension VerificationCodeView {
    
    var titleText: some View {
        HStack(alignment: .center, spacing: 0)  {
            Text("登陆解锁更多精彩内容")
                .font(.system(size: 24, weight: .bold))
            Spacer()
        }
    }
    
    var ZoneCodePickView: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Picker("", selection: $viewModel.selectedCountryCode) {
                    Text("+86").tag("+86").foregroundColor(.pink)
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }
    
    var inputPhoneNumberView: some View {
        HStack(alignment: .center, spacing: 12) {
            ZoneCodePickView
            
            TextField("请输入手机号", text: $viewModel.phone)
                .keyboardType(.numberPad)
                .onChange(of: viewModel.phone) { newValue in
                    // 检查手机号码长度，如果超过最大长度，截断输入
                    if viewModel.phone.count > viewModel.maxPhoneNumberLength {
                        viewModel.phone = String(viewModel.phone.prefix(viewModel.maxPhoneNumberLength))
                    }
                }
                .focused($focusField, equals: true)
        }
        .onAppear {
            focusField = true
        }
    }
    
    
    var getVerificationCodeButtonView: some View {
        
        Button(action: {
            viewModel.getVerificationCode()
        }, label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(viewModel.phone.count == 11 ? Color.blue : Color.gray)
                    .frame(height: 50)
                
                HStack(alignment: .center, spacing: 0)  {
                    Text("获取验证码")
                        .foregroundColor(.white)
                    
                }
                
            }
        })
        .navigationTitle("验证码登陆")
        .background {
            NavigationLink(destination: iptVerCode(viewModel: viewModel), isActive: $viewModel.isGetVerCode ) { }
        }
        
        
        
    }
    
    
    var VerificationCodeBottomTextView: some View {
        HStack(alignment: .center, spacing: 0)  {
            NavigationLink(destination: PasswordLogin()) {
                Text("密码登陆")
                    .foregroundColor(.black)
            }
            Spacer()
            HStack(alignment: .center, spacing: 0)  {
                Text("没有帐号?")
                    .foregroundColor(.gray)
                NavigationLink(destination: RegisterView()) {
                    Text("点击这里注册")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}




class LoginModel: ObservableObject {
    @Published var maxPhoneNumberLength: Int = 11
    @Published var isSuccessful: Bool = false
    @Published var isGetVerCode: Bool = false
    @Published var isGoToCompleteRegistration: Bool = false
    @Published var phone: String = ""
    @Published var nickname: String = ""
    @Published var password: String = ""
    @Published var secondPassword: String = ""
    @Published var selectedCountryCode = "+86"
    
    // MARK: 获取验证码
    func getVerificationCode() {
        ProgressHUD.animate("Loading...")
        NetworkTools.requestAPI(convertible: "/sms/sendSms",
                                method: .post,
                                parameters: ["phone": phone],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                ProgressHUD.succeed(result.message)
                self.isGetVerCode.toggle()
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { _ in
            
        }
    }
    
    // MARK: 验证 验证码
    func enterVerificationCode(veriCode: String) {
        NetworkTools.requestAPI(convertible: "/sms/verifyCode",
                                method: .post,
                                parameters: [
                                    "phone": phone,
                                    "code": veriCode
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0, let token = result.data {
                UserDefaults.standard.setValue(token, forKey: "Authorization")
                UserRequest.getMyUserInfo { _ in
                    self.isSuccessful.toggle()
                }
            } else {
                // 未注册，跳转完善资料页面
                self.isGoToCompleteRegistration.toggle()
                
            }
        } failure: { _ in
            
        }
    }
    
    
    func register() {
        if secondPassword == password {
            NetworkTools.requestAPI(convertible: "/user/register",
                                    method: .post,
                                    parameters: [
                                        "phone": phone,
                                        "password": password,
                                        "nickname": nickname
                                    ],
                                    responseDecodable: baseModel.self) { result in
                if result.code == 0 {
                    self.autoLogin() // 注册成功，自动登陆
                } else {
                    ProgressHUD.error("注册失败")
                }
            } failure: { _ in
                
            }
        } else {
            secondPassword = ""
            ProgressHUD.error("两次输入的密码不一致")
        }
    }
    
    private func autoLogin() {
        NetworkTools.requestAPI(convertible: "/user/login",
                                method: .post,
                                parameters: [
                                    "phone": phone,
                                    "password": password
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0, let token = result.data {
                UserDefaults.standard.setValue(token, forKey: "Authorization")
                UserRequest.getMyUserInfo { _ in
                    self.isSuccessful.toggle()
                    ProgressHUD.succeed("注册成功并自动登陆")
                }
            } else {
                ProgressHUD.error("自动登陆失败")
            }
        } failure: { _ in
            
        }

    }
    
    
}



// 手机帐号未注册，完善注册
struct CompleteRegistration: View {
    @StateObject var viewModel: LoginModel
    var body: some View {
        Form() {
            Section("必填*") {
                TextField("绑定手机号", text: $viewModel.phone)
                    .foregroundColor(.gray)
                    .disabled(true)
            }
            
            Section("必填*") {
                SecureField("设置密码", text: $viewModel.password)
                TextField("再次确认密码", text: $viewModel.secondPassword)
                TextField("昵称", text: $viewModel.nickname)
            }
            
            Section("完成注册") {
                Button(action: {
                    viewModel.register()
                }, label: {
                    Text("注册")
                })
                .disabled(viewModel.nickname.isEmpty || viewModel.password.isEmpty || viewModel.secondPassword.isEmpty)
            }
        }
        .navigationBarTitle("完善用户信息", displayMode: .inline)
        .background {
            NavigationLink(destination: CustomTabBar().navigationBarBackButtonHidden(true), isActive: $viewModel.isSuccessful) { }
        }
    }
}

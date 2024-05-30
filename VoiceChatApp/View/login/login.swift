import SwiftUI
import SDWebImageSwiftUI
import Alamofire
import ProgressHUD




struct login: View {
    @State private var isChecked: Bool = false
    @State private var isshow: Bool = true
    @State private var showAlertDialog: Bool = false
    @State private var isNaviLogin1: Bool = false
    
    @ObservedObject var model =  WeChatUserInfo()
    @ObservedObject var imageLoader = WeChatImageLoader()
    @State private var image: UIImage = UIImage()
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name("code")) //onResp拿到code后的通知界面
    @State private var isCodeReceived = false
    let loginModel = oneClickLoginModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isSuccessQQ: Bool = false
    
    @State private var isSuccessOneClickLogin = false
    
    @State private var returnString: String = ""
    @State private var weChatInfo: WeChatUserInfoModel = WeChatUserInfoModel(openid: "", nickname: "", sex: 0, headimgurl: "", unionid: "")
    @State private var isGoToPerfectUserInfo: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                ZStack {
                    AnimatedImage(name: "login_bg.gif")
                        .scaledToFill()
                        .ignoresSafeArea()
                        
                    VStack {
                        Spacer()
                        Text("御声")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 15)
                        
                        Text("和萌妹大神一起语音开黑")
                            .foregroundColor(Color.white)
                            .padding(.bottom, 85)
                        
                        loginButtonView
                        Spacer()
                        bottomTextView
                        
                        
                    }
                    .padding()
                    
                    
                }
                .edgesIgnoringSafeArea(.all)
            }
            .background {
                NavigationLink(destination: perfectUserInfo(weChatInfo: weChatInfo).navigationBarBackButtonHidden(true), isActive: $isGoToPerfectUserInfo) {
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
}


extension login {
    var loginButtonView: some View {
        VStack {
            //  MARK: 验证码登陆或密码登陆
            NavigationLink(destination: VerificationCodeView(),isActive: $isNaviLogin1) {
                Button(action: {
                    if isChecked {
                        isNaviLogin1 = true
                    } else {
                        showAlertDialog = true
                    }
                }) {
                    Text("验证码登陆或密码登陆")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.884, green: 0.388, blue: 0.502))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.bottom, 10)
            }
            
            // TODO: 完善本机号码一键登陆
            //  MARK: 本机号码一键登录
            Button(action: {
                if let currentController = getCurrentViewController() {
                    loginModel.getLoginToken(controller: currentController) { result in
                        returnString = result ?? "返回数据为空"
                        if returnString == "用户信息获取成功" {
                            isSuccessOneClickLogin = true
                        }
                    }
                }
            }, label: {
                Text("本机号码一键登录")
                    .padding()
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color("Button for sign"))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            })
            .background {
                NavigationLink(destination: CustomTabBar(), isActive: $isSuccessOneClickLogin, label: {
                    EmptyView()
                })
            }
            .padding(.bottom, 35)
            
            
            
            /// 其他方式登陆按钮
            HStack {
                Spacer()
                //  MARK: 微信登陆
                NavigationLink(destination: CustomTabBar().navigationBarBackButtonHidden(true), isActive: $isCodeReceived) {
                    Button(action: {
                        if isChecked {
                            getCode()
                        } else {
                            showAlertDialog = true
                        }
                    }, label: {
                        Image(.weChat)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(10)
                            .background(Color.gray)
                            .clipShape(Circle())
                    })
                }
                .onReceive(pub) { (output) in
                    //code拿access_token
                    let code = output.object as! String
                    self.getInfo(code: code)
                }
                
                
                
                
                Spacer()
                
                // MARK: QQ登陆
                Button(action: {
                    if isChecked {
                        // TODO: 完善QQ登录
                        appDelegate.registerQQ()
                    } else {
                        showAlertDialog = true
                    }
                }) {
                    Image(.QQ)
                        .resizable()
                        .frame(width: 30, height: 30) // 调整图片的大小
                        .padding(10) // 增加内边距，使按钮变大
                        .background(Color.gray)
                        .clipShape(Circle())
                }
                
                
            
                
                
                Spacer()
            }
        }
        .alert(isPresented: $showAlertDialog, content: {
            getAlert()
        })
        .padding(.horizontal, 20)
        
        
    }
    
    
    func getAlert() -> Alert {
        return Alert(
            title: Text("未同意用户协议和隐私协议"),
            message: Text("您尚未同意我们的用户协议和隐私协议。这些协议对保护您的隐私和确保应用的正常运行非常重要，请仔细阅读协议内容。如已阅读协议内容，请点击下面的按钮“我已阅读并同意协议内容”。"),
            primaryButton: .default(Text("我已阅读并同意协议内容"), action: {
                isChecked = true
            }),
            secondaryButton: .default(Text("取消"))
        )
        
    }
}


// 底部
extension login {
    var bottomTextView: some View {
        HStack(alignment: .center) {
            Button {
                print("点击时切换选中状态")
                isChecked.toggle() // 点击时切换选中状态
            } label: {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .blue : .white)
                    .font(.system(size: 18))
                    .padding(4)
            }

            HStack(alignment: .center, spacing: 5)  {
                Text("我已阅读并同意")
                    .foregroundColor(.white)
                
                Button(action: {
                    if let appURL = URL(string: "\(baseUrl.url)index/index/user_protocol") {
                        UIApplication.shared.open(appURL)
                    }
                }) {
                    Text("用户协议")
                        .foregroundColor(.blue)
                }
                
                Text("和")
                    .foregroundColor(.white)
                
                Button(action: {
                    if let appURL = URL(string: "\(baseUrl.url)index/index/secret_protocol") {
                        UIApplication.shared.open(appURL)
                    }
                }) {
                    Text("隐私协议")
                        .foregroundColor(.blue)
                }
            }
            .font(.system(size: 13))
        }
        .padding(.bottom, 20)
    }
}


struct WeChatAccessTokenModel: Decodable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
    let openid: String
    let scope: String
    let unionid: String
}

struct WeChatUserInfoModel: Decodable {
    let openid: String
    let nickname: String
    let sex: Int
    let headimgurl: String
    let unionid: String
}

extension login {
    
    func getCode(){
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "wx_oauth_authorization_state"
        DispatchQueue.main.async{
            WXApi.send(req)
        }
    }
    
    func getInfo(code: String){
        AF.request("https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(Utility.AppID)&secret=\(Utility.AppSecret)&code=\(code)&grant_type=authorization_code", method: .get).responseDecodable(of: WeChatAccessTokenModel.self) { res in
            switch res.result {
            case .success(let result):
                DispatchQueue.main.async {
                    requestUserInfo(result.access_token, result.openid)
                }
            case .failure(let error):
                print("WeChat_Login_getInfo result error: \(error.localizedDescription)")
            }
        }
        
    }
    
    
    func requestUserInfo(_ token: String, _ openID: String) {
        AF.request("https://api.weixin.qq.com/sns/userinfo?access_token=\(token)&openid=\(openID)", method: .get).responseDecodable(of: WeChatUserInfoModel.self) { res in
            switch res.result {
            case .success(let result):
                DispatchQueue.main.async {
                    weChatInfo = result
                    print("WeChatLoginRequestUserInfo result Success: NICKNAME: \(result)")
                }
                getUserInfoByWxOpenid(wxOpenid: result.openid)
            case .failure(let error):
                print("WeChatLoginRequestUserInfo result error: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func getUserInfoByWxOpenid(wxOpenid: String) {
        NetworkTools.requestAPI(convertible: "/user/getUserInfoByWxOpenid",
                                method: .post,
                                parameters: ["wxOpenid": wxOpenid],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0, let token = result.data {
                // 已注册 返回登陆Token
                UserDefaults.standard.setValue(token, forKey: "Authorization")
                UserRequest.getMyUserInfo { _ in
                    isCodeReceived = true // 跳转页面
                }
            } else {
                // 跳转到注册
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    debugPrint("跳转到注册")
                    isGoToPerfectUserInfo = true
//                })
                
            }
        } failure: { _ in
            
        }
    }
    
    
    
    // 创建一个函数来查找当前视图控制器
    private func getCurrentViewController() -> UIViewController? {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        guard var topController = keyWindow.rootViewController else {
            return nil
        }
        while let presentedController = topController.presentedViewController {
            topController = presentedController
        }
        return topController
    }
}



struct perfectUserInfo: View {
    @State var weChatInfo: WeChatUserInfoModel
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var isSucceedLogin: Bool = false
    @State private var showInputPassword: Bool = false
    var body: some View {
        Form() {
            Section("必填*") {
                TextField("绑定手机号", text: $phone)
                    .keyboardType(.numberPad)
                if showInputPassword {
                    TextField("设置登陆密码", text: $password)
                }
            }
            
            Section("完成注册") {
                Button(action: {
                    registerByWechatId()
                }, label: {
                    Text(showInputPassword ? "注册" : "该手机号以有帐号，绑定原有帐号")
                })
                .disabled(phone.count < 11 || phone.count > 11 || (showInputPassword && password.isEmpty))
            }
        }
        .navigationBarTitle("完善用户信息", displayMode: .inline)
        .background {
            NavigationLink(destination: CustomTabBar(), isActive: $isSucceedLogin) {
                
            }
        }
        .onChange(of: phone, perform: { newValue in
            if phone.count == 11 {
                isRegisterByPhone()
            } else {
                showInputPassword = false
            }
        })
    }
    
    private func isRegisterByPhone() {
        NetworkTools.requestAPI(convertible: "/user/isRegisterByPhone",
                                method: .post,
                                parameters: ["phone": phone],
                                responseDecodable: baseModel.self) { result in
            withAnimation(.spring) {
                showInputPassword = result.code == 1
            }
        } failure: { _ in
            
        }

    }
    
    private func registerByWechatId() {
        NetworkTools.requestAPI(convertible: "/user/registerByWxOpenid",
                                method: .post,
                                parameters: [
                                    "phone": phone,
                                    "password": password,
                                    "avatar": weChatInfo.headimgurl,
                                    "wxOpenid": weChatInfo.openid,
                                    "wxUnionid": weChatInfo.unionid,
                                    "sex": weChatInfo.sex
                                ],
                                responseDecodable: baseModel.self) { result in
            if let token = result.data, result.code == 0 {
                // 已注册 返回登陆Token
                UserDefaults.standard.setValue(token, forKey: "Authorization")
                UserRequest.getMyUserInfo { _ in
                    isSucceedLogin = true // 跳转页面
                }
            }
        } failure: { _ in
            
        }

    }
}

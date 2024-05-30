
import SwiftUI
import Combine


struct WeChatUserinfo: Decodable {
    let openid: String
    let nickname: String
    let sex: Int
    let province: String
    let city: String
    let country: String
    let headimgurl: String
    let unionid: String
    
}

class WeChatUserinfoModel: ObservableObject {
    
}

class WeChatUserInfo: ObservableObject {
    @Published var openid: String = ""
    @Published var nickname: String = ""
    @Published var sex: Int = 0
    @Published var province: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    @Published var headimgurl: String = ""
    @Published var unionid: String = ""
}

class WeChatImageLoader: ObservableObject {
    @Published var data: Data? = nil
    func loadData(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}


struct WeChatLoginView: View {
    @ObservedObject var model =  WeChatUserInfo()
    @ObservedObject var imageLoader = WeChatImageLoader()
    @State private var image: UIImage = UIImage()
    //onResp拿到code后的通知界面
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name("code"))
    @State private var isCodeReceived = false
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: CustomTabBar().navigationBarBackButtonHidden(true),
                           isActive: $isCodeReceived) {
                Button(action: {
                    getCode()
                }, label: {
                    Image(.weChat)
                        .resizable()
                        .frame(width: 30, height: 30) // 调整图片的大小
                        .padding(10) // 增加内边距，使按钮变大
                        .background(Color.gray)
                        .clipShape(Circle())
                })
            }
            
            
            
        }
        .onReceive(pub) { (output) in
            //code拿access_token
            let code = output.object as! String
            self.getInfo(code: code)
        }
        
    }
    
    func getCode(){
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "wx_oauth_authorization_state"
        DispatchQueue.main.async{
            WXApi.send(req)
        }
    }
    
    
    func getInfo(code: String){
        
        
        print("00000")
        let urlString = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(Utility.AppID)&secret=\(Utility.AppSecret)&code=\(code)&grant_type=authorization_code"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async(execute: {
                if error == nil && data != nil {
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        let access_token = dic["access_token"] as! String
                        let openID = dic["openid"] as! String
                        print("openID: \(openID)")
                        //通过access_token拿微信登录信息
                        requestUserInfo(access_token, openID)
                    } catch  {
                        print(#function)
                    }
                    return
                }
            })
        }.resume()
    }
    
    
    func requestUserInfo(_ token: String, _ openID: String) {
        let urlString = "https://api.weixin.qq.com/sns/userinfo?access_token=\(token)&openid=\(openID)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async(execute: {
                if error == nil && data != nil {
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        // 添加跳转到 allshow() 的view界面
                        self.isCodeReceived = true
                        print("NICKNAME: \(dic["nickname"] as! String)")
                        imageLoader.loadData(from: self.model.headimgurl)
                    } catch  {
                        print(#function)
                    }
                    return
                }
            })
        }.resume()
    }
    
    
    
    
}







struct WeChatLoginView_Previews: PreviewProvider {
    static var previews: some View {
        WeChatLoginView()
        
    }
}

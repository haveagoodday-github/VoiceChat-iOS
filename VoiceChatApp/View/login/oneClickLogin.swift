import SwiftUI
import CoreTelephony





struct OneClickLogin: View {
    @State private var avatarImageURL: URL? = URL(string: "https://i.postimg.cc/qqFxLzvp/IMG-3049-3.jpg")
//    @State private var api = myAPI()
    @State private var userPhoneNumberStored: String = ""
    @StateObject private var vm: QuickLogin = QuickLogin()
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                if let url = avatarImageURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text("中国电信提供认证服务")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                
                Button(action: {
//                    userPhoneNumberStored = api.getUserPhoneNumberStored()
                }, label: {
                    Text(userPhoneNumberStored != "" ? formatPhoneNumber(userPhoneNumberStored) : "获取手机号")
                        .font(userPhoneNumberStored != "" ? .title : .subheadline)
                })

                    

                Button(action: {
                    vm.quickLogin(mobile: userPhoneNumberStored) { result in
                        print(result)
                    }
//                    let body: [String: Any] = [ "mobile": userPhoneNumberStored ]
//                    api.requestAPI(httpMethod: "POST", apiurl: "http://service.msyuyin.cn/api/message/quick_login", body: body, resultType: PostModel_quick_login.self) { (result: Result<PostModel_quick_login, Error>) in
//                        switch result {
//                        case .success(let response):
//                            print("Success:", response)
//                        case .failure(let error):
//                            print("Error:", error)
//                        }
//                    }
                    
                }) {
//                    NavigationLink(destination: allShow().navigationBarHidden(true)){
                        Text("一键登陆")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(30)
//                    }
                    
                }
                .padding(.horizontal, 20)

                Button(action: {
                    // 点击“切换到其他方式”按钮的操作
                }) {
                    NavigationLink(destination: login().navigationBarHidden(true)) {
                        Text("切换到其他方式")
                            .foregroundColor(.blue)
                    }
                    
                }
            }
            .padding(.top, 150)
            Spacer()
            bottomTextView_()
        }
    }
    
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        // Check if the phone number has at least 7 digits to display
        if phoneNumber.count >= 7 {
            let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let endIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -4)
            let middlePart = phoneNumber[startIndex..<endIndex]
            let maskedPart = String(repeating: "*", count: middlePart.count)
            return String(phoneNumber.prefix(3)) + maskedPart + String(phoneNumber.suffix(4))
        } else {
            // If the phone number is less than 7 digits, return it as is
            return phoneNumber
        }
    }
    
}


class PhoneNumberManager: ObservableObject {
    @Published var userPhoneNumber: String = ""
    @Published var isPhoneNumberAvailable = false
    
    
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        // Check if the phone number has at least 7 digits to display
        if phoneNumber.count >= 7 {
            let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let endIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -4)
            let middlePart = phoneNumber[startIndex..<endIndex]
            let maskedPart = String(repeating: "*", count: middlePart.count)
            return String(phoneNumber.prefix(3)) + maskedPart + String(phoneNumber.suffix(4))
        } else {
            // If the phone number is less than 7 digits, return it as is
            return phoneNumber
        }
    }
}



struct bottomTextView_: View {
    @State private var isChecked: Bool = false
    var body: some View {
        VStack(spacing: 5) {
            VStack(spacing: 5) {
                HStack {
                    // 自定义的单选框样式
                    ZStack {
                        Circle()
                            .stroke(Color.gray, lineWidth: 2) // 空心圆形（灰色）
                            .frame(width: 16, height: 16)
                        if isChecked {
                            Circle()
                                .fill(Color.blue) // 填充的小圆点（蓝色）
                                .frame(width: 8, height: 8)
                        }
                    }
                    .onTapGesture {
                        isChecked.toggle() // 点击时切换选中状态
                    }
                    .padding(.horizontal,3)
                    
                    Text("我已阅读并同意")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // 处理天翼账号认证服务条款链接的动作
                        print("天翼账号认证服务条款")
                    }) {
                        Text("天翼账号认证服务条款")
                            .foregroundColor(.blue)
                    }
                    Text("和")
                        .foregroundColor(.gray)
                    Button(action: {
                        // 处理用户协议链接的动作
                        print("用户协议")
                    }) {
                        Text("《用户协议》")
                            .foregroundColor(.blue)
                    }
                }
                
                HStack {
                    Text("、")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // 处理隐私协议链接的动作
                        print("隐私协议")
                    }) {
                        Text("《隐私协议》")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .font(.system(size: 10))
    }
}

struct PostModel_quick_login: Decodable {
    let data: Bool
    let message: String
}

struct OneClickLogin_Previews: PreviewProvider {
    static var previews: some View {
        OneClickLogin()
    }
}

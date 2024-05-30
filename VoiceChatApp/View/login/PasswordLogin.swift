import SwiftUI

struct PasswordLogin: View {
    @StateObject private var viewModel: LoginViewModel = LoginViewModel()

    let maxPhoneNumberLength = 11 // 设置手机号码最大长度
    let countryCodes = [
            "+1", "+32", "+33", "+39", "+44", "+49", "+61", "+81", "+86", "+91"
        ]
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10.0) {
                Text("手机号密码登录")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20)
                
                HStack {
                    VStack {
                        Picker("", selection: $viewModel.selectedCountryCode) {
                            ForEach(countryCodes, id: \.self) { code in
                                Text(code).tag(code).foregroundColor(code == viewModel.selectedCountryCode ? .pink : .primary)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                    }
                    TextField("请输入手机号", text: $viewModel.phoneNumber)
                        .frame(height: 60)
                        .font(.system(size: 18))
                        .keyboardType(.numberPad)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: viewModel.phoneNumber, perform: { newValue in
                            if viewModel.phoneNumber.count > maxPhoneNumberLength {
                                viewModel.phoneNumber = String(viewModel.phoneNumber.prefix(maxPhoneNumberLength))
                            }
                        })
                }
                
                SecureField("请输入密码", text: $viewModel.password)
                    .padding()
                    .frame(height: 60)
                    .font(.system(size: 18))
                    .textFieldStyle(PlainTextFieldStyle())

                Button(action: {
                    viewModel.login()
                }) {
                    Text("登陆")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            .padding()
            Spacer()
        }
        .padding(1)
        .background {
            NavigationLink(destination: CustomTabBar().navigationBarBackButtonHidden(true), isActive: $viewModel.isLoginSucceed) {
                
            }
        }
    }
}



struct PasswordLogin_Previews: PreviewProvider {
    static var previews: some View {
        PasswordLogin()
    }
}

//
//  Setting.swift
//  testProject
//
//  Created by MacBook Pro on 2023/8/26.
//

import SwiftUI
import Defaults

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}


struct firstListItem: Identifiable {
    let id = UUID()
    let text: String
    let view: AnyView
}

struct Setting: View {
    let listArray: [firstListItem] = [
        firstListItem(text: "账号安全", view: AnyView(Text("帐号安全"))),
        firstListItem(text: "黑名单", view: AnyView(Text("黑名单"))),
        firstListItem(text: "通知设置", view: AnyView(NotificationSettingView())),
        firstListItem(text: "隐私政策", view: AnyView(Text("隐私政策")))
    ]
    @State private var isTurnOnPureMode = false
    @State private var showAlert: Bool = false
    @State private var isGoToLoginPageView: Bool = false
    @State private var isGoToAboutUs: Bool = false
    @State private var isGoToBlackList: Bool = false
    var body: some View {
        List {
            Section() {
                ForEach(listArray) { item in
                    selectItemView(item: item)
                }
            }
            Section(header: Text("开启纯净模式后，将关闭飘屏、特效等可能会提高性能消耗的功能，减少发热量，提高性能与稳定性。")) {
                Toggle("开启纯洁模式", isOn: $isTurnOnPureMode)
                selectItemView(item: firstListItem(text: "联系我们", view: AnyView(
                    Text("联系我们")
                        .navigationTitle("联系我们")
                        .navigationBarTitleDisplayMode(.inline)
                )))
                HStack(alignment: .center, spacing: 0)  {
                    Text("清空缓存")
                        .font(.system(size: 18))
                    Spacer()
                    Text("0.0MB")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                selectItemView(item: firstListItem(text: "关于我们", view: AnyView(AboutUs())))
            }
            Section() {
                Button(action: {
                    showAlert.toggle()
                }, label: {
                    HStack(alignment: .center, spacing: 0)  {
                        Spacer()
                        Text("退出登陆")
                        Spacer()
                    }
                })
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("提示"),
                          message: Text("确定要退出登录吗？"),
                          primaryButton: .destructive(Text("确定退出"), action: {
                        setIsSuccessLogin(forKey: .oneClickLogin, value: false)
                        setIsSuccessLogin(forKey: .weChat, value: false)
                        setIsSuccessLogin(forKey: .qq, value: false)
                        UserCache.shared.clearUserInfo()
                        isGoToLoginPageView = true
                        
                    }),
                          secondaryButton: .cancel())
                })
            }
            .accentColor(.red)
                
        }
        .background {
            NavigationLink(destination: login().navigationBarBackButtonHidden(true), isActive: $isGoToLoginPageView) { }
        }
        .navigationBarTitle("设置", displayMode: .inline)
        
    }
}

struct selectItemView: View {
//    let content: String
    let item: firstListItem
    var body: some View {
        NavigationLink(destination: item.view) {
            HStack(alignment: .center, spacing: 0)  {
                Text(item.text)
                    .font(.system(size: 18))
            }
        }
    }
}


struct NotificationSettingView: View {
    @Default(.isNotificationForReceiveNewMessage) var isNotificationForReceiveNewMessage
    var body: some View {
        Form {
            Section() {
                Toggle(isOn: $isNotificationForReceiveNewMessage) {
                    Text("消息通知")
                }
            }
        }
        .navigationBarTitle("通知设置", displayMode: .inline)
    }
}

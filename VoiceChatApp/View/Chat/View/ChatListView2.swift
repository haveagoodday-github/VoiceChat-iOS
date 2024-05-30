//
//  ChatListView2.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/22.
//

import UIKit
import SwiftUI
import Defaults
import UserNotifications


struct ChatListView2: View {
    @State var clickID: Int = 0
    @EnvironmentObject var vm: UserInfoMain
    @State private var userProfileFullSheet: Bool = false
    @Binding var isShowTabBar: Bool
    var body: some View {
        NavigationView {
            //            ConversationListViewControllerRepresentable(userProfileFullSheet: $userProfileFullSheet, clickID: $clickID, isShowTabBar: $isShowTabBar)
            //                .navigationBarTitle("消息", displayMode: .inline)
//            MessagesListView()
        }
        .onChange(of: clickID) { newValue in
            userProfileFullSheet = true
        }
        .fullScreenCover(isPresented: $userProfileFullSheet) {
            NavigationView {
                UserProfileSheetView(userId: clickID, isCloseUserProfileSheetView: $userProfileFullSheet)
            }
        }
        
    }
    
}

struct ContactListRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [ContactListModel]
}
struct ContactListModel: Decodable {
    //    let beUserId: Int
    //    let nickname: String
    //    let avatar: String
    //    let lastOnlineTime: String
    //    let lastMessageContent: String
    //    let lastMessageTime: String
    
    let userId: Int
    let avatar: String
    let nickname: String
    let lastMessageContent: String
    let lastMessageTime: String
    let lastOnlineTime: String
}

struct SingleMessageModel: Decodable {
    let isSender: Bool
    let avatar: String
    let message: String
}

struct MessagesListView: View {
    @StateObject var viewModel: MessageViewModel = MessageViewModel()
    var body: some View {
        List(viewModel.searchText.isEmpty ? viewModel.contactList : viewModel.filterContactList, id: \.userId) { contact in
            MessageItem(contact: contact)
        }
        .listStyle(.inset)
        .navigationBarTitle("消息", displayMode: .inline)
        .animation(.spring)
        .searchable(text: $viewModel.searchText, prompt: Text("搜索昵称或内容..."))
        .onAppear {
            NotificationCenter.default.addObserver(forName: .receiveNewMessage, object: nil, queue: .main) { notification in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    viewModel.getContactList(page: 1)
                })
            }
        }
    }
}

struct MessageItem: View {
    var contact: ContactListModel
    @State private var userProfileFullSheet: Bool = false
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView_Fill(imageUrl: contact.avatar)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .showUserInfoFullCoverSheet(userId: contact.userId, isShowUserInfoFullCoverSheet: $userProfileFullSheet)
            
            NavigationLink(
                destination: MessageDetailsView(beUserId: contact.userId,
                                                beUserNickname: contact.nickname,
                                                beUserAvatar: contact.avatar
                                               )
            ) {
                
                VStack(alignment: .leading, spacing: 12)  {
                    HStack(alignment: .center, spacing: 4)  {
                        Text(contact.nickname)
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                        Text(Timer.lastMessageDateString(contact.lastMessageTime))
                            .font(.system(size: 12, weight: .light))
                    }
                    
                    Text(contact.lastMessageContent)
                        .foregroundColor(.gray)
                    
                }
                .padding(.vertical, 4)
                
                Spacer()
                
            }
            
        }
        .frame(height: 60)
    }
}



struct MessageDetailsView: View {
    @StateObject var viewModel: MessageDetailsViewModel = MessageDetailsViewModel()
    
    var beUserId: Int
    var beUserNickname: String
    var beUserAvatar: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            ScrollView {
                ScrollViewReader { scrollView in
                    
                    VStack(alignment: .center, spacing: 8)  {
    //                        Spacer(minLength: UIScreen.main.bounds.height)
                        
                        ForEach(viewModel.messageList, id: \.messageId) { msg in
                            SingleMessageView(
                                isSender: msg.userId == UserCache.shared.getUserInfo()?.userId ?? 0,
                                avatar: beUserAvatar,
                                message: msg.content,
                                beUserId: msg.beUserId
                            )
                            .id(msg.messageId)
                        }
                        .onChange(of: viewModel.messageList, perform: { newValue in
                            withAnimation {
                                scrollView.scrollTo(viewModel.messageList.last?.messageId, anchor: .bottom)
                            }
                        })
                        
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(.bottom, 100)
            .padding(.top, 12)
        }
        .overlay(alignment: .bottom, content: {
            inputSendMessageView(viewModel: viewModel)
        })
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(beUserNickname, displayMode: .inline)
        .background(Color(red: 0.982, green: 0.982, blue: 0.997))
        .onAppear {
            viewModel.initAction(beUserId: beUserId)
            
            NotificationCenter.default.addObserver(forName: .receiveNewMessage, object: nil, queue: .main) { notification in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    viewModel.getMessageList(page: 1)
                })
            }
        }
        .adaptsToKeyboard()
        
    
        
    }
    
}


struct inputSendMessageView: View {
    @StateObject var viewModel: MessageDetailsViewModel

    var body: some View {
        
        ZStack(alignment: .trailing) {
            TextField("聊一聊～", text: $viewModel.msgContent)
                .submitLabel(.done)
                .onSubmit {
                    viewModel.sendMsg()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 40)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(.gray.opacity(0.4))
                .cornerRadius(10)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
            Image(!viewModel.msgContent.isEmpty ? "room_button_icon_send" : "room_button_icon_nosend")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(8)
                .padding(.horizontal, 4)
                .animation(.spring())
                .onTapGesture {
                    viewModel.sendMsg()
                }
        }
        .padding(.bottom, 40)
        
        
        
    }
    
    
}


struct SingleMessageView: View {
    let isSender: Bool
    let avatar: String
    let message: String
    let beUserId: Int
    @State private var isShowUserInfoFullCoverSheet: Bool = false
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 6)  {
            if !isSender {
                av
            } else {
                Spacer()
            }
            
            
            Text(message)
                .foregroundColor(.white)
                .frame(height: 35)
                .padding(.all, 4)
                .background(isSender ? .green.opacity(0.7) : .blue.opacity(0.7))
                .cornerRadius(10)
            
            if isSender {
                av
            } else {
                Spacer()
            }
            
        }
        .frame(height: 40)
    }
    
    
    var av: some View {
        KFImageView_Fill(imageUrl: isSender ? UserCache.shared.getUserInfo()?.avatar ?? "https://voicechat.oss-cn-shenzhen.aliyuncs.com/test_data/IMG_1295.PNG" : avatar)
            .frame(width: 40, height: 40)
            .cornerRadius(5)
            .showUserInfoFullCoverSheet(userId: isSender ? UserCache.shared.getUserInfo()?.userId ?? 0 : beUserId, isShowUserInfoFullCoverSheet: $isShowUserInfoFullCoverSheet)
    }
}




import Combine

struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight == 0 ? 0 : self.currentHeight - 300)
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            withAnimation(.easeOut(duration: 0.16)) {
                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                            }
                    }
                    .map { rect in
                        rect.height - geometry.safeAreaInsets.bottom
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { notification in
                            CGFloat.zero
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}

extension View {
    func adaptsToKeyboard() -> some View {
        return modifier(AdaptsToKeyboard())
    }
}

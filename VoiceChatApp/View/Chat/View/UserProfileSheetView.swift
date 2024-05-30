//
//  UserProfileSheetView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/11/10.
//


import SwiftUI

import Defaults
import Alamofire
import ProgressHUD
import UIKit




extension UserProfileSheetView {
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
    
    
    private func closeView() {
        isCloseUserProfileSheetView.toggle()
    }
    // 打开图片选择
    private func openImagePicker() {
        isImagePickerPresented.toggle()
    }
    // 打开用户编辑页面
    private func openEditPersonInfoView() {
        isEditPersonageInfo = true
    }
    
    // TODO: 打招呼
    func openChatView() {
        isOpenChat.toggle()
    }
    
    
    // 刷新数据
    private func refreshData() {
        ProgressHUD.animate("Loading...")
//        vm.getUserinfo(userId: userId) { msg in
//            ProgressHUD.dismiss()
//        }
    }
    
//    private func startTimer() {
//        if let images = vm.userinfo?.photos {
//            if !images.isEmpty {
//                timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
//                    currentIndex = (currentIndex + 1) % images.count
//                }
//            }
//        }
//    }
//    
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
}

struct UserProfileSheetView: View {
    @StateObject private var vm: UserInfoMain = UserInfoMain()
    @State var userId: Int
    @Binding var isCloseUserProfileSheetView: Bool
    
    @State private var selectItem: Bool = true // true = 关于Ta
    @State private var isEditPersonageInfo: Bool = false
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var currentIndex = 0
    @State private var timer: Timer? = nil
    
    @State private var isOpenChat: Bool = false
    

    var editPersonnelInfoOrSendMsg: some View {
        Button(action: {
            if userId == UserCache.shared.getUserInfo()?.userId {
                openEditPersonInfoView()
            } else {
                openChatView()
            }
        }, label: {
            HStack(alignment: .center, spacing: 0)  {
                Image(systemName: "ellipsis.bubble")
                Text(userId == UserCache.shared.getUserInfo()?.userId ? "编辑个人资料" : "打招呼")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
            .background(LinearGradient(colors: [Color(red: 0.993, green: 0.628, blue: 0.879), Color(red: 0.834, green: 0.474, blue: 0.997)], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(30)
            .shadow(radius: 3)
            .padding(.bottom, 32)
        })
    }
    
    var topView: some View {
        HStack(alignment: .center, spacing: 0)  {
            Image(systemName: "chevron.backward")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 38)
                .padding(.leading, 24)
                .onTapGesture {
                    closeView()
                    debugPrint("Back")
                }
            
            Spacer()
            
            Button(action: {
                if userId == UserCache.shared.getUserInfo()?.userId {
                    openEditPersonInfoView()
                } else {
                    if vm.userinfo?.isFollow == 1 {
                        UserRequest.cancelFollowedUser(cancelFollowedUserId: userId) { code in
                            withAnimation(.spring) {
                                vm.userinfo?.isFollow = 0
                            }
                        }
                    } else {
                        UserRequest.followUser(followedUserId: userId) { code in
                            withAnimation(.spring) {
                                vm.userinfo?.isFollow = 1
                            }
                        }
                    }
                }
            }, label: {
                if userId == UserCache.shared.getUserInfo()?.userId {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .padding(.top, 38)
                } else {
                    Text(vm.userinfo?.isFollow == 1 ? "已关注" : "关注")
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(30)
                        .padding(.top, 38)
                }

                
            })
            .padding(.trailing, 24)
            
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32)  {
                    Avatar_BG
                    Details
                    Spacer()
                }
            }
            .overlay(alignment: .bottom, content: {
                // 底部按钮
                editPersonnelInfoOrSendMsg
            })
            
//            if let backImg = vm.userinfo?.duckweed {
//                if !backImg.isEmpty && backImg != "" {
//                    SVGAPlayerView33(svgaSource: backImg, loop: 0)
//                        .scaledToFill()
//                        .scaleEffect(0.6)
//                        .frameall()
//                        .ignoresSafeArea()
//                        .offset(y: -200)
//                        .allowsHitTesting(false)
//                }
//            }
        }
        .overlay(alignment: .topLeading, content: {
            topView
        })
        .ignoresSafeArea()
        .background {
            NavigationLink(destination: EditPersonageInfo(avatar: vm.userinfo?.avatar ?? "", name: vm.userinfo?.nickname ?? "请重新登陆", gender: vm.userinfo?.sex == 1 ? "男" : "女", content: "", birthdate: Date()), isActive: $isEditPersonageInfo, label: {})
            
            NavigationLink(destination: MessageDetailsView(beUserId: vm.userId, beUserNickname: vm.userinfo?.nickname ?? "", beUserAvatar: vm.userinfo?.avatar ?? ""), isActive: $isOpenChat) {
                
            }
        }
        .onAppear {
            vm.initAction(userId: userId)
        }
        .onChange(of: selectedImage, perform: { newValue in
            
        })
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onDisappear {
            ProgressHUD.dismiss()
        }
        
    }
    
    
    
    
    
    var Avatar_BG: some View {
        ZStack(alignment: .bottomLeading) {
            if let headimgurl = vm.userinfo?.avatar,
               let id = vm.userinfo?.userId,
               let username = vm.userinfo?.nickname,
               let sex = vm.userinfo?.sex {
                
//                let imageURLs: [String] = vm.userinfo?.photos?.map { $0.photo } ?? []
//                if !imageURLs.isEmpty {
//                    TabView(selection: $currentIndex) {
//                        ForEach(0..<imageURLs.count, id: \.self) { index in
//                            //                                Image(images[index])
//                            //                                    .resizable()
//                            //                                    .scaledToFill()
//                            //                                    .tag(index)
//                            
//                            KFImage(URL(string: imageURLs[index]))
//                                .resizable()
//                                .loadDiskFileSynchronously()
//                                .cacheMemoryOnly()
//                                .scaledToFill()
//                                .edgesIgnoringSafeArea([.top, .leading, .trailing])
//                                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400)
//                                .blur(radius: 1)
//                                .cornerRadius(10)
//                                .overlay(content: {
//                                    Color.black.opacity(0.5)
//                                })
//                            
//                        }
//                    }
//                    .tabViewStyle(PageTabViewStyle())
//                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
//                    .onAppear {
//                        startTimer()
//                    }
//                    .onDisappear {
//                        stopTimer()
//                    }
//                } else {
//                    KFImage(URL(string: headimgurl))
//                        .resizable()
//                        .loadDiskFileSynchronously()
//                        .cacheMemoryOnly()
//                        .scaledToFill()
//                        .edgesIgnoringSafeArea([.top, .leading, .trailing])
//                        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400)
//                        .blur(radius: 1)
//                        .cornerRadius(10)
//                        .overlay(content: {
//                            Color.black.opacity(0.5)
//                        })
//                }
                
                
                KFImageView_Fill(imageUrl: headimgurl)
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400)
                    .blur(radius: 1)
                    .cornerRadius(10)
                    .overlay(content: {
                        Color.black.opacity(0.5)
                    })

                
                VStack(alignment: .leading, spacing: 10)  {
                    ZStack(alignment: .center) {
                        KFImageView_Fill(imageUrl: headimgurl)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .background {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 102, height: 102)
                            }
                            .padding(.vertical, 4)
                        if let avatarBorder = vm.userinfo?.avatar {
                            if !avatarBorder.isEmpty && avatarBorder != "https://www.msyuyin.cn/upload/wares/3400261520482f3e8e1fe16cace1d057.svga" {
                                SVGAPlayerView33(svgaSource: avatarBorder)
                                    .frame(width: 120, height: 120)
                            }
                        }
                        
                        
//                        UserInfoAvatarBorder(avatarBorder: avatarBorder, size: 100, plusSize: 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 6)  {
                        HStack(alignment: .center, spacing: 4)  {
                            Text(username)
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                            Image(sex == 0 ? "ic_chatroom_gender_gril" : "ic_chatroom_gender_boy")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                        
                        Text("ID: \(String(id))")
                            .foregroundColor(.white)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 6)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(8)
                    }
                    
                }
                .padding(12)
            }
            
            
        }
        .frame(height: UIScreen.main.bounds.height * 0.4)
        .overlay(alignment: .bottomTrailing) {
            if userId == UserCache.shared.getUserInfo()?.userId {
                Text("更换封面")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .cornerRadius(30) // 设置圆角半径
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1) // 设置边框颜色和宽度
                    )
                    .onTapGesture {
                        openImagePicker()
                    }
                    .padding([.bottom, .trailing], 12)
            }
        }
    }
    
    var Details: some View {
        VStack(alignment: .leading, spacing: 24)  {
            selectItemView
            if selectItem {
                // 关于Ta
                VStack(alignment: .leading, spacing: 24)  {
                    // 个人信息
                    VStack(alignment: .leading, spacing: 12)  {
                        Text("个人信息")
                            .font(.system(size: 18, weight: .bold))
                        HStack(alignment: .center, spacing: 4)  {
                            Text("年龄:")
                                .foregroundColor(.gray)
                            Text("\(Timer.calculateAge(birthDateString: vm.userinfo?.birthday ?? ""))岁")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .light))
                        }
                        HStack(alignment: .center, spacing: 4)  {
                            Text("认证:")
                                .foregroundColor(.gray)
                            Image(.homepageCloAutonym)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 18)
                        }
                    }
                    // 礼物墙
                    VStack(alignment: .leading, spacing: 12)  {
                        HStack(alignment: .center, spacing: 0)  {
//                            Text("礼物墙(\(vm.userinfo?.gifts?.count ?? 0))")
//                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            Button(action: {}, label: {
                                Text("查看更多>")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .regular))
                            })
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ], spacing: 20) {
//                            if let giftsArray = vm.userinfo?.gifts {
//                                ForEach(giftsArray, id: \.giftId) { item in
//                                    GiftItemView(img: item.img, name: item.giftName, num: item.sum)
//                                }
//                            }
                            
                        }
                        
                    }
                    .padding(.bottom, 48)
                }
                
            } else {
                // 动态
            }
        }
        .padding(12)
        
    }
    
    var selectItemView: some View {
        HStack(alignment: .center, spacing: 0)  {
            Text("关于Ta")
                .foregroundColor(!selectItem ? .gray : .black)
                .font(.system(size: !selectItem ? 15 : 18, weight: !selectItem ? .light : .bold))
                .onTapGesture {
                    withAnimation {
                        selectItem = true
                    }
                }
                .padding(.trailing, 7)
            Text("动态")
                .foregroundColor(selectItem ? .gray : .black)
                .font(.system(size: selectItem ? 15 : 18, weight: selectItem ? .light : .bold))
                .onTapGesture {
                    withAnimation {
                        selectItem = false
                    }
                }
                .padding(.horizontal, 7)
        }
        
    }
    
}

struct GiftItemView: View {
    @State var img: String
    @State var name: String
    @State var num: String
    var body: some View {
        VStack(alignment: .center, spacing: 6)  {
            KFImageView(imageUrl: img)
                .frame(width: 45, height: 45)
            
            VStack(alignment: .center, spacing: 3)  {
                Text("\(name)")
                Text("\(num)")
            }
            .foregroundColor(.black)
            .font(.system(size: 12))
        }
        .frame(width: UIScreen.main.bounds.width * 0.2, height: 100)
        .background(LinearGradient(colors: [Color(red: 0.94, green: 0.988, blue: 1.002), Color(red: 0.977, green: 0.945, blue: 0.99)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(radius: 2)
//        .foregroundColor(Color(red: 0.977, green: 0.945, blue: 0.99))
    }
}

//#Preview {
//    UserProfileSheetView()
//}

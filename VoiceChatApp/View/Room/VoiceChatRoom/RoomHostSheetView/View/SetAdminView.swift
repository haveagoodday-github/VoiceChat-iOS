//
//  SetAdminView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/11/17.
//

import SwiftUI
import ProgressHUD

import Defaults

struct SetAdminView: View {
    @StateObject var vm: UserInfoMain = UserInfoMain()
    @EnvironmentObject var vm_roomsettinmodel: RoomSettingModel
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            List {
                Section("管理员\(vm_roomsettinmodel.adminList.count)人") {
                    
                    ForEach(vm_roomsettinmodel.adminList, id: \.self) { admin in
                        item_SetAdminView(isHost: false, img: admin.headimgurl, name: admin.nickname, isAdmin: admin.is_admin == 1)
                    }
                    
                }
                
                Section("房间在线人数\(vm_roomsettinmodel.visitorList.count)人") {
                    ForEach(vm_roomsettinmodel.visitorList, id: \.self) { visitor in
                        item_SetAdminView(isHost: visitor.is_owner == 1, img: visitor.headimgurl, name: visitor.nickname)
                    }
                    
                }
            }
            
            
        }
        .navigationTitle("设置管理员")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(vm)
//        .onAppear {
//            vm_roomsettinmodel.getRoomPerson(roomId: 742) { msg in
//
//            }
//        }
    }
}

struct item_SetAdminView: View {
    let isHost: Bool
    let img: String
    let name: String
    var isAdmin: Bool = false
    let uid: Int = 1111239
    @State private var userProfileFullSheet: Bool = false
    @EnvironmentObject var vm: UserInfoMain
    
    var body: some View {
        Button(action: {
            ProgressHUD.animate("Loading...", interaction: true)
//            vm.getUserinfo(userId: uid) { msg in
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    withAnimation {
//                        userProfileFullSheet = true
//                    }
//                    ProgressHUD.dismiss()
//                }
//                
//            }
        }, label: {
            HStack(alignment: .center, spacing: 12)  {
                KFImageView(imageUrl: img)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                HStack(alignment: .center, spacing: 5)  {
                    if isHost || isAdmin {
                        Text(!isAdmin ? "房主" : "管理")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(!isAdmin ? Color.yellow : Color.blue)
                            .cornerRadius(3)
                    }
                    
                    Text(name)
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .bold))
                }
                
                Spacer()
                
                if !isHost {
                    Button(action: {
                        
                    }, label: {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 60, height: 30)
                            .overlay(content: {
                                Text("移除")
                                    .foregroundColor(.purple)
                                    .font(.system(size: 14, weight: .medium))
                            })
                            .border(Color.purple, width: 1)
                    })
                }
                
            }
        })
//        .modifier(ShowUserInfoFullCoverSheet(userId: uid, isShowUserInfoFullCoverSheet: $userProfileFullSheet))
        .showUserInfoFullCoverSheet(userId: uid, isShowUserInfoFullCoverSheet: $userProfileFullSheet)
        
    }
}

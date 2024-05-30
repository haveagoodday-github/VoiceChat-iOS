//
//  BottomCardView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/9.
//

import SwiftUI
import ProgressHUD
import Defaults

struct honorImgView: View {
    var img: String
    var body: some View {
        KFImageView_Fill(imageUrl: img)
            .frame(width: 26, height: 26)
    }
}

struct DataCard2: View {
    @StateObject var viewModelUserInfoMain: UserInfoMain
    @StateObject var viewModelRoomModel: RoomModel
    @Default(.room_user_data_card) var room_user_data_card
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            if let userInfo = viewModelUserInfoMain.userinfo {
                DataCard2Avatar(userInfo: userInfo)
            }
            HStack(alignment: .center, spacing: 8)  {
                UserName
                UserSex
            }
            HStack(alignment: .center, spacing: 8)  {
                UserID
                BeFollowNum
            }
            HStack(alignment: .center, spacing: 12)  {
                honorImgView(img: viewModelUserInfoMain.userinfo?.starsImg ?? "")
                honorImgView(img: viewModelUserInfoMain.userinfo?.goldImg ?? "")
            }
            
            
            
            if UserCache.shared.getUserInfo()?.userId == viewModelUserInfoMain.userinfo?.userId ?? 0 {
                Button(action: {
//                        if let roomId = vm_room.roomInfoRoomData?.id, let roomAdminID = vm_room.roomInfoRoomData?.uid{
//                            vm_room_control.downMic(roomId: roomId, roomAdminID: roomAdminID, userid: UserCache.shared.getUserInfo()?.userId) { msg in
//                                print(msg)
//                                ProgressHUD.succeed("下麦成功", delay: 1.0)
//                                vm_room.refreshMicrophoneList(roomId: roomId, uid: roomAdminID)
//                                send_message_code()
//                            }
//                        }
                    
                    
                    viewModelRoomModel.downMic(userId: viewModelRoomModel.currentShowUserInfoCardUserId)
                    viewModelRoomModel.isShowUserInfoCard = false
                    linphone.offMic()
                }, label: {
                    Text("下麦旁听")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.vertical, 8)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(30)
                })
            } else {
                Spacer()
            }
            
            Divider().padding(.vertical, 4)
            HStack(alignment: .center, spacing: 0)  {
                BottomButtonView(text: "@Ta", textColor: .black) {}
                Spacer()
                BottomButtonView(text: viewModelUserInfoMain.userinfo?.isFollow == 1 ? "已关注" : "关注", textColor: .black) {
                    if viewModelUserInfoMain.userinfo?.isFollow == 1 {
                        UserRequest.cancelFollowedUser(cancelFollowedUserId: viewModelUserInfoMain.userinfo?.userId ?? 0) { code in
                            viewModelUserInfoMain.userinfo?.isFollow = 0
                        }
                        // 取消关注
                    } else {
                        // 关注
                        UserRequest.followUser(followedUserId: viewModelUserInfoMain.userinfo?.userId ?? 0) { code in
                            viewModelUserInfoMain.userinfo?.isFollow = 1
                        }
                    }
                }
                Spacer()
                BottomButtonView(text: "私信", textColor: .black) {}
                Spacer()
                BottomButtonView(text: "送礼", textColor: .purple) {
//                    Defaults[.room_gift_card] = true
//                    room_user_data_card = false
                }
            }
            .padding(.horizontal, 4)
//            Button
//            DataCard2Buttom
//                .padding(.top, 12)
        }
//        .overlay(alignment: .topLeading, content: {
//            topLeadingContent()
//        })
//        .overlay(alignment: .topTrailing, content: {
//            topTrailingContent()
//        })
        
    }
    
//    func getUserinfo() {
//        vm.getUserinfo(userId: userid) { msg in
//            isFollow = vm.userinfo?.userInfo.isFollow == 0
//        }
//    }
    
    var UserName: some View {
        Text(viewModelUserInfoMain.userinfo?.nickname ?? "")
            .font(.system(size: 18, weight: .bold))
    }
    var UserSex: some View {
        Image(viewModelUserInfoMain.userinfo?.sex == 1 ? "ic_chatroom_gender_boy" : "ic_chatroom_gender_gril")
            .resizable()
            .frame(width: 18, height: 18)
    }
    var UserID: some View {
        Text("ID: \(String(viewModelUserInfoMain.userinfo?.userId ?? 0))")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.gray)
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .overlay() {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 1.0)
                    .fill(Color.gray)
            }
    }
    var BeFollowNum: some View {
        Text("粉丝 \(viewModelUserInfoMain.userinfo?.fansNum ?? 0)")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.gray)
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .overlay() {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 1.0)
                    .fill(Color.gray)
            }
    }
//    var Button: some View {
//        HStack(alignment: .center, spacing: 16)  {
//            DataCard2Button(icon: "person.fill.badge.plus", name: "加好友", color: Color(red: 0.513, green: 0.376, blue: 0.979)) {
//                
//            }
//            DataCard2Button(icon: "gift.fill", name: "送礼物", color: Color(red: 1.001, green: 0.329, blue: 0.547)) {
//                
//            }
//        }
//    }
    var DataCard2Buttom: some View {
        HStack(alignment: .center, spacing: 0)  {
            Spacer()
            DataCard2ButtomItem(content: "静麦") {
                print("静麦")
            }
//            Spacer()
            DataCard2ButtomItem(content: "旁听") {
                print("旁听")
            }
//            Spacer()
            DataCard2ButtomItem(content: "封麦") {
                print("封麦")
            }
//            Spacer()
            DataCard2ButtomItem(content: "踢出") {
                print("踢出")
            }
//            Spacer()
            DataCard2ButtomItem(content: "开音乐") {
                print("开音乐")
            }
            Spacer()
        }
    }

    
}

struct BottomButtonView: View {
    var text: String
    let textColor: Color
    let action: () -> ()
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text("\(text)")
                .foregroundColor(textColor)
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 18)
        })
    }
}

struct topLeadingContent: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16)  {
            Text("举报")
                .onTapGesture {
                    
                }
            Text("@TA")
                .onTapGesture {
                    
                }
        }
        .foregroundColor(.gray)
        .font(.system(size: 17, weight: .bold))
        .padding(.leading, 4)
    }
}


struct topTrailingContent: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Image(.magicStick)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .scaleEffect(x: -1, y: 1)
        })
    }
}


struct DataCard2Avatar: View {
    var userInfo: UserInfo
//    let avatar: String
//    @State var avatarBorder: String
//    @State var isFollow: Bool = false
//    let userId: Int
    let size: CGFloat = 90
    @State private var userProfileFullSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            KFImageView_Fill(imageUrl: userInfo.avatar)
                .frame(width: 90, height: 90)
                .clipShape(Circle())
            
//            UserInfoAvatarBorder(avatarBorder: avatarBorder, size: size)
            if let avatarBox = userInfo.avatarBox {
                SVGAPlayerView33(svgaSource: avatarBox)
                    .frame(width: size + 20, height: size + 20)
            }
        }
        .onTapGesture {
            withAnimation {
                userProfileFullSheet = true
            }
        }
//        .modifier(ShowUserInfoFullCoverSheet(userId: Int(userId), isShowUserInfoFullCoverSheet: $userProfileFullSheet))
        .showUserInfoFullCoverSheet(userId: userInfo.userId, isShowUserInfoFullCoverSheet: $userProfileFullSheet)
        
        
//        ZStack(alignment: .bottom) {
//            KFImage(URL(string: avatar))
//                .loadDiskFileSynchronously()
//                .cacheMemoryOnly()
//                .resizable()
//                .placeholder {
//                    ProgressView()
//                }
//                .scaledToFit()
//                .frame(width: 90, height: 90)
//                .clipShape(Circle())
            
//            Button(action: {
//                withAnimation {
//                    isFollow.toggle()
//                }
//            }, label: {
//                Text(isFollow ? "已关注" : "+关注")
//                    .font(.system(size: 16, weight: .heavy))
//                    .foregroundColor(Color(red: 0.459, green: 0.362, blue: 0.817))
//                    .padding(.vertical, 4)
//                    .padding(.horizontal, 14)
//                    .background(Color(red: 0.97, green: 0.922, blue: 1.001))
//                    .cornerRadius(30)
//                    .padding(.top, 12)
//                    .animation(.spring())
//            })
//        }
    }
}


struct DataCard2Button: View {
    let icon: String
    let name: String
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(alignment: .center, spacing: 8)  {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(name)
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(color)
            .cornerRadius(30)
        })
    }
}




struct DataCard2ButtomItem: View {
    let content: String
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(content)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.gray)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
        })
    }
}


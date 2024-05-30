//
//  NestView2.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/8/30.
//

import SwiftUI
import AVFoundation
import ProgressHUD
import Defaults
import SDWebImageSwiftUI
import SwiftyJSON



struct NestView2: View {
    @ObservedObject var linphone : IncomingCallTutorialContext
    @StateObject var viewModel = RoomModel()
    @StateObject var vmForUserInfoMain: UserInfoMain = UserInfoMain()
    @StateObject var vmRoomSettingModel: RoomSettingModel = RoomSettingModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State var ChatType: Bool = true // 为真则是“房间”，反之则是“世界”
    @State private var keyboardHeight: CGFloat = 0.0
    @State private var timer: Timer? = nil
    
    @State var roomId: Int
    @State var roomUid: Int
    @State var showUsername = true
    
    
    let backColor: Color = Color(red: 0.138, green: 0.133, blue: 0.215)
    
    @State var roomPass: String
    @State var userId: Int = 0
    @State var is_default: Int = 0
    
    
    @Default(.room_message_card) var room_message_card
    @Default(.room_smiley_card) var room_smiley_card
    @Default(.room_gift_list) var room_gift_list
    @Default(.room_setting_full_sheet) var room_setting_full_sheet
    @Default(.room_show_gift_animation_img ) var room_show_gift_animation_img
    @Default(.room_show_gift_animation_svga ) var room_show_gift_animation_svga
    @Default(.room_xdz) var room_xdz
    @Default(.game_url) var game_url
    
    // 底部按钮
    //    @State var text: String = ""
    let audioSession = AVAudioSession.sharedInstance()
    let iconSize: CGFloat = 35
    @Default(.room_send_message_keyboard_status) var room_send_message_keyboard_status
    
    @State private var isShowFloatBall: Bool = false
    @Binding var isGotoRoom: Bool
    
    @State var isfollow: Bool = false
    @Default(.go_to_room) var go_to_room
    @State private var isShowingSafari: Bool = false
    @State private var isShowTabBar: Bool = true
    @State private var timeRemaining: String = ""
    var body: some View {
        ZStack(alignment: .top) {
            nestView2
                .scaleEffect(!isShowFloatBall ? 1 : 0)
                .offset(x: !isShowFloatBall ? 0 : UIScreen.main.bounds.width, y: !isShowFloatBall ? 0 : UIScreen.main.bounds.height * 0.8)
            
            
            FloatBallView(floatValue: floatModel(
                headimgurl: viewModel.roomInfo?.roomCover ?? "",
                roomName: viewModel.roomInfo?.roomName ?? "",
                roomId: roomId,
                status: true)) {
                    withAnimation(.spring) {
                        isShowFloatBall = false
                    }
                } closeAction: {
                    exitRoom()
                }
                .scaleEffect(isShowFloatBall ? 1 : 0)
                .opacity(isShowFloatBall ? 1 : 0)
        }
        .onChange(of: go_to_room) { newValue in
            if go_to_room.roomId == 0 {
                exitRoom()
            }
        }
        .onChange(of: Defaults[.sceneDidDisconnect]) { newValue in
            if Defaults[.sceneDidDisconnect] {
                exitRoom()
                print("退出APP，退出房间")
            }
        }
        .onAppear {
            viewModel.joinRoom(roomId: roomId)
            Socket.shared.write(with: "{'uid':'\(String(roomId))'}")
            print("进入房间")
        }
        
    }
    
    private func exitRoom() {
        viewModel.closeRoom()
        isGotoRoom = false
        presentationMode.wrappedValue.dismiss()
        linphone.terminateCall()
    }
    
    var nestView2: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                // MARK: 背景图片
                NestBackgroundView(viewModel: viewModel)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                VStack(alignment: .leading, spacing: 12)  {
                    HStack(alignment: .center, spacing: 0)  {
                        Button(action: {
                            // TODO: Test Float Ball
                            //                            presentationMode.wrappedValue.dismiss()
                            withAnimation(.spring) {
                                isShowFloatBall = true
                            }
                            
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        })
                        
                        NestPersonelInfoView
                    }
                    
                    HStack(alignment: .center, spacing: 0)  {
                        AnnouncementView
                        Spacer()
                        OnlineNumberView
                    }
                    
                    // MARK: 麦序列表
                    ClientListView
                    
                    // MARK: 礼物标签
                    //                    GiftLabelView(viewModel: viewModel)
                    
                    
                    // MARK: 房间聊天分类
                    ChatLimitationSingleSelectionView(viewModel: viewModel)
                    
                    // MARK: 房间聊天内容
                    MessagesList(viewModel: viewModel)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 8)
                
            }
        }
        .environmentObject(viewModel)
        .environmentObject(vmForUserInfoMain)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                withAnimation {
                    viewModel.isShowCloseRoom = true
                }
                
            }, label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical)
            })
        }
        // MARK: 点击公告
        .overlay(alignment: .center) {
            if viewModel.isShowRoomIntro {
                showAnnouncement
            }
        }
        // MARK: 礼物特效显示
        //        .overlay(alignment: .center, content: {
        //            ZStack(alignment: .center) {
        //                if room_show_gift_animation_svga {
        //                    if !viewModel.Gift_svga.isEmpty {
        //                        SVGAPlayerView33(svgaSource: viewModel.Gift_svga, loop: 1)
        //                            .scaledToFill()
        //                            .scaleEffect(0.6)
        //                            .frameall()
        //                            .ignoresSafeArea()
        //                            .offset(y: -200)
        //                            .allowsHitTesting(false)
        //                    }
        //                }
        //
        //
        //
        //            }
        //            .frameall()
        //            .ignoresSafeArea()
        //            // 显示图片礼物
        //            .nestGiftImageAnimation(imageUrl: $viewModel.Gift_img, isActionAniamtion: $room_show_gift_animation_img)
        //        })
        // MARK: 发送消息 / 底部按钮
        .overlay(alignment: .bottom, content: {
            NestBottomButtonView
        })
        // MARK: - 卡片显示
        .overlay {
            // 礼物卡片
            //            HalfModelView(isShown: $room_gift_card, backgroundColor: Color(red: 0.08, green: 0.09, blue: 0.141), modelHeight: 420) {
            //                GiftCard(roomId: roomId)
            //                    .environmentObject(viewModel)
            //            }
            
            
            // 房间设置卡片
            HalfModelView(isShown: $viewModel.isShowRoomSettingCard, backgroundColor: backColor, modelHeight: viewModel.isHost() ? 530 : 310, modelHeightSubtract: 0) {
                // 非房主不显示 房间设置
                RoomSettingCard(roomId: roomId, vm: vmRoomSettingModel, viewModel: viewModel, isShowingSafari: $isShowingSafari)
                    .environmentObject(vmRoomSettingModel)
            }
            
            // 用户信息卡片
            HalfModelView(isShown: $viewModel.isShowUserInfoCard, modelHeight: viewModel.currentShowUserInfoCardUserId == UserCache.shared.getUserInfo()?.userId ? 400 : 330, modelHeightSubtract: 60) {
                DataCard2(viewModelUserInfoMain: vmForUserInfoMain,
                          viewModelRoomModel: viewModel, linphone: linphone)
            }
            
            
            // 表情卡片
            HalfModelView(isShown: $room_smiley_card, backgroundColor: Color(red: 0.08, green: 0.09, blue: 0.141), modelHeight: 340, modelHeightSubtract: 60) {
                SmileyCard(viewModel: viewModel)
            }
            
            
            // 房间礼物历史记录列表卡片
            //            HalfModelView(isShown: $room_gift_list, backgroundColor: Color(red: 0.08, green: 0.09, blue: 0.141), modelHeight: UIScreen.main.bounds.height * 0.7, modelHeightSubtract: 0) {
            //                GiftListViewSheet(room_name: viewModel.roomInfoRoomData?.room_name ?? "", roomId: roomId, room_gift_list: room_gift_list)
            //                    .environmentObject(viewModel)
            //                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
            //                    .padding(.horizontal, 8)
            //                    .edgesIgnoringSafeArea(.bottom)
            //            }
            
            // 消息卡片
            HalfModelView(isShown: $room_message_card, backgroundColor: Color.white, modelHeight: UIScreen.main.bounds.height * 0.7, modelHeightSubtract: 0) {
                MessagesListView()
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }
            
            
        }
        .overlay(alignment: .top, content: {
            if viewModel.isShowCloseRoom {
                ZStack(alignment: .top) {
                    LinearGradient(colors: [Color.black, Color.clear], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.isShowCloseRoom = false
                        }
                    
                    HStack(alignment: .center, spacing: 0)  {
                        VStack(alignment: .center, spacing: 6)  {
                            Image(.roomGrengduoShouqifangjianXhdpi)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                            Text("收起房间")
                                .font(.system(size: 16))
                        }
                        .onTapGesture {
                            withAnimation(.spring) {
                                viewModel.isShowCloseRoom = false
                                viewModel.isShowFloatBall = true
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 6)  {
                            Image(.roomGengduoTuichufangjianXhdpi)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                            Text("关闭房间")
                                .font(.system(size: 16))
                        }
                        .onTapGesture {
                            viewModel.isShowCloseRoom = false
                            viewModel.closeRoom()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    .padding(.top, 64)
                }
                .frameall()
                .ignoresSafeArea()
            }
        })
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $viewModel.isShowHistoryUserList, content: {
            showOnlineUserListSheetView(viewModel: viewModel)
        })
        .sheet(isPresented: $room_setting_full_sheet, content: {
            RoomSettingView(viewModelRoom: viewModel)
        })
        .onChange(of: showUsername) {  newValue in
            LocalSendMessage()
        }
        //        .showGameWeb(urlString: "\(game_url)/?token=\(convertToBase64(UserCache.shared.getUserInfo()?.token ?? ""))", isClose: $isShowingSafari)
    }
    
    
    private func LocalSendMessage() {
        //        if let wel = viewModel.roomInfo?.welcome, let intro = viewModel.roomInfo?.intro {
        //            self.agoraRTMManager.messages.append(contentsOf: [
        //                .init(message: AgoraRtmMessage(text: "系统公告🎉\(wel)"), id: UUID().uuidString, sender: "nil"),
        //                .init(message: AgoraRtmMessage(text: "玩法介绍🎉\(intro)"), id: UUID().uuidString, sender: "nil")
        //            ])
        //        }
    }
    
    // 显示公告
    var showAnnouncement: some View {
        ZStack(alignment: .center) {
            Button(action: {
                withAnimation {
                    viewModel.isShowRoomIntro.toggle()
                }
            }, label: {
                Color.clear.ignoresSafeArea()
            })
            
            VStack(alignment: .leading, spacing: 0)  {
                HStack(alignment: .center, spacing: 0)  {
                    Spacer()
                    Text("公告")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
                .padding(.vertical, 12)
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: UIScreen.main.bounds.width * 0.77, height: 1)
                ScrollView {
                    Text("\(viewModel.roomInfo?.intro ?? "")")
                        .lineSpacing(8)
                        .font(.system(size: 16))
                        .padding(22)
                }
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: UIScreen.main.bounds.height * 0.5)
            .foregroundColor(.white)
            .background(Color(red: 0.099, green: 0.097, blue: 0.141))
            .cornerRadius(10)
            
            
        }
        .animation(.easeInOut)
        //                .transition(.opacity)
    }
    
    
}


// MARK: 背景
struct NestBackgroundView: View {
    @StateObject var viewModel: RoomModel
    //    @EnvironmentObject var viewModel: RoomModel
    var body: some View {
        
        if let back_img = viewModel.roomInfo?.roomBackground {
            if back_img.contains(".svga") {
                SVGAPlayerView33(svgaSource: back_img)
                    .scaledToFit()
                    .frameall()
                    .scaleEffect(1.2)
                    .offset(y: -200) // 210
                    .edgesIgnoringSafeArea(.all)
            } else {
                KFImageView_Fill(imageUrl: back_img)
                    .frameall()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        
    }
}

// MARK: 个人信息
extension NestView2 {
    var NestPersonelInfoView: some View {
        HStack(alignment: .center, spacing: 8)  {
            ZStack(alignment: .center) {
                KFImageView(imageUrl: viewModel.roomInfo?.roomCover ?? "")
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 7)  {
                Text("\(viewModel.roomInfo?.roomName ?? "")")
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
                Text("ID：\(String(viewModel.roomInfo?.roomId ?? 0))")
                    .foregroundColor(.black.opacity(0.5))
                    .font(.system(size: 8, weight: .bold))
            }
            
            
            //            Spacer()
            //            ZStack(alignment: .center) {
            //                RoundedRectangle(cornerRadius: 30)
            //                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.849, green: 0.409, blue: 0.801), Color(red: 0.56, green: 0.333, blue: 0.896)]), startPoint: .leading, endPoint: .trailing))
            //                    .frame(width: 60, height: 28)
            //                Button(action: {
            //                    // TODO: 收藏房间 操作
            //                }, label: {
            //                    HStack(alignment: .center, spacing: 4)  {
            //                        Image(systemName: "plus")
            //                            .font(.system(size: 14, weight: .bold))
            //                        Text(viewModel.roomInfo.isCollect ? "已收藏" : "收藏")
            //                            .font(.system(size: 14, weight: .bold))
            //                    }
            //                    .foregroundColor(.white)
            //                })
            //            }
        }
        .frame(height: 35)
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(Color.white.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        
    }
}


extension NestView2 {
    // MARK: 玩法/公告
    var AnnouncementView: some View {
        Image(.roomGonggao)
            .resizable()
            .scaledToFit()
            .frame(width: 60)
            .onTapGesture {
                viewModel.isShowRoomIntro.toggle()
            }
    }
    
    // MARK: 在线人数
    var OnlineNumberView: some View {
        HStack(alignment: .center, spacing: 0)  {
            Image(.roomZhuyemianZaixianrenshuicXhdpi)
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
            Text("在线\(String(viewModel.roomInfo?.onlineNum ?? 0))")
                .foregroundColor(.yellow.opacity(0.7))
        }
        .foregroundColor(.white)
        .font(.system(size: 14, weight: .regular))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.5))
        .cornerRadius(30)
        .onTapGesture {
            viewModel.getRoomHistoryUser(state: -1)
            viewModel.isShowHistoryUserList.toggle()
        }
    }
}


// MARK: - 麦位ITEM
struct ClientOfflineView: View {
    @StateObject var viewModel: RoomModel
    @StateObject var vm: UserInfoMain
    var mic: MicrophoneModel
    //    @State var avatarBorder: String = ""
    var position: Int
    
    @State var isGotoHoldingView: Bool = false // 抱人
    
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    let onLongPressGesture: () -> Void
    let size: CGFloat = 60
    
    @Default(.room_xdz) var room_xdz
    

    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            switch mic.state {
            case 1: // 显示用户
                ZStack(alignment: .center) {
                    KFImageView_Fill(imageUrl: mic.avatar ?? "")
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                    
                    if let avatarBox = mic.avatarBox {
                        SVGAPlayerView33(svgaSource: avatarBox)
                            .frame(width: size + 20, height: size + 20)
                    } else {
                        Circle()
                            .frame(width: size + 20, height: size + 20)
                            .hidden()
                    }
                    
                }
                // 静麦显示
                //                .overlay(alignment: .bottomTrailing, content: {
                //                    if viewModel.is_sound == 2 {
                //                        Image(systemName: "mic.slash.fill")
                //                            .font(.system(size: 12))
                //                            .foregroundColor(.white)
                //                            .padding(3)
                //                            .background(Color.red)
                //                            .clipShape(Circle())
                //
                //                    }
                //                })
                
                
                
            default:
                ZStack(alignment: .center) {
                    Image(mic.state == 2 ? "new_ic_chatroom_seat_lockup" : "new_ic_chatroom_seat_empty")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                    //                        .opacity(0.8)
                    
                    Circle()
                        .frame(width: size + 20, height: size + 20)
                        .opacity(0)
                }
                
                
            }
            
            HStack(alignment: .center, spacing: 5)  {
                Image(.roomXin)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                
                Text("\(String(mic.xdzNum ?? 0))") // 心动值
                    .foregroundColor(.white)
                    .font(.system(size: 10, weight: .medium))
                    .lineLimit(1)
                    .frame(width: 30)
                Spacer()
            }
            .frame(width: 50, height: 14)
            .padding(.horizontal, 3)
            .background(Color.white.opacity(0.3))
            .cornerRadius(30)
            .opacity(room_xdz ? mic.state == 1 ? 1 : 0 : 0) // state = 1 有人
            .padding(.bottom, 2)
            
            Text("\(mic.state == 1 ? mic.nickname ?? "" : position == 0 ? "主持位" : "\(position+1)号麦")")
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .bold))
        }
        .onTapGesture {
            onClick()
        }
        .sheet(isPresented: $isGotoHoldingView, content: {
            HoldingUpMicView(roomId: viewModel.roomInfo?.roomId ?? 0, phase: position+1)
        })
        .if(viewModel.isHost()) { content in
            content.modifier(HostFeatureViewModifier(viewModel: viewModel, mic: mic, isGotoHoldingView: $isGotoHoldingView, roomId: viewModel.roomInfo?.roomId ?? 0, position: position))
        }
        
    }
    
    
    func onClick() {
        switch mic.state {
        case 0: // 上麦
            viewModel.upMic(userId: UserCache.shared.getUserInfo()?.userId ?? 0, position: mic.position)
            linphone.outgoingCall(userId: UserCache.shared.getUserInfo()!.userId == 19 ? 18 : 19)
//            linphone.outgoingCall(userId: UserCache.shared.getUserInfo()?.userId ?? 0)
        case 1: // 显示 用户信息Sheet
            vm.initAction(userId: mic.userId)
            viewModel.currentShowUserInfoCardUserId = mic.userId
            viewModel.isShowUserInfoCard.toggle()
        case 3: // 锁麦
            ProgressHUD.error("已锁麦，无法上麦", delay: 1.5)
        default:
            print("Default")
        }
    }
    
    
}






// MARK: 麦位列表
extension NestView2 {
    var ClientListView: some View {
        VStack(alignment: .center, spacing: 8)  {
            // MARK: 房主麦
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                ForEach(viewModel.microphoneList, id: \.position) { item in
                    if item.position == 0 {
                        ClientOfflineView(viewModel: viewModel, vm: vmForUserInfoMain, mic: item, position: 0, linphone: linphone, onLongPressGesture: {
                            
                        })
                    }
                }
                
                Spacer()
            }
            
            
            
            
            LazyVGrid(
                columns: Array(repeating:
                                GridItem(.flexible()),
                               count: 4
                              ),
                spacing: 5
            ) {
                ForEach(viewModel.microphoneList, id: \.position) { item in
                    if item.position != 0 {
                        ZStack(alignment: .center) {
                            // 有人
                            ClientOfflineView(viewModel: viewModel, vm: vmForUserInfoMain, mic: item, position: item.position, linphone: linphone, onLongPressGesture: {
                                
                            })
                        }
                    }
                    
                }
            }
            
            
        }
        .frame(minHeight: UIScreen.main.bounds.height * 0.35, alignment: .bottom)
    }
    
    
    //    private func send_message_code(code: Int = 34) {
    //        let send_message = """
    //        {"MicPos":-1,"adminMenuEvent":null,"boxGift":null,"fromUser":null,"gift":null,"master_micPlaceInfo":null,"message":null,"messageType":\(code),"micList":null}
    //        """
    //        Task {
    //            await agoraRTMManager.sendMessage(send_message)
    //        }
    //    }
    
    
}

// MARK: 房间｜世界
struct ChatLimitationSingleSelectionView: View {
    @StateObject var viewModel: RoomModel
    var body: some View {
        HStack(alignment: .center, spacing: 4)  {
            
            Button(action: {
                viewModel.roomMessageType = .room
                print(viewModel.roomMessageType)
                print(viewModel.roomMessageType == .room)
            }, label: {
                Text("房间")
                    .messageTypeFormatting(isSelected: viewModel.roomMessageType == .room)
            })
            
            
            Button(action: {
                viewModel.roomMessageType = .tale
                print(viewModel.roomMessageType)
                print(viewModel.roomMessageType == .tale)
            }, label: {
                Text("传说")
                    .messageTypeFormatting(isSelected: viewModel.roomMessageType == .tale)
            })
            
            
            Button(action: {
                viewModel.roomMessageType = .broadcast
                print(viewModel.roomMessageType)
                print(viewModel.roomMessageType == .broadcast)
            }, label: {
                Text("广播")
                    .messageTypeFormatting(isSelected: viewModel.roomMessageType == .broadcast)
            })
        }
        
    }
}







// MARK: 聊天气泡
struct NestChatBoxView: View {
    let messages: String
    var body: some View {
        Text(messages)
            .font(.caption)
            .foregroundColor(Color(red: 0.817, green: 0.952, blue: 0.394))
            .padding(.all, 5)
            .background(Color.white.opacity(0.3))
            .cornerRadius(10)
            .multilineTextAlignment(.leading)
    }
}

enum ipt {
    case fangjian
    case chuanshuo
    case guangbo
}
// MARK: - 底部按钮
extension NestView2 {
    var NestBottomButtonView: some View {
        HStack(spacing: 5)  {
            
            ZStack(alignment: .center) {
                // MARK: 输入框
                TextField("", text: $viewModel.text)
                    .submitLabel(.send)
                    .onSubmit {
                        viewModel.sendMsg()
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
                    .frame(width: room_send_message_keyboard_status ? UIScreen.main.bounds.width * 0.85 : 100, height: iconSize)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(30)
                    .padding(.bottom, room_send_message_keyboard_status ? 12 : 0)
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                               object: nil, queue: .main) { _ in
                            withAnimation {
                                room_send_message_keyboard_status = true
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                               object: nil, queue: .main) { _ in
                            withAnimation {
                                room_send_message_keyboard_status = false
                            }
                        }
                    }
                    .opacity(room_send_message_keyboard_status ? 1 : 0.1)
                
                Image(.roomLiaotian)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: iconSize)
                    .allowsHitTesting(false)
                    .opacity(room_send_message_keyboard_status ? 0 : 1)
                
            }
            
            
            
            
            if !room_send_message_keyboard_status {
                leadingButtonView
                Spacer()
                trailingButtonView
            } else {
                // MARK: 发送按钮
                
                Image(!viewModel.text.isEmpty ? "room_button_icon_send" : "room_button_icon_nosend")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .animation(.spring())
                    .onTapGesture {
                        viewModel.sendMsg()
                    }
                    .padding(.bottom, room_send_message_keyboard_status ? 12 : 0)
            }
            
            
        }
        .padding(.horizontal, 8)
    }
    
    var leadingButtonView: some View {
        HStack(alignment: .center, spacing: 3)  {
            // MARK: 表情按钮
            Button(action: {
                room_smiley_card.toggle()
            }, label: {
                Image(.roomZhuyemianMaiweibiaoqingicXhdpi)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                
            })
            
            // MARK: 房间设置按钮
            Button(action: {
                viewModel.isShowRoomSettingCard.toggle()
            }, label: {
                Image(.roomZhuyemianFangjiancaozuoicXhdpi)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                
            })
            
            // MARK: 消息按钮
            Button(action: {
                room_message_card.toggle()
            }) {
                Image(.roomZhuyemianYonghuxiaoxiicXhdpi)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
            }
        }
    }
    var trailingButtonView: some View {
        HStack(alignment: .center, spacing: 5)  {
            if viewModel.isShowMicrophoneIcon {
                // MARK: 麦克风按钮
                Button(action: {
                    if viewModel.isBanSpeak() {
                        ProgressHUD.error("您已被静麦，不可打开麦克风！", delay: 1)
                    } else {
                        withAnimation {
                            viewModel.isOpenMicrophone.toggle()
//                            linphone.muteMicrophone() // 切换麦克风状态
                            linphone.onMic()
                        }
                    }
                }, label: {
                    ZStack {
                        Group {
                            image(Image(.roomZhuyemianKaimaiXhdpi), show: viewModel.isOpenMicrophone)
                            image(Image(.roomZhuyemianBimaiXhdpi), show: !viewModel.isOpenMicrophone)
                        }
                        .background(Color.white.opacity(0.3))
                        .clipShape(Circle())
                        
                    }
                })
            }
            
            // MARK: 扬声器按钮
            Button(action: {
                withAnimation {
                    viewModel.isOpenSound.toggle()
                    linphone.toggleSpeaker() // 切换免提
                }
            }, label: {
                ZStack {
                    Group {
                        image(Image(.roomDakaijingyin), show: viewModel.isOpenSound)
                        image(Image(.roomGuanbijingyin), show: !viewModel.isOpenSound)
                        
                    }
                    .background(Color.white.opacity(0.3))
                    .clipShape(Circle())
                }
            })
            
            // MARK: 礼物按钮
            Image(.newBtnChatroomGift)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .onTapGesture {
                    viewModel.isShowRoomGiftCard.toggle()
                }
        }
    }
    
    
    func image(_ image: Image, show: Bool) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
        
    }
    
    
    func toggleMicrophone() {
        do {
            if viewModel.isOpenSound {
                try audioSession.setActive(false)
            } else {
                try audioSession.setCategory(.playAndRecord, mode: .default)
                try audioSession.setActive(true)
            }
            viewModel.isOpenSound.toggle()
        } catch {
            print("Error toggling microphone: \(error.localizedDescription)")
        }
    }
}





struct showOnlineUserListSheetView: View {
    let headimgSize: CGFloat = 50
    @StateObject var viewModel: RoomModel
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            Text("房间在线用户")
                .font(.system(size: 18, weight: .bold))
                .padding()
            List(viewModel.roomHistoryUserList, id: \.userId) { user in
                HStack(alignment: .center, spacing: 12)  {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .overlay(content: {
                            KFImageView_Fill(imageUrl: user.avatar)
                                .frame(width: headimgSize, height: headimgSize)
                                .clipShape(Circle())
                        })
                        .frame(width: headimgSize, height: headimgSize)
                    Text("\(user.nickname)")
                }
            }
            .listStyle(.inset)
        }
    }
}


struct MessageUserInfo_MessageModel: Decodable {
    let userId: String
    let message: String
    
    let nickName: String
    let avatar: String
    let goldImg: String
    let star_img: String
    
}



struct MessagesList: View {
    @StateObject var viewModel: RoomModel
    @StateObject var vm: UserInfoMain = UserInfoMain()
    let textSize: CGFloat = 14
    
    var body: some View {
        switch(viewModel.roomMessageType) {
        case .tale:
            for_room.opacity(0)
        case .broadcast:
            for_room.opacity(0)
        default:
            for_room
        }
    }
    
    
    
    var for_room: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                VStack(alignment: .center, spacing: 12)  {
                    ForEach(viewModel.publicScreenContent, id: \.id) { msg in
                        switch msg.type {
                        case 5: // 进入房间 消息
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center, spacing: 0)  {
                                        KFImageView(imageUrl: msg.starsImg)
                                            .frame(width: 25, height: 25)
                                        
                                        Text(msg.nickname)
                                            .foregroundColor(.gray)
                                            .font(.system(size: textSize, weight: .medium))
                                            .padding(.horizontal, 4)
                                        
                                        Text("进入房间")
                                            .foregroundColor(.white)
                                            .font(.system(size: textSize, weight: .medium))
                                            .padding(.horizontal, 4)
                                        
                                        Button(action: {
                                            viewModel.sendWelcomeMessage(msg.nickname)
                                        }, label: {
                                            Image(.roomHuanyingIcon)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 55, height: 20)
                                        })
                                        .padding(.leading, 8)
                                        
                                    }
                                }
                                Spacer()
                            }
                            .id(msg.id)
                            
                        case 0: //普通文字消息
                            HStack {
                                VStack(alignment: .leading) {
                                    UserinfoView_Message(vm: vm, headImgUrl: msg.avatar, userId: msg.senderUserId, nickname: msg.nickname, star_img: msg.starsImg, goldImg: msg.goldImg)
                                    
                                    textMessageItem(text: msg.content, textSize: textSize)
                                }
                                //                                .padding(.horizontal)
                                Spacer(minLength: 60)
                            }
                            .id(msg.id)
                        case 1: // 表情消息
                            HStack(alignment: .center, spacing: 0)  {
                                VStack(alignment: .leading, spacing: 0)  {
                                    UserinfoView_Message(vm: vm, headImgUrl: msg.avatar, userId: msg.senderUserId, nickname: msg.nickname, star_img: msg.starsImg, goldImg: msg.goldImg)
                                    
                                    AnimatedImage(url: URL(string: msg.emoji))
                                        .resizable()
                                        .transition(.fade)
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                }
                                Spacer()
                            }
                            .id(msg.id)
                        default:
                            HStack {
                                VStack(alignment: .leading) {
                                    textMessageItem(text: "Message Type: \(msg.type)", textSize: textSize)
                                }
                                Spacer(minLength: 60)
                            }
                            .id(msg.id)
                        }
                        
                    }
                    .onChange(of: viewModel.publicScreenContent) { _ in
                        withAnimation {
                            scrollView.scrollTo(viewModel.publicScreenContent.last?.id, anchor: .bottom)
                        }
                        messageTypeFun()
                    }
                }
            }
        }
    }
    
    // MARK: - 消息类型函数
        func messageTypeFun() {
            print("ChatRoom messageType: \(viewModel.publicScreenContent.last?.type)")
            switch viewModel.publicScreenContent.last?.type {
            case 3: // 上麦
                debugPrint("上麦")
                viewModel.getMicrophoneList()
            case 4: // 下麦
                debugPrint("下麦")
                viewModel.getMicrophoneList()
            case 16: // 更新背景
                viewModel.getRoomInfo()
            case 13: // 清理公屏幕
                ProgressHUD.banner("\(viewModel.roomInfo?.roomName)", "房主已清理公屏", delay: 2)
                viewModel.publicScreenContent = []
            case 14: // 打开心动值
                viewModel.getRoomInfo()
                Defaults[.room_xdz] = true
            case 15: // 关闭心动值
                viewModel.getRoomInfo()
                Defaults[.room_xdz] = false
            default:
                debugPrint("什么都不做")
            }
        }
}


struct textMessageItem: View {
    var text: String
    let textSize: CGFloat
    var body: some View {
        Text(text)
            .font(.system(size: textSize))
            .padding(8)
            .foregroundColor(Color.white)
            .background(.black.opacity(0.3))
            .cornerRadius(8)
    }
}



struct UserinfoView_Message: View {
    @StateObject var vm: UserInfoMain
    let headImgUrl: String
    let userId: Int
    let nickname: String
    let star_img: String
    let goldImg: String
    
    @State private var userProfileFullSheet: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 3)  {
            KFImageView_Fill(imageUrl: headImgUrl)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .onTapGesture(perform: {
                    //                    vm.getUserinfo(userId: user_id) { msg in
                    //                        userProfileFullSheet = true
                    //                        ProgressHUD.dismiss()
                    //                    }
                })
                .showUserInfoFullCoverSheet(userId: userId, isShowUserInfoFullCoverSheet: $userProfileFullSheet)
            
            Text(nickname)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 4)
            
            KFImageView(imageUrl: star_img)
                .frame(width: 25, height: 25)
            
            KFImageView(imageUrl: goldImg)
                .frame(width: 25, height: 25)
            
        }
    }
}


//struct GiftLabelView: View {
//    @StateObject var vm: RoomModel
//    @Default(.room_gift_list) var room_gift_list
//    var body: some View {
//        VStack(alignment: .center, spacing: 0)  {
//            HStack(alignment: .center, spacing: 8)  {
//                Text(vm.RoomGiftRecordList.first?.to_user.nickname ?? "")
//                    .foregroundColor(.yellow)
//
//                Text("送给")
//                    .foregroundColor(.white)
//
//                Text(vm.RoomGiftRecordList.first?.from_user.nickname ?? "")
//                    .foregroundColor(.yellow)
//
//                Text(vm.RoomGiftRecordList.first?.giftName ?? "")
//                    .foregroundColor(.white)
//
//                Text("x\(vm.RoomGiftRecordList.first?.giftNum ?? 0)")
//                    .foregroundColor(.white)
//
//                KFImage(URL(string: vm.RoomGiftRecordList.first?.gift.img ?? ""))
//                    .loadDiskFileSynchronously()
//                    .cacheMemoryOnly()
//                    .fade(duration: 0.3)
//                    .placeholder {
//                        ProgressView()
//                    }
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 30, height: 30)
//                    .padding(2)
//            }
//            .font(.system(size: 12, weight: .medium))
//            .padding(.vertical, 2)
//            .padding(.horizontal, 8)
//            .background(Color.white.opacity(0.4))
//            .cornerRadius(30)
//            .onTapGesture {
//                room_gift_list.toggle()
//            }
//        }
//        .frame(width: UIScreen.main.bounds.width)
//        .opacity(!vm.RoomGiftRecordList.isEmpty ? 1 : 0)
//    }
//}



//struct GiftListViewSheet: View {
//    @EnvironmentObject var vm: RoomModel
//    let room_name: String
//    let roomId: Int
//    var room_gift_list: Bool
//
//
//    var body: some View {
//        VStack(alignment: .center, spacing: 12)  {
//            Text(room_name)
//                .foregroundColor(.white)
//                .font(.system(size: 20, weight: .bold))
//            ScrollView {
//                VStack(alignment: .center, spacing: 8)  {
//                    ForEach(0..<vm.RoomGiftRecordList.count, id: \.self) { i in
//                        let item = vm.RoomGiftRecordList[i]
//                        GiftListViewSheetItem(img: item.from_user.headimgurl, fromUsername: item.from_user.nickname, toUsername: item.to_user.nickname, giftName: item.giftName, giftImg: item.gift.img, giftNum: item.giftNum, gfitPrice: item.giftPrice, time: item.created_at, formUserId: item.from_user.id) {
//                        }
//
//                    }
//                }
//
//
//            }
//            .refreshable {
//                vm.get_gift_record(roomId: roomId, isRefresh: true) { msg in
//                    print("刷新数据")
//                }
//            }
//        }
//        .padding(.horizontal, 8)
//        .edgesIgnoringSafeArea(.bottom)
//        .onChange(of: room_gift_list) { newValue in
//            if newValue {
//                vm.get_gift_record(roomId: roomId, isRefresh: true) { msg in
//                    print("刷新数据")
//                }
//            }
//        }
//
//
//    }
//}

struct GiftListViewSheetItem: View {
    
    let img: String
    let fromUsername: String
    let toUsername: String
    let giftName: String
    let giftImg: String
    let giftNum: Int
    let gfitPrice: Int
    let time: String
    
    let formUserId: Int
    
    var action: (() -> ())?
    
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView_Fill(imageUrl: img)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            
            
            VStack(alignment: .leading, spacing: 0)  {
                HStack(alignment: .center, spacing: 3)  {
                    Text(fromUsername)
                        .foregroundColor(.white)
                    Text("送给")
                        .foregroundColor(.gray)
                    Text(fromUsername)
                        .foregroundColor(.white)
                }
                Spacer()
                HStack(alignment: .center, spacing: 4)  {
                    Text(giftName)
                        .foregroundColor(.gray)
                    KFImageView(imageUrl: giftImg)
                        .frame(width: 32, height: 32)
                    Text("\(String(giftNum))")
                        .foregroundColor(.yellow)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 0)  {
                HStack(alignment: .center, spacing: 6)  {
                    Text("\(String(gfitPrice))")
                        .foregroundColor(.white)
                    Image(.roomGpGbZhuanshi)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                Spacer()
                Text("\(formatTime(time))")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .frame(width: 100)
            
            
        }
        .frame(height: 60)
        .padding(.vertical, 6)
        .onAppear {
            action?()
        }
        
    }
    
    func formatTime(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            let now = Date()
            let secondsAgo = Int(now.timeIntervalSince(date))
            
            if secondsAgo < 60 {
                return "\(secondsAgo)秒前"
            } else if secondsAgo < 3600 {
                let minutes = secondsAgo / 60
                return "\(minutes)分钟前"
            } else {
                let calendar = Calendar.current
                if calendar.isDateInToday(date) {
                    dateFormatter.dateFormat = "今天HH:mm"
                    return dateFormatter.string(from: date)
                } else if calendar.isDateInYesterday(date) {
                    dateFormatter.dateFormat = "昨天HH:mm"
                    return dateFormatter.string(from: date)
                } else {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    return dateFormatter.string(from: date)
                }
            }
        } else {
            return "无效的日期格式"
        }
    }
}




extension View {
    /// 房间图片礼物动画
    /// - Parameters:
    ///   - imageUrl: 图片URL地址
    ///   - isActionAniamtion: Bool类型，变换成True才会生效，结束后会自动重制
    /// - Returns: 返回类型为modifier
    func nestGiftImageAnimation(imageUrl: Binding<String>, isActionAniamtion: Binding<Bool>) -> some View {
        modifier(NestAnimationViewModifier(imageUrl: imageUrl, isActionAniamtion: isActionAniamtion))
    }
}
struct NestAnimationViewModifier: ViewModifier {
    @Binding var imageUrl: String
    @State var giftImageSize: CGFloat = 80
    @State var time: Double = 1.5
    @State private var isAnimation: Bool = false
    @Binding var isActionAniamtion: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
            KFImageView(imageUrl: imageUrl)
                .frame(width: giftImageSize, height: giftImageSize)
                .position(x: UIScreen.main.bounds.width / 2, y: isAnimation ? UIScreen.main.bounds.height / 2 : -giftImageSize)
                .opacity(isAnimation ? 1 : 0)
                .scaleEffect(isAnimation ? 1.2 : 0.6, anchor: .center)
        }
        .onChange(of: isActionAniamtion) { newValue in
            if isActionAniamtion {
                actionAnimation()
            }
        }
    }
    
    private func animation() {
        withAnimation(
            Animation
                .spring(duration: time)
                .speed(1)
        ) {
            isAnimation.toggle()
        }
    }
    
    private func actionAnimation() {
        animation()
        DispatchQueue.main.asyncAfter(deadline: .now() + time + 1.5) {
            animation()
            isActionAniamtion = false
        }
    }
}


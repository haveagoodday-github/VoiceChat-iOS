//
//  RoomSettingSheet.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/11/15.
//

import SwiftUI

import ProgressHUD
import Defaults
import WebKit
import SDWebImage

//struct RoomSettingSheet: View {
//    @State var isShowSettingCard: Bool = true
//    @State var isHost: Bool = true
//    let backColor: Color = Color(red: 0.138, green: 0.133, blue: 0.215)
//    let roomId: Int = 742
//    @StateObject var vm: RoomSettingModel = RoomSettingModel()
//    @StateObject var viewModel = RoomModel()
//    var body: some View {
//        NavigationView {
//            Button(action: {
//                isShowSettingCard.toggle()
//            }, label: {
//                Text("123")
//            })
//            .overlay(content: {
//                HalfModelView(isShown: $isShowSettingCard, backgroundColor: backColor, modelHeight: isHost ? 530 : 310, modelHeightSubtract: 0) {
//                    RoomSettingCard(isHost: isHost, roomId: roomId, isShowSettingCard: $isShowSettingCard)
//                        .environmentObject(vm)
//                        .environmentObject(viewModel)
//                }
//            })
//            .onAppear {
//                viewModel.getRoomInfo(roomId: roomId) { msg in
//                    
//                }
//            }
//        }
//        
//
//    }
//}




struct RoomSettingCard: View {
    let roomId: Int
    @State var password: String = ""
    let col = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @StateObject var vm: RoomSettingModel
    @StateObject var viewModel: RoomModel
    
    @State var go_SetAdminView: Bool = false
    
    @Binding var isShowingSafari: Bool
    @Default(.game_url) var game_url
    @Default(.room_xdz) var room_xdz
    
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            // test 如果是房主
            if viewModel.isHost() {
                title_RoomSettingCard(title: "房间设置")
                LazyVGrid(columns: col, content: {
                    
//                    item_RoomSettingCard2(img: viewModel.roomInfoRoomData?.roomStatus == 1 ? "admin_jiami" : "admin_jiemi", name: viewModel.roomInfoRoomData?.roomStatus == 1 ? "房间上锁" : "房间解锁") {
//                        
//                        if viewModel.roomInfoRoomData?.roomStatus == 1 {
//                            alertView()
//                        } else {
//                            vm.settingRoom(
//                                uid: viewModel.roomInfoRoomData?.uid ?? 0,
//                                coverURL: viewModel.roomInfoRoomData?.room_cover ?? "",
//                                room_intro: viewModel.roomInfoRoomData?.room_intro ?? "",
//                                room_name: viewModel.roomInfoRoomData?.room_name ?? "",
//                                room_pass: "",
//                                room_type: Int(viewModel.roomInfoRoomData?.room_type ?? "0") ?? 0,
//                                room_backgroundID: viewModel.roomInfoRoomData?.room_background ?? 0,
//                                roomId: viewModel.roomInfoRoomData?.id ?? 0) { msg in
//                                print(msg)
//                                ProgressHUD.succeed(msg, delay: 1)
//                            }
//                        }
//                        
//                    }
                    
                    item_RoomSettingCard2(img: room_xdz ? "admin_noxdz" : "admin_xdz", name: room_xdz ? "心动关闭" : "心动打开") {
                        if room_xdz {
                            print("close 心动值")
                            viewModel.closeXDZ()
                        } else {
                            print("open 心动值")
                            room_xdz.toggle()
                        }
                    }
                    
                    item_RoomSettingCard2(img: "admin_clean", name: "清理公屏") {
                        viewModel.clearPublicScreen()
                    }
                    
                    item_RoomSettingCard2(img: "admin_bg", name: "房间背景") {
                        vm.getRoomBackground(){ msg in }
                        viewModel.isShowSettingBackground = true
                    }
                    
                    
                    item_RoomSettingCard2(img: "admin_admin", name: "管理员") {
                        vm.getRoomPerson(roomId: roomId) { msg in }
                        go_SetAdminView = true
                    }
                    
                    item_RoomSettingCard2(img: "admin_black", name: "黑名单") {
                        viewModel.isShowBlackList = true
                    }
                    
                    item_RoomSettingCard2(img: "room_music", name: "房间音乐")
                    
                    
                    item_RoomSettingCard2(img: "admin_setting", name: "房间设置") {
//                        Defaults[.room_ishost] = true
                        viewModel.isShowRoomSettingFullCover = true
                    }
                    

                    
                })
                .padding(.bottom)
            }
            
            // FIXME: 网页预览方式
            if !vm.gameListData.isEmpty {
                title_RoomSettingCard(title: "玩法中心")
                LazyVGrid(columns: col, content: {
                    ForEach(vm.gameListData, id: \.title) { game in
                        if let game_img = game.game_list?.first?.imges, let name = game.game_list?.first?.name {
                            Button(action: {
                                game_url = game.game_list?.first?.game_url ?? ""
                                if !game_url.isEmpty {
                                    Defaults[.room_setting_card] = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isShowingSafari = true
                                    }
                                }
                            }, label: {
                                VStack(alignment: .center, spacing: 8)  {
                                    KFImageView(imageUrl: game_img)
                                        .frame(width: 50, height: 50)
                                    Text(name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                }
                            })
                        }
                    }
                })
                .padding(.bottom)
//                .sheet(isPresented: $isShowingSafari) {
//                    if let token = UserCache.shared.getUserInfo()?.token {
//                        SafariView(url: URL(string: "\(game_url)/?token=\(convertToBase64(token))")!)
//                    }
//                }
                
            }
            
            
            title_RoomSettingCard(title: "更多功能")
            LazyVGrid(columns: col, content: {
                
                NavigationLink {
                    MyBagView()
                } label: {
                    item_RoomSettingCard2(img: "admin_zhuangban", name: "装扮")
                }
                
                
                item_RoomSettingCard2(img: "admin_texiao", name: "关闭特效") {
                    
                }

            })
        }
        .onAppear {
//            initialize()
//            room_xdz = viewModel.roomInfoRoomData?.play_num == 1
        }
        .sheet(isPresented: $viewModel.isShowRoomSettingFullCover) {
            RoomSettingView(viewModelRoom: viewModel)
        }
        .sheet(isPresented: $viewModel.isShowSettingBackground) {
            RoomBackgroundView(viewModel: viewModel) {
                viewModel.isShowSettingBackground.toggle()
            }
        }
//        .fullScreenCover(isPresented: $go_SetAdminView) {
//            SetAdminView()
//                .environmentObject(vm)
//        }
        .fullScreenCover(isPresented: $viewModel.isShowBlackList) {
            BlacklistView()
        }
        
        
    }
    
    private func alertView() {
        let alert = UIAlertController(title: "密码输入", message: "请输入6位密码", preferredStyle: .alert)
        
        alert.addTextField { pass in
            pass.isSecureTextEntry = true
            pass.keyboardType = .numberPad
            pass.placeholder = "请输入6位密码"
        }
        
        let login = UIAlertAction(title: "确定", style: .default) { _ in
            // do your onw stuff...
            password = alert.textFields![0].text!
            
            // 设置房间密码
//            vm.settingRoom(
//                uid: viewModel.roomInfoRoomData?.uid ?? 0,
//                coverURL: viewModel.roomInfoRoomData?.room_cover ?? "",
//                room_intro: viewModel.roomInfoRoomData?.room_intro ?? "",
//                room_name: viewModel.roomInfoRoomData?.room_name ?? "",
//                room_pass: password,
//                room_type: Int(viewModel.roomInfoRoomData?.room_type ?? "0") ?? 0,
//                room_backgroundID: viewModel.roomInfoRoomData?.room_background ?? 0,
//                roomId: viewModel.roomInfoRoomData?.id ?? 0) { msg in
//                print(msg)
//                ProgressHUD.succeed(msg, delay: 1)
//            }
            
            
        }
        
        let cancel = UIAlertAction(title: "取消", style: .destructive) { _ in
            
        }
        
        alert.addAction(cancel)
        alert.addAction(login)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true) { }
    }
    
    
//    func initialize() {
//        backgroundName = viewModel.roomInfoRoomData?.backgrounds?.filter({$0.is_check == 1}).first?.bname ?? ""
//        backgroundImgURL = viewModel.roomInfoRoomData?.backgrounds?.filter({$0.is_check == 1}).first?.img ?? ""
//        backgroundID = viewModel.roomInfoRoomData?.backgrounds?.filter({$0.is_check == 1}).first?.id ?? 0
//    }
    
    
}



struct title_RoomSettingCard: View {
    let title: String
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold))
            Spacer()
        }
    }
}


struct item_RoomSettingCard: View {
    var item: item
//    @Binding var isShowSettingCard: Bool
    let action: () -> ()
    
//    @Default(.room_setting_card) var room_setting_card
    
    var body: some View {
        Button(action: {
            action()
//            isShowSettingCard = false
            Defaults[.room_setting_card] = false
        }, label: {
            VStack(alignment: .center, spacing: 8)  {
                Image(item.status ? item.img : item.oimg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text(item.status ? item.name : item.oname)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium))
            }
        })

    }
}





struct item_RoomSettingCard2: View {
    var img: String
    var name: String
    var action: (() -> ())?
    var body: some View {
        VStack(alignment: .center, spacing: 8)  {
            Image(img)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            Text(name)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .medium))
        }
        .onTapGesture {
            action?()
            Defaults[.room_setting_card] = false
        }
    }
}








//struct LinkViewWrapper: UIViewRepresentable {
//    let linkView: LPLinkView
//    
//    func makeUIView(context: Context) -> LPLinkView {
//        linkView.backgroundColor = .clear // Customize the background if needed
//        return linkView
//    }
//    
//    func updateUIView(_ uiView: LPLinkView, context: Context) {}
//}
//


struct ShowGameWeb: ViewModifier {
    var urlString: String
    @Binding var isClose: Bool
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack(alignment: .bottom) {
                    Color.black
                        .opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isClose = false
                        }
                        
                    
                    WebViewWrapper(urlString: urlString)
                        .frame(width: 414, height: 640)
                }
                .offset(y: isClose ? 0 : UIScreen.main.bounds.height)
                .animation(Animation.spring)
                
                
            }
    }
}
extension View {
    func showGameWeb(urlString: String, isClose: Binding<Bool>) -> some View {
        modifier(ShowGameWeb(urlString: urlString, isClose: isClose))
    }
}
struct WebViewWrapper: UIViewRepresentable {
    var urlString: String

    func makeUIView(context: Context) -> WKWebView {
        var webView = WKWebView()
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

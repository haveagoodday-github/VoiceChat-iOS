//
//  GoToRoom.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/1/21.
//

import SwiftUI
import Defaults
import ProgressHUD

struct GotoRoomModel: Codable, Defaults.Serializable, Equatable {
    var roomStatus: Int
    var roomId: Int
    var roomUid: Int
    var is_default: Int
    var room_pass: String?
}

struct GotoRoom2: ViewModifier {
    var vm: GotoRoomModel
    @State var room_pass: String = ""
    @Default(.go_to_room) var go_to_room
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                print("点击了Item，进入房间")
                ProgressHUD.animate("Loading...", .barSweepToggle, interaction: false)
                Default(.go_to_room).reset() // 还原数据
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if vm.roomStatus == 1 {
                        go_to_room = vm
                    } else {
                        alertView()
                    }
                    
                    ProgressHUD.dismiss()
                }
                
            }
    }
    
    private func alertView() {
        let alert = UIAlertController(title: "密码输入", message: "请输入6位数字密码", preferredStyle: .alert)
        
        alert.addTextField { pass in
            pass.isSecureTextEntry = true
            pass.keyboardType = .numberPad
            pass.placeholder = "请输入6位数字密码"
        }
        
        let login = UIAlertAction(title: "确定", style: .default) { _ in
            room_pass = alert.textFields![0].text!
            
            if room_pass.count == 6 {
                let vm2: GotoRoomModel = GotoRoomModel(roomStatus: vm.roomStatus, roomId: vm.roomId, roomUid: vm.roomUid, is_default: vm.is_default, room_pass: room_pass)
                go_to_room = vm2
            } else if room_pass.count < 6 {
                ProgressHUD.error("密码格式为6位数字，请重新输入", delay: 1.5)
            } else {
                ProgressHUD.error("密码不正确，请重新输入", delay: 1.5)
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .destructive) { _ in
            ProgressHUD.dismiss()
        }
        
        alert.addAction(cancel)
        alert.addAction(login)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true) { }
    }
}


struct GotoRoom: ViewModifier {
    @Default(.go_to_room) var go_to_room
    @State private var isGotoRoom: Bool = false
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
                .onChange(of: go_to_room, perform: { newValue in
                    if go_to_room.roomId != 0 {
                        withAnimation(
                            Animation
                                .spring
                        ) {
                            isGotoRoom = true
                        }
                    }
                })
            
            if isGotoRoom {
                NestView2(linphone: linphone, roomId: go_to_room.roomId, roomUid: go_to_room.roomUid , roomPass: go_to_room.room_pass ?? "", is_default: go_to_room.is_default, isGotoRoom: $isGotoRoom)
            }
        }
    }
    
    
}

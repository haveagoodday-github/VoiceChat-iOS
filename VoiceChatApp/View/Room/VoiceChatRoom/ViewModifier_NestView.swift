//
//  ViewModifier_NestView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/11/15.
//

import SwiftUI
import ProgressHUD

struct HostFeatureViewModifier: ViewModifier {
    @StateObject var viewModel: RoomModel
    @State var mic: MicrophoneModel
    @Binding var isGotoHoldingView: Bool
    let roomId: Int
    let position: Int
    
    
    func body(content: Content) -> some View {
        // 如果房主ID与用户ID一致，则可以控制
//        if HostID == UserCache.shared.getUserInfo()?.userId {
            content
                .contextMenu {
                    if mic.state == 1 {
                        // 有人 显示禁麦/解除静麦
                        Button {
                            if viewModel.isBanSpeak() {
                                // 解除静麦
//                                controlRoom.openUserMic(userId: viewModel.user_id!, roomId: roomId) { msg in
//                                    if msg == "取消禁声成功" {
//                                        let send_message_forbadMic_cancel = """
//                                        {"MicPos":-1,"adminMenuEvent":null,"boxGift":null,"fromUser":null,"gift":null,"master_micPlaceInfo":null,"message":"\(viewModel.user_id!)","messageType":15,"micList":null}
//                                        """
//                                        Task {
//                                            await agoraRTMManager.sendMessage(send_message_forbadMic_cancel)
//                                        }
//                                        ProgressHUD.succeed(msg, delay: 1)
//                                    } else {
//                                        ProgressHUD.failed(msg, delay: 1.5)
//                                    }
//                                }
                            } else {
                                // 静麦
//                                controlRoom.closeUserMic(userId: viewModel.user_id!, roomId: roomId) { msg in
//                                    if msg == "加入禁声单成功" {
//                                        let send_message_forbadMic = """
//                                        {"MicPos":-1,"adminMenuEvent":null,"boxGift":null,"fromUser":null,"gift":null,"master_micPlaceInfo":null,"message":"\(viewModel.user_id!)","messageType":14,"micList":null}
//                                        """
//                                        Task {
//                                            await agoraRTMManager.sendMessage(send_message_forbadMic)
//                                        }
//                                        ProgressHUD.succeed(msg, delay: 1)
//                                    } else {
//                                        ProgressHUD.failed(msg, delay: 1.5)
//                                    }
//                                }
                            }
//                            offmic.toggle()
                        } label: {
                            Label(viewModel.isBanSpeak() ? "解除静麦" : "静麦", systemImage: "mic.slash.fill")
                        }
                    }
                    
                    
                    /// 非有人/非锁麦 状态下可抱人
//                    if !viewModel.status != 2 && viewModel.status != 3 {
                    if mic.state == 0 {
                        Button {
                            isGotoHoldingView.toggle()
                        } label: {
                            Label("抱人", systemImage: "figure.taichi")
                        }
                    }
                    
                    
                    Button {
                        
        //                isLock.toggle()
                        if mic.state == 1 {
                            // 解除封麦
                            viewModel.unlockMic(position: position+1)
                        } else {
                            // 封麦
                            viewModel.lockMic(position: position+1)
                        }
                    } label: {
                        Label(viewModel.isBanSpeak() ? "解除封麦" : "封麦", systemImage: "lock")
                    }
                    
//                    Button {
//                        print("开启音乐权限")
//                    } label: {
//                        Label("开启音乐权限", systemImage: "music.note")
//                    }
                    
                }
//        } else {
//            content
//        }
        
    }
}

//
//  RoomMessageView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/9/10.
//

import SwiftUI


struct RoomMessageView: View {
    @State var roomId: String
    @State var byToken: String
    @State private var message: String = ""
    @State var showUsername = true

    var body: some View {
        VStack {
            if !showUsername {
//                MessagesList(agoraRTMManager: agoraRTMManager)

//                MessageInput(agoraRTMManager: agoraRTMManager).onAppear {
//                    self.agoraRTMManager.messages.append(contentsOf: [
//                        .init(message: AgoraRtmMessage(text: "欢迎小主回来～\n房间名称：空\n房间类型：#娱乐交友-聊天#\n房间当前已开启高音质模式\n房间公告：空///📢"), id: UUID().uuidString, sender: "房间小助手"),
//                        .init(message: AgoraRtmMessage(text: "Hello world"), id: UUID().uuidString, sender: "Dorothy"),
//                        .init(message: AgoraRtmMessage(text: "What time is it?"), id: UUID().uuidString, sender: UserCache.shared.getUserInfo()?.nickname ?? ""),
//                        .init(message: AgoraRtmMessage(text: "Lunch time!"), id: UUID().uuidString, sender: "Gunther")
//                    ])
//                }
            }
        }.padding(.top, 50)
            .onAppear {
                Task {
//                    await agoraRTMManager.login(roomId: roomId, byToken: byToken)
//                    await agoraRTMManager.login(roomId: roomId)
                    self.showUsername = false
                }
            }
    }
}

struct MessageInput: View {
    @State var message: String = ""
    var body: some View {
        HStack {
            TextField("Type your message", text: $message)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button("Send") {

                
            }.padding(.horizontal).disabled(message.isEmpty)
        }.padding()
    }
}



//#Preview {
//    RoomMessageView()
//}

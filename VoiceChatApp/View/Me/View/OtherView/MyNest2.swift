//
//  MyNest2.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/9/9.
//

import SwiftUI

struct MyNest2: View {
    @StateObject var viewModel = RoomModel()
    @State var ChatType: Bool = true // 为真则是“房间”，反之则是“世界”
    @StateObject var getMessages: GetMessages = GetMessages()
    @State private var inputText: String = ""
    @State private var isStatusHost: Bool = false
    @State private var isShowAnnouncement: Bool = false
    @State private var keyboardHeight: CGFloat = 0.0
    @State private var isShowGiftCard: Bool = false
    @State private var isShowRoomSettingCard: Bool = true
    @State private var isShowDataCard: Bool = false // test
    
    var body: some View {
Text("123")
        
        
        
    }
}

#Preview {
    MyNest2()
}

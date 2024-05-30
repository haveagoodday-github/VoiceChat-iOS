//
//  SmileyCard.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/12/11.
//

import SwiftUI

import SDWebImageSwiftUI
import Defaults

struct SmileyCard: View {
    @StateObject var viewModel: RoomModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            Spacer()
            
            ScrollView(.horizontal, content: {
                HStack(alignment: .center, spacing: 6)  {
                    ForEach(viewModel.emojiList, id: \.emojiId) { item in
                        smileyItemView(roomModel: viewModel, img: item.gifUrl, id: item.emojiId)
                    }
                }
            })
            .frame(width: UIScreen.main.bounds.width)
        }
        
    }
}


struct smileyItemView: View {
    @StateObject private var vmForUserInfoMain: UserInfoMain = UserInfoMain()
    @StateObject var roomModel: RoomModel
    let img: String
    let id: Int
    
    var body: some View {
        Button(action: {
            sendMsg()
        }, label: {
            
            AnimatedImage(url: URL(string: img))
                .resizable()
                .transition(.fade)
                .scaledToFit()
                .frame(width: 60, height: 60)
        })
        
    }
    
    
    func sendMsg() {
        roomModel.sendMsgToRoomByType(1, "发送表情", emoji: img)
        Defaults[.room_smiley_card] = false
        
    }
}



//
//  HoldingUpMicView.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/9/12.
//

import SwiftUI

import ProgressHUD

struct HoldingUpMicView: View {
    @StateObject var viewModel: holdingUpMicModel = holdingUpMicModel()
    @StateObject var roomModel: RoomModel = RoomModel()
    let roomId: Int
    let phase: Int
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                Text("要抱谁上麦?")
                    .padding()
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            
            HoldingUpMicListView(viewModel: viewModel, roomModel: roomModel, roomId: roomId, phase: phase) {
                presentationMode.wrappedValue.dismiss()
            }
            .onAppear {
                viewModel.getRoomPerson(roomId: roomId)
            }
        }
        .overlay(alignment: .topTrailing) {
            HoldingUpMicTrailingButtonView()
        }
        
    }
}

struct HoldingUpMicTrailingButtonView: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Text("搜索")
                .padding()
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .bold))
        })
    }
}

struct HoldingUpMicListView: View {
    @StateObject var viewModel: holdingUpMicModel
    @StateObject var roomModel: RoomModel
    let roomId: Int
    let phase: Int
    let action: () -> Void
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0)  {
                ForEach(viewModel.visitorArray, id: \.selfID) { item in
                    Divider()
                    
                    HoldingUpMicListItemView(img: item.headimgurl, name: item.nickname, personelSign: "本宝宝暂时没想到个性签名") {
                        RoomRequest.upMic(userId: item.id, roomId: roomId, position: phase) { code in
                            
                        }
                    }
                    
                }
            }
        }
    }
}

struct HoldingUpMicListItemView: View {
    let img: String
    let name: String
    let personelSign: String
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(alignment: .center, spacing: 14)  {
                KFImageView(imageUrl: img)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2)  {
                    Text(name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    Text(personelSign)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                }
                Spacer()
                
            }
            .padding()
        })
    }
}


//#Preview {
//    NavigationView {
//        HoldingUpMicView()
//    }
//}

//
//  RoomBackgroundView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/11/17.
//

import SwiftUI
import ProgressHUD


struct RoomBackgroundView: View {
    @StateObject var viewModel: RoomModel
    @State var isFromRoomSetting: Bool = false
    @State var closeAction: () -> ()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            ScrollView {
                LazyVGrid(columns: Array(
                    repeating: GridItem(.flexible(), spacing: 10),
                    count: 3
                ), content: {
                    ForEach(viewModel.roomBackgroundArray, id: \.backgroundId) { item in
                        item_RoomBackgroundView(bg: item, selectedBg: viewModel.currentBg) {
                            viewModel.currentBg = item
                        }
                    }
                })
                .padding()
                
                Spacer(minLength: 80)
            }
            
            
        }
        .navigationTitle("房间背景")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: trailingButtonView)
        .overlay(alignment: .bottom, content: {
            if !isFromRoomSetting {
                bottomSaveButton
            }
        })
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var trailingButtonView: some View {
        Button(action: {
            
        }, label: {
            Text("装扮商场")
                .foregroundColor(.black)
        })
    }
    
    var bottomSaveButton: some View {
        Button(action: {
            if let bg = viewModel.currentBg {
                viewModel.updateBackground(backgroundId: bg.backgroundId) { code in
                    viewModel.isShowSettingBackground.toggle()
                }
            } else {
                closeAction()
            }
        }, label: {
            HStack(alignment: .center, spacing: 0)  {
                Text(viewModel.currentBg != nil ? "保存" : "取消")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width * 0.8, height: 60)
            .background(viewModel.currentBg == nil ?
                        LinearGradient(colors: [.gray, .black.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                        :
                            LinearGradient(colors: [Color(red: 0.993, green: 0.628, blue: 0.879), Color(red: 0.834, green: 0.474, blue: 0.997)], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(30)
            .shadow(radius: 3)
            .padding(.bottom, 32)
        })
        
    }

}



struct item_RoomBackgroundView: View {
    var bg: RoomBackgroundModel
    var selectedBg: RoomBackgroundModel?
    @State var action: () -> ()
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .center, spacing: 4)  {
                if bg.backgroundUrl.contains(".svga") {
//                    SVGAShow(url: img)
//                        .scaledToFill()
//                        .offset(y: -130)
//                        .scaleEffect(CGSize(width: 0.6, height: 0.6))
//                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 195)
//                        .clipped()
//    //                    .background(Color.red)
//                        .cornerRadius(5)
//                    Text("SVGA EDIT")
                    
                    SVGAPlayerView33(svgaSource: bg.backgroundUrl)
                        .scaledToFill()
                        .offset(y: -130)
                        .scaleEffect(CGSize(width: 0.6, height: 0.6))
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 195)
                        .clipped()
                    //                    .background(Color.red)
                        .cornerRadius(5)
                    
                } else {
                    KFImageView_Fill(imageUrl: bg.backgroundUrl)
                        .cornerRadius(5)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                }
                
                Text(bg.backgroundName)
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(3)
            .background(selectedBg == bg ? Color.pink.opacity(0.3) : Color.clear)
            .cornerRadius(3)
        })
        
    }
}

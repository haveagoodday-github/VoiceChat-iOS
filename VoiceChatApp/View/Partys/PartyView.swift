//
//  PartView.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/8/29.
//

import SwiftUI

import SDWebImage
import SDWebImageSwiftUI
import ProgressHUD
import Alamofire

struct PartView: View {
    @StateObject var viewModel: PartyViewModel
    @State var carouselData: [CarouselModel]
    
    @State private var selected_party: Bool = true
    @ObservedObject var linphone : IncomingCallTutorialContext
//    @State private var CurrentRoomType: partyTypeModel.data = partyTypeModel.data(id: 0, name: "")
    let gridItems = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 8)  {
            PartTopTabView(selected_party: $selected_party)
                .padding(.horizontal, 12)
            VStack(alignment: .center, spacing: 12)  {
                if selected_party {
                    PartCarousel
                    PartsingleChoice
                    PartContentView
                } else {
                    ActivityView()
                }
            }
        }
        .onChange(of: viewModel.typeList, perform: { newValue in
            viewModel.currentType = RoomTypeModel(roomTypeId: 0, name: "", typeType: 0)
        })
        .onDisappear {
            ProgressHUD.dismiss()
        }
        .navigationBarHidden(true)
    }
}


// MARK: 顶部单选
struct PartTopTabView: View {
    @Binding var selected_party: Bool
    var body: some View {
        HStack(alignment: .bottom, spacing: 12)  {
            Button(action: {
                withAnimation {
                    selected_party = true
                }
            }, label: {
                Text("派对")
                    .foregroundColor(selected_party ? .black : .gray)
                    .fontWeight(.bold)
                    .font(selected_party ? .title2 : .headline)
            })
            
            
            Button(action: {
                withAnimation {
                    selected_party = false
                }
            }, label: {
                Text("活动")
                    .foregroundColor(!selected_party ? .black : .gray)
                    .fontWeight(.bold)
                    .font(!selected_party ? .title2 : .headline)
            })
            
            
            
        }
    }
}




extension PartView {
    // MARK: 顶部轮播图
    var PartCarousel: some View {
        TabView {
            ForEach(carouselData, id: \.id) {item in
                KFImageView_Fill(imageUrl: item.imageUrl)
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .cornerRadius(10)
                    .clipped()
            }
        }
        .cornerRadius(10)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 不显示页面指示器
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive)) // 控制索引点大小
        .frame(height: 100)
        .padding(.horizontal, 7)
        
    }
    
    // MARK: 派对类别
    var PartsingleChoice: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 12)  {
                ForEach(viewModel.typeList, id: \.roomTypeId) { item in
                    CustomButton(title: item.name, isSelected: viewModel.currentType.roomTypeId == item.roomTypeId) {
                        ProgressHUD.animate("Loading...")
                        viewModel.currentType = item
                        viewModel.getPartyContent(currentType: item)
                    }
                    
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            
        }
    }
    
    // MARK: 派对内容
    var PartContentView: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 16) {
                ForEach(viewModel.partContentArray, id: \.roomId) { item in
                    PartyViewItem(item: item, linphone: linphone)
                }
            }
            .padding(16)
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}







// 自定义按钮
struct CustomButton: View {
    let title: String
    var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .frame(maxWidth: 40)
                .foregroundColor(isSelected ? .black : .gray)
                .font(.system(size: 15, weight: .bold))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(isSelected ? Color.yellow.opacity(0.5) : .gray.opacity(0.5))
                .cornerRadius(30)
        }
    }
}

struct PartyViewItem: View {
    let item: NewHallRecommendModel
    let size: CGFloat = UIScreen.main.bounds.width * 0.43
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6)  {
            ZStack(alignment: .bottom) {
                KFImageView(imageUrl: item.roomCover)
                    .frame(width: size)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack(alignment: .center, spacing: 3)  {
                    AnimatedImage(name: "yinlv_gray.gif")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("\(item.onlineNum)")
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(item.type))
                        .font(.caption2)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .cornerRadius(30)
                        .foregroundColor(.white)
                    
                }
                .padding(3)
                .frame(maxWidth: size)
                
            }
            Text("\(item.roomName)")
                .foregroundColor(.black)
                .font(.system(size: 14, weight: .medium))
        }
//        .modifier(GotoRoom(linphone: linphone))
        .modifier(GotoRoom2(vm: GotoRoomModel(roomStatus: 1, roomId: item.roomId, roomUid: item.roomUid, is_default: 0), linphone: linphone))
        
    }
    
    
}

//
//  DiamondDetailView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/27.
//

import SwiftUI

import ProgressHUD

struct DiamondDetailModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let list: [list]
        let total: Int
        
        struct list: Decodable {
            let id: Int
            let type: Int
            let giftId: Int
            let giftName: String
            let giftPrice: Int
            let giftNum: Int
            let gift: gift
            
            let to_user: user
            let from_user: user
            let created_at: String
            
            struct user: Decodable {
                let id: Int
                let nickname: String
                let sex: Int
                let headimgurl: String
            }
            
            struct gift: Decodable {
                let img: String
            }
        }
    }
}


class DiamondDetail: ObservableObject {
    @Published var sendGiftList: [DiamondDetailModel.data.list] = []
    @Published var giveGiftList: [DiamondDetailModel.data.list] = []
    @Published var isLoading: Bool = false
    
    init() {
        self.getSendGiftList()
        self.getGiveGiftList()
    }
    
    // MARK: 获取送出礼物记录
    func getSendGiftList(page: Int = 1, pageSize: Int = 15) {
        
//        NetworkTools.requestAPI(convertible: "api/room/give_gift",
//                                method: .post,
//                                parameters: [
//                                    "page": page,
//                                    "pageSize": pageSize
//                                ],
//                                responseDecodable: DiamondDetailModel.self) { result in
//            DispatchQueue.main.async {
//                self.sendGiftList = result.data.list
//                self.isLoading = true
//            }
//        } failure: { _ in
//            
//        }

        
    }
    
    
    // MARK: 获取收入礼物记录
    func getGiveGiftList(page: Int = 1, pageSize: Int = 15) {
        
//        NetworkTools.requestAPI(convertible: "api/room/accept_gift",
//                                method: .post,
//                                parameters: [
//                                    "page": page,
//                                    "pageSize": pageSize
//                                ],
//                                responseDecodable: DiamondDetailModel.self) { result in
//            DispatchQueue.main.async {
//                self.sendGiftList = result.data.list
//                self.isLoading = true
//            }
//        } failure: { _ in
//            
//        }
    }
}

struct DiamondDetailView: View {
    let max_index: Int = 3
    @State var index: Int = 1
    @State var offset: CGFloat = 0
    var width = UIScreen.main.bounds.width
    @StateObject private var vm: DiamondDetail = DiamondDetail()
    var body: some View {
        VStack(alignment: .center, spacing: 8)  {
            AppBar_DiamondDetailView(index: $index, offset: $offset)
            GeometryReader { g in
                HStack(spacing: 0)  {
                    
                    DiamondDetailListView(list: vm.sendGiftList)
                        .frame(width: g.frame(in: .global).width)
                    DiamondDetailListView(list: vm.giveGiftList)
                        .frame(width: g.frame(in: .global).width)
                    DiamondDetailListView(list: [])
                        .frame(width: g.frame(in: .global).width)

                    
                }
                .offset(x: offset)
                .highPriorityGesture(DragGesture()
                    .onEnded({ value in
                        if value.translation.width > 50 {
                            changeView(left: false)
                        }
                        if -value.translation.width > 50 {
                            changeView(left: true)
                        }
                    })
                )
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .animation(.default)
        .navigationTitle("明细")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: vm.isLoading) { newValue in
            ProgressHUD.dismiss()
        }
        .onAppear {
            ProgressHUD.animate()
        }
    }
    
    
    func changeView(left : Bool) {
        if left {
            if index != max_index {
                index += 1
            }
        } else {
            if index != 1 {
                index -= 1
            }
        }
        
        switch(index) {
        case 1:
            offset = 0
        case 2:
            offset = -width
        default:
            offset = 2 * -width
        }

    }
}

struct AppBar_DiamondDetailView: View {
    @Binding var index: Int
    @Binding var offset: CGFloat
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .center, spacing: 10)  {
            TopButtonViewItem_DiamondDetailView(text: "礼物支出", isSelected: index == 1) {
                index = 1
                offset = 0
            }
            TopButtonViewItem_DiamondDetailView(text: "礼物收入", isSelected: index == 2) {
                index = 2
                offset = -width
            }
            TopButtonViewItem_DiamondDetailView(text: "其他记录", isSelected: index == 3) {
                index = 3
                offset = 2 * -width
            }

        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        
    }
}
struct TopButtonViewItem_DiamondDetailView: View {
    @State var text: String
    var isSelected: Bool
    var action: (() -> ())?
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            VStack(alignment: .center, spacing: 8)  {
                Text(text)
                    .foregroundColor(isSelected ? .black : .gray)
                    .font(.system(size: isSelected ? 16 : 14, weight: isSelected ? .bold : .medium))
                    .lineLimit(1)
                
                Capsule()
                    .fill(.clear)
                    .frame(height: 4)
            }
        })
        
    }
}

struct DiamondDetailListView: View {
    var list: [DiamondDetailModel.data.list]
    var body: some View {
        List(list, id: \.id) { item in
            DiamondDetailListViewItem(item: item)
        }
        .listStyle(.inset)
    }
}

struct DiamondDetailListViewItem: View {
    let item: DiamondDetailModel.data.list

    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView_Fill(imageUrl: item.to_user.headimgurl)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8)  {
                HStack(alignment: .center, spacing: 4)  {
                    Text(item.to_user.nickname)
                    Text("送给")
                        .foregroundColor(.gray)
                    Text(item.from_user.nickname)
                }
                
                HStack(alignment: .center, spacing: 8)  {
                    Text(item.giftName)
                    KFImageView(imageUrl: item.gift.img)
                        .frame(width: 30, height: 30)
                    
                    Text("x\(String(item.giftNum))")
                }
                
            }
            .font(.system(size: 14))
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8)  {
                HStack(alignment: .center, spacing: 6)  {
                    Text(String(item.giftPrice))
                        .font(.system(size: 14))
                    Image(.gbZuanshi)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                    
                }
                
                Text(item.created_at)
                    .font(.system(size: 12))
            }
            
        }
    }
}


#Preview {
    NavigationView {
        DiamondDetailView()
    }
}





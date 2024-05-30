//
//  MyBagView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/18.
//

import SwiftUI

import Defaults
import ProgressHUD


struct bagModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let list: [list]
        
        struct list: Decodable, Hashable {
            let id: Int
            let user_id: Int
            let get_type: Int
            let type: Int
            let target_id: Int
            let num: Int
            let expire: Int
            let addtime: Int
            let is_read: Int
            let name: String
            let show_img: String
            let gifurl: String?
            let title: String
            let color: String?
            let is_dress: Int
        }
    }
}

class MyBag: ObservableObject {
    @Published var bagGiftList: [bagModel.data.list] = []
    @Published var bagCardList: [bagModel.data.list] = []
    @Published var bagAvatarBorderList: [bagModel.data.list] = []
    @Published var bagJoinEffectList: [bagModel.data.list] = []
    @Published var bagMicStatusEffectList: [bagModel.data.list] = []
    @Published var bagInfoFloatList: [bagModel.data.list] = []
    
    // MARK: 获取背包礼物
    func getBagGift(type: Int, userId: Int = UserCache.shared.getUserInfo()?.userId ?? 0) {
        NetworkTools.requestAPI(convertible: "api/my_pack",
                                parameters: [
                                    "type": type,
                                    "userId": userId
                                ],
                                responseDecodable: bagModel.self) { result in
            DispatchQueue.main.async {
                switch(type) {
                case 2:
                    self.bagGiftList = result.data.list
                case 4:
                    self.bagAvatarBorderList  = result.data.list
                case 6:
                    self.bagJoinEffectList = result.data.list
                case 7:
                    self.bagMicStatusEffectList = result.data.list
                case 9:
                    self.bagInfoFloatList = result.data.list
                default:
                    self.bagCardList = result.data.list
                }
            }
        } failure: { _ in
            
        }

    }
    
    // MARK: 装扮
    func getDress_up(id: Int, type: Int, completion: @escaping (String) -> Void) {
        
        NetworkTools.requestAPI(convertible: "api/dress_up",
                                parameters: [
                                    "id": id,
                                    "type": type
                                ],
                                responseDecodable: baseModel.self) { result in
            DispatchQueue.main.async {
                completion(result.message)
                self.getBagGift(type: 2)
                self.getBagGift(type: 10)
                self.getBagGift(type: 4)
                self.getBagGift(type: 6)
                self.getBagGift(type: 7)
                self.getBagGift(type: 9)
            }
        } failure: { _ in
            
        }

    }
    
    
}

struct MyBagView: View {
    let max_index: Int = 6
    @State var index: Int = 1
    @State var offset: CGFloat = 0
    var width = UIScreen.main.bounds.width
    @StateObject private var vm: MyBag = MyBag()
    var body: some View {
        VStack(alignment: .center, spacing: 8)  {
            AppBar(index: $index, offset: $offset)
            GeometryReader { g in
                HStack(spacing: 0)  {
                    
                    BagGiftView()
                        .frame(width: g.frame(in: .global).width)
                    
                    BagAnyView(list: vm.bagAvatarBorderList)
                        .frame(width: g.frame(in: .global).width)
                    BagAnyView(list: vm.bagJoinEffectList)
                        .frame(width: g.frame(in: .global).width)
                    BagAnyView(list: vm.bagMicStatusEffectList)
                        .frame(width: g.frame(in: .global).width)
                    BagAnyView(list: vm.bagInfoFloatList)
                        .frame(width: g.frame(in: .global).width)
                    BagAnyView(list: vm.bagCardList)
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
        .navigationTitle("我的背包")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.getBagGift(type: 2)
            vm.getBagGift(type: 10)
            vm.getBagGift(type: 4)
            vm.getBagGift(type: 6)
            vm.getBagGift(type: 7)
            vm.getBagGift(type: 9)
            
            
            Defaults.reset(.me_bag_avatar_border_selected_id)
            Defaults.reset(.me_bag_join_effect_selected_id)
            Defaults.reset(.me_bag_mic_status_effect_selected_id)
            Defaults.reset(.me_bag_info_float_selected_id)
            Defaults.reset(.me_bag_dynamic_card_selected_id)
        }
        .environmentObject(vm)
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
        case 3:
            offset = 2 * -width
        case 4:
            offset = 3 * -width
        case 5:
            offset = 4 * -width
        default:
            offset = 5 * -width
        }

    }
}

struct AppBar: View {
    @Binding var index: Int
    @Binding var offset: CGFloat
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 10)  {
                TopButtonViewItem(text: "背包礼物", isSelected: index == 1) {
                    index = 1
                    offset = 0
                }
                TopButtonViewItem(text: "头像框", isSelected: index == 2) {
                    index = 2
                    offset = -width
                }
                TopButtonViewItem(text: "进场特效", isSelected: index == 3) {
                    index = 3
                    offset = 2 * -width
                }
                
                TopButtonViewItem(text: "麦位动效", isSelected: index == 4) {
                    index = 4
                    offset = 3 * -width
                }
                
                TopButtonViewItem(text: "资料浮萍", isSelected: index == 5) {
                    index = 5
                    offset = 4 * -width
                }
                
                TopButtonViewItem(text: "动态卡片", isSelected: index == 6) {
                    index = 6
                    offset = 5 * -width
                }
                
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}


struct TopButtonViewItem: View {
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
                    .font(.system(size: isSelected ? 18 : 16, weight: isSelected ? .bold : .medium))
                    .lineLimit(1)
                
                Capsule()
                    .fill(isSelected ? .gray : .clear)
                    .frame(height: 4)
            }
        })
        
    }
}

// MARK: 背包礼物
struct BagGiftView: View {
    let col = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    @EnvironmentObject var vm: MyBag
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: col, spacing: 12, content: {
                ForEach(vm.bagGiftList, id: \.self) { item in
                    BagGiftViewItem(img: item.show_img, name: item.name)
                }
            })
        })
        .padding(.bottom, 18)
    }
}


struct BagGiftViewItem: View {
    let img: String
    let name: String
    var body: some View {
        VStack(alignment: .center, spacing: 2)  {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.982, green: 0.982, blue: 0.997))
                .frame(width: 100, height: 100)
                .overlay(content: {
                    KFImageView(imageUrl: img)
                        .frame(width: 80, height: 80)
                })
            Text(name)
                .foregroundColor(.black)
                .font(.system(size: 15))
        }
    }
}



struct BagAnyView: View {
    let col = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    var list: [bagModel.data.list]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: col, spacing: 12, content: {
                ForEach(list, id: \.self) { item in
                    BagAvatarBorderViewItem(item: item)
                }
            })
        })
        .padding(.bottom, 18)
    }
}


struct BagAvatarBorderViewItem: View {
    let item: bagModel.data.list
//    @Binding var selectedId: Int
    @State private var showAlert: Bool = false
//    @StateObject private var vm: MyBag = MyBag()
    @EnvironmentObject var vm: MyBag
    var body: some View {
        VStack(alignment: .center, spacing: 2)  {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.982, green: 0.982, blue: 0.997))
                
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .overlay(content: {
                    KFImageView(imageUrl: item.show_img)
                        .frame(width: 80, height: 80)
                })
                .overlay(alignment: .bottom, content: {
                    HStack(alignment: .center, spacing: 0)  {
                        Spacer()
                        Text("到期时间\(item.title)")
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                            .lineLimit(1)
                        Spacer()
                    }
                    .background(Color.gray)
                })
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(alignment: .topLeading, content: {
                    if item.is_dress == 1 {
                        Image(.roomXuanzhongic)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(4)
                    }
                })
                .padding(3)
                .background(item.is_dress == 1 ? Color.purple.opacity(0.5) : Color.clear)
                .cornerRadius(10)
                .onTapGesture {
                    showAlert.toggle()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(item.is_dress == 1 ? "是否取消装扮？" : "是否选择这个装扮"), primaryButton: .default(Text("确定"), action: {
                        vm.getDress_up(id: item.target_id, type: item.is_dress == 1 ? 2 : 1) { msg in
                            vm.getBagGift(type: item.type)
                            ProgressHUD.succeed(msg, delay: 1)
                        }
                    }), secondaryButton: .cancel())
                }
            
            Text(item.name)
                .foregroundColor(.gray)
                .font(.system(size: 13))
        }
    }
}



#Preview {
    NavigationView {
        MyBagView()
    }
}

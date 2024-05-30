//
//  DressShopView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/20.
//

import SwiftUI

import Defaults
import ProgressHUD
import SDWebImageSwiftUI



// Color(red: 0.747, green: 0.632, blue: 0.992)
// Color(red: 0.466, green: 0.424, blue: 0.815)

// Color(red: 0.927, green: 0.536, blue: 0.667)
// Color(red: 0.866, green: 0.446, blue: 0.659)

// Color(red: 0.982, green: 0.982, blue: 0.997)


enum dressType {
    case txk
    case jctx
    case mwdx
    case zlfp
    case dtkp
}

struct DressShopView: View {
    let max_index: Int = 5
    @State var index: Int = 1
    @State var offset: CGFloat = 0
    var width = UIScreen.main.bounds.width
    @StateObject private var vm: DressShop = DressShop()
    @Default(.me_dress_preview_svga_url) var me_dress_preview_svga_url
    @Default(.me_dress_preview_svga_url_over) var me_dress_preview_svga_url_over
    var body: some View {
        ZStack(alignment: .center) {
            
            VStack(alignment: .center, spacing: 0)  {
                ZStack(alignment: .center) {
                    Image(.storeImgBackground)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
    //                    .edgesIgnoringSafeArea(.top)
                        
                    
                    
                    ZStack(alignment: .center) {
                        KFImageView_Fill(imageUrl: UserCache.shared.getUserInfo()?.avatar ?? "")
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())

                        if !me_dress_preview_svga_url.isEmpty {
//                            UserInfoAvatarBorder(avatarBorder: me_dress_preview_svga_url, size: 70)
                            SVGAPlayerView33(svgaSource: me_dress_preview_svga_url)
                                .frame(width: 90, height: 90)
//                            Text("SVGA EDIT")
                        }
                        
                        
                    }
                    
                }
                .padding(.bottom, 12)
    //            .scaleEffect(1.2)
    //            .offset(y: 20)

                VStack(alignment: .center, spacing: 8)  {
                    AppBar_DressShop(index: $index, offset: $offset)
                    GeometryReader { g in
                        HStack(spacing: 0)  {

                            
                            DressView(list: vm.dressList_AvatarBorder, index: $index, dress_type: .txk)
                                .frame(width: g.frame(in: .global).width)

                            
                            DressView(list: vm.dressList_JoinEffect, index: $index, dress_type: .jctx)
                                .frame(width: g.frame(in: .global).width)

                            
                            DressView(list: vm.dressList_MicStatusEffect, index: $index, dress_type: .mwdx)
                                .frame(width: g.frame(in: .global).width)
                            
                            DressView(list: vm.dressList_InfoFloat, index: $index, dress_type: .zlfp)
                                .frame(width: g.frame(in: .global).width)
                            
                            DressView(list: vm.dressList_DynamicCard, index: $index, dress_type: .dtkp)
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
                .padding(.vertical, 15)
                .background(Color.white)
                .cornerRadius(10)
                .offset(y: -20)
                

                
            }
            .edgesIgnoringSafeArea(.bottom)
            .animation(.default)
                        
            
        }
        .navigationTitle("装扮商城")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(vm)
        .onAppear {
            initialize()
        }
        .onDisappear {
            initialize()
        }
        .overlay {
            if !me_dress_preview_svga_url_over.isEmpty &&
                me_dress_preview_svga_url_over != "http://www.msyuyin.cn/upload/emoji/fuping/qqxg.svga" {
                SVGAPlayerView33(svgaSource: me_dress_preview_svga_url_over, loop: 0)
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                    .offset(y: -300)
                    .overlay(alignment: .bottom) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                            .onTapGesture {
                                me_dress_preview_svga_url_over = ""
                            }
                    }
                    .edgesIgnoringSafeArea([.leading, .trailing])
            }
        }
    }
    
    private func initialize() {
        me_dress_preview_svga_url = ""
        me_dress_preview_svga_url_over = ""
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
        default:
            offset = 4 * -width
        }

    }
}

#Preview {
    NavigationView {
        DressShopView()
    }
}


struct SVGAShow_Gift_ForDressShop: View {
    @State var url: String
    @State var loops: Int = 0
    var body: some View {
//        SVGAPlayerView_Gift(url: URL(string: url)!, loops: loops)
//        Text("SVGA EDIT")
        SVGAPlayerView33(svgaSource: url, loop: loops)
    }
}

struct DressView: View {
    @EnvironmentObject var vm: DressShop
    let col = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    var list: [dressModel.data]
    @State private var selectedItem: dressModel.data = .init(id: 0, name: "", title: "", price: 0, score: 0, level: 0, show_img: "", img1: "", expire: 0, num: 0)
    @State private var selected_price_day: String = "300/3天"
    @State private var price_day: [String] = ["300/3天", "700/7天", "1500/15天"]
    @Default(.me_dress_preview_svga_url) var me_dress_preview_svga_url
    @Binding var index: Int
    @State var dress_type: dressType
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: col, spacing: 12, content: {
                ForEach(list, id: \.self) { item in
                    DressShopViewItem(item: item, selectedItem: $selectedItem, index: $index, dress_type: dress_type)
                }
            })
        })
        .padding(.bottom, 18)
        .edgesIgnoringSafeArea(.bottom)
        .overlay(alignment: .bottom) {
            HStack(alignment: .center, spacing: 0)  {
                Picker(selection: $selected_price_day) {
                    ForEach(price_day, id: \.self) { t in
                        Text(t)
                    }
                } label: {
                    Text("0/0天")
                        
                }
                .tint(.white)
                Spacer()
                
                Button(action: {
                    vm.buyDress(id: selectedItem.id, option_id: selectedItem.expire, price: selectedItem.price) { msg in
                        ProgressHUD.succeed(msg, delay: 1)
                    }
                }, label: {
                    Text("购买")
                        .foregroundColor(.white)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(LinearGradient(colors: [Color(red: 0.927, green: 0.536, blue: 0.667), Color(red: 0.866, green: 0.446, blue: 0.659)], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(6)
                })
                
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            .background(LinearGradient(colors: [Color(red: 0.747, green: 0.632, blue: 0.992), Color(red: 0.466, green: 0.424, blue: 0.815)], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .padding(.horizontal)
            
        }
    }
}






struct AppBar_DressShop: View {
    @Binding var index: Int
    @Binding var offset: CGFloat
    var width = UIScreen.main.bounds.width
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 10)  {
                TopButtonViewItem(text: "头像框", isSelected: index == 1) {
                    index = 1
                    offset = 0
                }
                TopButtonViewItem(text: "进场特效", isSelected: index == 2) {
                    index = 2
                    offset = -width
                }
                TopButtonViewItem(text: "麦位动效", isSelected: index == 3) {
                    index = 3
                    offset = 2 * -width
                }
                
                TopButtonViewItem(text: "资料浮萍", isSelected: index == 4) {
                    index = 4
                    offset = 3 * -width
                }
                
                TopButtonViewItem(text: "动态卡片", isSelected: index == 5) {
                    index = 5
                    offset = 4 * -width
                }
                
                
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        
        
    }
}


// MARK: 商品ITEM
struct DressShopViewItem: View {
    let item: dressModel.data
    @Binding var selectedItem: dressModel.data
    @Binding var index: Int
    @State var dress_type: dressType
    
    @Default(.me_dress_preview_svga_url) var me_dress_preview_svga_url
    @Default(.me_dress_preview_svga_url_over) var me_dress_preview_svga_url_over
    
    var body: some View {
        VStack(alignment: .center, spacing: 2)  {

                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.982, green: 0.982, blue: 0.997))
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .overlay(content: {
                    KFImageView(imageUrl: item.show_img)
                        .frame(width: 80, height: 80)
                })
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(alignment: .topLeading, content: {
                    if selectedItem == item {
                        Image(.roomXuanzhongic)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(4)
                    }
                })
                .padding(3)
                .background(selectedItem == item ? Color.purple.opacity(0.5) : Color.clear)
                .cornerRadius(10)
                .onTapGesture {
                    selectedItem = item
                    me_dress_preview_svga_url = ""
                    me_dress_preview_svga_url_over = ""
                    if dress_type == .txk || dress_type == .mwdx {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            me_dress_preview_svga_url = item.img1
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            me_dress_preview_svga_url_over = item.img1
                        }
                    }
                    print(item.img1)
                }
            
            Text(item.name)
                .foregroundColor(.gray)
                .font(.system(size: 13))
            HStack(alignment: .center, spacing: 0)  {
                Image(.roomGpGbZhuanshi)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                Text(String(item.price))
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
        }
    }
}




class DressShop: ObservableObject {
    @Published var dressList_AvatarBorder: [dressModel.data] = []
    @Published var dressList_JoinEffect: [dressModel.data] = []
    @Published var dressList_MicStatusEffect: [dressModel.data] = []
    @Published var dressList_InfoFloat: [dressModel.data] = []
    @Published var dressList_DynamicCard: [dressModel.data] = []
    
    
    init() {
        self.getDressList(cate_id: 4)
        self.getDressList(cate_id: 6)
        self.getDressList(cate_id: 7)
        self.getDressList(cate_id: 9)
        self.getDressList(cate_id: 10)
    }
    
    
    // MARK: 获取装扮列表
    func getDressList(page: Int = 1, cate_id: Int) {
        NetworkTools.requestAPI(convertible: "api/goods/getGoodsList?page=\(page)&cate_id=\(cate_id)", responseDecodable: dressModel.self) { result in
            DispatchQueue.main.async {
                switch(cate_id) {
                case 4:
                    self.dressList_AvatarBorder  = result.data
                case 6:
                    self.dressList_JoinEffect = result.data
                case 7:
                    self.dressList_MicStatusEffect = result.data
                case 9:
                    self.dressList_InfoFloat = result.data
                default:
                    self.dressList_DynamicCard = result.data
                }
            }
        } failure: { _ in
            
        }
    }
    
    
    // MARK: 获取装扮列表
    func buyDress(id: Int, option_id: Int, price: Int, completion: @escaping (String) -> Void) {
        
        NetworkTools.requestAPI(convertible: "api/goods/BuyGoods",
                                method: .post,
                                parameters: [
                                    "id": id,
                                    "option_id": option_id,
                                    "price": price
                                ],
                                responseDecodable: baseModel.self) { result in
            completion(result.message)
        } failure: { _ in
            
        }
    }
    
}



struct dressModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable, Hashable {
        let id: Int
        let name: String
        let title: String
        let price: Int
        let score: Int
        let level: Int
        let show_img: String
        let img1: String
        let expire: Int
        let num: Int
    }
}

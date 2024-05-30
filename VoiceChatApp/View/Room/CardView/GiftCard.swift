//
//  GiftCard.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/10.
//

import SwiftUI

import SDWebImageSwiftUI
import ProgressHUD
import Defaults
import Popovers
import Alamofire
import DynamicColor
 





struct GiftCard: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var meViewModel: MeViewModel = MeViewModel()
    @StateObject private var vmForUserInfoMain: UserInfoMain = UserInfoMain()
    @StateObject var viewModel: GiftModel = GiftModel()
    @EnvironmentObject var viewModelRoomModel: RoomModel
    
    let roomId: Int
    @State var type: giftType = .normal
    @State private var selection_gift_num: GiftNumModel = GiftNumModel(name: "1一心一意", num: "1")
//    @State private var selected_gift_id: Int = 0
    
//    @State private var selected_gift_item: GiftListModel.dataItem.list? = nil
    @Default(.room_gift_card) var room_gift_card
    
    @State private var selectedUserIDs: Set<Int> = []
    @State private var selectedGift_normal: GiftListModel.dataItem.list = GiftListModel.dataItem.list(id: 0, name: "", e_name: "", type: 0, vip_level: 0, hot: 0, is_play: 0, price: 0, sfxs: "", img: "", show_img: "", show_img2: "", gifts_xq: "", gifts_url: "", sort: 0, enable: 0, addtime: 0)
    @State private var selectedGift_luck: GiftLuckListModel.data = GiftLuckListModel.data(box_type: 0, price: 0, img: "", name: "", url: "", liwu: [])
    @State private var selectedGift_bag: GiftBagListModel.data.list = GiftBagListModel.data.list(id: 0, user_id: 0, type: 0, target_id: 0, name: "", show_img: "", gifurl: "", num: 0, price: 0)
    
    
    @State var filterOptions: [GiftNumModel] = [
        GiftNumModel(name: "1314一生一世", num: "1314"),
        GiftNumModel(name: "520我爱你", num: "520"),
        GiftNumModel(name: "188要抱抱", num: "188"),
        GiftNumModel(name: "66好运666", num: "66"),
        GiftNumModel(name: "10十全十美", num: "10"),
        GiftNumModel(name: "1一心一意", num: "1"),
    ]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
//            personListView
            
            giftList
                
            GiftBottomButtonView
                
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                viewModelRoomModel.getMicrophoneList()
            }
        }
        .onChange(of: Defaults[.room_gift_status]) { newValue in
            if !newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onChange(of: room_gift_card) { newValue in
            if newValue {
                viewModelRoomModel.getMicrophoneList()
            }
        }
        
        
    }
    
}



// MARK: 麦位列表 - 礼物
//extension GiftCard {
//    var personListView: some View {
//        HStack(alignment: .center, spacing: 12)  {
//            ScrollView(.horizontal) {
//                HStack(spacing: 8)  {
//                    ForEach(Array(viewModelRoomModel.microphoneList.enumerated()), id: \.element) { (index, item) in
//                        if item.status == 2 {
//                            personItemView(item: item, isSelected: selectedUserIDs.contains(item.userId ?? 0), pos: index) {
//                                if selectedUserIDs.contains(item.userId ?? 0) {
//                                    selectedUserIDs.remove(item.userId ?? 0)
//                                } else {
//                                    selectedUserIDs.insert(item.userId ?? 0)
//                                }
//                            }
//                        }
//                    }
//                    Spacer()
//                }
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                if selectedUserIDs == Set(viewModelRoomModel.microphoneList_Array.compactMap { $0.userId }) {
//                    selectedUserIDs = []
//                } else {
//                    selectedUserIDs = Set(viewModelRoomModel.microphoneList_Array.compactMap { $0.userId })
//                }
//                
//            }, label: {
//                if selectedUserIDs == Set(viewModelRoomModel.microphoneList_Array.compactMap { $0.userId }) {
//                    Image(.roomLiwuQuanmaixuanzhong)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 45, height: 45)
//                } else {
//                    AnimatedImage(name: "room_liwu_quanmai_xhdpi.gif")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 45, height: 45)
//                        .overlay(content: {
//                            Text("全麦")
//                                .foregroundColor(.pink)
//                                .font(.system(size: 12, weight: .medium))
//                        })
//                    
//                }
//                
//
//            })
//        }
//        .frame(width: UIScreen.main.bounds.width * 0.95)
//        .padding(.leading, 12)
//        .animation(.spring())
//    }
//}




struct personItemView: View {
    @State var item: MicrophoneListModel.microphoneList
    var isSelected: Bool
    var pos: Int
    let action: () -> ()
    let selectedColor = Color(hexString: "#D894F1")
    var body: some View {
        KFImageView(imageUrl: item.avatar ?? "")
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .padding(2)
            .background(isSelected ? selectedColor : Color.clear)
            .clipShape(Circle())
            .overlay(alignment: .bottom, content: {
                
                if pos != 0 {
                    Circle()
                        .fill(isSelected ? selectedColor : Color.white)
                        .frame(width: 12, height: 12)
                        .overlay {
                            Text("\(pos)")
                                .foregroundColor(isSelected ? .white : .black)
                                .font(.system(size: 10))
                        }
                } else {
                    Capsule()
                        .fill(isSelected ? selectedColor : Color.white)
                        .frame(width: 20, height: 12)
                        .overlay {
                            Text("主持")
                                .foregroundColor(isSelected ? .white : .black)
                                .font(.system(size: 8))
                        }
                }
            })
            .onTapGesture {
                action()
            }
    }
}


struct giftModel: Identifiable {
    let id: String = UUID().uuidString
    let img: String
    let name: String
    let price: String
}

struct giftTypeButtonModifier: ViewModifier {
    let isSelected: Bool
    let action: () -> ()
    func body(content: Content) -> some View {
        content
            .foregroundColor( isSelected ? Color.yellow : Color.gray)
            .font(.system(size: 17, weight: isSelected ? .bold : .medium ))
            .padding(.horizontal, 5)
            .padding(.bottom, 6)
            .onTapGesture {
                action()
            }
    }
}

enum giftType {
    case normal, bag, luck
}






// MARK: 礼物列表 + 标签
extension GiftCard {
    
    var giftList: some View {
        VStack(alignment: .leading, spacing: 4)  {
            HStack(spacing: 10) {
                Text("普通")
                    .giftTypeButtonFormatting(isSelected: type == .normal) {
                        type = .normal
                    }
                
                Text("幸运")
                    .giftTypeButtonFormatting(isSelected: type == .luck) {
                        type = .luck
                    }
                
                Text("背包")
                    .giftTypeButtonFormatting(isSelected: type == .bag) {
                        type = .bag
                    }
            }
            .padding(.horizontal, 8)
            
            
            switch(type) {
            case .luck:
                giftList_type_for_luck
            case .bag:
                giftList_type_for_bag
            default:
                giftList_type
            }
            
        }
        .frame(height: 260)
    }
    
}

extension GiftCard {
    // 普通
    var giftList_type: some View {
        TabView {
            ForEach(0..<viewModel.giftListArray2.count, id: \.self) { groupIndex in
                VStack(alignment: .center, spacing: 6)  {
                    ForEach(viewModel.giftListArray2[groupIndex], id: \.self) { row in
                        HStack(alignment: .center, spacing: 0)  {
                            ForEach(row, id: \.self) { item in
                                Spacer()
                                giftItemView(item: item, selectedGift_normal: $selectedGift_normal) {
                                    selectedGift_normal = item
                                }
                                Spacer()
                            }
                            if row.count < 4 {
                                ForEach(4-row.count..<4, id: \.self) { other in
                                    Rectangle()
                                        .frame(minWidth: 80, minHeight: 100)
                                        .hidden()
                                }
                            }
                            
                        }
                        if viewModel.giftListArray2[groupIndex].count == 1 {
                            HStack(alignment: .center, spacing: 0)  {
                                ForEach(0..<4, id: \.self) { other in
                                    Rectangle()
                                        .frame(minWidth: 80, minHeight: 100)
                                            .hidden()
                                }
                            }
                            
                        }
                    }
                }
                .tag(groupIndex)
                .tabItem {
                    Text("Tab \(groupIndex + 1)")
                }
            }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(width: UIScreen.main.bounds.width)
    }
    
    // 幸运/箱子
    var giftList_type_for_luck: some View {
        TabView {
            ForEach(0..<viewModel.giftListArray_for_luck.count, id: \.self) { groupIndex in
                VStack(alignment: .center, spacing: 6)  {
                    ForEach(viewModel.giftListArray_for_luck[groupIndex], id: \.self) { row in
                        HStack(alignment: .center, spacing: 0)  {
                            ForEach(row, id: \.self) { item in
                                Spacer()
                                giftItemView_Luck(item: item, selectedGift_luck: $selectedGift_luck) {
                                    selectedGift_luck = item
                                }
                                Spacer()
                            }
                            if row.count < 4 {
                                ForEach(4-row.count..<4, id: \.self) { other in
                                    Rectangle()
                                        .frame(minWidth: 80, minHeight: 100)
                                        .hidden()
                                }
                            }
                            
                        }
                        if viewModel.giftListArray_for_luck[groupIndex].count == 1 {
                            HStack(alignment: .center, spacing: 0)  {
                                ForEach(0..<4, id: \.self) { other in
                                    Rectangle()
                                        .frame(minWidth: 80, minHeight: 100)
                                            .hidden()
                                }
                            }
                            
                        }
                    }
                }
                .tag(groupIndex)
                .tabItem {
                    Text("Tab \(groupIndex + 1)")
                }
            }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(width: UIScreen.main.bounds.width)
    }
    
    // 背包
    var giftList_type_for_bag: some View {
        TabView {
            ForEach(0..<viewModel.giftListArray_for_bag.count, id: \.self) { groupIndex in
                VStack(alignment: .center, spacing: 6)  {
                    ForEach(viewModel.giftListArray_for_bag[groupIndex], id: \.self) { row in
                        HStack(alignment: .center, spacing: 0)  {
                            ForEach(row, id: \.self) { item in
                                Spacer()
                                giftItemView_Bag(item: item, selectedGift_bag: $selectedGift_bag) {
                                    selectedGift_bag = item
                                }
                                Spacer()
                            }
                            if row.count < 4 {
                                ForEach(4-row.count..<4, id: \.self) { other in
                                    Rectangle()
                                        .frame(minWidth: 80, minHeight: 100)
                                        .hidden()
                                }
                            }
                            
                        }
                        if viewModel.giftListArray_for_bag[groupIndex].count == 1 {
                            HStack(alignment: .center, spacing: 0)  {
                                ForEach(0..<4, id: \.self) { other in
                                    Rectangle()
                                        .frame(minWidth: 80, minHeight: 100)
                                            .hidden()
                                }
                            }
                            
                        }
                    }
                }
                .tag(groupIndex)
                .tabItem {
                    Text("Tab \(groupIndex + 1)")
                }
            }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(width: UIScreen.main.bounds.width)
    }
}




struct giftItemView_Bag: View {
    let item: GiftBagListModel.data.list
    @Binding var selectedGift_bag: GiftBagListModel.data.list
    let action: () -> ()
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(
                selectedGift_bag == item ?
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.849, green: 0.409, blue: 0.801), Color(red: 0.56, green: 0.333, blue: 0.896)]), startPoint: .top, endPoint: .bottom) :
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]), startPoint: .top, endPoint: .bottom),
                lineWidth: 1
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.136, green: 0.145, blue: 0.193))
            )
            .overlay {
                VStack(spacing: 5)  {
                    KFImageView(imageUrl: item.show_img)
                        .frame(width: 40, height: 40)
                    Text(item.name)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    HStack(alignment: .center, spacing: 4)  {
                        Image(.roomGpGbZhuanshi)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                        Text("\(String(item.price))")
                            .foregroundColor(.gray)
                            .font(.system(size: 11, weight: .light))
                    }
                }
            }
            .overlay(alignment: .topTrailing, content: {
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(hexString: "#6C7CF4"), Color(hexString: "#785ED8")]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 10, height: 14)
                    .overlay {
                        Text("\(String(selectedGift_bag.num))")
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                    }
            })
            .onTapGesture {
                action()
            }
    }
}

struct giftItemView: View {
    let item: GiftListModel.dataItem.list
    @Binding var selectedGift_normal: GiftListModel.dataItem.list
    let action: () -> ()
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(
                selectedGift_normal == item ?
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.849, green: 0.409, blue: 0.801), Color(red: 0.56, green: 0.333, blue: 0.896)]), startPoint: .top, endPoint: .bottom) :
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]), startPoint: .top, endPoint: .bottom),
                lineWidth: 1
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.136, green: 0.145, blue: 0.193))
            )
            .overlay {
                VStack(spacing: 5)  {
                    KFImageView(imageUrl: item.img)
                        .frame(width: 40, height: 40)
                    Text(item.name)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    HStack(alignment: .center, spacing: 4)  {
                        Image(.roomGpGbZhuanshi)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                        Text("\(String(item.price))")
                            .foregroundColor(.gray)
                            .font(.system(size: 11, weight: .light))
                    }
                }
            }
            .onTapGesture {
                action()
            }
    }
}

struct giftItemView_Luck: View {
    let item: GiftLuckListModel.data
    @Binding var selectedGift_luck: GiftLuckListModel.data
    let action: () -> ()
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(
                selectedGift_luck == item ?
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.849, green: 0.409, blue: 0.801), Color(red: 0.56, green: 0.333, blue: 0.896)]), startPoint: .top, endPoint: .bottom) :
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]), startPoint: .top, endPoint: .bottom),
                lineWidth: 1
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.136, green: 0.145, blue: 0.193))
            )
            .overlay {
                VStack(spacing: 5)  {
                    KFImageView(imageUrl: item.img)
                        .frame(width: 40, height: 40)
                    Text(item.name)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    HStack(alignment: .center, spacing: 4)  {
                        Image(.roomGpGbZhuanshi)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                        Text("\(String(item.price))")
                            .foregroundColor(.gray)
                            .font(.system(size: 11, weight: .light))
                    }
                }
            }
            .onTapGesture {
                action()
            }
    }
}



struct GiftNumModel: Decodable, Hashable {
    let name: String
    let num: String
}


// MARK: 底部按钮
extension GiftCard {
    var GiftBottomButtonView: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.08, green: 0.09, blue: 0.141).ignoresSafeArea()
            
            HStack(alignment: .center, spacing: 3)  {
                HStack(alignment: .center, spacing: 6)  {
                    HStack(alignment: .center, spacing: 3)  {
                        Image(.icMeDressupGoldcoin)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                        Spacer()
                        Text("\(meViewModel.userinfo?.mibi ?? "0")")
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .medium))
                            .lineLimit(1)
                    }
                    .frame(height: 30)
                    .padding(.horizontal, 6)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(30)
                    .modifier(PointWithdrawalViewFullCover(PointsNumber: meViewModel.userinfo?.mibi ?? "0"))
                    
                    
                    NavigationLink(
                        destination: DiamondTopUpView(viewModel: meViewModel),
                        label: {
                        HStack(alignment: .center, spacing: 3)  {
                            Image(.icMeDressupDiamonds)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                            Spacer()
                            Text("\(meViewModel.userinfo?.balance ?? "0")")
                                .foregroundColor(.white)
                                .font(.system(size: 10, weight: .medium))
                                .lineLimit(1)
                            
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        .frame(height: 30)
                        .padding(.horizontal, 6)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(30)
                    })
                    
                    
                }
                
                Spacer()
                
                HStack(alignment: .center, spacing: 6)  {
                    
                    Templates.Menu {
                        Templates.MenuButton(title: filterOptions[0].name) {
                            selection_gift_num = filterOptions[0]
                        }
                        Templates.MenuButton(title: filterOptions[1].name) {
                            selection_gift_num = filterOptions[1]
                        }
                        Templates.MenuButton(title: filterOptions[2].name) {
                            selection_gift_num = filterOptions[2]
                        }
                        Templates.MenuButton(title: filterOptions[3].name) {
                            selection_gift_num = filterOptions[3]
                        }
                        Templates.MenuButton(title: filterOptions[4].name) {
                            selection_gift_num = filterOptions[4]
                        }
                        Templates.MenuButton(title: filterOptions[5].name) {
                            selection_gift_num = filterOptions[5]
                        }
                        
                    } label: { fade in
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 60, height: 30)
                            .overlay(alignment: .trailing) {
                                HStack(alignment: .center, spacing: 2)  {
                                    Text(selection_gift_num.num)
                                    Image(systemName: fade ? "chevron.down" : "chevron.up")
                                }
                                .foregroundColor(.purple)
                                .font(.system(size: 12))
                                .padding(.horizontal, 3)
                            }
                            .padding(1)
                            .background(Color.yellow)
                            .cornerRadius(30)
                            .opacity(fade ? 0.5 : 1)
                    }
                    
                    
//                    .frame(width: 100, height: 30)
//                    .background(Color.white.opacity(0.3))
//                    .cornerRadius(30)

                    
                    
                    Button(action: {
                            sendGift_function()
                    }, label: {
                        Text("赠送")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
//                            .padding(.vertical, 4)
//                            .padding(.horizontal, 10)
                            .frame(width: 60, height: 35)
                            .background(LinearGradient(colors: [Color(red: 0.834, green: 0.484, blue: 0.992), Color(red: 0.998, green: 0.623, blue: 0.879)], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(30)
                    })
                    
                    
                }
            }
            .padding(.horizontal, 8)
            
        }
        .frame(height: 30)
    }
    
    
    private func sendGift_function() {
        if !selectedUserIDs.isEmpty {
            if selectedUserIDs.contains(UserCache.shared.getUserInfo()?.userId ?? 0) {
                ProgressHUD.error("不能送给自己礼物", delay: 1)
                return
            }
            if type == .normal && selectedGift_normal.id != 0 {
                
                let parms: Parameters = [
                    "id": String(selectedGift_normal.id),
                    "roomId": String(roomId),
                    "user_id": UserCache.shared.getUserInfo()?.userId,
                    "fromUid": Array(selectedUserIDs)[0],
                    "num": String(selection_gift_num.num),
                    "pack_type": "2",
                ]
            
                NetworkTools.requestAPI(convertible: "/api/gift_queue",
                                        method: .post,
                                        parameters: [
                                            "id": String(selectedGift_normal.id),
                                            "roomId": String(roomId),
                                            "user_id": UserCache.shared.getUserInfo()?.userId,
                                            "fromUid": Array(selectedUserIDs)[0],
                                            "num": String(selection_gift_num.num),
                                            "pack_type": "2",
                                        ],
                                        responseDecodable: baseModel.self) { result in
                    
                } failure: { _ in
                    
                }

//                AF.request("\(baseUrl.url)api/gift_queue",
//                           method: .post,
//                           parameters: parms,
//                ).responseString { res in
//                    switch res.result {
//                    case .success(let jsonString):
//                        do {
//                            if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
//                                let json = try JSON(data: dataFromString)
//                                let tempMsg: String = """
//                                {
//                                    "MicPos": -1,
//                                    "adminMenuEvent": null,
//                                    "boxGift": null,
//                                    "fromUser": {
//                                        "goldImg": "",
//                                        "headImgUrl": "\(UserCache.shared.getUserInfo()?.headimgurl ?? "")",
//                                        "is_admin": false,
//                                        "is_answer": false,
//                                        "ltk_right": "",
//                                        "nickColor": "#ffffff",
//                                        "nickName": "\(UserCache.shared.getUserInfo()?.nickname ?? "")",
//                                        "sex": 2,
//                                        "star_img": "",
//                                        "user_id": "\(UserCache.shared.getUserInfo()?.userId)",
//                                        "vip_tx": ""
//                                    },
//                                    "gift": \(json["data"]),
//                                    "master_micPlaceInfo": null,
//                                    "message": null,
//                                    "messageType": 49,
//                                    "micList": \(viewModelRoomModel.microphoneList_Array_json)
//                                }
//                                """
//                                Task {
//                                    await agoraRTMManager.sendMessage(tempMsg)
//                                }
//                            }
//                        } catch {
//                            print("Error converting JSON string to JSON object: \(error)")
//                        }
//                    case .failure(let error):
//                        ProgressHUD.error(error.localizedDescription, delay: 1.5)
//                        print("gift_queue result error: \(error.localizedDescription)")
//                    }
//                }
            }
            else if type == .luck && selectedGift_luck.box_type != 0 {
                let parms: Parameters = [
                    "keysNum": String(selection_gift_num.num),
                    "fromuid": UserCache.shared.getUserInfo()?.userId,
                    "boxtype": String(selectedGift_luck.box_type),
                    "roomuid": String(roomId),
                    "price": String(selectedGift_luck.price)
                ]
                
                
                
//                AF.request("\(baseUrl.url)api/getAwardList", method: .post, parameters: parms, headers: HeaderUtility.headers)
//                    .responseString { res in
//                        switch res.result {
//                        case .success(let jsonString):
//                            do {
//                                if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
//                                    let json = try JSON(data: dataFromString)
//                                    print(json)
//                                    print("=================")
//                                    let gift_msg: String = """
//                                    {
//                                        "MicPos": -1,
//                                        "adminMenuEvent": null,
//                                        "boxGift": \(json["data"][0]["res"][0]),
//                                        "fromUser": {
//                                            "goldImg": "",
//                                            "headImgUrl": "\(UserCache.shared.getUserInfo()?.headimgurl ?? "")",
//                                            "is_admin": false,
//                                            "is_answer": false,
//                                            "ltk_right": "",
//                                            "nickColor": "#ffffff",
//                                            "nickName": "\(UserCache.shared.getUserInfo()?.nickname ?? "")",
//                                            "sex": 2,
//                                            "star_img": "",
//                                            "user_id": "\(UserCache.shared.getUserInfo()?.userId)",
//                                            "vip_tx": ""
//                                        },
//                                        "gift": null,
//                                        "master_micPlaceInfo": null,
//                                        "message": null,
//                                        "messageType": 59,
//                                        "micList": \(viewModelRoomModel.microphoneList_Array_json)
//                                    }
//                                    """
//                                    print(gift_msg)
//                                    
//                                    Task {
//                                        await agoraRTMManager.sendMessage(gift_msg)
//                                    }
//                                    
//                                }
//                            } catch {
//                                print("Error converting JSON string to JSON object: \(error)")
//                            }
//                        case .failure(let error):
//                            ProgressHUD.error(error.localizedDescription, delay: 1.5)
//                            print("getAwardList result error: \(error.localizedDescription)")
//                        }
//                    }
            }
            else if type == .bag && selectedGift_bag.id != 0 {
                let parms: Parameters = [
                    "id": String(selectedGift_bag.target_id),
                    "roomId": String(roomId),
                    "user_id": UserCache.shared.getUserInfo()?.userId,
                    "fromUid": Array(selectedUserIDs)[0],
                    "num": String(selection_gift_num.num),
                    "pack_type": String(selectedGift_bag.type),
                ]
//                AF.request("\(baseUrl.url)api/gift_queue", method: .post, parameters: parms, headers: HeaderUtility.headers).responseString { res in
//                    switch res.result {
//                    case .success(let jsonString):
//                        do {
//                            if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
//                                let json = try JSON(data: dataFromString)
//                                let tempMsg: String = """
//                                {
//                                    "MicPos": -1,
//                                    "adminMenuEvent": null,
//                                    "boxGift": null,
//                                    "fromUser": {
//                                        "goldImg": "",
//                                        "headImgUrl": "\(UserCache.shared.getUserInfo()?.headimgurl ?? "")",
//                                        "is_admin": false,
//                                        "is_answer": false,
//                                        "ltk_right": "",
//                                        "nickColor": "#ffffff",
//                                        "nickName": "\(UserCache.shared.getUserInfo()?.nickname ?? "")",
//                                        "sex": 2,
//                                        "star_img": "",
//                                        "user_id": "\(UserCache.shared.getUserInfo()?.userId)",
//                                        "vip_tx": ""
//                                    },
//                                    "gift": \(json["data"]),
//                                    "master_micPlaceInfo": null,
//                                    "message": null,
//                                    "messageType": 49,
//                                    "micList": \(viewModelRoomModel.microphoneList_Array_json)
//                                }
//                                """
//                                Task {
//                                    await agoraRTMManager.sendMessage(tempMsg)
//                                }
//                            }
//                        } catch {
//                            print("Error converting JSON string to JSON object: \(error)")
//                        }
//                    case .failure(let error):
//                        ProgressHUD.error(error.localizedDescription, delay: 1.5)
//                        print("gift_queue2 result error: \(error.localizedDescription)")
//                    }
//                }
                
            }
            else {
                ProgressHUD.error("选择分类和礼物要一致", delay: 1.5)
            }
            room_gift_card = false
        } else {
            ProgressHUD.error("请选择要赠送的人", delay: 1)
        }
    }
}


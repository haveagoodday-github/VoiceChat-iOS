//
//  LeaderboardView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/22.
//

import SwiftUI
import Kingfisher
import Alamofire
import ProgressHUD
import Parchment

struct RankingModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let user: [user]
        let top: [top]
        let other: [top]
        
        struct user: Decodable {
            let id: Int
            let headimgurl: String
            let nickname: String
            let sex: Int
            let sort: String
            let starsImg: String
            let goldImg: String
            let vip_img: String
            let exp: Int
        }
        
        struct top: Decodable {
            let exp: Int
            let user_id: Int
            let headimgurl: String
            let nickname: String
            let sex: Int
            let starsImg: String
            let goldImg: String
            let vip_img: String
        }
        
    }
}

struct RoomRankingModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let total: Int
        let list: [list]
        
        struct list: Decodable {
            let price: Int
            let roomId: Int
            let room: room
            
            struct room: Decodable {
                let id: Int
                let numid: String
                let room_name: String
                let room_cover: String
            }
        }
    }
}

class LeaderboardModel: ObservableObject {
    @Published var charmList_day_other: [RankingModel.data.top] = []
    @Published var charmList_day_top: [RankingModel.data.top] = []
    @Published var charmList_day_user: [RankingModel.data.user] = []
    
    @Published var charmList_week_other: [RankingModel.data.top] = []
    @Published var charmList_week_top: [RankingModel.data.top] = []
    @Published var charmList_week_user: [RankingModel.data.user] = []
    
    @Published var charmList_month_other: [RankingModel.data.top] = []
    @Published var charmList_month_top: [RankingModel.data.top] = []
    @Published var charmList_month_user: [RankingModel.data.user] = []
    
    @Published var wealthList_day_other: [RankingModel.data.top] = []
    @Published var wealthList_day_top: [RankingModel.data.top] = []
    @Published var wealthList_day_user: [RankingModel.data.user] = []
    
    @Published var wealthList_week_other: [RankingModel.data.top] = []
    @Published var wealthList_week_top: [RankingModel.data.top] = []
    @Published var wealthList_week_user: [RankingModel.data.user] = []
    
    @Published var wealthList_month_other: [RankingModel.data.top] = []
    @Published var wealthList_month_top: [RankingModel.data.top] = []
    @Published var wealthList_month_user: [RankingModel.data.user] = []
    
    
    @Published var roomList_day_top: [RoomRankingModel.data.list] = []
    @Published var roomList_week_top: [RoomRankingModel.data.list] = []
    @Published var roomList_month_top: [RoomRankingModel.data.list] = []
    
    
    
    init() {
        self.getRanking(classType: 1, type: 1)
        self.getRanking(classType: 1, type: 2)
        self.getRanking(classType: 1, type: 3)
        
        self.getRanking(classType: 2, type: 1)
        self.getRanking(classType: 2, type: 2)
        self.getRanking(classType: 2, type: 3)
        
        
        self.getRoomTopList(type: 1)
        self.getRoomTopList(type: 2)
        self.getRoomTopList(type: 3)
    }
    
    // MARK: 魅力榜/财富榜
    func getRanking(classType: Int, type: Int, userId: Int = UserCache.shared.getUserInfo()?.userId ?? 0) {
        
        NetworkTools.requestAPI(convertible: "api/ranking",
                                method: .post,
                                parameters: [
                                    "classType": classType,
                                    "type": type,
                                    "userId": userId
                                ],
                                responseDecodable: RankingModel.self) { result in
            DispatchQueue.main.sync {
                var top = result.data.top
                if top.count > 1 {
                    top.swapAt(0, 1)
                }
                switch(classType) {
                case 1:
                    switch(type) {
                    case 1:
                        self.charmList_day_top = top
                        self.charmList_day_user = result.data.user
                        self.charmList_day_other = result.data.other
                    case 2:
                        self.charmList_week_top = top
                        self.charmList_week_user = result.data.user
                        self.charmList_week_other = result.data.other
                    default:
                        self.charmList_month_top = top
                        self.charmList_month_user = result.data.user
                        self.charmList_month_other = result.data.other
                    }
                default:
                    switch(type) {
                    case 1:
                        self.wealthList_day_top = top
                        self.wealthList_day_user = result.data.user
                        self.wealthList_day_other = result.data.other
                    case 2:
                        self.wealthList_week_top = top
                        self.wealthList_week_user = result.data.user
                        self.wealthList_week_other = result.data.other
                    default:
                        self.wealthList_month_top = top
                        self.wealthList_month_user = result.data.user
                        self.wealthList_month_other = result.data.other
                    }
                }
            }
        } failure: { _ in
            
        }
    }
    
    
    func getRoomTopList(type: Int, page: Int = 1, pageSize: Int = 15) {
//        AF.request("\(baseUrl.newurl)api/room/room_rank?page=\(String(page))&type=\(String(type))&pageSize=\(String(pageSize))",
//                   method: .get
//        ).responseDecodable(of: RoomRankingModel.self) { res in
//            switch res.result {
//            case .success(let result):
//                debugPrint("getRoomTopList Success result：\(result.message)")
//                DispatchQueue.main.async {
//                    switch type {
//                    case 1:
//                        self.roomList_day_top = result.data.list
//                    case 2:
//                        self.roomList_week_top = result.data.list
//                    default:
//                        self.roomList_month_top = result.data.list
//                    }
//                }
//            case .failure(let error):
//                debugPrint("getRoomTopList error result: ", error.localizedDescription)
//                ProgressHUD.failed("\(type)类型，加载失败")
//            }
//        }
    }
    
}



struct LeaderboardView: View {
    let max_index: Int = 3
    @State var index: Int = 1
    @State var index_Index: Int = 1
    @State var offset: CGFloat = 0
    var width = UIScreen.main.bounds.width
    @StateObject private var vm: LeaderboardModel = LeaderboardModel()
    @Binding var closeSheet: Bool
    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .top) {
                Color(red: 0.246, green: 0.609, blue: 0.997).ignoresSafeArea()
                
                Image(.phb1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.95)
                    .offset(y: 50)
            }
            
            VStack(alignment: .center, spacing: 12)  {
                HStack(alignment: .center, spacing: 0)  {
                    Spacer()
                    AppBar_Leaderboard_Index(index: $index_Index, initIndex: $index)
                    Spacer()
                }
                .overlay(alignment: .leading) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(3)
                        .onTapGesture {
                            closeSheet.toggle()
                        }
                }
                .padding(.horizontal)
                
                VStack(alignment: .center, spacing: 8)  {
                    AppBar_Leaderboard(index: $index, offset: $offset)
                    
                    if index_Index != 3 {
                        GeometryReader { g in
                            HStack(spacing: 0)  {
                                
                                ListAnyView(item_top: index_Index == 1 ? vm.charmList_day_top : vm.wealthList_day_top,
                                            item_user: index_Index == 1 ? vm.charmList_day_user : vm.wealthList_day_user,
                                            item_other: index_Index == 1 ? vm.charmList_day_other : vm.wealthList_day_other,
                                            status: "本日榜单")
                                .frame(width: g.frame(in: .global).width)
                                
                                ListAnyView(item_top: index_Index == 1 ? vm.charmList_week_top : vm.wealthList_week_top,
                                            item_user: index_Index == 1 ? vm.charmList_week_user : vm.wealthList_week_user,
                                            item_other: index_Index == 1 ? vm.charmList_week_other : vm.wealthList_week_other,
                                            status: "本周榜单")
                                .frame(width: g.frame(in: .global).width)
                                
                                ListAnyView(item_top: index_Index == 1 ? vm.charmList_month_top : vm.wealthList_month_top,
                                            item_user: index_Index == 1 ? vm.charmList_month_user : vm.wealthList_month_user,
                                            item_other: index_Index == 1 ? vm.charmList_month_other : vm.wealthList_month_other,
                                            status: "本月榜单")
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
                        .padding(.top, 48)
                        .animation(.default)
                    } else {
                        GeometryReader { g in
                            HStack(spacing: 0)  {
                                
                                ListAnyView_Room(item_top: vm.roomList_day_top,
                                            item_user: [],
                                            item_other: [],
                                            status: "本日榜单")
                                .frame(width: g.frame(in: .global).width)
                                
                                
                                ListAnyView_Room(item_top: vm.roomList_week_top,
                                            item_user: [],
                                            item_other: [],
                                            status: "本周榜单")
                                .frame(width: g.frame(in: .global).width)
                                
                                ListAnyView_Room(item_top: vm.roomList_month_top,
                                            item_user: [],
                                            item_other: [],
                                            status: "本月榜单")
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
                        .padding(.top, 48)
                        .animation(.default)
                    }
                    
                }
            }
            .edgesIgnoringSafeArea(.bottom)
//            .animation(.default)
            
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

struct ListAnyView: View {
    var item_top: [RankingModel.data.top]
    var item_user: [RankingModel.data.user]
    var item_other: [RankingModel.data.top]
    let status: String
    var body: some View {
        VStack(alignment: .center, spacing: 20)  {
            HStack(alignment: .center, spacing: 24)  {
                ForEach(item_top.indices, id: \.self) { index in
                    if (item_top[index].headimgurl != "") {
                        ListAnyTopViewItem(index: index, headimgurl: item_top[index].headimgurl, username: item_top[index].nickname, sex: item_top[index].sex, exp: item_top[index].exp, userId: item_top[index].user_id)
                    } else {
                        ListAnyTopViewItem(index: index, headimgurl: "", username: "", sex: 0, exp: 0, userId: 0)
                    }
                }
            }
            
            VStack(alignment: .center, spacing: 8)  {
                
                ZStack(alignment: .leading) {
                    Image(.topList)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 80)
                    
                    HStack(alignment: .center, spacing: 12)  {
                        Text(status)
                            .foregroundColor(.yellow)
                            .font(.system(size: 24, weight: .bold))
                    }
                    .padding(.leading, 64)
                }
                VStack(alignment: .center, spacing: 8)  {
                    ForEach(item_other.indices, id: \.self) { index in
                        ListAnyUserViewItem(serial: index + 4, headimgurl: item_other[index].headimgurl, username: item_other[index].nickname, sex: item_other[index].sex, starsImg: item_other[index].starsImg, exp: item_other[index].exp)
                        Divider()
                    }
                }
                .padding(.horizontal, 8)
                Spacer()
                
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(alignment: .bottom) {
                
                ListAnyMyViewItem(serial: item_user.first?.sort ?? "", headimgurl: item_user.first?.headimgurl ?? "", username: item_user.first?.nickname ?? "", sex: item_user.first?.sex ?? 0, starsImg: item_user.first?.starsImg ?? "", exp: item_user.first?.exp ?? 0)
                
            }
            
        }
    }
}

struct ListAnyView_Room: View {
    var item_top: [RoomRankingModel.data.list]
    var item_user: [RankingModel.data.user]
    var item_other: [RankingModel.data.top]
    let status: String
    var body: some View {
        VStack(alignment: .center, spacing: 20)  {
            HStack(alignment: .center, spacing: 24)  {
                if item_top.count == 1 {
                    ListAnyTopViewItem_Room(index: 1, headimgurl: "", username: "", exp: 0)
                }
                ForEach(item_top.indices, id: \.self) { index in
                    if (item_top[index].room.room_cover != "") {
                        ListAnyTopViewItem_Room(index: index, headimgurl: item_top[index].room.room_cover, username: item_top[index].room.room_name, exp: item_top[index].price)
                    } else {
                        ListAnyTopViewItem_Room(index: index, headimgurl: "", username: "", exp: 0)
                    }
                }
                if item_top.count == 1 {
                    ListAnyTopViewItem_Room(index: 2, headimgurl: "", username: "", exp: 0)
                } else if item_top.count == 2 {
                    ListAnyTopViewItem_Room(index: 2, headimgurl: "", username: "", exp: 0)
                } else if item_top.count == 0 {
                    ListAnyTopViewItem_Room(index: 1, headimgurl: "", username: "", exp: 0)
                    ListAnyTopViewItem_Room(index: 0, headimgurl: "", username: "", exp: 0)
                    ListAnyTopViewItem_Room(index: 2, headimgurl: "", username: "", exp: 0)
                }
                
            }
            
            VStack(alignment: .center, spacing: 8)  {
                
                ZStack(alignment: .leading) {
                    Image(.topList)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 80)
                    
                    HStack(alignment: .center, spacing: 12)  {
                        Text(status)
                            .foregroundColor(.yellow)
                            .font(.system(size: 24, weight: .bold))
                    }
                    .padding(.leading, 64)
                }
                VStack(alignment: .center, spacing: 8)  {
                    ForEach(item_other.indices, id: \.self) { index in
                        ListAnyUserViewItem(serial: index + 4, headimgurl: item_other[index].headimgurl, username: item_other[index].nickname, sex: item_other[index].sex, starsImg: item_other[index].starsImg, exp: item_other[index].exp)
                        Divider()
                    }
                }
                .padding(.horizontal, 8)
                Spacer()
                
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(alignment: .bottom) {
                if !item_user.isEmpty {
                    ListAnyMyViewItem(serial: item_user.first?.sort ?? "", headimgurl: item_user.first?.headimgurl ?? "", username: item_user.first?.nickname ?? "", sex: item_user.first?.sex ?? 0, starsImg: item_user.first?.starsImg ?? "", exp: item_user.first?.exp ?? 0)
                }
            }
            
        }
    }
}

struct ListAnyMyViewItem: View {
    let serial: String
    let headimgurl: String
    let username: String
    let sex: Int
    let starsImg: String
    let exp: Int
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            Text(serial)
                .foregroundColor(.black)
            
            KFImage(URL(string: headimgurl))
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            Text(username)
            Image(sex == 2 ?"ic_chatroom_gender_boy" : "ic_chatroom_gender_gril")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
            KFImage(URL(string: starsImg))
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 0)  {
                Text(String(exp))
                    .foregroundColor(.orange)
                Text("魅力值")
                    .foregroundColor(.yellow)
                
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 32)
        .padding(.horizontal, 12)
        .background(Color.white)
        .overlay(alignment: .top) {
            Divider()
        }
        
        
    }
}

struct ListAnyUserViewItem: View {
    let serial: Int
    let headimgurl: String
    let username: String
    let sex: Int
    let starsImg: String
    let exp: Int
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            Text("\(String(serial))")
                .foregroundColor(.black)
            
            KFImage(URL(string: headimgurl))
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 16)  {
                Text(username)
                HStack(alignment: .center, spacing: 8)  {
                    Image(sex == 2 ?"ic_chatroom_gender_boy" : "ic_chatroom_gender_gril")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    KFImage(URL(string: starsImg))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 16)  {
                Text("魅力值")
                    .foregroundColor(.yellow)
                Text(String(exp))
                    .foregroundColor(.orange)
            }
        }
    }
    
}


struct ListAnyTopViewItem_Room: View {
    let index: Int
    let headimgurl: String
    let username: String
//    let sex: Int
    let exp: Int
    var body: some View {
        VStack(alignment: .center, spacing: 4)  {
            ZStack(alignment: .center) {
                if headimgurl.isEmpty {
                    Image(.bottomNavCenter)
                        .resizable()
                        .scaledToFill()
                        .frame(width: index == 0 ? 80 : 70, height: index == 0 ? 80 : 70)
                        .clipShape(Circle())
                } else {
                    let encodedURLString = headimgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    if let encodedURLString = encodedURLString, let url = URL(string: encodedURLString) {
                        KFImage(url)
                            .loadDiskFileSynchronously()
                            .cacheMemoryOnly()
                            .fade(duration: 0.3)
                            .placeholder {
                                Image(.bottomNavCenter)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: index == 0 ? 80 : 70, height: index == 0 ? 80 : 70)
                                    .clipShape(Circle())
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: index == 0 ? 80 : 70, height: index == 0 ? 80 : 70)
                            .clipShape(Circle())
                    }
                    
                }
                
                
                
                Image(index == 0 ? "list_head_one" : index == 1 ? "list_head_two" : "list_head_three")
                    .resizable()
                    .scaledToFit()
                    .frame(width: index == 0 ? 100 : 90, height: index == 0 ? 100 : 90)
                
            }
            Text(headimgurl.isEmpty ? "虚位以待" : username)
                .foregroundColor(.white)

            Image(.icChatroomGenderBoy)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .opacity(0)
            
            
            Text("\(String(exp))")
                .foregroundColor(.white)
                .opacity(headimgurl.isEmpty ? 0 : 1)
            
            
        }
        .padding(.bottom, index == 0 ? 32 : 0)
    }
}

struct ListAnyTopViewItem: View {
    let index: Int
    let headimgurl: String
    let username: String
    let sex: Int
    let exp: Int
    let userId: Int
    @State private var isShowFullSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 4)  {
            ZStack(alignment: .center) {
                if sex == 0 {
                    Image(.bottomNavCenter)
                        .resizable()
                        .scaledToFill()
                        .frame(width: index == 1 ? 80 : 70, height: index == 1 ? 80 : 70)
                        .clipShape(Circle())
                } else {
                    let encodedURLString = headimgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    if let encodedURLString = encodedURLString, let url = URL(string: encodedURLString) {
                        KFImage(url)
                            .loadDiskFileSynchronously()
                            .cacheMemoryOnly()
                            .fade(duration: 0.3)
                            .placeholder {
                                Image(.bottomNavCenter)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: index == 1 ? 80 : 70, height: index == 1 ? 80 : 70)
                                    .clipShape(Circle())
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: index == 1 ? 80 : 70, height: index == 1 ? 80 : 70)
                            .clipShape(Circle())
                            .onTapGesture {
                                isShowFullSheet.toggle()
                            }
                            .showUserInfoFullCoverSheet(userId: userId, isShowUserInfoFullCoverSheet: $isShowFullSheet)
                    }
                    
                }
                
                
                Image(index == 1 ? "list_head_one" : index == 0 ? "list_head_two" : "list_head_three")
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 100, height: 100)
                    .frame(width: index == 1 ? 100 : 90, height: index == 1 ? 100 : 90)
                
            }
            Text(sex == 0 ? "虚位以待" : username)
                .foregroundColor(.white)
            
            Image(sex == 2 ? "ic_chatroom_gender_boy" : "ic_chatroom_gender_gril")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .opacity(sex == 0 ? 0 : 1)
            
            
            Text("\(String(exp))")
                .foregroundColor(.white)
                .opacity(sex == 0 ? 0 : 1)
            
            
        }
        .padding(.bottom, index == 1 ? 32 : 0)
    }
}



struct AppBar_Leaderboard: View {
    @Binding var index: Int
    @Binding var offset: CGFloat
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .center, spacing: 10)  {
            TopButtonViewItem_Leaderboard(text: "日榜", isSelected: index == 1) {
                index = 1
                offset = 0
            }
            TopButtonViewItem_Leaderboard(text: "周榜", isSelected: index == 2) {
                index = 2
                offset = -width
            }
            TopButtonViewItem_Leaderboard(text: "月榜", isSelected: index == 3) {
                index = 3
                offset = 2 * -width
            }
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.pink.opacity(0.5), lineWidth: 2)
        )
        .padding(.horizontal)
        
        
    }
}


struct AppBar_Leaderboard_Index: View {
    @Binding var index: Int
    @Binding var initIndex: Int
    var body: some View {
        HStack(alignment: .center, spacing: 2)  {
            TopButtonViewItem_Leaderboard_Index(text: "魅力榜", isSelected: index == 1) {
                index = 1
                initIndex = 1
            }
            TopButtonViewItem_Leaderboard_Index(text: "财富榜", isSelected: index == 2) {
                index = 2
                initIndex = 1
            }
            TopButtonViewItem_Leaderboard_Index(text: "房间榜", isSelected: index == 3) {
                index = 3
                initIndex = 1
            }
            
        }
        .padding(.horizontal)
        
        
    }
}

struct TopButtonViewItem_Leaderboard_Index: View {
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
                    .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                    .lineLimit(1)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
            }
        })
        
    }
}


struct TopButtonViewItem_Leaderboard: View {
    @State var text: String
    var isSelected: Bool
    var action: (() -> ())?
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            VStack(alignment: .center, spacing: 8)  {
                Text(text)
                    .foregroundColor(isSelected ? .white : .pink)
                    .font(.system(size: 18, weight: isSelected ? .bold : .medium))
                    .lineLimit(1)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.pink, lineWidth: 2)
                            .opacity(isSelected ? 1 : 0)
                        
                    )
                
                
                
                //                Capsule()
                //                    .fill(isSelected ? .white : .clear)
                //                    .frame(height: 4)
            }
        })
        
    }
}


struct test_LeaderboardView: View {
    @State private var isShowSheet: Bool = true
    var body: some View {
        Button(action: {
            isShowSheet.toggle()
        }, label: {
            Text("Button")
        })
        .buttonStyle(.borderedProminent)
        .fullScreenCover(isPresented: $isShowSheet, content: {
            LeaderboardView(closeSheet: $isShowSheet)
        })
    }
}

#Preview {
//    LeaderboardView()
    test_LeaderboardView()
}

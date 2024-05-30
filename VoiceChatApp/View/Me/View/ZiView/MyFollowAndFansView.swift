//
//  MyFollowView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/25.
//

import SwiftUI
import ProgressHUD
import Combine

struct MyFollowRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [VisitorsModel]?
}
struct VisitorsRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [VisitorsModel]?
}
struct VisitorsModel: Decodable {
    let nickname: String
    let avatar: String
    let userId: Int
    let sex: Int
    let accessTime: String
    let isFollowed: Int?
}



class MyFollow: ObservableObject {
    @Published var followList: [VisitorsModel] = []
    @Published var fansList: [VisitorsModel] = []
    @Published var visitorList: [VisitorsModel] = []
    
    @Published var filterVisitorList: [VisitorsModel] = []
    @Published var filterFollowList: [VisitorsModel] = []
    @Published var filterFansList: [VisitorsModel] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published var type: followOrFans = .follow
    
    init() {
//        addSubscribers()
    }
    
    // MARK: 获取关注的用户
    func getFollowUserList(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/user/getFollowedList",
                                method: .get,
                                responseDecodable: MyFollowRequestModel.self) { result in
            DispatchQueue.main.async {
                if let data = result.data {
                    self.followList = data
                }
            }
        } failure: { _ in
            
        }
    }
    
    // MARK: 获取粉丝
    func getFansList(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/user/getFansList",
                                method: .get,
                                responseDecodable: MyFollowRequestModel.self) { result in
            DispatchQueue.main.async {
                if let data = result.data {
                    self.fansList = data
                }
            }
        } failure: { _ in
            
        }
    }
    
    
    // MARK: 获取访客
    func getVisitorList(page: Int = 1) {
        
        NetworkTools.requestAPI(convertible: "/user/getVisitorList",
                                method: .get,
                                responseDecodable: VisitorsRequestModel.self) { result in
            DispatchQueue.main.async {
                if let data = result.data {
                    self.visitorList = data
                }
            }
        } failure: { _ in
            
        }
    }
    
    private func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterRestaurants(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterRestaurants(searchText: String) {
        if type == .follow {
            // 关注
            guard !searchText.isEmpty else {
                filterFollowList = []
                return
            }
            print(searchText)
            let search = searchText.lowercased()
            filterFollowList = followList.filter({ restaurant in
                let titleContainsSearch = restaurant.nickname.contains(search)
                return titleContainsSearch
            })
        } else {
            // 粉丝
            guard !searchText.isEmpty else {
                fansList = []
                return
            }
            print(searchText)
            let search = searchText.lowercased()
            filterFansList = followList.filter({ restaurant in
                let titleContainsSearch = restaurant.nickname.contains(search)
                return titleContainsSearch
            })
        }
    }
    
    
}

enum followOrFans {
    case follow
    case fans
    case visitor
}



struct MyFollowAndFansView: View {
    @State var type: followOrFans
    @StateObject private var vm: MyFollow = MyFollow()
    var body: some View {
        List(type == .follow ? vm.followList : type == .visitor ? vm.visitorList : vm.fansList, id: \.userId) { item in
            MyFollowViewItem(vm: vm, item: item)
        }
        .listStyle(.inset)
        .navigationTitle(type == .follow ? "关注列表" : type == .visitor ? "访客列表" : "粉丝列表")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $vm.searchText, prompt: Text("通过昵称搜索..."))
        .onAppear {
            vm.type = type
            if type == .follow {
                vm.getFollowUserList()
            } else if type == .fans {
                vm.getFansList()
            } else {
                vm.getVisitorList()
            }
        }
    }
}


struct MyFollowViewItem: View {
    @StateObject var vm: MyFollow
    var item: VisitorsModel
    @State var isShowUserInfoFullCoverSheet: Bool = false
    @State var isCancel: Bool = false
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView_Fill(imageUrl: item.avatar)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
//                .onTapGesture {
//                    isShowUserInfoFullCoverSheet.toggle()
//                }
                .showUserInfoFullCoverSheet(userId: Int(item.userId), isShowUserInfoFullCoverSheet: $isShowUserInfoFullCoverSheet)
            
            VStack(alignment: .leading, spacing: 8)  {
                HStack(alignment: .center, spacing: 4)  {
                    Text(item.nickname)
                        .foregroundColor(.black)
                    
                    Image(item.sex == 1 ? "ic_chatroom_gender_boy" : "ic_chatroom_gender_gril")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                
                Text(String(item.userId))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8)  {
                Text("\(Timer.handleLateTimeT(from: item.accessTime))")
                    .foregroundColor(.gray)
                if let isf = item.isFollowed {
                    if !isCancel && isf == 1 {
                        Button {
                            UserRequest.cancelFollowedUser(cancelFollowedUserId: item.userId) { code in
                                ProgressHUD.succeed("取消关注")
                                isCancel = true
                            }
                        } label: {
                            Text("取消关注")
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(.red.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                    }
                }
            }
            
            
        }
        .frame(maxHeight: 60)
        .padding(.vertical, 8)
        
//        .overlay(alignment: .trailing) {
//            Button(action: {
//                if let id = item.id {
//                    if item.isFollow == 1 {
//                        UserRequest.cancelFollowedUser(cancelFollowedUserId: id) { code in
//                            
//                        }
//                    } else {
//                        UserRequest.followUser(followedUserId: id) { code in
//                            
//                        }
//                    }
//                }
//                
//            }) {
//                Text(item.isFollow == 1 ? "取消关注" : "关注")
//                    .foregroundColor(.purple)
//                    .font(.system(size: 14))
//                    .padding(.vertical, 6)
//                    .padding(.horizontal, 12)
//                    .background(Color.purple.opacity(0.5))
//                    .clipShape(RoundedRectangle(cornerRadius: 30))
//                
//            }
//        }
    }
}




#Preview {
    NavigationView {
        VStack(alignment: .center, spacing: 12)  {
            NavigationLink(destination: MyFollowAndFansView(type: .fans)) {
                Text("粉丝")
            }
            
            NavigationLink(destination: MyFollowAndFansView(type: .follow)) {
                Text("关注")
            }
        }
        
    }
}

//
//  MyVisitorView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/25.
//

import SwiftUI

import Combine




//class MyVisitor: ObservableObject {
//    @Published var visitorList: [VisitorsModel] = []
//    @Published var filterVisitorList: [VisitorsModel] = []
//    private var cancellables = Set<AnyCancellable>()
//    @Published var searchText: String = ""
//
//    init() {
//        getVisitorList()
//        addSubscribers()
//    }
//    // MARK: 获取访客
//    func getVisitorList(page: Int = 1) {
//        
//        NetworkTools.requestAPI(convertible: "/user/getVisitorList",
//                                method: .get,
//                                responseDecodable: VisitorsRequestModel.self) { result in
//            DispatchQueue.main.async {
//                if let data = result.data {
//                    self.visitorList = data
//                }
//            }
//        } failure: { _ in
//            
//        }
//    }
//    
//    
//    private func addSubscribers() {
//        $searchText
//            .debounce(for: 0.3, scheduler: DispatchQueue.main)
//            .sink { [weak self] searchText in
//                self?.filterRestaurants(searchText: searchText)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func filterRestaurants(searchText: String) {
//        guard !searchText.isEmpty else {
//            filterVisitorList = []
//            return
//        }
//        let search = searchText.lowercased()
//        filterVisitorList = visitorList.filter({ restaurant in
//            let titleContainsSearch = restaurant.nickname.contains(search)
//            return titleContainsSearch
//        })
//    }
//    
//}

//struct MyVisitorView: View {
//    @StateObject private var vm: MyVisitor = MyVisitor()
//    var body: some View {
//        List(vm.visitorList, id: \.userId) { item in
//            MyVisitorViewItem(item: item)
//        }
//        .listStyle(.inset)
//        .navigationTitle("访客")
//        .navigationBarTitleDisplayMode(.inline)
//        .searchable(text: $vm.searchText, prompt: Text("搜索昵称..."))
//    }
//}


//struct MyVisitorViewItem: View {
//    let item: VisitorsModel
//    @State var isShowUserInfoFullCoverSheet: Bool = false
//    var body: some View {
//        HStack(alignment: .center, spacing: 12)  {
//            KFImageView_Fill(imageUrl: item.avatar)
//                .frame(width: 60, height: 60)
//                .clipShape(Circle())
//            
//            
//            VStack(alignment: .leading, spacing: 0)  {
//                HStack(alignment: .center, spacing: 8)  {
//                    Text(item.nickname ?? "")
//                    Image(item.sex == 1 ? "ic_chatroom_gender_boy" : "ic_chatroom_gender_gril")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 20, height: 20)
//                }
//                Spacer()
//                Text(String(item.userId))
//            }
//            Spacer()
//            VStack(alignment: .center, spacing: 0)  {
//                Spacer()
//                Text(item.accessTime)
//                    .foregroundColor(.gray)
//                    .font(.system(size: 14))
//                    .lineLimit(1)
//            }
//
//        }
//        .frame(maxHeight: 60)
//        .foregroundColor(.black)
//        .padding(.vertical, 8)
//        .onTapGesture(perform: {
//            isShowUserInfoFullCoverSheet.toggle()
//        })
//        .showUserInfoFullCoverSheet(userId: item.userId, isShowUserInfoFullCoverSheet: $isShowUserInfoFullCoverSheet)
//
//    }
//}

//#Preview {
//    NavigationView {
//        MyVisitorView()
//    }
//}

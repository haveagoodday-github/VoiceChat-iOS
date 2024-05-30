//
//  MessageDetailsViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/9.
//

import Foundation
import SwiftUI
import Combine

class MessageViewModel: ObservableObject {
    
    @Published private(set) var contactList: [ContactListModel] = []
    @Published private(set) var filterContactList: [ContactListModel] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    
    
    init() {
        getContactList()
        addSubscribers()
    }
    
    func getContactList(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/messages/getContactList",
                                method: .get,
                                parameters: ["page": page],
                                responseDecodable: ContactListRequestModel.self) { result in
            if result.code == 0 {
                self.contactList = result.data
            }
            debugPrint("刷新通讯录 - \(result.data.first)")
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
        guard !searchText.isEmpty else {
            filterContactList = []
            return
        }
        print(searchText)
        let search = searchText.lowercased()
        filterContactList = contactList.filter({ restaurant in
            let titleContainsSearch = restaurant.nickname.contains(search)
            let backgroundContainsSearch = restaurant.lastMessageContent.contains(search)
            return titleContainsSearch || backgroundContainsSearch
        })
    }
    
}



struct MessageItemRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [MessageItemModel]
}

struct MessageItemModel: Decodable, Equatable {
    let messageId: Int
    let userId: Int
    let beUserId: Int
    let content: String
    let state: Int
    let createTime: String
    let updateTime: String
}

class MessageDetailsViewModel: ObservableObject {
    @Published var messageList: [MessageItemModel] = []
    @Published var msgContent: String = ""
    @Published var beUserId: Int = 0
    
    init() {
        
    }
    
    func initAction(beUserId: Int) {
        self.beUserId = beUserId
        getMessageList()
    }
    
    func getMessageList(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/messages/getMessageList",
                                method: .get,
                                parameters: [
                                    "beUserId": beUserId,
                                    "page": page
                                ],
                                responseDecodable: MessageItemRequestModel.self) { result in
            if result.code == 0 {
                self.messageList = result.data.reversed()
            }
        } failure: { _ in
            
        }

    }
    
    func sendMsg() {
        UserRequest.sendMsg(beUserId: beUserId, msg: msgContent) { isTrue in
            if isTrue {
                self.getMessageList()
            }
        }
        msgContent = ""
    }
}

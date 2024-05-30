//
//  Room_MatchmakModel.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/8/30.
//

import Foundation


struct messagesModel: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let messages: String
}

// 获取信息
class GetMessages: ObservableObject {
    @Published var msgArray: [messagesModel] = []
    
    init () {
        getDefMsg()
    }
    
    func addMessages(msg: String) {
        print("\(msg)")
        if !msg.trimmingCharacters(in: .whitespaces).isEmpty {
            self.msgArray.append(messagesModel(messages: msg))
        }
    }
    
    func getDefMsg() {
        self.msgArray.append(messagesModel(messages: "官方提倡绿色交友，对房间内容24小时在线巡查。任何传播违规、违法、低俗、暴力等不良信息将会封停账号。"))
        self.msgArray.append(messagesModel(messages: "📢房间公告"))
    }
}

//
//  RoomManageView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/12/20.
//

import SwiftUI


struct RoomManageView: View {
    @StateObject private var vm: RoomManageObj = RoomManageObj()
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .center, spacing: 0)  {
                ForEach(vm.myManageRoomList, id: \.id) { item in
                    RoomManageViewItem(item: item, linphone: linphone)
                }
            }
        }
        .background(Color(red: 0.982, green: 0.982, blue: 0.997))
        .navigationTitle("房间管理")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RoomManageViewItem: View {
    let item: MyManageRoomModel.data.list
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView_Fill(imageUrl: item.room_cover)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
            VStack(alignment: .leading, spacing: 0)  {
                Text(item.room_name)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Text(item.room_category.name)
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
            }
            Spacer()
            
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(alignment: .trailing) {
            Text("房主")
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .medium))
                .padding(.trailing, 12)
        }
        .padding(.horizontal, 8)
//        .modifier(GotoRoom(roomStatus: item.room_class, roomId: item.id, roomUid: item.uid))
        .modifier(GotoRoom2(vm: GotoRoomModel(roomStatus: 1, roomId: item.id, roomUid: item.uid, is_default: 0), linphone: linphone))
    }
}




struct MyManageRoomModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let list: [list]
        
        struct list: Decodable {
            let id: Int
            let room_name: String
            let room_cover: String
            let uid: Int
            let room_class: Int
            let room_type: String
            let room_category: room_category
            let user: user
            let category_class: room_category
            let category_type: room_category
            
            struct room_category: Decodable {
                let id : Int
                let name: String
                let cate_img: String?
            }
            
            struct user: Decodable {
                let id: Int
                let nickname: String
                let sex: Int
                let headimgurl: String
                let city: String?
            }
            
        }
    }
}

class RoomManageObj: ObservableObject {
    
    @Published var myManageRoomList: [MyManageRoomModel.data.list] = []
    
    
    init() {
        self.getMyManageRoomList()
    }
    
    
    // MARK: 我管理的房间
    func getMyManageRoomList() {
//        guard let url = URL(string: "\(baseUrl.newurl)api/room/manage?page=1&pageSize=10") else { return }
//        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.userInfo.token, forHTTPHeaderField: "Token")
//        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
//            guard let self = self else { return }
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(MyManageRoomModel.self, from: data)
//                    debugPrint("getMyManageRoomList \(result.message)")
//                    DispatchQueue.main.async {
//                        self.myManageRoomList = result.data.list
//                    }
//                } else {
//                    debugPrint("getMyManageRoomList other result：No data")
//                }
//            } catch(let error) {
//                debugPrint("getMyManageRoomList function Error result：\(error.localizedDescription)")
//            }
//        }.resume()
    }
}


import SwiftUI

//import //import JGProgressHUD_SwiftUI



struct settingItemView: View {
    @State var isSheetPresented: Bool = false
    let name: String
    let img: String
    let view: AnyView
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
            isSheetPresented.toggle()
        }, label: {
            VStack(spacing: 5)  {
                Image(img)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 45, height: 45)
                Text(name)
                    .font(.caption)
                    .foregroundColor(.black)
            }
        })
        .sheet(isPresented: $isSheetPresented, content: {
            view
        })
    }
}

struct RoomSettingCard2: View {
    let rows = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    @StateObject var getRoomSettingCard = GetRoomSettingCard()
    
    @State private var isSheetPresented = false
    //    @State private var selectedFunction: RoomSettingCardModel? // 存储选定的功能
    
    @State var roomUid: Int
    @State var roomId: Int
    @StateObject var viewModel: RoomModel
    var body: some View {
        VStack(spacing: 20)  {
            VStack(alignment: .leading, spacing: 20)  {
                HStack(alignment: .center, spacing: 12)  {
                    Text("\(String(roomUid))")
                    Text("\(UserCache.shared.getUserInfo()?.userId ?? 0)")
                }
                if roomUid == UserCache.shared.getUserInfo()?.userId {
//                    if !roomUid.words.isEmpty {
                    Text("房间设置")
                        .fontWeight(.bold)
                    HStack(spacing: 0)  {
                        LazyVGrid(columns: rows, spacing: 12) {
                            settingItemView(name: "房间上锁", img: "fjss", view: AnyView(Text("房间上锁"))) { }
                            settingItemView(name: "打开心动值", img: "dkxdz", view: AnyView(Text("打开心动值"))) { }
                            settingItemView(name: "清理公屏", img: "qlgp", view: AnyView(Text("清理公屏"))) { }
                            settingItemView(name: "关闭公屏", img: "gbgp", view: AnyView(Text("关闭公屏"))) { }
                            
                            settingItemView(name: "房间背景", img: "fjbj", view: AnyView(selectorBackgroundView_For_RoomSettingCard(viewModel: viewModel, roomId: roomId))) { }
                            
                            settingItemView(name: "管理员", img: "gly", view: AnyView(Text("管理员"))) { }
                            settingItemView(name: "房间黑名单", img: "fjhmd", view: AnyView(Text("房间黑名单"))) { }
                            settingItemView(name: "开启欢迎语", img: "kqhyy", view: AnyView(Text("开启欢迎语"))) { }
                            settingItemView(name: "音乐", img: "yy", view: AnyView(MusicLibrary())) { }
                            settingItemView(name: "房间设置", img: "fjsz", view: AnyView(EditRoomInfoView(uid: roomUid, roomId: roomId))) { }
                        }
                    }
                    
                }
                VStack(alignment: .leading, spacing: 20)  {
                    Text("更多功能")
                        .fontWeight(.bold)
                    HStack(spacing: 0)  {
                        LazyVGrid(columns: rows, spacing: 12) {
                            settingItemView(name: "装扮", img: "zb", view: AnyView(roomSettingCardSheet())) { }
                            settingItemView(name: "关闭特效", img: "gbtx", view: AnyView(roomSettingCardSheet())) { }
                        }
                    }
                }
            }
            .frame(height: 300)
            .padding(4)
            .background(Color.white)
            
        }
        
    }
    
}



struct selectorBackgroundView_For_RoomSettingCard: View {
    @StateObject var viewModel: RoomModel
    let roomId: Int
    @StateObject var editModel: EditRoomInfoModel = EditRoomInfoModel()
//    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @Environment(\.presentationMode) var presentationModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], alignment: .center, spacing: 12, content: {
                ForEach(viewModel.roomBackgroundArray, id: \.backgroundId) { item in
                    Button(action: {
                        // 修改房间背景
                        presentationModel.wrappedValue.dismiss()
                        
                        RoomRequest.updateRoomBackground(roomId: roomId, backgroundId: item.backgroundId) { code in
                            
                        }
                    }, label: {
                        VStack(alignment: .center, spacing: 8)  {
                            KFImageView(imageUrl: item.backgroundUrl)
                                .frame(height: UIScreen.main.bounds.height * 0.23)
                                .cornerRadius(8)
                            Text("\(item.backgroundName)")
                                .foregroundColor(.gray)
                        }
                    })
                }
            })
            .padding(8)
        }
    }
}

//struct RoomSettingCard_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomSettingCard()
//    }
//}



struct RoomSettingCardModel: Identifiable {
    let id: String = UUID().uuidString
    let img: String
    let name: String
    let view: AnyView
}

class GetRoomSettingCard: ObservableObject {
    @Published var RoomSettingCardArray: [RoomSettingCardModel] = []
    @Published var MoreSettingCardArray: [RoomSettingCardModel] = []
    init () {
        getRoomSettingCardArray()
        getMoreSettingCardArray()
    }
    
    
    
    func getRoomSettingCardArray() {
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "fjss", name: "房间上锁", view: AnyView(roomSettingCardSheet())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "dkxdz", name: "打开心动值", view: AnyView(customSheetView())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "qlgp", name: "清理公屏", view: AnyView(customSheetView())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "gbgp", name: "关闭公屏", view: AnyView(customSheetView())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "fjbj", name: "房间背景", view: AnyView(customSheetView())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "gly", name: "管理员", view: AnyView(customSheetView())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "fjhmd", name: "房间黑名单", view: AnyView(customSheetView())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "kqhyy", name: "开启欢迎语", view: AnyView(customSheetView())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "yy", name: "音乐", view: AnyView(MusicLibrary())))
        self.RoomSettingCardArray.append(RoomSettingCardModel(img: "fjsz", name: "房间设置", view: AnyView(customSheetView())))
    }
    
    func getMoreSettingCardArray() {
        self.MoreSettingCardArray.append(RoomSettingCardModel(img: "zb", name: "装扮", view: AnyView(customSheetView())))
        self.MoreSettingCardArray.append(RoomSettingCardModel(img: "gbtx", name: "关闭特效", view: AnyView(customSheetView())))
    }
}

struct customSheetView: View {
    var body: some View {
        Text("自定义View")
    }
}

struct roomSettingCardSheet: View {
    var body: some View {
        Text("自定义View12")
    }
}

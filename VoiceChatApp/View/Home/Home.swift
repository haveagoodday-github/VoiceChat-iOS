

import SwiftUI

import SDWebImageSwiftUI
import ProgressHUD
import Defaults
import Alamofire
import DynamicColor


struct Home: View {
    @State private var selected_tuijian: Bool = true // test 小窝
    @State private var isSheetForCreateRoom: Bool = false
    @StateObject var viewModel: RecommendViewModel
    @StateObject var vm: NestViewModel
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hexString: "#F6F5FA").ignoresSafeArea()
                
            VStack(alignment: .leading, spacing: 12)  {
                TopTabView(selected_tuijian: $selected_tuijian, isSheetForCreateRoom: $isSheetForCreateRoom)
                    .padding(.horizontal, 12)
                ScrollView {
                    VStack(alignment: .center, spacing: 12)  {
                        Carousel()
                        if selected_tuijian {
                            HomeRecommendedView(viewModel: viewModel, linphone: linphone)
                        } else {
                            VStack(alignment: .center, spacing: 12)  {
                                singleChoice(vm: vm)
                                singleChoiceContentView(viewModel: vm, linphone: linphone)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
        .sheet(isPresented: $isSheetForCreateRoom, content: {
            CreateRoomView()
        })
        .environmentObject(viewModel)
        .navigationBarHidden(true)
        
    }
}



struct singleChoice: View {
    @StateObject var vm: NestViewModel
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            ForEach(vm.typeListArray, id: \.roomTypeId) { type in
                Text(type.name)
                    .frame(maxWidth: 40)
                    .foregroundColor(vm.currentType == type ? .black : .gray)
                    .font(.system(size: 15, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(vm.currentType == type ? Color.yellow.opacity(0.5) : .gray.opacity(0.5))
                    .cornerRadius(30)
                    .onTapGesture {
                        vm.currentType = type
                        ProgressHUD.animate("Loading")
                        vm.getNestContent(currentType: type)
                    }
            }
        }
    }
}

// MARK: 小窝内容
struct singleChoiceContentView: View {
    @StateObject var viewModel: NestViewModel
    @State var page: Int = 1
    @ObservedObject var linphone : IncomingCallTutorialContext
    let gridItems = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 16) {
                ForEach(viewModel.nestContentArray, id: \.roomId) { item in
                    singleChoiceContentViewItem(item: item, linphone: linphone)
                }
            }
            Divider().padding(.vertical, 4)
        }
    }
}

struct singleChoiceContentViewItem: View {
    let item: NewHallRecommendModel
    @State private var isGotoRoom: Bool = false
    @State private var room_pass: String = ""
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                
            singleChoiceContentViewAvatarItem(headimg: item.roomCover, sex: false, nickname: item.roomName ?? "")
                .padding(.all)
                .padding(.vertical)
                .padding(.vertical)
            
        }
        .overlay(alignment: .bottomTrailing, content: {
            HStack(alignment: .top, spacing: 3)  {
                Image(.ltsHmIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("\(item.onlineNum)")
                    .foregroundColor(.black)
                    .font(.footnote)
            }
            .padding(8)
        })
        .overlay(alignment: .topLeading, content: {
            // 左上角 - 标签
            HStack(alignment: .center, spacing: 2)  {
                HStack(alignment: .center, spacing: 0)  {
                    AnimatedImage(name: "yinlv_blue.gif")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text(item.roomName)
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.7))
                .cornerRadius(30)
                Spacer()
            }
            .padding(8)
        })
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 3)
//        .modifier(GotoRoom(roomStatus: item.roomStatus, roomId: item.id, roomUid: item.uid))
        .modifier(GotoRoom2(vm: GotoRoomModel(roomStatus: 1, roomId: item.roomId, roomUid: item.roomUid, is_default: 0), linphone: linphone))

        
        
    }
    
    private func alertView() {
        let alert = UIAlertController(title: "密码输入", message: "请输入6位数字密码", preferredStyle: .alert)
        
        alert.addTextField { pass in
            pass.isSecureTextEntry = true
            pass.keyboardType = .numberPad
            pass.placeholder = "请输入6位数字密码"
        }
        
        let login = UIAlertAction(title: "确定", style: .default) { _ in
            room_pass = alert.textFields![0].text!
            
            if room_pass.count == 6 {
                isGotoRoom = true
            } else if room_pass.count < 6 {
                ProgressHUD.error("密码格式为6位数字，请重新输入", delay: 1.5)
            } else {
                ProgressHUD.error("密码不正确，请重新输入", delay: 1.5)
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .destructive) { _ in
            
        }
        
        alert.addAction(cancel)
        alert.addAction(login)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true) { }
    }
}


// MARK: 头像部分
struct singleChoiceContentViewAvatarItem: View {
    let headimg: String
    let sex: Bool
    let nickname: String
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.gray)
                    .overlay(content: {
                        KFImageView(imageUrl: headimg)
                            .clipShape(Circle())
                    })
                    .frame(width: 50, height: 50)
                if sex {
                    
                    Image(.icChatroomGenderBoy)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .offset(x: 5, y: 5)
                } else {
                    Image(.icChatroomGenderGril)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .offset(x: 5, y: 5)
                }
            }
            
            Text(nickname)
                .foregroundColor(.black)
                .font(.system(size: 14, weight: .bold))
        }
    }
}



// MARK: 推荐视图
struct HomeRecommendedView: View {
    @StateObject var viewModel: RecommendViewModel
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            VStack(alignment: .center, spacing: 0)  {
                
                if let item = viewModel.popularActivitiesRoomData.first {
                    PopularActivitiesView(item: item)
                        .modifier(GotoRoom2(vm: GotoRoomModel(roomStatus: 1, roomId: viewModel.popularActivitiesRoomData.first?.id ?? 0, roomUid: viewModel.popularActivitiesRoomData.first?.uid ?? 0, is_default: 0), linphone: linphone))
                        .padding(.top, 12)
                }
                
                // 全区广播
                AllStationRadioView()
                
                // 新厅推荐
                NewHallRecommendView(viewModel: viewModel, linphone: linphone)
                
                // 热门推荐
                newlyweds(viewModel: viewModel, linphone: linphone)
                
            }
            .offset(y: -12)
            
        }
    }
}









struct TextModel: View {
    let leadingNmae: String
    let moreName: String
    init(leadingNmae: String, moreName: String = "更多>") {
        self.leadingNmae = leadingNmae
        self.moreName = moreName
    }
    var body: some View {
        HStack {
            Text(leadingNmae)
                .font(.subheadline)
                .fontWeight(.bold)
            Spacer()
            Text(moreName)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// 顶部轮播图
struct Carousel: View {
    @EnvironmentObject var viewModel: RecommendViewModel
    var body: some View {
        TabView {
            ForEach(viewModel.carouselData, id: \.id) {item in
                KFImageView_Fill(imageUrl: item.imageUrl)
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .cornerRadius(10)
                    .clipped()
            }
        }
        .cornerRadius(10)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 不显示页面指示器
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive)) // 控制索引点大小
        .frame(height: 100)
        .padding(.horizontal, 7)
        
    }
}

// MARK: 新厅推荐
struct NewHallRecommendView: View {
    @StateObject var viewModel: RecommendViewModel
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            TextModel(leadingNmae: "新厅推荐")
                .padding(.vertical, 12)
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                ForEach(viewModel.newHallRecommend, id: \.roomId) { item in
                    RecommendedByTheNewHallViewItem(item: item, linphone: linphone)
                }
            }
            .padding(10)
            
        }
    }
}
struct RecommendedByTheNewHallViewItem: View {
    let item: NewHallRecommendModel
    @ObservedObject var linphone : IncomingCallTutorialContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4)  {
            ZStack(alignment: .bottom) {
                KFImageView(imageUrl: item.roomCover)
                    .cornerRadius(10)
                HStack(alignment: .center, spacing: 3)  {
                    AnimatedImage(name: "yinlv_gray.gif")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("\(item.onlineNum)")
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(item.type))
                        .font(.caption2)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .cornerRadius(30)
                        .foregroundColor(.white)
                }
                .padding(3)
                .frame(maxWidth: 120)
                
            }
            Text("\(item.roomName)")
                .font(.system(size: 12, weight: .medium))
        }
        .modifier(GotoRoom2(vm: GotoRoomModel(roomStatus: 1, roomId: item.roomId, roomUid: item.roomUid, is_default: 0), linphone: linphone))
        // TODO: Test Float Ball
//        .modifier(GotoRoom(roomStatus: item.roomStatus, roomId: item.id, roomUid: item.uid))
        
    }
    
    
}



// MARK: 热门推荐
struct newlyweds: View {
    @StateObject var viewModel: RecommendViewModel
    @ObservedObject var linphone : IncomingCallTutorialContext
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            TextModel(leadingNmae: "热门推荐")
                .padding(.vertical, 12)
            VStack (alignment: .center, spacing: 12) {
                ForEach(viewModel.receptionDataRoomData, id: \.roomId) { item in
                    newlywedsItemView(item: item, linphone: linphone)
                }
                
            }
        }
    }
}


struct newlywedsItemView: View {
    let item: HotRecommendModel
    @ObservedObject var linphone : IncomingCallTutorialContext
    var body: some View {
        HStack(alignment: .center, spacing: 4)  {
            KFImageView_Fill(imageUrl: item.roomCover)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 80, height: 80)
                
            VStack(alignment: .center, spacing: 0)  {
                Text("\(item.roomName)")
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                HStack(alignment: .center, spacing: 4)  {
                    AnimatedImage(name: "yinlv_gray.gif")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("\(item.hot ?? 0)")
                        .font(.system(size: 12, weight: .light))
                }
            }
            .frame(height: 80)
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .modifier(GotoRoom2(vm: GotoRoomModel(roomStatus: 1, roomId: item.roomId, roomUid: item.roomUid, is_default: 0), linphone: linphone))
    }
}

// MARK: 热门活动
struct PopularActivitiesView: View {
    @EnvironmentObject var viewModel: RecommendViewModel
    var item: GetPopularActivitiesModel.RoomData
    @State private var currentPage = 0 // 用于跟踪当前页面
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                // 头像
                KFImageView_Fill(imageUrl: item.room_cover)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                

                VStack(alignment: .leading) {
                    Text(item.room_name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(item.category_class.name)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .cornerRadius(30)
                        .foregroundColor(Color(red: 0.954, green: 0.778, blue: 0.627))
                        .padding(.trailing, 8)
                }
                .frame(height: 70)
                
                Spacer()
                
            }
            .padding()
            .background(Color.white)
            .frame(height: 90)
            .cornerRadius(10)

            // 热门活动中
            Image(.homeRemen)
                .resizable()
                .scaledToFit()
                .frame(height: 24)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(alignment: .bottomTrailing) {
            HStack(spacing: 10) {
                AnimatedImage(name: "yinlv_gray.gif")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("\(item.hot)")
                    .font(.caption)

            }
            .padding(8)
        }
    }
}

// 动画
struct animationView: View {
    @State var Size: CGFloat
    @State var isAnimating: Bool = false
    let timeing: Double = 0.2
    var body: some View {
        HStack(spacing: 3) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.5))
                .frame(width: Size * 10, height: isAnimating ? 15 : 4)
                .animation(Animation.linear(duration: timeing))
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.5))
                .frame(width: Size * 10, height: isAnimating ? 15 : 4)
                .animation(Animation.linear(duration: timeing + 0.25))
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.5))
                .frame(width: Size * 10, height: isAnimating ? 15 : 4)
                .animation(Animation.linear(duration: timeing+0.5))
                
        }
        .onAppear() {
            // 添加计时器以实现自动轮播
//            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
//                withAnimation {
//                    isAnimating = !isAnimating
//                }
//            }
        }
    }
}


// MARK: 全服头条/全服头条
struct AllStationRadioView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            TextModel(leadingNmae: "全站广播", moreName: "")
                .padding(.top, 12)
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    ZStack {
                        // 背景
                        Image(.homeToutiaoBg9)
                            .resizable()
                            .frame(height: 50)
                        // 头像 - 文字信息
                        HStack(alignment: .center, spacing: 10)  {
                            KFImageView(imageUrl: "https://voicechat.oss-cn-shenzhen.aliyuncs.com/test_data/IMG_1295.PNG")
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 1)  {
                                Text("我好浪漫啊～")
                                    .foregroundColor(.black.opacity(0.8))
                                Text("xxxxxxxx")
                            }
                            .font(.footnote)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .zIndex(1)
                    
                    ZStack(alignment: .center) {
                        Image(.homeGbBg9)
                            .resizable()
                            .scaledToFit()
                        
                        HStack(alignment: .center, spacing: 0)  {
                            AllStationRadioMessageView(90)
                                .padding(.top, 6)
                            Spacer()

                            Image(.homeGbGengduoIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        }
                        .padding(.horizontal)
                        

                    }
                    .offset(y: -12)
                    .zIndex(0)
                }
                // 全国广播
                Image(.toutiao)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 30)
                    .offset(x: -20, y: -3)
            }
            .frame(height: 210)
    //        .frame(maxHeight: 250)
        }
    }
}

struct AllStationRadioMessageModel: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let headimg: String
    let messages: String
}



struct AllStationRadioMessageView: View {
    let ChatHeight: CGFloat
    init(_ ChatHeight: CGFloat = 100) {
        self.ChatHeight = ChatHeight
    }
    @StateObject var getMessages: GetAllStationRadioMessageModel = GetAllStationRadioMessageModel()
    @State private var inputText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(getMessages.msgArray) { msg in
                            AllStationRadioMessageViewItem(headimg: msg.headimg, chatText: msg.messages)
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .onChange(of: getMessages.msgArray) { _ in
                        if let lastMessage = getMessages.msgArray.last {
                            withAnimation {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: ChatHeight)
//        .padding(.all, 10)
        
        
    }
}

struct AllStationRadioMessageViewItem: View {
    let headimg: String
    let chatText: String
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            KFImageView_Fill(imageUrl: headimg)
                .clipShape(Circle())
                .frame(width: 25, height: 25)
            Text(chatText)
                .font(.subheadline)
                .padding(.horizontal, 5)
                .font(.system(size: 16, weight: .light))
        }
        .padding(.all, 5)
        .frame(height: 30)
        .background(Color.white)
        .cornerRadius(30)
        
    }
}




// MARK: 顶部单选
struct TopTabView: View {
    @Binding var selected_tuijian: Bool
//    @State private var showingAlert = false
    @State private var isGoToCreateRoomView = false
    @State private var isGoToNestViewView = false
    @StateObject var viewModel: MyNestInfo = MyNestInfo()
    @Binding var isSheetForCreateRoom: Bool
    @State private var isShowSheet: Bool = false
    var body: some View {
        HStack(alignment: .bottom, spacing: 12)  {
            Button(action: {
                withAnimation {
                    selected_tuijian = true
                }
            }, label: {
                Text("推荐")
                    .foregroundColor(selected_tuijian ? .black : .gray)
                    .fontWeight(.bold)
                    .font(selected_tuijian ? .title2 : .headline)
            })
            
            
            Button(action: {
                withAnimation {
                    selected_tuijian = false
                }
            }, label: {
                Text("小窝")
                    .foregroundColor(!selected_tuijian ? .black : .gray)
                    .fontWeight(.bold)
                    .font(!selected_tuijian ? .title2 : .headline)
            })
            
            Spacer()
            HStack(alignment: .center, spacing: 12)  {
                NavigationLink(destination: Home_SearchView()) {
                    Image(.icHomeSs)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                Image(.icHomeBd)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        isShowSheet.toggle()
                    }
                    .fullScreenCover(isPresented: $isShowSheet) {
                        LeaderboardView(closeSheet: $isShowSheet)
                    }
                
                
                
                Image(.icKfjIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        isSheetForCreateRoom.toggle()
                    }
                // 有房间直接进入房间
//                    .modifier(GotoRoom2(vm: GotoRoomModel(roomStatus: 1, roomId: UserCacheMyNestInfo.shared.getUserMyNestInfo()?.first?.id ?? 0, roomUid: UserCache.shared.getUserInfo()?.userId ?? 0, is_default: 1)))
                    
                
            }
            
        }

    }
}



struct Home_SearchView: View {
    @State var searchContent: String = ""
    var action: (() -> ())?
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
                    .padding(6)
                
                TextField("输入关键字", text: $searchContent)
                    .font(.system(size: 18))
                    .padding(.vertical, 6)
                    .onSubmit {
                        action?()
                    }
            }
            .background(Color.white)
            .cornerRadius(30)
            
            
            Spacer()
            
        }
        .padding(.horizontal, 12)
        .background(Color(red: 0.982, green: 0.982, blue: 0.997))
    }
}




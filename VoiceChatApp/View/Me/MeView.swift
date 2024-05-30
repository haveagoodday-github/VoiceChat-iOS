//
//  MyView.swift
//  testProject
//
//  Created by MacBook Pro on 2023/8/26.
//

import SwiftUI

import Defaults
import Alamofire

 

struct MyView: View {
    @StateObject var viewModel: MeViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(.myHeadBg2)
                .resizable()
//                    .frame(width: .infinity)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .center, spacing: 12)  {
                    checkInButtonView()
                        .hidden()
                    
                    userInfo(viewModel: viewModel)
                        .onTapGesture {
                            viewModel.userProfileFullSheet = true
                        }
                        .showUserInfoFullCoverSheet(isShowUserInfoFullCoverSheet: $viewModel.userProfileFullSheet)
                    
                    
                    userData(vm: viewModel)
                    VStack(alignment: .center, spacing: 12)  {
                        wallet_diamond(viewModel: viewModel)
                        myServers()
                        otherServers()
                    }
                    
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 12)
            
        }
        .onAppear {
            viewModel.refreshData()
        }
        .navigationBarHidden(true)
        
    }
    
}


struct checkInButtonView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            Spacer()
            HStack(alignment: .center, spacing: 4)  {
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                NavigationLink(destination: MissionCenter()) {
                    Text("签到")
                        .font(.system(size: 14, weight: .light))
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 8)
            .foregroundColor(.white)
            .background(Color(red: 0.531, green: 0.497, blue: 0.519))
            .cornerRadius(5)
        }
    }
}


// MARK: 用户信息：头像/昵称/ID
struct userInfo: View {
    @StateObject var viewModel: MeViewModel
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView_Fill(imageUrl: viewModel.userinfo?.avatar ?? "https://voicechat.oss-cn-shenzhen.aliyuncs.com/test_data/logo_corner.jpg")
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                
            VStack(alignment: .leading, spacing: 16)  {
//                Text("远方")
                Text(viewModel.userinfo?.nickname ?? "请重新登陆")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                Text("ID \(String(viewModel.userinfo?.userId ?? 0))")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(.gray)
                .font(.system(size: 24, weight: .light))
            
                
        }
    }
}

// MARK: 动态/胸章/关注/粉丝
struct userData: View {
    @StateObject var vm: MeViewModel
    @StateObject var viewModel: DynamicViewModel = DynamicViewModel()
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            userDataItem(num: vm.userinfo?.dynamicNum ?? 0, text: "动态", someView: AnyView(MyDynamicView()))
            Spacer()
            userDataItem(num: vm.userinfo?.visitorNum ?? 0, text: "访客", someView: AnyView(MyFollowAndFansView(type: .visitor)))
            Spacer()
            userDataItem(num: vm.userinfo?.followsNum ?? 0, text: "关注", someView: AnyView(MyFollowAndFansView(type: .follow)))
            Spacer()
            userDataItem(num: vm.userinfo?.fansNum ?? 0, text: "粉丝", someView: AnyView(MyFollowAndFansView(type: .fans)))
        }
        .font(.system(size: 16, weight: .bold))
        .padding(.horizontal)
    }
}

struct userDataItem: View {
    var num: Int
    let text: String
    let someView: AnyView
    var body: some View {
        NavigationLink(destination: someView) {
            VStack(alignment: .center, spacing: 12)  {
                Text(String(num))
                Text(text)
            }
            .foregroundColor(.black)
        }
        
    }
}

struct VIP: View {
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 15)
                .trim(from: 0.5, to: 1)
                .fill((LinearGradient(gradient: Gradient(colors: [Color(red: 0.481, green: 0.466, blue: 0.492), Color(red: 0.09, green: 0.09, blue: 0.112)]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                .frame(height: 105)

            HStack(alignment: .center, spacing: 12)  {
                Text("💎")
                Text("VIP")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(.yellow)
                    .italic()
                Spacer()
                Text("超多御声特权，开通VIP即享")
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
                Text("开通vip")
                    .padding(.horizontal, 3)
                    .padding(.vertical, 4)
                    .background(Color(red: 1.0, green: 0.906, blue: 0.813))
                    .font(.system(size: 12, weight: .medium))
                    .cornerRadius(30)
            }
            .padding(.all, 12)
            .offset(y: 4)
        }
        
    }
}

// 钱包/米钻
struct wallet_diamond: View {
    @StateObject var viewModel: MeViewModel
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            NavigationLink(destination: DiamondTopUpView(viewModel: viewModel)) {
                wallet_diamondItem(bgColor: Color(red: 1.001, green: 0.972, blue: 0.916), name: "钱包", num: "\(viewModel.userinfo?.balance ?? "0")", icon: "ic_vip_wallet", isTrailing: true)
            }
            Spacer()
            NavigationLink(destination: MyPointsView(PointsNumber: viewModel.userinfo?.mibi ?? "0")) {
                wallet_diamondItem(bgColor: Color(red: 0.998, green: 0.939, blue: 0.94), name: "积分", num: "\(viewModel.userinfo?.mibi ?? "0")", icon: "ic_mizuan")
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        
    }
}


struct wallet_diamondItem: View {
    let bgColor: Color
    let name: String
    let num: String
    let icon: String
    let isTrailing: Bool
    
    init(bgColor: Color, name: String, num: String, icon: String, isTrailing: Bool = false) {
        self.bgColor = bgColor
        self.name = name
        self.num = num
        self.icon = icon
        self.isTrailing = isTrailing
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(bgColor)
                        .frame(height: 100)
                    
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(8)
                        .zIndex(1)
                    
                }
                VStack(alignment: .leading, spacing: 4)  {
                    Text(name)
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .bold))
                    Text(num)
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.yellow)
                        .lineLimit(1)
                        .zIndex(2)
                }
                .padding()
                
            }
            if isTrailing {
                Image(.icShouchong)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
            }
            
        }
        
        
    }
}

struct serverListModel: Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let icon: String
    let view: AnyView
}

class initializationServerList: ObservableObject {
    var serversListArray: [serverListModel] = []
//    @StateObject var viewModel: MyNestInfo = MyNestInfo()
    @ObservedObject var linphone: IncomingCallTutorialContext = IncomingCallTutorialContext()
    
    init() {
        getServersListArray()
    }
    
    private func getServersListArray() {
        serversListArray.append(serverListModel(name: "我的背包", icon: "icon_my_bag", view: AnyView(MyBagView())))
        serversListArray.append(serverListModel(name: "装扮商城", icon: "icon_new_my_shop", view: AnyView(DressShopView())))
        serversListArray.append(serverListModel(name: "房间管理", icon: "img_my_room_manage", view: AnyView(RoomManageView(linphone: linphone))))
        serversListArray.append(serverListModel(name: "家族广场", icon: "icon_new_my_family", view: AnyView(FamilySquareView())))
        serversListArray.append(serverListModel(name: "我的等级", icon: "icon_user_grade", view: AnyView(MyGrade())))
        serversListArray.append(serverListModel(name: "我的收藏", icon: "icon_my_collect_room", view: AnyView(Text("你的收藏空空如也").navigationTitle("我的收藏").navigationBarTitleDisplayMode(.inline))))
    }
}

// 我的服务
struct myServers: View {
    @StateObject var viewModel: initializationServerList = initializationServerList()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                Text("我的服务")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .padding(.vertical, 16)
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 0, maximum: .infinity)),
                GridItem(.flexible(minimum: 0, maximum: .infinity)),
                GridItem(.flexible(minimum: 0, maximum: .infinity)),
                GridItem(.flexible(minimum: 0, maximum: .infinity))
            ], spacing: 24) {
                ForEach(viewModel.serversListArray) { item in
                    NavigationLink(destination: item.view) {
                        VStack(alignment: .center, spacing: 8)  {
                            Image(item.icon)
                                .resizable()
//                                .scaledToFit()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
//                                .clipShape(Circle())
                            Text("\(item.name)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    
    }
}



struct otherServers: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                Text("其他服务")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .padding(.vertical, 16)
            VStack(alignment: .center, spacing: 32)  {
//                otherServersItem(icon: "mic", name: "公会入驻")
                NavigationLink(destination: Feedback()) {
                    otherServersItem(icon: "envelope", name: "帮助与反馈")
                }
                .accentColor(Color.black)
                
                NavigationLink(destination: AboutUs()) {
                    otherServersItem(icon: "square.on.square", name: "关于")
                }
                .accentColor(Color.black)
                
                
                NavigationLink(destination: Setting()) {
                    otherServersItem(icon: "gear", name: "设置")
                }
                .accentColor(Color.black)
                
            }
            .padding(.vertical)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct otherServersItem: View {
    let icon: String
    let name: String
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            Image(systemName: icon)
            Text(name)
                .font(.system(size: 16, weight: .bold))
            Spacer()
            Image(systemName: "chevron.forward")
        }
        
    }
}







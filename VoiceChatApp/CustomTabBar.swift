//
//  CustomTabBar.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/8/30.
//

import SwiftUI
import Foundation
import Combine
import Defaults
import ProgressHUD




struct CustomTabBar: View {
    @ObservedObject var linphone : IncomingCallTutorialContext = IncomingCallTutorialContext()
    
    @State var CurrentTabBarType: TabBarType = .home // test
    @StateObject private var vmUserInfoMain: UserInfoMain = UserInfoMain()
    // 推荐/首页
    @StateObject private var vmRecommendViewModel: RecommendViewModel = RecommendViewModel()
    @StateObject private var vmNestViewModel: NestViewModel = NestViewModel()
    
    // 派对
    @StateObject private var partyvm: PartyViewModel = PartyViewModel()
    
    // 动态
    @StateObject var vmDynamicViewModel: DynamicViewModel = DynamicViewModel()
    
    // 我的 - 钻石 【充值列表】
    @StateObject private var vmTopUpList: TopUpList = TopUpList()
    @StateObject var viewModel: MeViewModel = MeViewModel()
    // 消息
//    @StateObject private var vmMessageViewModel: MessageViewModel = MessageViewModel()
    
    @State private var isShowTabBar: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(alignment: .center, spacing: 0)  {
                    VStack(alignment: .center, spacing: 0)  {
                        if CurrentTabBarType == .home {
                            Home(viewModel: vmRecommendViewModel, vm: vmNestViewModel, linphone: linphone)
                        } else if CurrentTabBarType == .dynamic {
                            DynamicView(viewModel: vmDynamicViewModel)
                        } else if CurrentTabBarType == .party {
                            PartView(viewModel: partyvm, carouselData: vmRecommendViewModel.carouselData, linphone: linphone)
                        } else if CurrentTabBarType == .messages {
                            MessagesListView()
                        } else if CurrentTabBarType == .my {
                            MyView(viewModel: viewModel)
                        }
                        Spacer(minLength: 65)
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height)
                    
                }
                tabBarView
                    .offset(y: isShowTabBar ? 0 : 200)
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Default(.go_to_room).reset()
            }
            .environmentObject(vmUserInfoMain)
            .environmentObject(vmRecommendViewModel)
            .environmentObject(vmNestViewModel)
            .environmentObject(partyvm)
            .environmentObject(vmTopUpList)
            .modifier(GotoRoom(linphone: linphone))

            
            
        }
    }
}



enum TabBarType {
    case home
    case dynamic
    case party
    case messages
    case my
}

extension CustomTabBar {
    var tabBarView: some View {
        HStack(alignment: .bottom, spacing: 0)  {
            tabBarButtonItem(TabBarIcon: "house", TabBarText: "首页", isSelected: CurrentTabBarType == .home, action: {
                CurrentTabBarType = .home
            })
            Spacer()
            tabBarButtonItem(TabBarIcon: "balloon", TabBarText: "动态", isSelected: CurrentTabBarType == .dynamic, action: {
                CurrentTabBarType = .dynamic
            })
            Spacer()
            PartTabBarButtom(TabBarText: "派对", isSelected: CurrentTabBarType == .party, action: {
                CurrentTabBarType = .party
            })
            Spacer()
            tabBarButtonItem(TabBarIcon: "ellipsis.message", TabBarText: "消息", isSelected: CurrentTabBarType == .messages, action: {
                CurrentTabBarType = .messages
            })
            Spacer()
            tabBarButtonItem(TabBarIcon: "person", TabBarText: "我的", isSelected: CurrentTabBarType == .my, action: {
                CurrentTabBarType = .my
            })
        }
        .padding(.horizontal)
        .frame(maxHeight: 40)
        .padding(.bottom, 30)
        .background {
            ZStack(alignment: .top) {
                Color.white
                
                Divider()
            }
        }
    }
}



struct tabBarButtonItem: View {
    let TabBarIcon: String
    let TabBarText: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .center, spacing: 8)  {
                Image(systemName: TabBarIcon)
                Text(TabBarText)
                    .font(.system(size: 12))
            }
            .foregroundColor(isSelected ? .yellow : .gray)
        })
        .padding()
        
    }
}


struct PartTabBarButtom: View {
    let TabBarText: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .center, spacing: 8)  {
                Image(.bottomNavCenter)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text(TabBarText)
                    .font(.system(size: 12))
            }
            .foregroundColor(isSelected ? Color(red: 0.999, green: 0.779, blue: 0.311) : .gray)
        })
        .padding()
    }
}




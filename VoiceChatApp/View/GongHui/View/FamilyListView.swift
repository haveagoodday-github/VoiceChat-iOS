//
//  FamilyListView.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/9/7.
//

import SwiftUI


struct FamilyListView: View {
    @StateObject var viewModel: GongHui
    @State var isShowSheet: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            FamilyListSearch(viewModel: viewModel, isShowSheet: $isShowSheet)
            
            ForEach(viewModel.GHListArray, id: \.id) { item in
                GHItemView(coverImage: item.guild_image, name: item.guild_name, intro: item.guild_desc, familyID: item.id)
            }
        }
        .padding(.vertical)
        .sheet(isPresented: $isShowSheet, onDismiss: {
            viewModel.searchResult = nil
        }, content: {
            FamilyListSearchResultView(item: viewModel.searchResult!)
        })
    }
}

// MARK: 搜索结果
struct FamilyListSearchResultView: View {
    @State var item: searchGHModel.dataItem
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            Text("搜索结果")
            Divider()
            GHItemView(coverImage: item.guild_image, name: item.guild_name, intro: item.guild_desc, familyID: item.id)
            Spacer()
        }
        .padding(.vertical)
    }
}

// MARK: 搜索
struct FamilyListSearch: View {
    @State var searchText: String = ""
    @StateObject var viewModel: GongHui
    @Binding var isShowSheet: Bool
//    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18))
                .foregroundColor(.gray)
            TextField("搜索家族ID，昵称", text: $searchText)
                .submitLabel(.done)
                .onSubmit({
                    action()
                })
        }
        .padding()
        .background(Color.white)
        .cornerRadius(30)
    }
    
    func action() {
        searchText = ""
//        let hud = JGProgressHUD()
//        hudCoordinator.showHUD {
            if !searchText.isEmpty {
                viewModel.searchGHtoId(nameOrId: searchText)
//                hud.textLabel.text = "搜索中"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if viewModel.searchResult != nil {
                        isShowSheet.toggle()
//                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
//                        hud.textLabel.text = "搜索成功"
//                        hud.dismiss(afterDelay: 2)
                    } else {
//                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                        hud.textLabel.text = "无结果"
//                        hud.dismiss(afterDelay: 2)
                    }
                }
            } else {
                viewModel.getGHList(page: 1, pageSize: 12)
            }
//            return hud
//        }
    }
}

// MARK: 工会Item
struct GHItemView: View {
    let coverImage: String
    let name: String
    let intro: String
    let familyID: Int
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView(imageUrl: coverImage)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8)  {
                HStack(alignment: .center, spacing: 0)  {
                    Text(name)
                        .font(.system(size: 17, weight: .bold))
                    
                }

                Text(intro)
                    .font(.system(size: 13))
                    .lineLimit(1)

                Text("家族ID: \(String(familyID))")
                    .font(.system(size: 13))
            }
            
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(.gray.opacity(0.5))
                .padding(2)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalid: Bool = false
}
struct pullDownLoadingView: View {
    @State var refresh = Refresh(started: false, released: false)
    @State var refreshDown = Refresh(started: false, released: false)
    @StateObject var viewModel: GongHui = GongHui()
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            ScrollView {
                
                GeometryReader{ reader -> AnyView in
                    
                    DispatchQueue.main.async {
                        
                        if refresh.startOffset == 0 {
                            refresh.startOffset = reader.frame(in: .global).minY
                        }
                        
                        refresh.offset = reader.frame(in: .global).minY
                        
                        if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                            refresh.started = true
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                            withAnimation(Animation.linear) { refresh.released = true }
                            updateData()
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                            refresh.invalid = false
                            updateData()
                        }
                        // =========
                        
                        
                        refreshDown.offset = reader.frame(in: .global).minY
                        
                        if refreshDown.offset < -20 && !refreshDown.started {
                            refreshDown.started = true
                        }
                        
                        if refreshDown.started && !refreshDown.released {
                            withAnimation(Animation.linear) { refreshDown.released = true }
                            addData()
                        }
                        
                        if refreshDown.started && refreshDown.released && refreshDown.invalid {
                            refreshDown.invalid = false
                            addData()
                        }
                        
                        
                    }

                    return AnyView(Color.black.frame(width: 0, height: 0))
                }
                .frame(width: 0, height: 0)
                
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    if refresh.started && refresh.released {
                        ProgressView()
                            .offset(y: -35)
                    } else {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(.gray)
                            .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                            .offset(y: -35)
                            .animation(.easeIn)
                    }
                    
                    
                    FamilyListView(viewModel: viewModel)
                        .overlay(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                            if refreshDown.started && refreshDown.released {
                                ProgressView()
                                    .offset(y: 35)
                            } else {
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 16, weight: .heavy))
                                    .foregroundColor(.gray)
                                    .rotationEffect(.init(degrees: refreshDown.started ? 180 : 0))
                                    .offset(y: 40)
                                    .animation(.easeIn)
                            }
                            
                        }
                        .offset(y: refreshDown.released ? -40 : 10)

                }
                .offset(y: refresh.released ? 40 : -10)
            }
            
        }
        .padding()
        .background(Color(red: 0.965, green: 0.959, blue: 0.999))
        .navigationTitle("家族广场")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: trailingButtonView(viewModel: viewModel))
    }
    func updateData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if refresh.startOffset == refresh.offset {
                // 更新数据
                viewModel.getGHList(page: 1, pageSize: 12)
                refresh.released = false
                refresh.started = false
            } else {
                refresh.invalid = true
            }
        }
        
    }
    
    func addData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if refreshDown.started && refreshDown.released {
                // 更新数据
                viewModel.addGHList(pageSize: 5)
                refreshDown.released = false
                refreshDown.started = false
            } else {
                refreshDown.invalid = true
            }
        }
        
    }
}

struct trailingButtonView: View {
    @StateObject var viewModel: GongHui
    @State var isGoToCreateGHView: Bool = false
    @State var isGoToMyGHView: Bool = false
    var body: some View {
        
//        NavigationLink(destination: create_gh(), isActive: $isGoToMyGHView) {}
        if viewModel.isHaveGHData?.data == nil {
            NavigationLink(destination: create_gh()) {
                Text("创建工会")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
        } else {
            NavigationLink(destination: create_gh()) {
                Text("我的工会")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
        }
        
        
    }
}

#Preview {
    NavigationView {
        pullDownLoadingView()
    }
    
}

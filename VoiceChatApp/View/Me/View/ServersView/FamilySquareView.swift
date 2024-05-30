//
//  FamilySquareView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/20.
//

import SwiftUI

import ProgressHUD
// 用户主页信息

// 按钮渐变色
// Color(red: 0.742, green: 0.632, blue: 0.997)
// Color(red: 0.464, green: 0.427, blue: 0.993)
// 背景渐变色
// Color(red: 0.493, green: 0.352, blue: 0.79)
// Color(red: 0.283, green: 0.185, blue: 0.626)
// 背景浅色
// Color(red: 0.982, green: 0.982, blue: 0.997)


struct ShowUserInfoFullCoverSheet: ViewModifier {
    var userId: Int
    @Binding var isShowUserInfoFullCoverSheet: Bool
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                isShowUserInfoFullCoverSheet.toggle()
            }
            .fullScreenCover(isPresented: $isShowUserInfoFullCoverSheet) {
                NavigationView {
                    UserProfileSheetView(userId: userId, isCloseUserProfileSheetView: $isShowUserInfoFullCoverSheet)
                }
            }
    }
}

extension View {
    func showUserInfoFullCoverSheet(userId: Int = UserCache.shared.getUserInfo()?.userId ?? 0, isShowUserInfoFullCoverSheet: Binding<Bool>) -> some View {
        modifier(ShowUserInfoFullCoverSheet(userId: userId, isShowUserInfoFullCoverSheet: isShowUserInfoFullCoverSheet))
    }
}

struct FamilySquareView: View {
    @StateObject private var vm: FamilySquare = FamilySquare()
    @State private var searchContent: String = ""
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.982, green: 0.982, blue: 0.997).edgesIgnoringSafeArea(.bottom)
            
            VStack(alignment: .center, spacing: 12)  {
                SearchFrame_FamilySquare(searchContent: $searchContent)
                    .padding(.top, 12)
                ScrollView {
                    ForEach(vm.familySquareList, id: \.id) { item in
                        NavigationLink(destination: FamilyPageView(item: item).environmentObject(vm)) {
                            FamilySquareViewItem(item: item)
                        }
                    }
                    Divider()
                        .onAppear {
                            vm.getFamilySquareList(page: vm.currentPage + 1)
                        }
                    
                }
            }
        }
        .navigationTitle("家族广场")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct FamilyPageView: View {
    @EnvironmentObject var vm: FamilySquare
    let item: FamilySquareListModel.data.list
    @State var isShowUserInfoFullCoverSheet: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [Color(red: 0.493, green: 0.352, blue: 0.79), Color(red: 0.283, green: 0.185, blue: 0.626)], startPoint: .leading, endPoint: .trailing).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 12)  {
                VStack(alignment: .center, spacing: 8)  {
                    KFImageView(imageUrl: item.guild_image)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                    Text(item.guild_name)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                    
                    HStack(alignment: .center, spacing: 4)  {
                        Image(.iconGuildId)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        Text("\(String(item.id))")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                        Text("|")
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                        Text("\(item.membernum)")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .padding(.vertical, 12)
                
                
                VStack(alignment: .center, spacing: 12)  {
                    UserInfo
                    Announcement
                    Introduce
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal ,12)
                .background(Color(red: 0.982, green: 0.982, blue: 0.997))
                .cornerRadius(10)
                .edgesIgnoringSafeArea(.bottom)
            }
            
            
        }
        .overlay(alignment: .bottom) {
            Text("加入家族")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                .background(LinearGradient(colors: [Color(red: 0.742, green: 0.632, blue: 0.997), Color(red: 0.464, green: 0.427, blue: 0.993)], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(30)
                .onTapGesture {
//                    print("加入家族")
                    JoinFamily()
                }
        }
        .navigationTitle(item.guild_name)
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
    
    func JoinFamily() {
        vm.applyJoinGuild(id: item.id) { msg in
            if msg == "已经申请过了，请勿重复申请" {
                ProgressHUD.error(msg, delay: 1)
            } else {
                ProgressHUD.succeed(msg, delay: 1)
            }
        }
    }
    
    var UserInfo: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView_Fill(imageUrl: item.user.headimgurl)
                .frame(width: 60, height: 60)
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 0)  {
                HStack(alignment: .center, spacing: 4)  {
                    Text(item.user.nickname)
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                    Image(item.user.sex == 1 ? "ic_chatroom_gender_boy" : "ic_chatroom_gender_gril")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                
                Spacer()
                HStack(alignment: .center, spacing: 12)  {
                    Text("族长")
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(LinearGradient(colors: [Color(red: 0.742, green: 0.632, blue: 0.997), Color(red: 0.464, green: 0.427, blue: 0.993)], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    Text("\(String(item.user.id))")
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(.gray)
                .font(.system(size: 16))
        }
        .frame(height: 60)
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .showUserInfoFullCoverSheet(userId: item.user_id, isShowUserInfoFullCoverSheet: $isShowUserInfoFullCoverSheet)
        
    }
    
    var Announcement: some View {
        HStack(alignment: .center, spacing: 12)  {
            Text("公告")
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(LinearGradient(colors: [Color(red: 0.742, green: 0.632, blue: 0.997), Color(red: 0.464, green: 0.427, blue: 0.993)], startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 30))
            
            Text("\(item.guild_nickname)")
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .bold))
            Spacer()
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        
    }
    
    var Introduce: some View {
        HStack(alignment: .center, spacing: 0)  {
            VStack(alignment: .leading, spacing: 12)  {
                Text("家族介绍")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .bold))
                Text("家族介绍")
                    .font(.system(size: 15))
            }
            Spacer()
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct SearchFrame_FamilySquare: View {
    @Binding var searchContent: String
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16))
                .padding(6)
            
            TextField("搜索家族ID，昵称", text: $searchContent)
                .font(.system(size: 16))
                .padding(.vertical, 6)
        }
        .background(Color.white)
        .cornerRadius(30)
        .padding(.horizontal, 12)
    }
}

struct FamilySquareViewItem: View {
    let item: FamilySquareListModel.data.list
    var body: some View {
        HStack(alignment: .center, spacing: 8)  {
            KFImageView_Fill(imageUrl: item.guild_image)
                .frame(width: 60, height: 60)
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 0)  {
                HStack(alignment: .center, spacing: 0)  {
                    Text(item.guild_name)
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
                Spacer()
                Text(item.guild_desc)
                    .foregroundColor(.gray)
                    .font(.system(size: 13, weight: .light))
                Spacer()
                Text("家族ID \(String(item.id))")
                    .foregroundColor(.gray)
                    .font(.system(size: 13, weight: .light))
            }
            .frame(height: 60)
            
            
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        FamilySquareView()
    }
}



// 推荐Class
class FamilySquare: ObservableObject {
    
    @Published var familySquareList: [FamilySquareListModel.data.list] = [] // 家族广场(无Token)
    @Published var currentPage: Int = 1
    
    init() {
        getFamilySquareList() // 家族广场(无Token)
    }
    
    
    // MARK: 家族广场(无Token)
    func getFamilySquareList(page: Int = 1) {
//        let funcNmae: String = "getFamilySquareList"
//        guard let url = URL(string: "\(baseUrl.newurl)api/guild/index?page=\(page)&pageSize=15") else { return }
//        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
//        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
//            guard let self = self else { return }
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(FamilySquareListModel.self, from: data)
//                    DispatchQueue.main.async {
//                        debugPrint("\(funcNmae) function Success result：\(result.message)")
//                        if page != 1 {
//                            self.familySquareList.append(contentsOf: result.data.list)  // 更新数据
//                        } else {
//                            self.familySquareList = result.data.list  // 更新数据
//                        }
//                        
//                        self.currentPage = result.data.currentPage
//                    }
//                } else {
//                    debugPrint("\(funcNmae) other result：No data")
//                }
//            } catch(let error) {
//                debugPrint("\(funcNmae) function Error result：\(error.localizedDescription)")
//            }
//        }.resume()
    }
    
    // MARK: 申请加入公会
    func applyJoinGuild(id: Int, completion: @escaping (String) -> Void) {
//        let body: [String: Any] = [ "id" : String(id)]
//        
//        // =============POST==================
//        guard let url = URL(string: "\(baseUrl.url)api/guild/ApplyJoinGuild") else { return }
//        
//        do {
//            let finalData = try JSONSerialization.data(withJSONObject: body)
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.httpBody = finalData
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
//            
//            
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                do {
//                    if let data = data {
//                        let result = try JSONDecoder().decode(baseModel.self, from: data)
//                        debugPrint("applyJoinGuild Success result：\(result)")
//                        completion(result.message)
//                    }
//                } catch(let error) {
//                    completion("加入公会失败")
//                    debugPrint("applyJoinGuild error result: ", error.localizedDescription)
//                }
//                
//            }.resume()
//        } catch {
//            completion("网络异常,加入公会失败")
//            debugPrint("applyJoinGuild error result: ", error.localizedDescription)
//        }
    }
}


struct FamilySquareListModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable {
        let list: [list]
        let currentPage: Int
        
        struct list: Decodable {
            let id: Int
            let user_id: Int
            let category_id: Int
            let guild_name: String
            let guild_image: String
            let guild_nickname: String
            let guild_desc: String
            let createtime: String
            let members_count: Int
            let membernum: Int
            let user: user
            
            struct user: Decodable {
                let id: Int
                let nickname: String
                let sex: Int
                let headimgurl: String
            }
        }
    }
    
    
}

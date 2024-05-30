//
//  MyGrade.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/11/12.
//

import SwiftUI

 
import Alamofire

struct MyGrade: View {
    @State var isSeletor: Bool = false
    @StateObject var vm: UserInfoMain = UserInfoMain()
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.201, green: 0.201, blue: 0.201).ignoresSafeArea()
            VStack(alignment: .center, spacing: 6)  {
                HStack(alignment: .center, spacing: 0)  {
                    HStack(alignment: .center, spacing: 0)  {
                        Spacer()
                        Text("财富等级")
                            .padding(.horizontal, 12)
                            .foregroundColor(isSeletor ? .gray : .white)
                            .font(.system(size: isSeletor ? 18 : 20, weight: isSeletor ? .bold : .bold))
                            .onTapGesture {
                                withAnimation {
                                    isSeletor = false
                                }
                                
                            }
                        Spacer()
                    }
                    HStack(alignment: .center, spacing: 0)  {
                        Spacer()
                        Text("魅力等级")
                            .padding(.horizontal, 12)
                            .foregroundColor(!isSeletor ? .gray : .white)
                            .font(.system(size: !isSeletor ? 18 : 20, weight: !isSeletor ? .bold : .bold))
                            .onTapGesture {
                                withAnimation {
                                    isSeletor = true
                                }
                            }
                        Spacer()
                    }
                }
                .padding(.bottom, 18)
                
                ScrollView {
                    VStack(alignment: .center, spacing: 8)  {
                        KFImageView_Fill(imageUrl: vm.userinfo?.avatar ?? "")
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text("当前等级距离下一级还差\(String(1000))")
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                        HStack(alignment: .center, spacing: 4)  {
                            Text("\(String(0))%")
                                .foregroundColor(.purple)
                                .font(.system(size: 15, weight: .medium))
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 1.2)
                            KFImageView_Fill(imageUrl: !isSeletor ? vm.userinfo?.goldImg ?? "" : vm.userinfo?.starsImg ?? "")
                                .frame(width: 40, height: 40)
                                .padding(.leading, 8)
                        }
                        .padding(.horizontal, 24)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 140)
                    .background(LinearGradient(colors:  !isSeletor ? [Color(red: 0.676, green: 1.001, blue: 0.803), Color(red: 0.989, green: 0.621, blue: 0.577)] : [Color(red: 1.0, green: 0.524, blue: 0.888), Color(red: 0.99, green: 0.602, blue: 0.583)], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    
                    
                    Image(!isSeletor ? "cf_help" : "ml_help")
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: UIScreen.main.bounds.width)
            }
        }
        .navigationTitle("用户等级")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
             UserRequest.getUserInfo(completion: { userinfo in
                 vm.userinfo = userinfo
            })
        }
        
    }
}




class UserInfoMain: ObservableObject {
    @Published var userinfo: UserInfo? = nil
    @Published var userId: Int = 0
    
    init() {
        
    }
    
    func initAction(userId: Int) {
        self.userId = userId
        self.getUserInfo() // 获取用户信息
    }
    
    func getUserInfo() {
        NetworkTools.requestAPI(convertible: "/user/getUserInfoById",
                                method: .post,
                                parameters: [
                                    "userId": userId
                                ],
                                responseDecodable: UserInfoRequestModel.self) { result in
            if result.code == 0 {
                self.userinfo = result.data
            }
        } failure: { _ in
            
        }
    }
    

    
    
}



struct myStoreModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable, Equatable {
        let id: Int
        let ali_user_id: String?
        let ali_avatar: String?
        let ali_nick_name: String?
        let mizuan: String
        let mibi: String
        let r_mibi: String
        let is_ali: Int
    }
}

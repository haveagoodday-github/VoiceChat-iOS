//
//  EditPersonageInfo.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/10/29.
//

import SwiftUI

import Alamofire
import ProgressHUD

struct EditPersonageInfo: View {
    @State var avatar: String = ""
    @State var name: String = ""
    @State var gender: String = "男"
    @State var content: String = ""
    @State var birthdate = Date()
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    let genderList: [String] = ["男", "女"]
    @Environment(\.presentationMode) var presentationMode
    @State private var birthdayString: String = "1999-01-01"
    @StateObject private var vm: editUserinfo = editUserinfo()
    @EnvironmentObject var vmUserinfoMain: UserInfoMain
    var body: some View {
        Form {
            Section("头像", content: {
                if let image = selectedImage {
                    Button(action: {
                        //                        selectedImage = nil
                        isImagePickerPresented.toggle()
                    }, label: {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    })
                } else {
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }, label: {
                        Circle()
                            .fill(Color(red: 0.956, green: 0.95, blue: 0.99))
                            .frame(width: 70, height: 70)
                            .overlay(alignment: .center) {
                                KFImageView_Fill(imageUrl: vm.userinfo?.headimgurl ?? "")
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            }
                    })
                    
                }
                
            })
            
            Section("基本资料", content: {
                HStack(alignment: .center, spacing: 32)  {
                    Text("昵称 ")
                    Spacer()
                    TextField("请输入新的昵称", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                Picker("性别", selection: $gender) {
                    ForEach(genderList, id: \.self) { item in
                        Text(item)
                    }
                }
                DatePicker("年龄", selection: $birthdate, displayedComponents: .date)
            })
            
            
            Section("个性签名", content: {
                TextField("填写个签更容易获得互动哦～", text: $content)
            })
            
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .navigationTitle("修改个人资料")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: trailingView)
        .onChange(of: birthdate) { newValue in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: birthdate)
            if let year = components.year, let month = components.month, let day = components.day {
                birthdayString = "\(year)-\(month)-\(day)"
                print(birthdayString)
            }
            
        }
        .onChange(of: vm.userinfo) { newValue in
            name = vm.userinfo?.nickname ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let date = dateFormatter.date(from: vm.userinfo?.birthday ?? "") {
                birthdate = date
            }
            
            content = vm.userinfo?.signature ?? ""
            gender = vm.userinfo?.sex == 1 ? "男" : "女"
        }
    }
    
    
    var trailingView: some View {
        Button(action: {
            save()
        }, label: {
            Text("保存")
        })
    }
    
    
    private func save() {
//        ProgressHUD.animate("Loading...")
//        if let image = selectedImage {
//            UIImage.qiniuUploadImage(image: image, imageName: "userAvatar\(UIImage.generateRandomString())") { imageUrl in
//                
//                NetworkTools.requestAPI(convertible: "https://api.msyuyin.cn/api/edit_user_info",
//                                        method: .post,
//                                        parameters: [
//                                            "id": UserCache.shared.getUserInfo()?.userId,
//                                            "img": imageUrl,
//                                            "nickname": name,
//                                            "sex": String(gender == "男" ? 1 : 2),
//                                            "birthday": birthdayString,
//                                            "constellation": "狮子座",
//                                            "city": "北京市",
//                                            "signature": content
//                                        ],
//                                        responseDecodable: baseModel.self) { result in
//                    presentationMode.wrappedValue.dismiss()
//                    if result.code == 1 {
//                        ProgressHUD.succeed("修改成功")
//                    } else {
//                        ProgressHUD.error("修改失败", delay: 2)
//                    }
////                    self.vmUserinfoMain.getUserInfo()
//                } failure: { _ in
//                    
//                }
//
//                
//            }
//        } else {
//            
//            NetworkTools.requestAPI(convertible: "https://api.msyuyin.cn/api/edit_user_info",
//                                    method: .post,
//                                    parameters: [
//                                        "id": UserCache.shared.getUserInfo()?.userId,
//                                        "img": vm.userinfo?.headimgurl ?? "https://mmbiz.qpic.cn/sz_mmbiz_jpg/IhB6Hhm1o7ePJiavV7zqakVTqnua7IogpxuicTEEecdFkup5UGPVLmstpEj7CpddUo72Oj5gPZqE9kz97Nd2KzQA/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1",
//                                        "nickname": name,
//                                        "sex": String(gender == "男" ? 1 : 2),
//                                        "birthday": birthdayString,
//                                        "constellation": "狮子座",
//                                        "city": "北京市",
//                                        "signature": content
//                                    ],
//                                    responseDecodable: baseModel.self) { result in
//                presentationMode.wrappedValue.dismiss()
//                if result.code == 1 {
//                    ProgressHUD.succeed("修改成功")
//                } else {
//                    ProgressHUD.error("修改失败", delay: 2)
//                }
////                    self.vmUserinfoMain.getUserInfo()
//            } failure: { _ in
//                
//            }
//            
//        }
    }
    
    
}


class editUserinfo: ObservableObject {
    @Published var userinfo: UserinfoModel.data? = nil
    
    init() {
        self.getUserInfo()
    }
    
    private func getUserInfo() {
        AF.request("https://api.msyuyin.cn/api/get_user_info?user_id=\(UserCache.shared.getUserInfo()?.userId)", method: .get).responseDecodable(of: UserinfoModel.self) { res in
            switch res.result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.userinfo = result.data
                }
            case .failure(let error):
                print("getUserInfo result error: \(error.localizedDescription)")
            }
        }
    }
}


struct UserinfoModel: Decodable {
    let code: Int
    let message: String
    let data: data
    
    struct data: Decodable, Equatable {
        let id: Int
        let headimgurl: String
        let nickname: String
        let sex: Int
        let birthday: String
        let signature: String
    }
}

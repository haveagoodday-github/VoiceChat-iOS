//
//  EditRoomInfoView.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/9/11.
//

import SwiftUI

//import //import JGProgressHUD_SwiftUI

struct EditRoomInfoView: View {
    let uid: Int
    let roomId: Int
    @State var shutCurrentView: Bool = false
    @Environment(\.presentationMode) var presentationModel
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            Text("修改房间信息")
                .font(.system(size: 18, weight: .bold))
                .padding(.vertical)
            EditRoomInfoForm(uid: uid,  roomId: roomId) {
                presentationModel.wrappedValue.dismiss()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                hideKeyboard()
            }, label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .padding()
            })
        }
        
    }
}


struct EditRoomInfoForm: View {
    @StateObject var viewModel = RoomModel()
    @StateObject var editModel = EditRoomInfoModel()
    @State var userid: String = ""
    @State var roomName: String = ""
    @State var announcement: String = ""
    @State var roomPassword: String = ""
    @State var isSetPassword: Bool = false
//    let themeArray: [String] = ["交友", "闲聊", "陪伴", "连麦"]
    
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    @State private var backgroundSelect: String = "默认"
    @State private var backgroundSelectID: Int = 80
    @State private var isShowBackgroundSelect: Bool = false
    
//    @State private var typeID: Int = 0
    
    let uid: Int
    let roomId: Int
    
    //    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    var action: () -> Void
    var body: some View {
        Form {
            Section("房间名称", content: {
                TextField("请输入房间名称，限15字", text: $roomName)
                    .onChange(of: roomName) { newValue in
                        if newValue.count > 15 {
                            roomName = String(newValue.prefix(15))
                        }
                    }
            })
            Section("公告", content: {
                TextEditor(text: $announcement)
                //                    TextField("请输入公告内容，限200字", text: $announcement)
            })
            Section("更换封面", content: {
                if let image = selectedImage {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(12)
                        
                        Button(action: {
                            selectedImage = nil
                        }, label: {
                            Image(systemName: "multiply")
                                .font(.footnote)
                                .padding(4)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .offset(x: 5, y: -5)
                        })
                    }
                } else {
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }, label: {
                        Rectangle()
                            .fill(Color(red: 0.956, green: 0.95, blue: 0.99))
                            .frame(width: 100, height: 100)
                            .overlay(alignment: .center) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .foregroundColor(.gray.opacity(0.6))
                                    .frame(width: 30, height: 30)
                            }
                            .overlay(alignment: .bottom) {
                                Text("更换封面")
                                    .font(.system(size: 14))
                                    .padding(.vertical, 3)
                                    .foregroundColor(.white)
                                    .frame(width: 100)
                                    .background(Color(red: 0.484, green: 0.479, blue: 0.502))
                            }
                            .cornerRadius(12)
                    })
                    .padding(.trailing, 18)
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    
                }
                
                
                
                
            })
            
            Section("房间上锁", content: {
                HStack(alignment: .center, spacing: 0)  {
                    TextField("请输入6位数字密码", text: $roomPassword)
                        .keyboardType(.numberPad)
                        .disabled(!isSetPassword)
                    Toggle("", isOn: $isSetPassword)
                }
            })
            
            // 背景
            Section() {
                Button(action: {
                    viewModel.getRoomBackgroundArray()
                    isShowBackgroundSelect.toggle()
                }, label: {
                    HStack(alignment: .center, spacing: 0)  {
                        Text("房间背景")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(backgroundSelect) >")
                            .foregroundColor(.gray)
                    }
                })
                .sheet(isPresented: $isShowBackgroundSelect, content: {
                    selectorBackgroundView(viewModel: viewModel, backgroundSelect: $backgroundSelect, backgroundSelectID: $backgroundSelectID, isShowBackgroundSelect: $isShowBackgroundSelect)
                })
                
                
            }
            
            Section("类型", content: {
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 12)  {
                        ForEach(editModel.typeListArray, id: \.roomTypeId) { item in
                            CreateRoomFormCustomButton(title: item.name, isSelected: editModel.currentType == item, action: {
                                editModel.currentType = item
                            })
                        }
                    }
                }
            })
            
            Section() {
                Button(action: {
                    // 提交
//                    uploadCoverImage()
                }, label: {
                    Text("提交")
                })
            }
        }

    }
    
//    func uploadCoverImage() {
//        if let image = selectedImage {
//            UIImage.qiniuUploadImage(image: image, imageName: "roombg") { imageURL in
//                submit(adminID: String(userid), RoomID: String(roomId), coverURL: imageURL)
//            }
//        }
//        action()
//    }
    
    func submit(adminID: String, RoomID: String, coverURL: String) {
        editModel.editRoomInfo(adminID: adminID, coverURL: coverURL, room_intro: announcement, room_name: roomName, room_pass: roomPassword, room_type: editModel.currentType, room_background: backgroundSelectID, roomId: RoomID) { result in
            
        }
    }
}


struct selectorBackgroundView: View {
    @StateObject var viewModel: RoomModel
    
    @Binding var backgroundSelect: String
    @Binding var backgroundSelectID: Int
    @Binding var isShowBackgroundSelect: Bool
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], alignment: .center, spacing: 12, content: {
                ForEach(viewModel.roomBackgroundArray, id: \.backgroundId) { item in
                    Button(action: {
                        backgroundSelect = item.backgroundName
                        backgroundSelectID = item.backgroundId
                        isShowBackgroundSelect.toggle()
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

//#Preview {
//    EditRoomInfoView()
//}

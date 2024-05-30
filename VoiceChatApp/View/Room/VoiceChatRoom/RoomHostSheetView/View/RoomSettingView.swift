    //
//  RoomSettingView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/11/17.
//

import SwiftUI
import ProgressHUD
import Defaults


struct RoomSettingView: View {
    @StateObject private var viewModel: CreateRoomViewModel = CreateRoomViewModel()
    @StateObject var viewModelRoom: RoomModel
//    @State var closeAction: () -> ()
    @State private var isShowSettingBackground: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            Form {
                Section("房间名称", content: {
                    TextField("请输入房间名称，限15字", text: $viewModel.createRoomModel.roomName)
                        .onChange(of: viewModel.createRoomModel.roomName) { newValue in
                            if newValue.count > 15 {
                                viewModel.createRoomModel.roomName = String(newValue.prefix(15))
                            }
                        }
                })
                Section("更换封面", content: {
                    Button(action: {
                        viewModel.isImagePickerPresented.toggle()
                    }, label: {
                        if let image = viewModel.createRoomModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(12)
                        } else {
                            KFImageView_Fill(imageUrl: viewModelRoom.roomInfo?.roomCover ?? "")
                                .frame(width: 100, height: 100)
                                .cornerRadius(12)
                        }
                    })
                    .padding(.trailing, 18)
                    .sheet(isPresented: $viewModel.isImagePickerPresented) {
                        ImagePicker(selectedImage: $viewModel.createRoomModel.selectedImage)
                    }
                    

                    
                })
                Section("房间介绍", content: {
                    TextEditor(text: $viewModel.createRoomModel.intro)
                        .frame(height: 100)
                })
                Section("房间欢迎语", content: {
                    TextEditor(text: $viewModel.createRoomModel.welcome)
                        .frame(height: 100)
                })
                Section("房间主题", content: {
                    Picker("房间主题", selection: $viewModel.createRoomModel.selectedRoomTypeName) {
                        ForEach(viewModel.roomTypeList.map({$0.name}), id: \.self) { name in
                            Text(name)
                        }
                    }
                    .pickerStyle(.menu)
                })
                
                Section("房间上锁", content: {
                    HStack(alignment: .center, spacing: 0)  {
                        TextField("请输入6位数字密码", text: $viewModel.createRoomModel.roomPassword)
                            .keyboardType(.numberPad)
                            .disabled(!viewModel.isSetPassword)
                        Toggle("", isOn: $viewModel.isSetPassword)
                    }
                })
                Section() {
                    Button(action: {
                        viewModel.getRoomBackgroundList()
                        viewModel.isShowBackgroundSelect.toggle()
                    }, label: {
                        HStack(alignment: .center, spacing: 0)  {
                            Text("房间背景")
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(viewModel.createRoomModel.roomBackgroundSelected?.backgroundName ?? "") >")
                                .foregroundColor(.gray)
                        }
                    })
                    .sheet(isPresented: $viewModel.isShowBackgroundSelect, content: {
                        ScrollView {
                            LazyVGrid(
                                columns: Array(
                                    repeating: GridItem(.flexible(), spacing: 10),
                                    count: 3
                                ),
                                alignment: .center, spacing: 12,
                                content: {
                                ForEach(viewModel.roomBackgroundList, id: \.backgroundId) { item in
                                    Button(action: {
                                        viewModel.createRoomModel.roomBackgroundSelected = item
                                        viewModel.isShowBackgroundSelect.toggle()
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
                    })
                    
                    
                }
                Section() {
                    Button(action: {
                        viewModel.updateRoomAction(roomId: viewModelRoom.roomId)
                    }, label: {
                        Text("更新房间")
                    })
                }
            }
        }
//        .background(Color(red: 0.951, green: 0.951, blue: 0.97))
//        .navigationTitle("修改房间信息")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarItems(trailing: trailingSave)
        .onAppear {
            if let pass = viewModelRoom.roomInfo?.roomPassword {
                viewModel.isSetPassword = pass.isEmpty
            }
            if let rf = viewModelRoom.roomInfo {
                viewModel.createRoomModel = CreateRoomModel(
                    roomName: rf.roomName,
                    roomPassword: rf.roomPassword,
                    selectedImage: nil,
                    selectedRoomTypeName: "",
                    roomBackgroundSelected: nil,
                    welcome: rf.welcome ?? "",
                    intro: rf.intro
                )
                
                viewModel.selectedTypeId = rf.type
                viewModel.roomBackgroundSelectedUrl = rf.roomBackground
                viewModel.roomCover = rf.roomCover
            }
        }
//        .fullScreenCover(isPresented: $isShowSettingBackground) {
//            RoomBackgroundView(viewModel: viewModel) {
//                viewModel.isShowSettingBackground.toggle()
//            }
//        }
    }
    
}

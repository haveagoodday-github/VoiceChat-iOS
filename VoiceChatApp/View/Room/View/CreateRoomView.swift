//
//  CreateRoomView.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/9/2.
//

import SwiftUI

//import //import JGProgressHUD_SwiftUI


#Preview {
//    CreateRoomView()
    CreateRoomView()
}
// 自定义按钮
struct CreateRoomFormCustomButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .foregroundColor(.gray)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(isSelected ? Color.yellow.opacity(0.5) : Color(red: 0.956, green: 0.95, blue: 0.99))
                .cornerRadius(30)
        }
    }
}

struct CreateRoomView: View {
    @StateObject private var viewModel: CreateRoomViewModel = CreateRoomViewModel()
    
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
                                    Text("房间封面")
                                        .font(.system(size: 14))
                                        .padding(.vertical, 3)
                                        .foregroundColor(.white)
                                        .frame(width: 100)
                                        .background(Color(red: 0.484, green: 0.479, blue: 0.502))
                                }
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
                        viewModel.createRoomAction()
                    }, label: {
                        Text("创建房间")
                    })
                }
            }
        }

        
        // 跳转到已经创建好的房间内
//        NavigationLink(destination: NestView2(roomId:  UserCacheMyNestInfo.shared.getUserMyNestInfo()?.first?.id ?? 0, roomUid: UserCacheMyNestInfo.shared.getUserMyNestInfo()?.first?.uid ?? 0, roomPass: "", isGotoRoom: $isGoToMyRoom), isActive: $isGoToMyRoom) { }
        
    }
    
    
}

 

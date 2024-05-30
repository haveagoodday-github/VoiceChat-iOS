//
//  CreateGHView.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/9/7.
//


import SwiftUI
import PhotosUI

struct create_gh: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            topBgView()
            GuildFormView()
        }
        .navigationBarTitle("创建公会", displayMode: .inline) // 添加标题
        .navigationBarItems(trailing: packUpKeyBoardView())
        
    }
}

struct packUpKeyBoardView: View {
    var body: some View {
        Button(action: {
            hideKeyboard()
        }, label: {
            Image(systemName: "keyboard.chevron.compact.down")
                .font(.system(size: 14))
        })
    }
}


struct topBgView: View {
    var body: some View {
        ZStack(alignment: .center) {
            KFImageView_Fill(imageUrl: "https://img02.mockplus.cn/image/2022-11-17/62c07980-6688-11ed-8869-ff4751c452a3.png")
                .frame(height: 120)

            
            Text("创建公会")
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.white)
                .offset(y: -12)
            
        }
        .overlay(alignment: .bottom) {
            Text("为保证公会顺利通过，请如实填写下列信息")
                .foregroundColor(.white)
                .font(.system(size: 13, weight: .bold))
        }
    }
}






enum FocusTextType {
    case guildName, personName, idCardNumber, commissionPercentage, guildDescription
}

struct GuildFormView: View {
    
    @State private var guildName = ""
    @State private var personName = ""
    @State private var idCardNumber = ""
    @State private var commissionPercentage = ""
    @State private var guildDescription = ""
    
    @State private var image1URL: String = ""
    @State private var image2URL: String = ""
    @State private var image3URL: String = ""
    @State private var image4URL: String = ""
    @State private var image5URL: String = ""
    
    
    @State private var isStartUpdataImage: Bool = false
    
//    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @FocusState private var focusField: FocusTextType?
    var body: some View {
        
        
        VStack(alignment: .center, spacing: 0)  {
            Form {
                Section("公会名称", content: {
                    TextField("请输入要您要创建的公会名称", text: $guildName)
                        .focused($focusField, equals: .guildName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusField = .personName
                        }
                })
                Section("个人姓名", content: {
                    TextField("请输入您的姓名", text: $personName)
                        .focused($focusField, equals: .personName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusField = .idCardNumber
                        }
                })
                Section("身份证号", content: {
                    TextField("请填写您的身份证号码", text: $idCardNumber)
                        .focused($focusField, equals: .idCardNumber)
                        .submitLabel(.next)
                        .onSubmit {
                            focusField = .commissionPercentage
                        }
                })
                Section("抽成比例", content: {
                    TextField("请填写0-100之间的整数", text: $commissionPercentage)
                        .keyboardType(.numberPad)
                        .focused($focusField, equals: .commissionPercentage)
                        .submitLabel(.next)
                        .onSubmit {
                            focusField = .guildDescription
                        }
                })
                
                Section("公会简介", content: {
                    ZStack(alignment: .topLeading) {
                        if guildDescription.isEmpty {
                            Text("请输入公会简介")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                                .padding(.top, 6)
                        }
                        TextEditor(text: $guildDescription)
                            .frame(height: 100)
                    }
                    .font(.footnote)
                })

                Section("身份证正面", content: {
                    updataImageItemView(imagename: "IDCardFront", imagetext: "身份证正面", isStartUpdataImage: $isStartUpdataImage, updataResult: $image1URL)
                })
                Section("身份证反面", content: {
                    updataImageItemView(imagename: "IDCardBack", imagetext: "身份证反面", isStartUpdataImage: $isStartUpdataImage, updataResult: $image2URL)
                })
                
                Section("手持身份证", content: {
                    updataImageItemView(imagename: "IDCardInHand", imagetext: "手持身份证", isStartUpdataImage: $isStartUpdataImage, updataResult: $image3URL)
                })
                
                Section("营业执照", content: {
                    updataImageItemView(imagename: "BusinessLicense", imagetext: "营业执照", isStartUpdataImage: $isStartUpdataImage, updataResult: $image4URL)
                })
                
                
                
                Section("证件照片", content: {
                    updataImageItemView(imagename: "AvatarGH", imagetext: "公会头像", isStartUpdataImage: $isStartUpdataImage, updataResult: $image5URL)
                })
                
                
                Section {
                    Button("提交申请") {
                        // 判断输入内容
                        if !guildName.isEmpty && !personName.isEmpty && !idCardNumber.isEmpty && !commissionPercentage.isEmpty && !guildDescription.isEmpty {
                            isStartUpdataImage.toggle() // 开始上传图片
//                            hudCoordinator.showHUD {
//                                let hud = JGProgressHUD()
//                                hud.textLabel.text = "上传图片中..."
//                                return hud
//                            }
                            // 判断图片链接
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                if !image1URL.isEmpty && !image2URL.isEmpty && !image3URL.isEmpty && !image4URL.isEmpty && !image5URL.isEmpty {
                                    print("上传成功\(image1URL)\(image2URL)\(image3URL)\(image4URL)\(image5URL)")
                                } else {
                                }
                            }
                        } else {
                            
                        }
                        
                        
                        

                        
                        

                    }
                }
            }
        }
    }
}


struct updataImageItemView: View {
    let imagename: String
    let imagetext: String
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @Binding var isStartUpdataImage: Bool
    
    @Binding var updataResult: String
    
    var body: some View {
        if let image = selectedImage {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
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
            .onChange(of: isStartUpdataImage) { newValue in
                if let image = selectedImage {
                    updataImage()
                }
            }
        } else {
            Button(action: {
                isImagePickerPresented.toggle()
            }, label: {
                Rectangle()
                    .fill(Color(red: 0.956, green: 0.95, blue: 0.99))
                    .frame(height: 100)
                    .overlay(alignment: .center) {
                        VStack(alignment: .center, spacing: 2)  {
                            Image(imagename)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray.opacity(0.6))
                                .frame(width: 50, height: 50)
                            Text(imagetext)
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                        }
                    }
                    .cornerRadius(12)
            })
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .onChange(of: isStartUpdataImage) { newValue in
                if let image = selectedImage {
                    
                } else {
                    
                }
            }

        }
            
    }
    
}



import SwiftUI
import PhotosUI

struct create_gh: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 12) {
                topBgView()
                GuildFormView()
            }
            .navigationBarTitle("创建公会", displayMode: .inline) // 添加标题
        }
    }
}

struct topBgView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .center) {
                if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-17/62c07980-6688-11ed-8869-ff4751c452a3.png") {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 110)
                    } placeholder: {
                        ProgressView()
                    }
                    
                }
                
                Text("创建公会")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y: -12)
                
            }
            
            Text("为保证公会顺利通过，请如实填写下列信息")
                .foregroundColor(.white)
                .font(.caption)
        }
    }
}








struct GuildFormView: View {
    @State private var guildName = ""
    @State private var personName = ""
    @State private var idCardNumber = ""
    @State private var commissionPercentage = ""
    @State private var guildDescription = ""
    
    
    
    @StateObject var IDCardFront = PhotoPickerViewModel()
    @StateObject var IDCardBack = PhotoPickerViewModel()
    @StateObject var IDCardInHand = PhotoPickerViewModel()
    @StateObject var BusinessLicense = PhotoPickerViewModel()
    @StateObject var AvatarGH = PhotoPickerViewModel()
    
    var body: some View {
        
        
        Form {
            Section(header: Text("公会信息")) {
                
                VStack(alignment: .leading) {
                    Text("公会名称")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                    
                    ZStack(alignment: .topLeading) {
                        TextField("请输入要您要创建的公会名称", text: $guildName)
                    }
                    .font(.footnote)
                }
                
                
                VStack(alignment: .leading) {
                    Text("个人姓名")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                    
                    ZStack(alignment: .topLeading) {
                        TextField("请输入您的姓名", text: $personName)
                    }
                    .font(.footnote)

                }
                
                VStack(alignment: .leading) {
                    Text("身份证号")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                    
                    ZStack(alignment: .topLeading) {
                        TextField("请填写您的身份证号码", text: $idCardNumber)
                    }
                    .font(.footnote)

                }
                
                
                VStack(alignment: .leading) {
                    Text("抽成比例")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                    
                    ZStack(alignment: .topLeading) {
                        TextField("请填写0-100之间的整数", text: $commissionPercentage)
                            .keyboardType(.numberPad)
                    }
                    .font(.footnote)

                }
                
                
                VStack(alignment: .leading) {
                    Text("公会简介")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                    
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
                }
                
            }
            
            
            Section(header: Text("证件照片")) {
                ImagePickerButton(viewModel: IDCardFront, name: "身份证正面", imageName: "IDCardFront")
            }
            Section(header: Text("身份证反面")) {
                ImagePickerButton(viewModel: IDCardBack, name: "身份证反面", imageName: "IDCardBack")
            }
            Section(header: Text("手持身份证")) {
                ImagePickerButton(viewModel: IDCardInHand, name: "手持身份证", imageName: "IDCardInHand")
            }
            Section(header: Text("营业执照")) {
                ImagePickerButton(viewModel: BusinessLicense, name: "营业执照", imageName: "BusinessLicense")
            }
            Section(header: Text("公会头像")) {
                ImagePickerButton(viewModel: AvatarGH, name: "公会头像", imageName: "AvatarGH")
            }
            
            
            
            Section {
                Button("提交") {
                    // 在这里添加提交操作
                }
            }
        }
        .navigationBarTitle("公会申请表单", displayMode: .inline)
    }
}


struct ImagePickerButton: View {
    @StateObject var viewModel: PhotoPickerViewModel
    let name: String
    let imageName: String
    
    var body: some View {
        // iOS 16
        if let image = viewModel.selectedImage {
//            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: .infinity, height: 140)
//                    .cornerRadius(10)
//            }
        } else {
//            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
//                Rectangle()
//                    .fill(Color(red: 0.844, green: 0.844, blue: 0.844))
//                    .frame(width: .infinity, height: 140)
//                    .cornerRadius(10)
//                    .overlay(content: {
//                        VStack(alignment: .center, spacing: 0)  {
//                            Image(imageName)
//                            Text(name)
//                        }
//                    })
//            }
        }
    }
}



struct create_gh_Previews: PreviewProvider {
    static var previews: some View {
        create_gh()
    }
}

//
//  mall.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/11.
//

import SwiftUI


struct mall: View {
    var body: some View {
        VStack(spacing: 10)  {
            topPicker()
            topTypePicker()
            commodityView()
            
        }
        .padding(.horizontal)
        .ignoresSafeArea()
        
        
    }
}

struct commodityModel: Identifiable {
    let id = UUID()
    let img: String
    let name: String
    let price: String
    let term: String
}

class CommodityViewModel: ObservableObject {
    @Published var commodityArray: [commodityModel] = []
    
    init() {
        getCommodity()
    }
    
    func getCommodity() {
        self.commodityArray.append(commodityModel(img: "https://img02.mockplus.cn/image/2022-11-16/21f9a180-65b4-11ed-91fb-4b29e74055de.png", name: "满目星辰", price: "666", term: "7"))
        self.commodityArray.append(commodityModel(img: "https://img02.mockplus.cn/image/2022-11-16/21f9a180-65b4-11ed-91fb-4b29e74055de.png", name: "满目星河", price: "777", term: "7"))
        self.commodityArray.append(commodityModel(img: "https://img02.mockplus.cn/image/2022-11-16/012ef020-65b6-11ed-a481-71c58ef8d1b5.png", name: "满目星辰", price: "666", term: "7"))
        self.commodityArray.append(commodityModel(img: "https://img02.mockplus.cn/image/2022-11-16/21f9a180-65b4-11ed-91fb-4b29e74055de.png", name: "满目星辰", price: "666", term: "7"))
    }
    
}


struct commodityView: View {
    @StateObject var Commodity = CommodityViewModel()
    @State var showDressCard: Bool = false
    
    @State var current_img: String = ""
    @State var current_name: String = ""
    @State var current_price: String = ""
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(Commodity.commodityArray, id: \.id) { item in
                    Button(action: {
                        self.current_img = item.img
                        self.current_name = item.name
                        self.current_price = item.price
                        showDressCard.toggle()
                    }, label: {
                        VStack(alignment: .leading, spacing: 5)  {
                            KFImageView(imageUrl: item.img)
                                .frame(width: 70, height: 70)
                                .padding()
                                .background(Color.blue.opacity(0.4))
                                .cornerRadius(10)
//                            if let imageURL = URL(string: item.img) {
//                                AsyncImage(url: imageURL) { image in
//                                    image
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 70, height: 70)
//                                        .padding()
//                                        .background(Color.blue.opacity(0.4))
//                                        .cornerRadius(10)
//                                } placeholder: {
//                                    ProgressView()
//                                }
//                            }
                            Text(item.name)
                                .font(.footnote)
                                .foregroundColor(.black)
                            Text("\(item.price)/\(item.term)天")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    })
                    
                }
                
            }
//            .padding()
        }
//        .sheet(isPresented: $showDressCard, content: {
//            dressCard(commodityImgurl: current_img, name: current_name, price: current_price)
//                .ignoresSafeArea()
//            // iOS 16
////                .presentationDetents([.fraction(0.32), .fraction(0.50)])
////                .presentationDragIndicator(.visible)
//                
//        })
        
        HalfModelView(isShown: $showDressCard, content: {
            dressCard(commodityImgurl: $current_img, name: $current_name, price: $current_price)
                .ignoresSafeArea()
        })
        
        
    }
}


enum MallModel: String, CaseIterable {
    case commodity = "装扮"
    case props = "道具"
}



struct topPicker: View {
    @State private var mallType: MallModel = .commodity
    @State var isSelector: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .center, spacing: 12)  {
                Button(action: {
                    isSelector.toggle()
                }, label: {
                    Text("装扮")
                        .font(.system(size: 16, weight: isSelector ? .bold : .medium))
                        .foregroundColor(isSelector ? .gray : .black)
                })
                
                Button(action: {
                    isSelector.toggle()
                }, label: {
                    Text("道具")
                        .font(.system(size: 16, weight: !isSelector ? .bold : .medium))
                        .foregroundColor(!isSelector ? .gray : .black)
                })
                
            }
        }
        .frame(width: 150)
        
//        Picker("", selection: $mallType) {
//            ForEach(MallModel.allCases, id: \.rawValue) { type in
//                Text(type.rawValue)
//                    .tag(type)
//            }
//        }
//        .pickerStyle(.segmented)
//        .labelsHidden()
//        .frame(width: 150)
    }
}

enum typePickerModel: String, CaseIterable {
    case txk = "头像框"
    case zj = "座驾"
    case qp = "气泡"
    case fp = "浮萍"
    case yb = "音波"
    case fjbj = "房间背景"
}




struct topTypePicker: View {
    @State private var typePicker: typePickerModel = .txk
    
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.clear
        
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.black
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    
    var body: some View {
        Picker("", selection: $typePicker) {
            ForEach(typePickerModel.allCases, id: \.rawValue) { type in
                Text(type.rawValue)
                    .tag(type)
                    .font(.caption)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }
}


struct dressCard: View {
    @Binding var commodityImgurl: String
    @Binding var name: String
    @Binding var price: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5)  {
            // 头像
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                ZStack() {
                    // 头像
                    KFImageView(imageUrl: UserCache.shared.getUserInfo()?.avatar ?? "https://voicechat.oss-cn-shenzhen.aliyuncs.com/test_data/IMG_1295.PNG")
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                    
                    // 头像框
                    KFImageView(imageUrl: commodityImgurl)
                        .frame(width: 110, height: 110)
                    
                    
                    
                    
                    
                }
                Spacer()
            }
            .frame(height: 160)
//            .frame(width: .infinity, height: 160)
            .background(Color.blue.opacity(0.5))
            // 名称 价格
            VStack(alignment: .leading, spacing: 5)  {
                Text(name)
                    .font(.subheadline)
                HStack(alignment: .center, spacing: 0)  {
                    Text("钻石购买")
                    Text(price)
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            // 期限
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                Text("7天")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 40)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                Spacer()
                Text("15天")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 40)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                Spacer()
                
                Text("30天")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 40)
                    .cornerRadius(10) // 设置圆角半径
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                Spacer()
                
                
            }
            .padding(.vertical, 15)
            // 余额
            HStack(alignment: .center, spacing: 10)  {
                Spacer()
                Text("钻石余额：100")
                    .font(.caption)
                Button(action: {
                    
                }, label: {
                    Text("去充值")
                        .font(.caption)
                        .foregroundColor(.blue)
                })
                Spacer()
            }
            Spacer()
        }
    }
}

struct carCard: View {
    let userHeadimg: String = "https://img02.mockplus.cn/image/2022-11-16/84562470-65b4-11ed-bb3a-ed2420f1acb4.jpg"
    let carImg: String
    let name: String
    let price: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5)  {
            // 头像
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                ZStack() {
                    if let imageURL = URL(string: carImg) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 110)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 110, height: 110)
                        }
                    }
                }
                Spacer()
            }
            .frame(width: .infinity, height: 160)
            .background(Color.blue.opacity(0.5))
            // 名称 价格
            VStack(alignment: .leading, spacing: 5)  {
                Text(name)
                    .font(.subheadline)
                HStack(alignment: .center, spacing: 0)  {
                    Text("钻石购买")
                    Text(price)
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            // 期限
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                Text("7天")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 40)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                Spacer()
                Text("15天")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 40)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                Spacer()
                
                Text("30天")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 40)
                    .cornerRadius(10) // 设置圆角半径
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                Spacer()
                
                
            }
            .padding(.vertical, 15)
            // 余额
            HStack(alignment: .center, spacing: 10)  {
                Spacer()
                Text("钻石余额：100")
                    .font(.caption)
                Button(action: {
                    
                }, label: {
                    Text("去充值")
                        .font(.caption)
                        .foregroundColor(.blue)
                })
                Spacer()
            }
            Spacer()
        }
    }
}

struct mall_Previews: PreviewProvider {
    static var previews: some View {
        mall()
//        dressCard()
//        topPicker()
        
    }
}


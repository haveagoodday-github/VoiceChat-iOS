//
//  personPageView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/11.
//

import SwiftUI

struct personPageView: View {
    @State private var infoTypePicker: infoTypeModel = .gy
    
    
    init() {
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.clear
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8)  {
                topBg_info()
                
                
                VStack(alignment: .center, spacing: 0)  {
                    PersonalHonorPanel()
                        .padding(.vertical, 5)
                    
                    Picker("", selection: $infoTypePicker) {
                        ForEach(infoTypeModel.allCases, id: \.rawValue) { type in
                            Text(type.rawValue)
                                .tag(type)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding([.horizontal, .vertical])
                    
                    
                    if infoTypePicker == .gy {
                        gy(age: "21", constellation: "摩羯座", location: "陕西 西安", sign: "摩羯座xxx")
                        
                    } else if infoTypePicker == .ry {
                        ry()
                    } else if infoTypePicker == .sh {
                        sh()
                    } else if infoTypePicker == .dt {
                        dt()
                    }
                }
                
                // 关注  私信TA
                HStack(alignment: .center, spacing: 15)  {
                    HStack(alignment: .center, spacing: 4)  {
                        Spacer()
                        Image(systemName: "checkmark")
                        Text("已关注")
                        Spacer()
                    }
                    .padding(.vertical, 9)
                    .background(Color.blue)
                    .cornerRadius(30)
                    HStack(alignment: .center, spacing: 4)  {
                        Spacer()
                        Image(systemName: "ellipsis.message")
                        Text("私信TA")
                        Spacer()
                    }
                    .padding(.vertical, 9)
                    .background(Color.green)
                    .cornerRadius(30)
                }
//                .fontWeight(.bold) // iOS 16
                .foregroundColor(.white)
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea()
//        .toolbar(.hidden, for: .tabBar) // iOS 16
    }
}

// 顶部信息
struct topinfo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0)  {
            avatar(headimgSize: 90)
            HStack(alignment: .center, spacing: 0)  {
                VStack(alignment: .leading, spacing: 4)  {
                    HStack(alignment: .center, spacing: 5)  {
                        Text("远方")
                            .foregroundColor(.white)
                        Image(systemName: "person")
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.all, 5)
                            .background(Color.blue)
                            .clipShape(Circle())
                        PersonalHonor() // 个人荣誉
                    }
                    // ID 粉丝 官方认证
                    HStack(alignment: .center, spacing: 15)  {
                        Group {
                            Text("ID：1111097")
                            Text("粉丝：10")
                        }
                            .foregroundColor(.white)
                        Text("官方认证")
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                }
                Spacer()
                rightBottomRelated()
            }
        }
        .padding(.all, 12)
    }
}

struct topBg_info: View {
    let topBgImg: String = "https://img02.mockplus.cn/image/2022-11-16/b41f5510-65bd-11ed-80e4-653ae1a9cc76.jpg"
    var body: some View {
        ZStack(alignment: .bottom) {
            if let imageURL = URL(string: topBgImg) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 340)
                        .edgesIgnoringSafeArea([.top])
                    
                } placeholder: {
                    ProgressView()
                }
            }
            
            topinfo()
        }
    }
}

struct avatar: View {
    let headimgSize: CGFloat
    var body: some View {
        ZStack() {
            // 头像
            if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/84562470-65b4-11ed-bb3a-ed2420f1acb4.jpg") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: headimgSize-40, height: headimgSize-40)
                        .clipShape(Circle())
                    
                } placeholder: {
                    ProgressView()
                        .frame(width: headimgSize-40, height: headimgSize-40)
                        .clipShape(Circle())
                }
                
            }
            
            // 头像框
            if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/a8ae6c90-65b6-11ed-a34b-c3701f21de1d.png") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: headimgSize, height: headimgSize)
                    
                } placeholder: {
                    ProgressView()
                        .scaledToFit()
                        .frame(width: headimgSize, height: headimgSize)
                }
                
            }
            
            
            
            
            
        }
    }
}

struct PersonalHonor: View {
    var body: some View {
        HStack(alignment: .center, spacing: 3)  {
            ForEach(0..<3) { index in
                if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/f4e2f670-6599-11ed-a481-71c58ef8d1b5.png") {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                        
                    } placeholder: {
                        ProgressView()
                    }
                    
                }
            }
        }
    }
}

struct rightBottomRelated: View {
    var body: some View {
        HStack(alignment: .center, spacing: 5)  {
            if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/e9003fe0-65bf-11ed-bb3a-ed2420f1acb4.png") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                } placeholder: {
                    ProgressView()
                }
                
            }
            
            VStack(alignment: .center, spacing: 0)  {
                Text("恋爱指数")
                Text("1000")
            }
            
            if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/2376d530-65c0-11ed-a8b7-d1b38bb6b3d2.jpg") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    
                } placeholder: {
                    ProgressView()
                }
                
            }
            
            
            
        }
        .foregroundColor(.white)
        .font(.caption)
        .padding(.all, 4)
        .padding(.horizontal, 3)
        .background(Color.white.opacity(0.4))
        .cornerRadius(30)
    }
}

struct PersonalHonorPanel: View {
    let items = (1...6).map { "Item \($0)" }
    var body: some View {
        
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 3) {
            ForEach(items, id: \.self) { item in
                if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/ecbae170-65c0-11ed-91d3-7137596fe5cc.png") {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }

            }
        }
        .padding(.all)
        
        
    }
}


enum infoTypeModel: String, CaseIterable {
    case gy = "关于Ta"
    case ry = "荣誉"
    case sh = "守护"
    case dt = "动态"
}


//struct infoType: View {
//    @State private var infoTypePicker: infoTypeModel = .gy
//    
//    
//    init() {
//        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.clear
//        let attributes: [NSAttributedString.Key:Any] = [
//            .foregroundColor : UIColor.black,
//            .font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
//        ]
//        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
//    }
//    
//    
//    var body: some View {
//        Picker("", selection: $infoTypePicker) {
//            ForEach(infoTypeModel.allCases, id: \.rawValue) { type in
//                Text(type.rawValue)
//                    .tag(type)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//        }
//        .pickerStyle(.segmented)
//        .labelsHidden()
//    }
//}



struct gy: View {
    let age: String
    let constellation: String
    let location: String
    let sign: String
    let tags: [String] = ["标签1", "个性标签2", "很长的个性标签3", "标签4", "个性标签5", "标签6", "个性标签7"]
    
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 0, alignment: .leading)
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 7)  {
            Text("关于信息")
                .font(.headline)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 4)  {
                Text("年龄: \(age)")
                Text("星座: \(constellation)")
                Text("所在地: \(location)")
                Text("个性签名: \(sign)")
            }
            .font(.subheadline)
            
            Text("个性标签")
                .font(.headline)
                .fontWeight(.bold)
            
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .lineLimit(1)
                            .padding(.horizontal, 24)
                            .padding(.vertical , 2)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
            
            
        }
        .padding(.horizontal)
    }
}



struct ry: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0)  {
            Text("荣誉")
                .fontWeight(.bold)
                .padding(.vertical, 15)
            ZStack(alignment: .center) {
                if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-17/396ff0b0-65ca-11ed-91d3-7137596fe5cc.png") {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    
                }
                HStack(alignment: .center, spacing: 0)  {
                    Spacer()
                    VStack(alignment: .center, spacing: 5)  {
                        if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/289cd850-659a-11ed-a481-71c58ef8d1b5.png") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        Text("王爵5")
                    }
                    Spacer()
                    VStack(alignment: .center, spacing: 5)  {
                        if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/289cd850-659a-11ed-a481-71c58ef8d1b5.png") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        Text("王爵5")
                    }
                    Spacer()
                    VStack(alignment: .center, spacing: 5)  {
                        if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-16/289cd850-659a-11ed-a481-71c58ef8d1b5.png") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        Text("王爵5")
                    }
                    Spacer()
                }
                .font(.subheadline)
                .foregroundColor(.white)
//                .fontWeight(.bold) // iOS 16
                .offset(y: 15)
            }
            
            Text("勋章")
                .fontWeight(.bold)
                .padding(.vertical, 15)
            HStack(alignment: .center, spacing: 20)  {
                ForEach(0..<3) { item in
                    VStack(alignment: .center, spacing: 5)  {
                        if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-17/473b79c0-65cb-11ed-91d3-7137596fe5cc.png") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        Text("徽章10")
                            .font(.footnote)
                    }
                }
            }
            .padding(.horizontal)
            
            Text("座驾")
                .fontWeight(.bold)
                .padding(.vertical, 15)
            HStack(alignment: .center, spacing: 20)  {
                ForEach(0..<3) { item in
                    VStack(alignment: .center, spacing: 5)  {
                        if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-17/35492300-65cd-11ed-a481-71c58ef8d1b5.png") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        Text("劳斯莱斯")
                            .font(.footnote)
                        Text("1天后到期")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            
            ry_gift()
                
            
        }
        .padding(.horizontal)
    }
}

enum GiftTypeModel: String, CaseIterable {
    case zjsl = "最近收礼"
    case lwq = "礼物墙"
}


struct ry_gift: View {
    @State private var GiftModelPicker: GiftTypeModel = .zjsl
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.clear
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            Picker("", selection: $GiftModelPicker) {
                ForEach(GiftTypeModel.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(.vertical, 12)
            
            
            if GiftModelPicker == .zjsl {
                ry_zjsl()
            } else if GiftModelPicker == .lwq {
                ry_lwq()
            }
            
        }
        
    }
}

struct ry_zjsl: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            ForEach(0..<5) { item in
                HStack(alignment: .center, spacing: 12)  {
                    
                    if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-17/77341ba0-65d0-11ed-91fb-4b29e74055de.jpg") {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                
                            
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 7)  {
                        Text("老头")
                            .fontWeight(.bold)
                        Text("11.16 19:58")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 0)  {
                        if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-17/4e42d880-65d0-11ed-a8b7-d1b38bb6b3d2.png") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        Text("法拉利X1")
                            .foregroundColor(Color(red: 0.43, green: 0.007, blue: 0.057))
                            .font(.footnote)
                    }
                    
                    
                }
            }
        }
    }
}


struct ry_lwq: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<8, id: \.self) { item in
                    VStack(alignment: .center, spacing: 3)  {
                        if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-17/64589d60-65d2-11ed-bb3a-ed2420f1acb4.png") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        
                        Text("璀璨星河")
                            .font(.caption)
                        Text("X1")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .frame(height: 100)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(Color.green.opacity(0.4))
                    .cornerRadius(12)
                }
            }
        }
    }
}


struct sh: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5)  {
            HStack(alignment: .center, spacing: 0)  {
                Text("守护榜")
                Spacer()
                Text("查看全部>")
            }
            
            VStack(alignment: .center, spacing: 0)  {
                top_av(avImg: "https://img02.mockplus.cn/image/2022-11-17/91fdf470-665b-11ed-91fb-4b29e74055de.jpg", avFrame: "https://img02.mockplus.cn/image/2022-11-17/b4863ee0-665a-11ed-80e4-653ae1a9cc76.png", name: "冷陌", guardValue: "7507")
                HStack(alignment: .center, spacing: 0)  {
                    top_av(avImg: "https://img02.mockplus.cn/image/2022-11-17/91fdf470-665b-11ed-91fb-4b29e74055de.jpg", avFrame: "https://img02.mockplus.cn/image/2022-11-17/b482bc70-665a-11ed-a8b7-d1b38bb6b3d2.png", name: "远方", guardValue: "1154")
                    Spacer()
                    top_av(avImg: "https://img02.mockplus.cn/image/2022-11-17/91fdf470-665b-11ed-91fb-4b29e74055de.jpg", avFrame: "https://img02.mockplus.cn/image/2022-11-17/b42f1e30-665a-11ed-83aa-a3882dfb46ed.png", name: "颜颜", guardValue: "1100")
                }
                .offset(y: -50)
                .padding(.horizontal, 40)
            }
            
            Text("关系谱")
            relationshipSpectrum()
        }
        .padding(.horizontal, 8)
    }
}

struct top_av: View {
    let avImg: String
    let avFrame: String
    let name: String
    let guardValue: String
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            ZStack(alignment: .center) {
                // 头像
                if let imageURL = URL(string: avImg) {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                    } placeholder: {
                        ProgressView()
                    }
                    
                }
                
                // 头像框
                if let imageURL = URL(string: avFrame) {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        
                    } placeholder: {
                        ProgressView()
                    }
                    
                }
                
            }
            
            Text("\(name)")
                .font(.subheadline)
            Text("\(guardValue)")
                .font(.caption)
                .foregroundColor(.red)
            Text("守护值")
                .font(.caption)
                .foregroundColor(.gray)
        }
        
    }
}


struct relationshipSpectrum: View {
    var body: some View {
        HStack(alignment: .center, spacing: 5)  {
            ForEach(0..<3) { item in
                VStack(alignment: .center, spacing: 4)  {
                    Text("小跟班")
                    if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-11-17/82e8d030-6661-11ed-8f9c-97014d7b0c11.jpg") {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            
                        } placeholder: {
                            ProgressView()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                        }
                        
                    }
                    
                    Text("LV4")
                        .foregroundColor(.blue)
                    Text("龙龙")
                        .font(.subheadline)
                    
                    Text("2020.5.23至今 900天")
                        .lineLimit(1)
                        .foregroundColor(.gray)
                        .font(.caption2)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(10)
                
            }
        }
        
    }
}


struct dt: View {
    var body: some View {
        Text("临时")
//        dynamicContentView(apiUrl: "\(baseUrl.url)api/dynamicTjList")
    }
}

struct personPageView_Previews: PreviewProvider {
    static var previews: some View {
        personPageView()
//        dt()
    }
}

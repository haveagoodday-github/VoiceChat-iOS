import SwiftUI

struct MyNest: View {
    var body: some View {
        ZStack(alignment: .center) {
            myNestBgView()
            VStack(alignment: .center, spacing: 0)  {
                HStack(alignment: .center, spacing: 120)  {
                    myNestUserAv(user1AvatarURL: "https://img02.mockplus.cn/image/2022-11-19/5614edd0-67e4-11ed-a22a-ad1667deb42a.jpg", username: "远方")
                    myNestUserAv(user1AvatarURL: "", username: "")
                }
                .padding(.top, 190)
                .padding(.horizontal)
                // "需要是好友且守护值大于520才能求婚哦"
                HStack(alignment: .center, spacing: 0)  {
                    Spacer()
                    Text("需要是好友且守护值大于520才能求婚哦")
                        .foregroundColor(Color(red: 0.668, green: 0.668, blue: 0.668))
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.2))
                .cornerRadius(30)
                .padding(.top, 70)
                .padding(.horizontal)
                
                Spacer()
                youMaybeLikePeople()
                    
            }
        }
        .ignoresSafeArea()
    }
}



struct myNestBgView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Image(.myNestBg)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea()
    }
}



struct myNestUserAv: View {
    let user1AvatarURL: String
    let username: String
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            if user1AvatarURL.isEmpty {
                Rectangle()
                    .fill(Color.gray)
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .overlay(
                        
                        ZStack(alignment: .center) {
                            Circle()
                                .stroke(Color(red: 0.79, green: 0.98, blue: 0.512), lineWidth: 1)
                            Image(systemName: "questionmark")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }
                    )
            } else {
                if let imageURL = URL(string: user1AvatarURL) {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color(red: 0.79, green: 0.98, blue: 0.512), lineWidth: 1)
                            )
                        
                    } placeholder: {
                        ProgressView()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color(red: 0.79, green: 0.98, blue: 0.512), lineWidth: 1)
                            )
                    }
                    
                }
            }
            
            Text(username.isEmpty ? "我的伴侣" : username)
                .foregroundColor(.white)
        }
    }
}


struct youMaybeLikePeople: View {
    let avURL: String = "https://img02.mockplus.cn/image/2022-11-19/5614edd0-67e4-11ed-a22a-ad1667deb42a.jpg"
    let num: String = "1000"
    var body: some View {
        VStack(alignment: .leading, spacing: 18)  {
            HStack(alignment: .center, spacing: 5)  {
                Text("你可能喜欢的人")
                    .font(.headline)
                Text("赠送礼物可以增加守护值哦")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            VStack(alignment: .leading, spacing: 16)  {
                ForEach(0..<3) { item in
                    HStack(alignment: .center, spacing: 12)  {
                        // 头像
                        if let imageURL = URL(string: avURL) {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 8)  {
                            HStack(alignment: .center, spacing: 4)  {
                                Text("远方")
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.white)
                                    .padding(.all, 3)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                            HStack(alignment: .center, spacing: 0)  {
                                Text("守护值：")
                                    .foregroundColor(.gray)
                                Text("\(num)")
                                    .foregroundColor(Color(red: 0.43, green: 0.007, blue: 0.057))
                            }
                            .font(.subheadline)
                        }
                        Spacer()
                        Text("去求婚")
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color(red: 0.881, green: 0.516, blue: 0.512))
                            .cornerRadius(30)
                    }
                }
                
            }
            
            Spacer()
        }
        .frame(maxHeight: 500)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}




struct MyNest_Previews: PreviewProvider {
    static var previews: some View {
        MyNest()
    }
}

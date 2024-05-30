
import SwiftUI
//import RongIMKit

struct ChatListView: View {
    @State private var selectedOption = "好友"
    var body: some View {
        VStack(alignment: .leading, spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                Picker(selection: $selectedOption, label: Text("选择")) {
                    Text("聊天").tag("聊天")
                    Text("好友").tag("好友")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 120)
                Spacer()
            }
            .padding()
            
            if selectedOption == "聊天" {
                chatlistView()
            } else {
                friendsListView()
            }
            Spacer()
        }
    }
    
    
    
    
    
    
}



struct chatlistItemView: View {
    let isHasTime: Bool = false
    let msgCount: Int = 1
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            if let imageURL = URL(string: "https://img02.mockplus.cn/image/2022-07-01/1b682810-ec37-11ec-a977-53bd184e353b.jpg") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                } placeholder: {
                    ProgressView()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
            }
            
            VStack(alignment: .leading, spacing: 4)  {
                Text("声音恋人")
                    .font(.subheadline)
                Text("Ta一直在等你")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Spacer()
            if isHasTime {
                Text("等你搭配>")
                    .font(.subheadline)
            } else {
                VStack(alignment: .trailing, spacing: 4)  {
                    Text("2022-02-14")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    if msgCount == 0 {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 5, height: 5)
                    } else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 15, height: 15)
                            .overlay(
                                Text("\(msgCount)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            )
                    }
                    
                }
            }
            
                
            
        }
    }
}

struct chatlistView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            List(0..<10) { item in
                chatlistItemView()
            }
        }
    }
}


struct friendsListView: View {
    @State private var selectedButton: String? = "好友"
    var body: some View {
        VStack(alignment: .leading, spacing: 0)  {
            friends_topPickerView(selectedButton: $selectedButton)
            VStack(alignment: .leading, spacing: 12)  {
                ForEach(0..<10) { item in
                    friendsListItemView()
                }
            }
            .padding()
        }
    }
}

struct friends_topPickerView: View {
    @Binding var selectedButton: String?
    let buttons: [String] = ["好友", "关注", "粉丝"]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(buttons, id: \.self) { buttonTitle in
                Button(action: {
                    selectedButton = buttonTitle
                }) {
                    VStack(spacing: 8) {
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: selectedButton == buttonTitle ? .bold : .regular))
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Rectangle()
                            .frame(height: 4)
                            .foregroundColor(selectedButton == buttonTitle ? Color(red: 0.994, green: 0.779, blue: 0.074) : .clear)
                    }
                    .frame(width: 50)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct friendsListItemView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            Image(.customerService)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4)  {
                Text("御声小客服")
                    .fontWeight(.bold)
                Text("您的24小时专属小助理")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
        
    }
}




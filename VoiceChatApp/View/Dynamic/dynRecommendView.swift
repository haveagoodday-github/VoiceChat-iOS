//
//  dynRecommendView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/7/29.
//

import SwiftUI


struct dynRecommendView: View {
    var body: some View {
        VStack(spacing: 0)  {
            pairingView()
            
//            dynamicContentView(apiUrl: "\(baseUrl.url)api/dynamicTjList")
        }
        
        
        // test
//        NavigationView {
//            VStack(spacing: 0)  {
//                topicSquareView()
//                pairingView()
//                
//                dynamicContentView(apiUrl: "\(baseUrl.url)api/dynamicTjList")
//            }
//
//        }
        
        
        
    }
}




struct relationModel: Identifiable {
    let id: String = UUID().uuidString
    let imgURL1: String
    let imgURL2: String
    let user1: String
    let user2: String
    let say: String
}

class RelationViewModel: ObservableObject {
    @Published var relationArray: [relationModel] = []
    @Published var isLoading: Bool = false
    
    init() {
        getRelation()
    }
    
    func getRelation() {
        let relation1 = relationModel(imgURL1: "https://img02.mockplus.cn/image/2022-07-01/290e2f20-ec35-11ec-a977-53bd184e353b.jpeg", imgURL2: "https://img02.mockplus.cn/image/2022-07-01/2c2448c0-ec35-11ec-9d56-4b2df2206005.jpeg", user1: "初心", user2: "&.小白", say: "天长地久，我们要永远在一起，小白")
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.relationArray.append(relation1)
            self.isLoading = false
        }
    }
    
}
// 关系
struct pairingView: View {
    @StateObject var relationModel: RelationViewModel = RelationViewModel()
    
    var body: some View {
        if relationModel.isLoading {
            ProgressView()
        } else {
            
            ForEach(relationModel.relationArray) { relation in
                HStack(spacing: 0)  {
                    
                    ZStack {
                        HStack(spacing: -8)  {
                            if let imageURL = URL(string: relation.imgURL1) {
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 40)
        
                                } placeholder: {
                                    ProgressView()
                                        .clipShape(Circle())
                                        .frame(width: 40)
                                }
        
                            }
                            if let imageURL = URL(string: relation.imgURL2) {
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 40)
        
                                } placeholder: {
                                    ProgressView()
                                        .clipShape(Circle())
                                        .frame(width: 40)
                                }
        
                            }
                            
                        }
                        Image(systemName: "heart.fill")
                            .font(.footnote)
                            .foregroundColor(Color(red: 0.986, green: 0.352, blue: 0.452))
                            .offset(CGSize(width: 0.0, height: -14.0))
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0)  {
                        HStack(spacing: 0)  {
                            Text("\(relation.user1) ")
                                .foregroundColor(Color(red: 0.989, green: 0.826, blue: 0.245))
                            Text("深情告白")
                            Text(" \(relation.user2)")
                                .foregroundColor(Color(red: 0.989, green: 0.826, blue: 0.245))
                            Text(":")
                        }
                        .padding(.bottom, 3)
                        Text("\(relation.say)")
                            .lineLimit(1)
//                            .italic() // iOS 16
                    }
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    
                    Image(systemName: "chevron.forward.circle.fill")
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.45, green: 0.185, blue: 0.872), Color(red: 0.982, green: 0.431, blue: 0.623)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(30)
                .padding()
                   
            }
        }
        
        
    }
}

struct dynamicModel: Identifiable {
    let id: String = UUID().uuidString
    let avatar: String
    let uname: String
    let usex: Bool
    let lateTime: Date
    let contentText: String
    let contentImgUrls: [String]
    let coontentTopic: String
    let heartNum: Int
    let commentNum: Int
    let commentContentList: [Comment]
    
    struct Comment: Hashable {
        let avatar: String
        let name: String
        let comment: String
        let gift: String?
        let giftNum: Int?
    }
}


struct SendCommentView: View {
    @State private var commentText: String = ""
    var pid: Int
    var id: Int
    var hf_uid: Int
    @ObservedObject var sendCommentModel: SendCommentModel
    @State private var isLoading = false
    @State private var LoadingText: String = "评论中..."
    

    
    init(pid: Int, id: Int, hf_uid: Int) {
        self.pid = pid
        self.id = id
        self.hf_uid = hf_uid
        self.sendCommentModel = SendCommentModel(apiurl: "\(baseUrl.url)api/dynamic_comment")
    }
    
    
    
    var body: some View {
        VStack {
            Spacer()
            if isLoading {
                ProgressView("\(LoadingText)")
                    .padding()
            }
            HStack {
                ZStack(alignment: .leading) {
                    Color.gray.opacity(0.4)
                        .frame(height: 40)
                        .cornerRadius(20)
                    TextField("输入评论...", text: $commentText)
                        .padding(.horizontal)
                }
                .padding(.horizontal)
                
                Button(action: {
                    sendComment()
                }, label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.993, green: 0.628, blue: 0.879), Color(red: 0.838, green: 0.493, blue: 0.949)]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                            .clipShape(Circle())
                        )

                    
                })
                .padding(.trailing)
                
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color.white)
            
            
        }
        

        
    }



    func sendComment() {
        if !commentText.isEmpty {
            isLoading = true
            
            let apiurl = "\(baseUrl.url)api/dynamic_comment?pid=\(pid)&id=\(id)&content=\(commentText)&hf_uid=\(hf_uid)"
            
            DispatchQueue.global().asyncAfter(deadline: .now()) {
                // Simulate completion
                sendCommentModel.sendComment(apiurl: apiurl)
                
                DispatchQueue.main.async {
                    LoadingText = sendCommentModel.returnMessage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLoading = false
                    }
                    commentText = ""
                    hideKeyboard()
                }
            }
        }
    }
}

//struct PostModel_SendComment: Decodable {
//    let message: String
//}
class SendCommentModel: ObservableObject {
//    @State private var api = myAPI()
    @Published var returnMessage: String = ""
    
    init (apiurl: String) {
        sendComment(apiurl: apiurl)
    }
    
    func sendComment(apiurl: String) {
        NetworkTools.requestAPI(convertible: "apiurl",
                                method: .post,
                                responseDecodable: baseModel.self) { result in
            self.returnMessage = result.message
        } failure: { _ in
            
        }

    }
}


struct showUserInfo: View {
    var headimgurl: String
    var nickname: String
    var sex: Int
    var addtime: String
    var isFollow: Int
    var target_id: Int
//    @ObservedObject var viewModel: HandlePraise
    var body: some View {
        HStack(spacing: 0)  {
            HStack(spacing: 0)  {
                if let imageURL = URL(string: headimgurl) {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 50)
                    } placeholder: {
                        ProgressView()
                    }
                    
                }
                VStack(alignment: .leading, spacing: 3)  {
                    HStack(spacing: 5)  {
                        Text(nickname)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        if sex == 1 {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                        } else {
                            Image(systemName: "person.fill")
                                .foregroundColor(.pink)
                                .font(.caption)
                        }
                    }
                    Text(addtime)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
            }
            Spacer()
            
//            clickFollowed(isFollow: isFollow == 0, target_id: target_id, viewModel: viewModel)

            
            Image(systemName: "ellipsis")
                .rotationEffect(Angle(degrees: 90))
                .foregroundColor(.gray)
                .padding(.leading, 30)
        }
    }
}

struct showPictures_Content: View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 3, alignment: .leading),
        GridItem(.flexible(), spacing: 3, alignment: .leading),
        GridItem(.flexible(), spacing: 3, alignment: .leading)
    ]
    var content: String
    var images: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0)  {
            Text(content)
                .padding(.vertical, 17)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 7) {
                ForEach(images, id: \.self) { image in
                    if let imageURL = URL(string: image) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(10)
                        }
                        
                    }
//                    let imgurl = images[index]
                }
            }
        }
    }
}



struct dynRecommendView_Previews: PreviewProvider {
    static var previews: some View {
        dynRecommendView()
    }
}

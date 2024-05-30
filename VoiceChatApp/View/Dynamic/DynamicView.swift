//
//  DynamicView.swift
//  testProject
//
//  Created by MacBook Pro on 2023/8/25.
//

import SwiftUI

import Defaults
import DynamicColor




// MARK: 动态顶部单选 + 小铃铛
enum DynamicTopTabType {
    case tuijian
    case zuixin
    case guanzhu
    case mypost
}
struct DynamicTopTabView: View {
    @StateObject var viewModel: DynamicViewModel
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .bottom, spacing: 12)  {
                
                DynamicTopCustomButton(title: "推荐", isSelected: viewModel.CurrentDynamicType == .tuijian, action: {
                    viewModel.getRecommendedDynamic(page: 1)
                    viewModel.CurrentDynamicType = .tuijian
                })
                
                DynamicTopCustomButton(title: "最新", isSelected: viewModel.CurrentDynamicType == .zuixin, action: {
                    viewModel.getNewDynamic()
                    viewModel.CurrentDynamicType = .zuixin
                })
                
                DynamicTopCustomButton(title: "关注", isSelected: viewModel.CurrentDynamicType == .guanzhu, action: {
                    viewModel.getFollowDynamic(page: 1)
                    viewModel.CurrentDynamicType = .guanzhu
                })
                
            }
            Spacer()
            Button(action: {
                // 点击小铃铛
            }, label: {
                Image(systemName: "bell")
                    .font(.headline)
                    .foregroundColor(.gray)
            })
        }
    }
}

// 自定义按钮
struct DynamicTopCustomButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Text(title)
                .foregroundColor(isSelected ? .black : .gray)
                .fontWeight(.bold)
                .font(isSelected ? .title2 : .headline)
        }
    }
}

// MARK: 发布按钮
struct PostDynamicButtonView: View {
    @Binding var isShowFullCoverSheet: Bool
    var body: some View {
        Button {
            isShowFullCoverSheet.toggle()
        } label: {
            Image(.dongtaiFabuXiao)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .padding()
        }

    }
}

// MARK: 动态展示MAIN
struct DynamicView: View {
    @StateObject var viewModel: DynamicViewModel
    @State var isGoToDynamicDetails: Bool = false
    var body: some View {
//        VStack(alignment: .center, spacing: 0)  {
//            ScrollView {
//                // MARK: 动态详情
//                DynamicViewItemView(viewModel: viewModel)
//            }
//            
//            
//        }
        DynamicViewItemView(viewModel: viewModel)
        .onAppear {
            viewModel.getRecommendedDynamic(page: 1)
        }
        .overlay(alignment: .bottomTrailing) {
            PostDynamicButtonView(isShowFullCoverSheet: $viewModel.isShowFullCoverSheet)
        }
        .fullScreenCover(isPresented: $viewModel.isShowFullCoverSheet) {
            PostDynamic(viewModel: viewModel)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)

        
    }
}

// MARK: 动态
struct DynamicViewItemView: View {
    @StateObject var viewModel: DynamicViewModel
    @State var currentCommentPage: Int = 1
    var body: some View {
        VStack(alignment: .leading, spacing: 0)  {
            DynamicTopTabView(viewModel: viewModel)
                .padding()
            
            VStack(alignment: .center, spacing: 6)  {
                // TODO: 我的关注 - 样式不一样
                DynamicContentItemView(
                    viewModel: viewModel,
                    currentCommentPage: currentCommentPage)
            }
//            .redacted(reason: viewModel.recommendedDynamicData.isEmpty ? .placeholder : [])
        }
    }
}


struct DynamicContentItemView: View {
    @StateObject var viewModel: DynamicViewModel
    var currentCommentPage: Int
    
    var body: some View {
        
//        ForEach(list, id: \.dynamicId) { item in
//            NavigationLink(destination: DynamicDetails(item: item, viewModel: viewModel)) {
//                HStack(alignment: .center, spacing: 0)  {
//                    DynamicItem(item: item, viewModel: viewModel, currentCommentPage: currentCommentPage)
//                }
//                .foregroundColor(.black)
//            }
//            Divider()
//        }
        
        List(viewModel.CurrentDynamicType == .tuijian ? viewModel.recommendedDynamicData : viewModel.CurrentDynamicType == .zuixin ? viewModel.newDynamicData : viewModel.CurrentDynamicType == .guanzhu ? viewModel.followDynamicData : viewModel.myDynamicList, id: \.dynamicId) { item in
            DynamicItem(item: item, viewModel: viewModel, currentCommentPage: currentCommentPage)
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width)
//            Divider()
        }
        .listStyle(.inset)
        .refreshable {
            switch viewModel.CurrentDynamicType {
            case .zuixin:
                viewModel.getNewDynamic()
            case .guanzhu:
                viewModel.getFollowDynamic()
            case .tuijian:
                viewModel.getRecommendedDynamic(page: 1)
            case .mypost:
                viewModel.getMyPostDynamic()
            }
        }
    }
}




// 触底拉区数据
// MARK: 动态Item
struct DynamicItem: View {
    var item: DynamicModel.data
    @State private var isFullScreenPresented = false
    @StateObject var viewModel: DynamicViewModel
    @State var msg: String = ""
    @State var currentIndex: Int = 0
    @State var currentCommentPage: Int
    @State var resultArray: [String] = []
    @State private var isOpenChat: Bool = false
    @State private var isOpenUserInfo: Bool = false
    @State private var isOpenDetails: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0)  {
                // 头像 个人信息 发布时间 性别
                DynamicDetailsPersonalInfo(userId: item.userId, avatar: item.avatar, nickname: item.nickname, sex: item.sex == 1, addtime: item.updateTime)
                    .showUserInfoFullCoverSheet(userId: item.userId, isShowUserInfoFullCoverSheet: $isOpenUserInfo)
                
                VStack(alignment: .leading, spacing: 0)  {
                    
                    VStack(alignment: .leading, spacing: 0)  {
                        // 文案
                        Text(item.content)
                            .padding(.vertical, 10)
                        // 图片/视频
    //                    MediaItem(medias: item.image)
                        MediaView(images: item.images)
                        if let tags = item.tags {
                            TagsListView2(items: tags.components(separatedBy: ",").map { $0.replacingOccurrences(of: "#", with: "") }, resultArray: $resultArray)
                        }
                    }
                    .background {
                        NavigationLink(destination: DynamicDetails(item: item, viewModel: viewModel)) {
                        }
                        .opacity(0)
                    }
                    
                    
                    // MARK: 评论/点赞 按钮
                    HStack(alignment: .center, spacing: 52)  {
                        HStack(alignment: .center, spacing: 6)  {
                            Image(.dynamicstateButtonIconComment)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("\(item.commentCount)")
                        }
                        
                        clickHeart(viewModel: viewModel, isLiked: item.isLiked > 0, likeCount: item.likeCount, dynamicId: item.dynamicId)
//                            .background {
//                                Color.blue
//                            }
                        
                    }
                    .foregroundColor(.gray)
                }
                .padding(.leading, 42)
            }
            // 打招呼
            if item.userId != UserCache.shared.getUserInfo()?.userId {
                Image(.dongtaiDazhaohuIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .background {
                        NavigationLink(destination: MessageDetailsView(beUserId: item.userId, beUserNickname: item.nickname, beUserAvatar: item.avatar)) {
                            
                        }
                        .opacity(0)
                    }
            }
            
        }
        .padding(.all)
//        .background(Color(hexString: "#F6F5FA"))
        .background(Color.white)
        .background {
            
            
            
        }
        
    }

}

// MARK: 图片/视频
struct MediaIteme: View {
    let imgurl: String
    @State var isFullScreenPresented: Bool = false
    @State var size: CGFloat
    var body: some View {
        KFImageView_Fill(imageUrl: imgurl)
            .frame(maxWidth: UIScreen.main.bounds.width * size, maxHeight: UIScreen.main.bounds.width * size)
            .cornerRadius(10)
        // TODO: 是否显示全图
            .onTapGesture {
                isFullScreenPresented.toggle()
            }
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            KFImageView(imageUrl: imgurl)
                .cornerRadius(3)
                .onTapGesture {
                    isFullScreenPresented.toggle()
                }
        }
        
    }
}
struct MediaListView: View {
    let medias: [String]
    @State var size: CGFloat
    var body: some View {
        HStack(alignment: .center, spacing: 8)  {
            ForEach(medias, id: \.self) { media in
                MediaIteme(imgurl: media, size: size)
            }
        }
    }
}

struct MediaView: View {
    let images: String
    func medias() -> [String] {
        return images.components(separatedBy: ",")
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8)  {
            switch medias().count {
            case 1:
                MediaListView(medias: medias(), size: 0.42)
            case 2:
                MediaListView(medias: medias(), size: 0.35)
            case 3:
                MediaListView(medias: medias(), size: 0.25)
            case 4:
                MediaListView(medias: [medias()[0], medias()[1]], size: 0.35)
                MediaListView(medias: [medias()[2], medias()[3]], size: 0.35)
            case 5:
                MediaListView(medias: [medias()[0], medias()[1], medias()[2]], size: 0.25)
                MediaListView(medias: [medias()[3], medias()[4]], size: 0.25)
            case 6:
                MediaListView(medias: [medias()[0], medias()[1], medias()[2]], size: 0.25)
                MediaListView(medias: [medias()[3], medias()[4], medias()[5]], size: 0.25)
            default:
    //            MediaItem(medias: item.image, size: 0.25)
                EmptyView()
            }
        }
    }
}


// MARK: 动态详情
struct DynamicDetails: View {
    var item: DynamicModel.data
    @State private var isFullScreenPresented = false
    @ObservedObject var viewModel: DynamicViewModel
    @State var isFocusField: Bool = false
    @State var isFocusFieldSon: Bool = false
    @State var currentPlaceholder: String = "评论千万条，友善第一条～"
    @State var currentReplyUserName: String = ""
    @State var currentReplyUserID: Int = 0
    @State var currentReplyCommentID: Int = 0
    @State var inputText: String = ""
    @State var resultArray: [String] = []
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .center, spacing: 0)  {
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .leading, spacing: 0)  {
                            DynamicDetailsPersonalInfo(userId: item.userId, avatar: item.avatar, nickname: item.nickname, sex: item.sex == 1, addtime: item.updateTime)
                            
                            VStack(alignment: .leading, spacing: 0)  {
                                // 文案
                                Text(item.content)
                                    .padding(.vertical, 10)
                                // 图片/视频
//                                MediaItem(medias: item.image)
                                MediaView(images: item.images)
                                
                                // 标签
//                                HStack(alignment: .center, spacing: 0)  {
//                                    Image("dt_huati_icon")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 15, height: 15)
//                                    Text(item.tags_str)
//                                        .font(.footnote)
//                                        .fontWeight(.bold)
//                                }
//                                .padding(.vertical, 4)
//                                .padding(.horizontal, 8)
//                                .background(Color.gray.opacity(0.3))
//                                .cornerRadius(10)
//                                .padding(.vertical, 15)
                                if let tags = item.tags {
                                    TagsListView2(items: tags.components(separatedBy: ",").map { $0.replacingOccurrences(of: "#", with: "") }, resultArray: $resultArray)
                                }
                                
                            }
                            .padding(.leading, 42)
                        }
                        // 打招呼
                        Button(action: {
                            // 跳转到聊天页面
                        }, label: {
                            Image(.dongtaiDazhaohuIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                        })
                    }
                    
                    .background(Color.white)
                    .navigationBarTitle("动态详情", displayMode: .inline)
                    .navigationBarItems(trailing: Image(systemName: "ellipsis"))
                    
                    HStack(alignment: .center, spacing: 0)  {
                        Text("全部评论")
                            .font(.headline)
                            .padding(.vertical, 32)
                        Spacer()
                    }
                    DynamicDetailsCommentItem(currentReplyUserName: $currentReplyUserName,
                                              currentReplyUserID: $currentReplyUserID,
                                              currentReplyCommentID: $currentReplyCommentID,
                                              action: {
                        currentPlaceholder = "回复：\(currentReplyUserName)"
                        currentReplyUserID = currentReplyUserID
                        currentReplyCommentID = currentReplyCommentID
                        isFocusField.toggle() // 唤起焦点
                    }, actionSon: {
                        currentPlaceholder = "回复：\(currentReplyUserName)"
                        currentReplyUserID = currentReplyUserID
                        currentReplyCommentID = currentReplyCommentID
                        isFocusFieldSon.toggle()
                    })
                    Spacer()
                }
                .padding(.all)
            }
            
            .padding(.bottom, 40)
            CommentInput(inputText: $inputText, placeholderText: $currentPlaceholder, isFocusField2: $isFocusField, isFocusFieldSon: $isFocusFieldSon, sendComment: {
                viewModel.basicComment(dynamicId: item.dynamicId, content: inputText)
                currentPlaceholder = "评论千万条，友善第一条～"
                currentReplyUserID = 0
                currentReplyUserID = 0
                inputText = ""
                
            })
                .zIndex(2)
                .ignoresSafeArea()
//                .onChange(of: currentReplyUserName) { newValue in
//                    currentReplyUserName = newValue
//                }
        }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.getCommentLisData(dynamicId: item.dynamicId, page: 1)
        }
    }

}
struct TagsListView2: View {
    let items: [String]
    var groupedItems: [[String]] = [[String]]()
    let screenWidth = UIScreen.main.bounds.width
    
    @Binding var resultArray: [String]
    
    
    init(items: [String], resultArray: Binding<[String]>) {
        self._resultArray = resultArray
        self.items = items
        self.groupedItems = createGroupedItems(items)
    }
    
    private func createGroupedItems(_ items: [String]) -> [[String]] {
        
        var groupedItems: [[String]] = [[String]]()
        var tempItems: [String] =  [String]()
        var width: CGFloat = 0
        
        for word in items {
            
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 32
            
            if (width + labelWidth + 55) < screenWidth {
                width += labelWidth
                tempItems.append(word)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(word)
            }
            
        }
        
        groupedItems.append(tempItems)
        return groupedItems
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4)  {
            ForEach(groupedItems, id: \.self) { subItems in
                HStack(alignment: .center, spacing: 4)  {
                    ForEach(subItems, id: \.self) { word in
                        TagsItemView2(content: word, add: {
                            resultArray.append(word)
                        }, del: {
                            resultArray.removeAll(where: { $0 == word })
                        })
                    }
                    
                }
            }
        }
        .padding(.vertical, 15)
        
        //        HStack(alignment: .center, spacing: 0)  {
        //            Image("dt_huati_icon")
        //                .resizable()
        //                .scaledToFit()
        //                .frame(width: 15, height: 15)
        //            Text(item.tags_str)
        //                .font(.footnote)
        //                .fontWeight(.bold)
        //        }
        //        .padding(.vertical, 4)
        //        .padding(.horizontal, 8)
        //        .background(Color.gray.opacity(0.3))
        //        .cornerRadius(10)
        //        .padding(.vertical, 15)

        
    }
}
struct TagsItemView2: View {
    let content: String
    let add: () -> Void
    let del: () -> Void
    @State var isSelected: Bool = false
    var body: some View {
        Button(action: {
            isSelected.toggle()
            if isSelected {
                add()
            } else {
                del()
            }
        }, label: {
            HStack(alignment: .center, spacing: 4)  {
                Image(.dtHuatiIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                Text(content)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)

        })
        
        //        HStack(alignment: .center, spacing: 0)  {
        //            Image("dt_huati_icon")
        //                .resizable()
        //                .scaledToFit()
        //                .frame(width: 15, height: 15)
        //            Text(item.tags_str)
        //                .font(.footnote)
        //                .fontWeight(.bold)
        //        }
        //        .padding(.vertical, 4)
        //        .padding(.horizontal, 8)
        //        .background(Color.gray.opacity(0.3))
        //        .cornerRadius(10)
        //        .padding(.vertical, 15)
    }
}

// MARK: 动态详情 - 个人信息
struct DynamicDetailsPersonalInfo: View {
    let userId: Int
    let avatar: String
    let nickname: String
    let sex: Bool
    let addtime: String
    @State private var isGotoUserinfoFullCover: Bool = false
    
    var body: some View {
        // 头像 个人信息 发布时间 性别
        HStack(alignment: .center, spacing: 12)  {
            KFImageView_Fill(imageUrl: avatar)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .onTapGesture {
                    isGotoUserinfoFullCover = true
                }
                
            VStack(alignment: .leading, spacing: 5)  {
                HStack(alignment: .bottom, spacing: 6)  {
                    Text(nickname)
                        .fontWeight(.bold)
                        .font(.headline)
                    if sex {
                        Image(.icChatroomGenderBoy)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17, height: 17)
                    } else {
                        Image(.icChatroomGenderGril)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17, height: 17)
                    }
                }
                Text(addtime)
                    .lineLimit(1)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Spacer()
            
        }
        .showUserInfoFullCoverSheet(userId: userId, isShowUserInfoFullCoverSheet: $isGotoUserinfoFullCover)
        
    }
}

// MARK: 动态详情 - 评论内容
struct DynamicDetailsCommentItem: View {
    @EnvironmentObject var viewModel: DynamicViewModel
    @Binding var currentReplyUserName: String
    @Binding var currentReplyUserID: Int
    @Binding var currentReplyCommentID: Int
    let action: () -> Void
    let actionSon: () -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            ForEach(viewModel.commentLisData, id: \.commentId) { item in
                VStack(alignment: .leading, spacing: 0)  {
                    DynamicDetailsPersonalInfo(userId: item.userId, avatar: item.avatar, nickname: item.nickname, sex: item.sex == 1, addtime: item.createTime)
                    VStack(alignment: .leading, spacing: 0)  {
                        Button(action: {
                            currentReplyUserName = item.nickname
                            currentReplyUserID = item.userId
                            currentReplyCommentID = item.dynamicId
                            action()
                        }, label: {
                            HStack(alignment: .center, spacing: 0)  {
                                Text(item.content)
                                    .foregroundColor(.black)
                                    .font(.callout)
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                        })
                        
//                        ForEach(item.son, id: \.id) { item2 in
//                            Button(action: {
//                                currentReplyUserName = item2.user.nickname
//                                currentReplyUserID = item2.hf_uid
//                                currentReplyCommentID = item2.pid
//                                actionSon()
//                            }, label: {
//                                ReplyView(replyItem: item2)
//                            })
//                            
//                        }
                        
                    }
                    .padding(.leading, 54)
                    .padding(.trailing, 8)
                    
                }
            }
        }
        
    }
}

// MARK: 评论回复
//struct ReplyView: View {
//    let replyItem: DynamicCommentListModel.SonComment
//    var body: some View {
//        HStack(alignment: .center, spacing: 0)  {
//            Text(replyItem.user.nickname)
//                .foregroundColor(.purple)
//            +
//            Text(" 回复: ")
//                .foregroundColor(.black)
//            +
//            Text("\(replyItem.reply_user.nickname) ")
//                .foregroundColor(.purple)
//            +
//            Text("\(replyItem.content)")
//                .foregroundColor(.black)
//            
//            Spacer()
//        }
//        .font(.subheadline)
//        .padding(.vertical, 8)
//        .padding(.horizontal, 8)
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(5)
//        .padding(.vertical, 2)
//        .multilineTextAlignment(.leading)
//        
//    }
//}

// MARK: 处理评论
struct CommentInput: View {
    @Binding var inputText: String
    @EnvironmentObject var viewModel: DynamicViewModel
    
    @State private var isTextFieldFocused = false
    @FocusState var focusField: FocusType?
    @Binding var placeholderText: String
    @Binding var isFocusField2: Bool
    @Binding var isFocusFieldSon: Bool
    let sendComment: () -> Void
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            
            TextField(placeholderText, text: $inputText)
                .focused($focusField, equals: .reply)
                .focused($focusField, equals: .replySon)
                .submitLabel(.done)
                .onSubmit {
                    sendComment()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(30)
                .padding(.bottom, 8)
                .onChange(of: isFocusField2) { newValue in
                    focusField = .reply
                }
                .onChange(of: isFocusFieldSon) { newValue in
                    focusField = .replySon
                }

            Button(action: {
                
                if !inputText.isEmpty {
                    sendComment()
                } else {
                    print("为空")
                }
                defSend()
                
            }, label: {
                Image(.dongtaiPlFasongIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            })
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .background(Color.white)
    }
    
    func defSend() {
        inputText = ""
        // 隐藏键盘
        hideKeyboard()
        focusField = .empty
        placeholderText = "评论千万条，友善第一条～"
    }
    
}


enum FocusType {
    case reply, replySon, empty
}



// MARK: 处理点赞
struct clickHeart: View {
    @StateObject var viewModel: DynamicViewModel
    @State var isLiked: Bool
    @State var likeCount: Int
    @State var dynamicId: Int
    
    var body: some View {
        
        HStack(spacing: 5)  {
            ZStack {
                image(Image(.newDynamicIcnXihuan), show: isLiked)
                image(Image(.newDynamicIcnMorenXihuan), show: !isLiked)
            }
            ZStack {
                text(Text("\(likeCount)"), show: isLiked)
                text(Text("\(likeCount)"), show: !isLiked)
            }
        }
        .onTapGesture {
            self.isLiked.toggle()
            if isLiked {
                DynamicRequest.likeDynamic(dynamicId: dynamicId)
                likeCount += 1
            } else {
                DynamicRequest.unlikeDynamic(dynamicId: dynamicId)
                likeCount -= 1
            }
        }
        
    }
    func text(_ text: Text, show: Bool) -> some View {
        text
            .foregroundColor(show ? .gray : .black)
    }
    
    func image(_ image: Image, show: Bool) -> some View {
        image
            .resizable().scaledToFit().frame(width: 25, height: 25)
            .tint(isLiked ? .red : .gray)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
            
        
    }
    
}



// MARK: 推荐内容
//struct RecommendedDynamicView: View {
//    @EnvironmentObject var viewModel: DynamicViewModel
//    @State var currentItem: DynamicModel.data? = nil
//    @State var currentCommentPage: Int = 1
//    var body: some View {
//        ForEach(viewModel.recommendedDynamicData, id: \.dynamicId) { item in
//            NavigationLink(destination: DynamicDetails(item: item, viewModel: viewModel)) {
//                HStack(alignment: .center, spacing: 0)  {
//                    DynamicItem(item: item, currentCommentPage: currentCommentPage)
//                }
//                .foregroundColor(.black)
//            }
//
//            Divider()
//        }
//        .environmentObject(viewModel)
//    }
//}
// MARK: 最新内容
//struct NewDynamicView: View {
//    @EnvironmentObject var viewModel: DynamicViewModel
//    @State var currentItem: DynamicModel.data? = nil
//    @State var currentCommentPage: Int = 1
//    var body: some View {
//        ForEach(viewModel.newDynamicData, id: \.id) { item in
//            NavigationLink(destination: DynamicDetails(item: item, viewModel: viewModel)) {
//                HStack(alignment: .center, spacing: 0)  {
//                    DynamicItem(item: item, currentCommentPage: currentCommentPage)
//                }
//                .foregroundColor(.black)
//            }
//
//            Divider()
//        }
//        .environmentObject(viewModel)
//    }
//}

// MARK: 关注的内容
//struct FollowDynamicView: View {
//    @EnvironmentObject var viewModel: DynamicViewModel
//    @State var currentCommentPage: Int = 1
//    var body: some View {
//        if viewModel.followDynamicData.isEmpty {
//            VStack(alignment: .center, spacing: 0)  {
//                Spacer()
//                HStack(alignment: .center, spacing: 0)  {
//                    Spacer()
//                    CustomEmptyView()
//                        .frame(width: 150, height: 150)
//                    Spacer()
//                }
//                Spacer()
//            }
//            .frame(minHeight: UIScreen.main.bounds.height * 0.7)
//        } else {
//            DynamicContentItemView(list: viewModel.followDynamicData, currentCommentPage: currentCommentPage)
//                .environmentObject(viewModel)
//        }
//
//
//
//
//    }
//}

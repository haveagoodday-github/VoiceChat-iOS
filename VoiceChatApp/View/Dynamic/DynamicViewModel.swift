//
//  DynamicViewModel.swift
//  testProject
//
//  Created by MacBook Pro on 2023/8/25.
//

import Foundation
import ProgressHUD

class DynamicViewModel: ObservableObject {
    @Published var recommendedDynamicData: [DynamicModel.data] = [] // 推荐动态
    @Published var newDynamicData: [DynamicModel.data] = [] // 最新动态
    @Published var followDynamicData: [DynamicModel.data] = [] // 关注动态
    
    @Published var dynamicTags: [DynamicTagsModel] = [] // 动态标签
    @Published var myDynamicList: [DynamicModel.data] = [] // 我的动态
    // 评论
    @Published var commentLisData: [DynamicCommentsModel] = [] // 评论列表数据
    

    @Published var isShowFullCoverSheet: Bool = false
    @Published var selectedImageIndex: Int? = nil
    @Published var picker: Bool = false
    @Published var images: [UIImage] = []
    @Published var isShowUpdateButton: Bool = false
    @Published var updatedImages: [String] = []
    
    @Published var resultArray: [String] = []
    @Published var tagsArray: [String] = []
    @Published var inputText: String = ""
    @Published var CurrentDynamicType: DynamicTopTabType = .tuijian
    
    init() {
        getDynamicTags() // 获取标签
        getRecommendedDynamic()
        getFollowDynamic()
        getNewDynamic()
    }
    
    
    func getMyPostDynamic(page: Int = 1) {
//        ProgressHUD.animate("Loading...")
        NetworkTools.requestAPI(convertible: "/dynamic/getMyPostDynamic",
                                parameters: ["page": page],
                                responseDecodable: DynamicModel.self) { result in
            self.myDynamicList = result.data
//            ProgressHUD.dismiss()
        } failure: { _ in
            
        }
    }
    
    // MARK: 推荐动态
    func getRecommendedDynamic(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/dynamic/getRecommendedDynamics",
                                 parameters: ["page": page],
                                 responseDecodable: DynamicModel.self) { result in
            debugPrint("/dynamic/getRecommendedDynamics: \(result.data)")
            DispatchQueue.main.async {
                self.recommendedDynamicData = result.data  // 更新数据
            }
        } failure: { _ in
            
        }
    }
    
    // MARK: 最新动态
    func getNewDynamic(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/dynamic/getLatestDynamics",
                                parameters: ["page": page],
                                 responseDecodable: DynamicModel.self) { result in
            debugPrint("/dynamic/getLatestDynamics: \(result.data)")
            DispatchQueue.main.async {
                self.newDynamicData = result.data  // 更新数据
            }
        } failure: { error in
            
        }
    }
    
    // MARK: 关注的动态
    func getFollowDynamic(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/dynamic/getMyFollowDynamic",
                                 parameters: ["page": page],
                                 responseDecodable: DynamicModel.self) { result in
            debugPrint("/dynamic/getMyFollowDynamic: \(result.data)")
            DispatchQueue.main.async {
                self.followDynamicData = result.data  // 更新数据
            }
        } failure: { _ in
            
        }
        
    }
    
    
    // MARK: 获取评论列表
    func getCommentLisData(dynamicId: Int, page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/dynamicComment/getDynamicComment",
                                parameters: [
                                   "dynamicId": dynamicId,
                                   "page": page
                               ],
                                responseDecodable: DynamicCommentsRequestModel.self
        ) { result in
            print(result)
            if let data = result.data {
                DispatchQueue.main.async {
                    self.commentLisData = data
                }
            }
        } failure: { _ in
            
        }
    }
    
    
    // MARK: 根评论
    /// - Parameter commentId: 第一级评论的id，0就是根评论
    /// - Parameter dynamicId: 动态id
    /// - Parameter content: 内容
    /// - Parameter recoverUid: 回复对象的id，0就是根评论
    func basicComment(dynamicId: Int, content: String) {
        NetworkTools.requestAPI(convertible: "/dynamicComment/commentDynamic",
                                 method: .post,
                                 parameters: [
                                    "dynamicId": dynamicId,
                                    "content": content,
                                ],
                                 responseDecodable: baseModel.self) { result in
            self.getCommentLisData(dynamicId: dynamicId, page: 1) // 刷新评论
        } failure: { error in
            
        }
    }
    
    // MARK: 发布动态
    
    /// 发布动态
    /// - Parameters:
    ///   - content: 内容
    ///   - images: 多张图片
    ///   - tags: 标签
    ///   - state: 状态 0私密/1公开/3删除
    func postDynamicContent() {
        var update: CGFloat = 0
        ProgressHUD.progress("上传图片中...", update)
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "uploadImage")
        
        for (_, image) in images.enumerated() {
            group.enter()  // 进入组，表示开始一个任务
            queue.async {
                NetworkTools.uploadImage(image: image) { url in
                    update = update + CGFloat((1 / self.images.count))
                    ProgressHUD.progress("上传图片中...", update)
                    self.updatedImages.append(url)  // 保存上传结果
                    group.leave()  // 任务完成，离开组
                }
            }
        }
        
        
        group.notify(queue: queue) { // 当所有任务完成时执行
            ProgressHUD.succeed("图片上传完成")
            NetworkTools.requestAPI(convertible: "/dynamic/postDynamic",
                                     method: .post,
                                     parameters: [
                                        "content": self.inputText,
                                        "images": self.updatedImages.joined(separator: ","),
                                        "tags": self.handleDynamicTags(),
                                        "state": 1
                                    ],
                                     responseDecodable: baseModel.self) { result in
                self.isShowFullCoverSheet.toggle()
                ProgressHUD.succeed(result.message)
            } failure: { error in
                
            }
            
        }

    }
    
    
    
    
    func handleDynamicTags() -> String {
        var result = ""
        result = resultArray.joined(separator: ",")
        return result
    }
    
    
    // MARK: 动态标签
    func getDynamicTags() {
        NetworkTools.requestAPI(convertible: "/dynamic/getDynamicTags",
                                responseDecodable: DynamicTagsRequestModel.self
        ) { result in
            DispatchQueue.main.async {
                self.dynamicTags = result.data  // 更新数据
                self.tagsArray = result.data.map({$0.tagContent})
            }
        } failure: { error in
            
        }
    }
    
    
}

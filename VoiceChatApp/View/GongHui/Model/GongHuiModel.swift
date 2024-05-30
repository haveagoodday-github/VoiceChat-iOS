//
//  GongHuiModel.swift
//  TestProject
//
//  Created by 吕海锋 on 2023/9/7.
//

import Foundation

struct GHListModel: Decodable {
    let code: Int
    let message: String
    let data: dataItem
    
    struct dataItem: Decodable {
        let list: [ghList]
        
        struct ghList: Decodable {
            let id: Int
            let user_id: Int
            let category_id: Int
            let guild_name: String
            let guild_image: String
            let guild_nickname: String
            let guild_desc: String
            let createtime: String
            let members_count: Int
            let user: user
            let category: category
            
            struct user: Decodable {
                let id: Int
                let nickname: String
                let sex: Int
                let headimgurl: String
                let city: String
                let constellation: String
            }
            
            struct category: Decodable {
                let id: Int
                let category_name: String
                let category_desc: String?
            }
        }
    }
    
    
}

struct searchGHModel: Decodable {
    let code: Int
    let message: String
    let data: dataItem
    
    struct dataItem: Decodable {
        let id: Int
        let user_id: Int
        let category_id: Int
        let guild_name: String
        let guild_image: String
        let guild_nickname: String
        let guild_desc: String
        let mobile: String
        let email: String
        let front_idcard_image: String
        let back_idcard_image: String
        let handheld_image: String
        let business_license_image: String
        let status: String
        let reject_remark: String?
        let createtime: String
        let updatetime: Int
        let deletetime: String?
        let user: user
        let category: category
//
        struct user: Decodable {
            let id: Int
            let nickname: String
            let sex: Int
            let headimgurl: String
            let city: String
            let constellation: String
        }
        
        struct category: Decodable {
            let id: Int
            let category_name: String
            let category_desc: String
        }
        
    }
}

struct isHaveGHModel: Decodable {
    let message: String
    let data: String?
}

class GongHui: ObservableObject {
    @Published var GHListArray: [GHListModel.dataItem.ghList] = []
    @Published var currentPage: Int = 2
    @Published var searchResult: searchGHModel.dataItem? = nil
    @Published var isHaveGHData: isHaveGHModel? = nil
    
    init() {
        getGHList(page: 1, pageSize: 12)
        isHaveGH()
//        searchGHtoName(nameOrId: "诚诺传媒")
    }
    // 获取工会列表
    func getGHList(page: Int, pageSize: Int) {
        
        guard let url = URL(string: "\(baseUrl.newurl)api/guild/index?page=\(page)&pageSize=\(pageSize)") else { return }
        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            guard let self = self else { return }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(GHListModel.self, from: data)
                    DispatchQueue.main.async {
                        print("getGHList function Success result：\(result)")
                        self.GHListArray = result.data.list
                    }
                } else {
                    print("getGHList other result：No data")
                }
            } catch(let error) {
                print("getGHList function Error result：\(error.localizedDescription)")
            }
        }.resume()
    }
    
    // 下拉拼接列表
    func addGHList(pageSize: Int) {
        guard let url = URL(string: "\(baseUrl.newurl)api/guild/index?page=\(currentPage)&pageSize=\(pageSize)") else { return }
        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            guard let self = self else { return }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(GHListModel.self, from: data)
                    DispatchQueue.main.async {
                        print("getGHList function Success result：\(result)")
                        self.GHListArray.append(contentsOf: result.data.list)
                        self.currentPage = self.currentPage + 1
                    }
                } else {
                    print("getGHList other result：No data")
                }
            } catch(let error) {
                print("getGHList function Error result：\(error.localizedDescription)")
            }
        }.resume()
    }
    
    // 获取搜索结果
    func searchGHtoName(nameOrId: String) {
        guard let url = URL(string: "\(baseUrl.newurl)api/guild/search?name=\(nameOrId)") else { return }
        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            guard let self = self else { return }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(searchGHModel.self, from: data)
                    DispatchQueue.main.async {
                        print("searchGHtoName function Success result：\(result)")
                        if result.data == nil {
                            self.searchGHtoId(nameOrId: nameOrId)
                        } else {
                            self.searchResult = result.data
                        }
//                        self.GHListArray = result.data.list
                        
                    }
                } else {
                    print("searchGHtoName other result：No data")
                }
            } catch(let error) {
                print("searchGHtoName function Error result：\(error.localizedDescription)")
            }
        }.resume()
    }
    func searchGHtoId(nameOrId: String) {
        guard let url = URL(string: "\(baseUrl.newurl)api/guild/search?id=\(nameOrId)") else { return }
        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            guard let self = self else { return }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(searchGHModel.self, from: data)
                    DispatchQueue.main.async {
                        print("searchGHtoId function Success result：\(result)")
                        self.searchResult = result.data
                    }
                } else {
                    print("searchGHtoId other result：No data")
                }
            } catch(let error) {
                print("searchGHtoId function Error result：\(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    
    func isHaveGH() {
        // edit
        guard let url = URL(string: "\(baseUrl.newurl)api/user/home_page?user_id=1111148") else { return }
        var request = URLRequest(url: url)
//        request.setValue(UserCache.shared.getUserInfo()?.token, forHTTPHeaderField: "Token")
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            guard let self = self else { return }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(isHaveGHModel.self, from: data)
                    DispatchQueue.main.async {
                        print("isHaveGH function Success result：\(result)")
                        self.isHaveGHData = result
                    }
                } else {
                    print("isHaveGH other result：No data")
                }
            } catch(let error) {
                print("isHaveGH function Error result：\(error.localizedDescription)")
            }
        }.resume()
    }
    
}

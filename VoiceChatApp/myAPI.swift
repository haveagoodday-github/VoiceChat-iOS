//
//  myAPI.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/1.

import Foundation
import SwiftUI
//var userPhoneNumberStored: String = ""
//class myAPI: ObservableObject {
//    final private let token: String = UserCache.shared.getUserInfo()?.token ?? ""
//    func getUserPhoneNumberStored() -> String {
//        return userPhoneNumberStored
//    }
//    func setUserPhoneNumberStored(userPhoneNumber: String){
//        print("存储成功=\(userPhoneNumberStored)")
//        userPhoneNumberStored = userPhoneNumber
//    }
//    
//    
//    // POST
//    func requestAPI<T: Decodable>(httpMethod: String, apiurl: String, body: [String: Any], resultType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: apiurl) else { return }
//        
//        do {
//            let finalData = try JSONSerialization.data(withJSONObject: body)
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = httpMethod
//            request.httpBody = finalData
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(token, forHTTPHeaderField: "Token")
//            
//
//            
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                do {
//                    if let data = data {
//                        let result = try JSONDecoder().decode(T.self, from: data)
//                        completion(.success(result))
//                    } else {
//                        print("myAPI_Post返回：No data")
//                    }
//                } catch(let error) {
//                    print("myAPI_Post1错误返回：", error.localizedDescription)
//                    completion(.failure(error))
//                }
//                
//            }.resume()
//        } catch {
//            print("myAPI_Post2错误返回：", error.localizedDescription)
//            completion(.failure(error))
//        }
//    }
//
//    
//    // GET
//    func loadAPI<T: Decodable>(getUrl: String, resultType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: getUrl) else { return }
//        var request = URLRequest(url: url)
//        request.setValue(token, forHTTPHeaderField: "Token")
//        URLSession.shared.dataTask(with: request) { (data, res, err) in
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(T.self, from: data)
//                    DispatchQueue.main.async {
//                        print("myAPI_Get成功返回：\(result)")
//                        completion(.success(result))
//                    }
//                } else {
//                    print("myAPI_Get：No data")
//                }
//            } catch(let error) {
//                print("myAPI_Get错误返回：\(error.localizedDescription)")
//            }
//        }.resume()
//    }
//
//    
//}


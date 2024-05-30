//
//  RegisterView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @FocusState var fieldInFocus: OnboardingField?
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            Form {
                Section() {
//                    TextField("请设置用户名", text: $viewModel.username, prompt: Text("请设置用户名"))
//                        .focused($fieldInFocus, equals: .username)
//                        .submitLabel(.next)
//                        .onSubmit {
//                            fieldInFocus = .password
//                        }
                    
                    TextField("请设置昵称", text: $viewModel.nickname, prompt: Text("请设置昵称"))
                        .focused($fieldInFocus, equals: .nickname)
                        .submitLabel(.return)
                        .onSubmit {
                            fieldInFocus = .password
                        }
                    
                    TextField("请设置密码", text: $viewModel.password, prompt: Text("请设置密码"))
                        .focused($fieldInFocus, equals: .password)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .phone
                        }
                    
                    TextField("请设置手机号码", text: $viewModel.phone, prompt: Text("请设置手机号码"))
                        .focused($fieldInFocus, equals: .phone)
                        .submitLabel(.next)
                        .onSubmit {
                            viewModel.register()
                        }
                }
                
                
                Section() {
                    Button(action: {
                        viewModel.register()
                    }, label: {
                        Text("注册")
                    })
                }
            }
        }
        .navigationTitle("注册")
        .navigationBarTitleDisplayMode(.inline)
        .background {
            NavigationLink(
                destination: CustomTabBar().navigationBarBackButtonHidden(true),
                isActive: $viewModel.isLogin,
                label: {
                    
                })
            
        }
    }
}


#Preview {
    RegisterView()
}

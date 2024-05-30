//
//  iptVerCode.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/7/28.
//

import SwiftUI
import Alamofire
import ProgressHUD

struct iptVerCode: View {
    @StateObject var viewModel: LoginModel
    @FocusState private var focusField: Bool?
    @State private var veriCode: String = ""
    
    var body: some View {
        HStack(spacing: 0)  {
            VStack(alignment: .leading, spacing: 5) {
                Text("输入验证码")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Text("验证码已发送至" + viewModel.selectedCountryCode + " " + viewModel.phone)
                    .padding([.leading, .bottom])
                HStack(alignment: .center, spacing: 0)  {
                    TextField("请输入验证码", text: $veriCode)
                        .keyboardType(.numberPad)
                        .frame(height: 50)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .focused($focusField, equals: true)
                        
                    
                    if veriCode.count == 6 {
                        ProgressView()
                            .frame(width: 40, height: 40)
                    }
                }
                
                HStack(spacing: 0)  {
                    Text("收不到验证码？")
                        .foregroundColor(.gray)
                    Text("查看解决方案")
                        .foregroundColor(.blue)
                }
                .padding(.leading)
                
                Spacer()
            }
            .animation(.spring)
            .padding()
            .onChange(of: veriCode) { newValue in
                if veriCode.count == 6 {
                    viewModel.enterVerificationCode(veriCode: veriCode)
                }
            }
            
            Spacer()
            
        }
        .background {
            NavigationLink(destination: CustomTabBar().navigationBarBackButtonHidden(true), isActive: $viewModel.isSuccessful) { }
            
            NavigationLink(
                destination: CompleteRegistration(viewModel: viewModel),
                isActive: $viewModel.isGoToCompleteRegistration
            ) {
                
            }
        }
        .onAppear {
            focusField = true
        }
        

    }
    
    
    
}


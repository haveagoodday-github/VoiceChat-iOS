//
//  AboutUs.swift
//  testProject
//
//  Created by MacBook Pro on 2023/8/26.
//

import SwiftUI

struct AboutUs: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 0)  {
                logoVersion()
                otherSelectorView()
            }
        }
        .navigationBarTitle("关于我们", displayMode: .inline)
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}



struct logoVersion: View {
    var body: some View {
        VStack(alignment: .center, spacing: 18)  {
            Image(.appLog)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
            Text("V 1.74")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(Color(red: 0.963, green: 0.949, blue: 0.97))
    }
}


struct otherSelectorView: View {
    @State private var isNaviFeedback: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 8)  {
            HStack(alignment: .center, spacing: 0)  {
                Text("社区规范")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            .padding()
            
            
            HStack(alignment: .center, spacing: 0)  {
                Text("用户协议")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            .padding()
            
            
            NavigationLink(destination: Feedback(), isActive: $isNaviFeedback) {
                HStack(alignment: .center, spacing: 0)  {
                    Text("我要反馈")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            
            HStack(alignment: .center, spacing: 0)  {
                Text("检查更新")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            .padding()
            
            
            
            
            HStack(alignment: .center, spacing: 0)  {
                Text("联系人工客服（QQ）")
                    .font(.system(size: 18, weight: .bold))
                Text("客服工作时间10:00-18:00")
                    .font(.system(size: 12, weight: .light))
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            .padding()
            
        }
    }
}



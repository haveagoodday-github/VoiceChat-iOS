//
//  CustomEmptyView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/9/14.
//

import SwiftUI

struct CustomEmptyView: View {
//    @State var backgroundColor: UIColor = Color.white
    @State var content: String = "暂无数据"
    var body: some View {
        ZStack(alignment: .center) {
//            backgroundColor
            Color.white
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 8)  {
                Image(.messageImgBgDafault)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                Text(content)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    CustomEmptyView()
}

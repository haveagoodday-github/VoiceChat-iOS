//
//  MyDynamicView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/12/25.
//

import SwiftUI

struct MyDynamicView: View {
    @StateObject var viewModel: DynamicViewModel = DynamicViewModel()
    @State var currentCommentPage: Int = 1
    var body: some View {
        DynamicContentItemView(viewModel: viewModel, currentCommentPage: currentCommentPage)
        .onAppear {
            viewModel.CurrentDynamicType = .mypost
            viewModel.getMyPostDynamic()
        }
        .navigationTitle("我的动态")
        .navigationBarTitleDisplayMode(.inline)
    }
}



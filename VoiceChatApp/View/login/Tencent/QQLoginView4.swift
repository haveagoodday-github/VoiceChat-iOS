//
//  QQLoginView4.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/18.
//

import SwiftUI
import UIKit
import Foundation
import AGConnectAuth



struct QQLoginView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isSuccessQQ: Bool = false
    
    var body: some View {
        Button(action: {
            appDelegate.registerQQ()
        }) {
            Image(.QQ)
                .resizable()
                .frame(width: 30, height: 30) // 调整图片的大小
                .padding(10) // 增加内边距，使按钮变大
                .background(Color.gray)
                .clipShape(Circle())
        }
        
        
    }
}




struct QQLoginView_Previews: PreviewProvider {
    static var previews: some View {
        QQLoginView()
        
    }
}

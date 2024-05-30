//
//  VoiceChatAppApp.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/7/27.
//

import SwiftUI
import UIKit
import Foundation

@main
struct VoiceChatAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if let userId = UserCache.shared.getUserInfo()?.userId {
                CustomTabBar(linphone: appDelegate.tutorialContext)
            } else {
                login()
                    .onOpenURL{url in
                        WXApi.handleOpen(url, delegate: appDelegate)
                    }
                    .onAppear {
                        print("--\(UserCache.shared.getUserInfo())")
                    }
            }

        }
    }
}


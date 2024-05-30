//
//  ProgressHUDTool.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/8.
//

import Foundation
import ProgressHUD

class ProgressHUDTool {
    class func showHUD(_ code: Int, message: String) {
        if code == 0 {
            ProgressHUD.succeed(message)
        } else {
            ProgressHUD.failed(message, delay: 2)
        }
    }
}

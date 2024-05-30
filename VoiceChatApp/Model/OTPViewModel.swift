//
//  OTPViewModel.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/7/28.
//

import SwiftUI

class OTPViewModel: ObservableObject {
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
}

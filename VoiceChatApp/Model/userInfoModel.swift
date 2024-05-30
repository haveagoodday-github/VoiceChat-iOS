//
//  userInfo.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/7/29.
//

import SwiftUI


class userInfoModel: ObservableObject {
    @Published var selectedCountryCode: String = ""
    @Published var phoneNumber: String = ""
}

//
//  ExtensionView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/1/2.
//

import Foundation
import SwiftUI


extension View {
    
    func convertToBase64(_ stringToConvert: String) -> String {
        if let data = stringToConvert.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return ""
    }
    
    
    func giftTypeButtonFormatting(isSelected: Bool, action: @escaping () -> ()) -> some View {
        modifier(giftTypeButtonModifier(isSelected: isSelected, action: action))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func calculateAge(birthday: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateOfBirth = dateFormatter.date(from: birthday) {
            let calendar = Calendar.current
            let currentDate = Date()
            let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: currentDate)
            let age = ageComponents.year
            return age
        } else {
            return nil
        }
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
    
    func chatViewFormatting(textColor: Color = Color(red: 0.817, green: 0.952, blue: 0.394)) -> some View {
        modifier(chatViewModifier(textColor: textColor))
    }
    
    func keyboardExtensionViewFormatting() -> some View {
        modifier(keyboardExtensionModifier())
    }
    
    func messageTypeFormatting(isSelected: Bool) -> some View {
        modifier(message_type_ViewModifier(isSelected: isSelected))
    }
    func frameall(_ widthPercent: Double = 1.0, _ heighPercent: Double = 1.0) -> some View {
        modifier(Framewh_ViewModifier(widthPercent: widthPercent, heighPercent: heighPercent))
    }
}






extension View {
    func SendDefaultMsg(goldImg: String, headImgUrl: String, nickName: String, sex: Int, star_img: String, user_id: String, vip_tx: String) -> String {
        return """
                            {"MicPos":-1,"adminMenuEvent":null,"bagGifListData":null,"changeMicrophone":null,"fromUser":{"goldImg":"\(goldImg)","headImgUrl":"\(headImgUrl)","is_admin":false,"is_answer":false,"ltk_right":"","nickColor":"#ffffff","nickName":"\(nickName)","sex":\(sex),"star_img":"\(star_img)","user_id":"\(user_id)","vip_tx":"\(vip_tx)"},"gift":null,"giftNum":null,"master_micPlaceInfo":null,"message":null,"messageType":2,"micList":null,"microStatusData":null,"roomInfo":null,"upMicPos":-1}
                            """
    }
    
    
}

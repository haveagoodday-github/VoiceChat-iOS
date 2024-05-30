//
//  ViewModifier_extension.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/12/11.
//

import SwiftUI

//struct CountdownSecondViewModifier: ViewModifier {
//    let second: Int
//    @Binding var timeRemaining: String
//    var everySecondAction: (() -> ())?
//    var timeOutAction: (() -> ())?
//    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
//    var futureDate: Date = Calendar.current.date(byAdding: .second, value: 60, to: Date()) ?? Date()
//    
//    init(second: Int, timeRemaining: Binding<String> , everySecondAction: (() -> ())?, timeOutAction: (() -> ())?) {
//        self.second = second
//        self._timeRemaining = timeRemaining
//        self.everySecondAction = everySecondAction
//        self.timeOutAction = timeOutAction
//        self.futureDate = Calendar.current.date(byAdding: .second, value: second, to: Date()) ?? Date()
//    }
//    
//    
//    func body(content: Content) -> some View {
//        content
//            .onReceive(timer) { _ in
//                updateTimeRemaining()
//            }
//    }
//    
//    private func updateTimeRemaining() {
//        let remaining = Calendar.current.dateComponents([.second], from: Date(), to: futureDate)
//        let second = remaining.second ?? 0
//        timeRemaining = "\(second)"
//        everySecondAction?()
//        if second < 1 {
//            timeOutAction?()
//        }
//    }
//}


//extension View {
//    func countdownSecond(second: Int, timeRemaining: Binding<String> , everySecondAction: (() -> ())?, timeOutAction: (() -> ())?) -> some View {
//        modifier(CountdownSecondViewModifier(second: second, timeRemaining: timeRemaining, everySecondAction: everySecondAction, timeOutAction: timeOutAction))
//    }
//}


struct Framewh_ViewModifier: ViewModifier {
    var widthPercent: Double
    var heighPercent: Double
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.main.bounds.width * widthPercent, height: UIScreen.main.bounds.height * heighPercent)
    }
}



struct message_type_ViewModifier: ViewModifier {
    let isSelected: Bool
    func body(content: Content) -> some View {
        content
            .foregroundColor(isSelected ? .white : .gray)
            .font(.system(size: 16, weight: isSelected ? .bold : .regular))
            .padding(.horizontal, 2)
    }
}

struct chatViewModifier: ViewModifier {
    let textColor: Color?
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(textColor)
            .padding(.all, 5)
            .background(Color.white.opacity(0.3))
            .cornerRadius(10)
            .multilineTextAlignment(.leading) // 设置文本左对齐
    }
}




struct keyboardExtensionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Image(systemName: "keyboard.chevron.compact.down")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    
                }
            }
    }
}

//
//  HandleTime.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/4/26.
//

import Foundation


/// 显示过去的某个时间点距今多久时
/// - Parameter dateString: 初始时间字符串类型
/// - Returns: 返回String x分钟前/x小时前/x天前



/// 日期间隔
/// - Parameters:
///   - starttime: 开始日期
///   - endtime: 结束日期
/// - Returns: 返回Int?日期间隔
func daysBetween(starttime: String, endtime: String) -> Int? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yy-MM-dd"
    
    guard let start = formatter.date(from: starttime),
          let end = formatter.date(from: endtime) else {
        return nil
    }
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: start, to: end)
    
    return components.day
}

//
//  Timer.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/4.
//

import Foundation

class Timer {
    class func daysBetween(starttime: String, endtime: String) -> Int? {
        // 创建一个日期格式化器
        let formatter = DateFormatter()
        // 设置日期格式
        formatter.dateFormat = "yy-MM-dd"
        
        // 使用格式化器将字符串转换为日期
        guard let start = formatter.date(from: starttime),
              let end = formatter.date(from: endtime) else {
            // 如果转换失败，返回nil
            return nil
        }
        
        // 使用Calendar计算两个日期之间的天数差
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
        
        // 返回间隔天数
        return components.day
    }
    
    
    class func calculateAge(birthDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let birthDate = dateFormatter.date(from: birthDateString) else {
            return "0"
        }
        
        // 计算当前日期
        let now = Date()
        // 使用当前日历获取年份之间的差异
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        // 提取年龄
        let age = ageComponents.year ?? 0
        
        // 返回年龄的字符串表示
        return String(age)
    }
    
    class func handleLateTime(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: Date())
            
            if let year = components.year, year > 0 {
                return "\(year)年前"
            } else if let month = components.month, month > 0 {
                return "\(month)月前"
            } else if let day = components.day, day > 0 {
                return "\(day)天前"
            } else if let hour = components.hour, hour > 0 {
                return "\(hour)小时前"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute)分钟前"
            } else {
                return "刚刚"
            }
        } else {
            return "时间格式错误"
        }
    }
    
    
    class func handleLateTimeT(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: Date())
            
            if let year = components.year, year > 0 {
                return "\(year)年前"
            } else if let month = components.month, month > 0 {
                return "\(month)月前"
            } else if let day = components.day, day > 0 {
                return "\(day)天前"
            } else if let hour = components.hour, hour > 0 {
                return "\(hour)小时前"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute)分钟前"
            } else {
                return "刚刚"
            }
        } else {
            return "时间格式错误"
        }
    }
    
    class func lastMessageDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // 保证无论用户的设备在什么locale，都能正确解析
        guard let date = inputFormatter.date(from: dateString) else {
            return "Invalid date"
        }
        
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "zh_CN")
        
        if calendar.isDateInToday(date) {
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "昨天"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            outputFormatter.dateFormat = "EEEE"
            return outputFormatter.string(from: date)
        } else if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            outputFormatter.dateFormat = "MM/dd"
            return outputFormatter.string(from: date)
        } else {
            outputFormatter.dateFormat = "yyyy-MM-dd"
            return outputFormatter.string(from: date)
        }
    }
}


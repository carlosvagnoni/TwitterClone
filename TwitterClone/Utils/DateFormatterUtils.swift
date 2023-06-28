//
//  DateFormatter.swift
//  TwitterClone
//
//  Created by user239477 on 6/27/23.
//

import Firebase

class DateFormatterUtils {
    static  func formatTimestamp(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let now = Date()
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day], from: date, to: now)

        if let day = components.day, day >= 11 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yy"
            return dateFormatter.string(from: date)
        } else if let day = components.day, day > 0 {
            return "\(day)d"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m"
        } else if let second = components.second, second > 0 {
            return "\(second)s"
        } else {
            return "Now"
        }
    }
}

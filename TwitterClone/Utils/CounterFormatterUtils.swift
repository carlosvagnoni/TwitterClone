//
//  CounterFormatterUtils.swift
//  TwitterClone
//
//  Created by user239477 on 7/9/23.
//

import Foundation

class CounterFormatterUtils {
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    static func formatCounter(_ count: Int) -> String {
        switch count {
        case 1..<10000:
            return numberFormatter.string(from: NSNumber(value: count)) ?? "\(count)"
        case 10000..<100000:
            return String(format: "%.1fK", Double(count) / 1000.0)
        case 100000..<1000000:
            return "\(count / 1000)K"
        case 1000000..<100000000:
            return String(format: "%.1fM", Double(count) / 1000000.0)
        case 100000000...Int.max:
            return "\(count / 1000000)M"
        default:
            return "0"
        }
    }
}



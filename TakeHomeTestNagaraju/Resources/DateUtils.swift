//
//  DateUtils.swift
//  TakeHomeTest
//
//  Created by Raju on 17/12/24.
//

import Foundation

class DateUtils {
    
    public static func dayName(from string: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: string) else {
            return nil
        }

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        return dayFormatter.string(from: date)
    }
    
    public static func getHours(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        // 2024-12-17 02:00
        let dayFormatter = DateFormatter()
        dayFormatter.dateStyle = .none
        dayFormatter.timeStyle = .short
        let time = dayFormatter.string(from: date)
        return time
    }
    
    public static func getCurrentDayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
    }
}

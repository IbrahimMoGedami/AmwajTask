//
//  Date+.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/18/23.
//

import Foundation

class DateHelper {
    
    static func getDateString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    static func getDateFromString(date: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return formatter.date(from: date) ?? Date()
    }
    
    static func getTimeStringFromDateStr(date: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateNew = formatter.date(from: date) ?? Date()
        formatter.dateFormat = "hh:mm"
        
        return formatter.string(from: dateNew)
    }
    
    static func convertDateFromTimestamp(timeStamp: Int?) -> Date {
        if timeStamp != nil {
            let date = Date(timeIntervalSince1970: Double(timeStamp!))
            let dateStr = getDateString(date: date)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateFinal = formatter.date(from: dateStr)
            
            return dateFinal ?? Date()
        }
        let dateStr = getDateString(date: Date())
        let formatter = DateFormatter()
        return formatter.date(from: dateStr) ?? Date()
    }
    
    static func convertTimeFromTimestamp(timeStamp: Int?) -> String {
        if timeStamp != nil {
            let date = Date(timeIntervalSince1970: Double(timeStamp!))
            
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            
            let dateStr = formatter.string(from: date)
            return dateStr
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let dateStr = formatter.string(from: Date())
        
        return dateStr
    }
}

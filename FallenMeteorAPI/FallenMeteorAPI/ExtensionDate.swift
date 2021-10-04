//
//  ExtensionDate.swift
//  FallenMeteorAPI
//
//  Created by Shilei Mao on 03/10/2021.
//

import Foundation

extension Date {
    /// Formate the date to String using the format string provided, default time zone is the same with user device's settings, you can provide your own time zone
    /// - Parameter format: the format string
    /// - Parameter timeZone: time zone for the date formatter
    /// - Returns: Formatted string of the date
    public func toString(_ format: String, timeZone: TimeZone = TimeZone.current) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: self)
    }
    
    
    /// Parse the string into a date, returns null if the date string or format string is not vaid
    /// - Parameters:
    ///   - dateString: The original date string
    ///   - format: formats string to parse the date string
    ///   - timeZone: time zone of the parser, default to user device's settings, you can provide your own ones
    /// - Returns: Decoded Date object, of nil if the data provided is invalid
    public static func fromString(_ dateString: String, format: String, timeZone: TimeZone = TimeZone.current) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.date(from: dateString)
    }
}

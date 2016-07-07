//
//  DateExtension.swift
//  SoundKeylogger
//
//  Created by Rodrigo Alves on 7/7/16.
//  Copyright © 2016 Rodrigo Alves. All rights reserved.
//

import Foundation

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .ISO8601)
            formatter.locale = Locale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            return formatter
        }()
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

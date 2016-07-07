//
//  StringExtension.swift
//  SoundKeylogger
//
//  Created by Rodrigo Alves on 7/5/16.
//  Copyright © 2016 Rodrigo Alves. All rights reserved.
//

import Foundation

extension String {
    func stringByAppendingPathComponent(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
}

//
//  HelperFunctions.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import Foundation


func convertTimestampToShortDate(timestamp: Int) -> String {
    
    let date = Date(timeIntervalSince1970: Double(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM d"
    let strDate = dateFormatter.string(from: date)
    
    return strDate
}


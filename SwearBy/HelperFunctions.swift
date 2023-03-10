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

func getTimestamp() -> Int {
    
    return Int(round(Date().timeIntervalSince1970))

}

func makePhoneNumberPretty(phone_number: String) -> String {
    
    if phone_number.count >= 10 {
        
        let area_code = String(phone_number.prefix(3))
        
        let digit_three = phone_number.index(phone_number.startIndex, offsetBy: 3)
        let digit_six = phone_number.index(phone_number.startIndex, offsetBy: 6)
        let digit_ten = phone_number.index(phone_number.startIndex, offsetBy: 10)
        
        let range1 = digit_three..<digit_six
        let range2 = digit_six..<digit_ten
        
        let first_three = phone_number[range1]
        let last_four = phone_number[range2]
        
        return "(" + area_code + ") " + first_three + "-" + last_four
        
    } else {
        return phone_number
    }
    
    
}


//
//  HelperFunctions.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import Foundation
import SwiftUI


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


func convertMyReferralCodeSubtitle(commission_type: String, commission_value: String, offer_type: String, offer_value: String) -> [Any] {
    
    let icon:String = getIconForReferralSubtitles(type: commission_type, value: commission_value)[0] as! String
    let icon_color:Color = getIconForReferralSubtitles(type: commission_type, value: commission_value)[1] as? Color ?? Color.black
    let commission_string:String = getIconForReferralSubtitles(type: commission_type, value: commission_value)[2] as! String
    
    let offer_icon:String = getIconForReferralSubtitles(type: offer_type, value: offer_value)[0] as! String
    let offer_icon_color:Color = getIconForReferralSubtitles(type: offer_type, value: offer_value)[1] as? Color ?? Color.black
    let offer_string:String = getIconForReferralSubtitles(type: offer_type, value: offer_value)[3] as! String
    
    return [icon, icon_color, commission_string, offer_icon, offer_icon_color, offer_string]

}

func getIconForReferralSubtitles(type: String, value: String) -> [Any] {
    
    switch type {
    case "Cash":
        return ["banknote", Color.green, "Get $\(value)", "Give $\(value)"]
    case "Gift Card":
        return ["giftcard", Color.orange, "Get $\(value)", "Give $\(value)"]
    case "Discount ($)":
        return ["dollarsign.square", Color.indigo, "Get $\(value)", "Give $\(value)"]
    case "Discount (%)":
        return ["percent", Color.blue, "Get \(value)%", "Give \(value)%"]
    case "Points":
        return ["circle", Color.yellow, "Get \(value) pts", "Give \(value) pts"]
    default:
        return ["", Color.gray, "", ""]
        
    }
}





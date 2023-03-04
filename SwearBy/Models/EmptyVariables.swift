//
//  EmptyVariables.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import Foundation

class EmptyVariables {
    
    var empty_user = Users(email: "", email_verified: false, name: Struct_Profile_Name(first: "", last: "", first_last: ""), phone: "", phone_verified: false, user_id: "")
    
    var empty_post = Posts(description: "", is_public: false, is_verified: false, post_id: "", product_id: "", purchase_id: "", user_id: "", timestamp: 0)
    
    var empty_purchase = Purchases(brand_id: "", product_id: "", purchase_id: "", user_id: "", verification_status: "")
    
}

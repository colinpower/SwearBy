//
//  EmptyVariables.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import Foundation

class EmptyVariables {
    
    
    var empty_post = Posts(description: "", is_public: false, is_verified: false, post_id: "", product_id: "", purchase_id: "", user_id: "", timestamp: 0)
    
    var empty_purchase = Purchases(brand_id: "", product_id: "", purchase_id: "", user_id: "", verification_status: "")
    
    var empty_user = Users(email: "", email_verified: false, friend_requests: [], friends_added: [], friends_list: [], name: Struct_Profile_Name(first: "", last: "", first_last: ""), phone: "", phone_verified: false, user_id: "")
    
    var empty_preloaded_referral_program = PreloadedReferralPrograms(brand_id: "", code: "", commission_type: "", commission_value: 0, expiration: 0, for_new_customers_only: false, link: "", link_for_setup: "", offer_type: "", offer_value: 0, preloaded_referral_program_id: "", product_ids: [], steps: SetupReferralSteps(one: "", two: "", three: ""))
    
}

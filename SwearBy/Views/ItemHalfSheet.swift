//
//  ItemHalfSheet.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import SwiftUI

struct ItemHalfSheet: View {
    
    var purchase: Purchases
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            if purchase.verification_status == "VERIFIED" {
                Text("Verified purchase")
            } else {
                Text("Not yet verified")
            }
            
            HStack {
                
                Rectangle().frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.trailing)
                
                VStack {
                    Text(purchase.brand_id)
                }
                
                Spacer()
                
            }.padding(.horizontal)
                .padding(.top, 40)
            
            Text("BUTTON LINKING TO THE ITEM")
            
            
            
        }
    }
}


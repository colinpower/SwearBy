//
//  AddPreloadedCode.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI

struct AddPreloadedCode: View {
    
    @Environment(\.dismiss) var dismiss
    
    var preloaded_referral_program: PreloadedReferralPrograms
    
    var body: some View {
        VStack {
            Text("Add preloaded code page")
            
            Text(preloaded_referral_program.link_for_setup)
            
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("dismiss")
            }
            Spacer()
            
        }
    }
}

//
//  SetupSteps.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI

struct SetupSteps: View {
    
    @Binding var setup_link:String
    @Binding var steps:SetupReferralSteps
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Spacer()
                Text("Follow steps")
                Spacer()
            }
            
            Text(steps.one)
            Divider()
            Text(steps.two)
            Text("alsefj")
            Divider()
            Text(steps.three)
                .padding(.bottom, 50)
            
            Link(destination: URL(string: setup_link)!) {
                Text("Follow this link")
            }.padding(.bottom, 100)
            
        }
    }
}

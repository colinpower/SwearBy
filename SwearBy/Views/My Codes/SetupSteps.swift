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
        
        VStack(alignment: .center, spacing: 0) {
            
            Text("Follow these steps")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.bottom).padding(.bottom)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(steps.one != "" ? steps.one : "This is step one")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
                
                Text(steps.two != "" ? steps.two : "This is step one")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.vertical)
                
                Text(steps.three != "" ? steps.three : "This is step one")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color("text.black"))
            }.padding(.horizontal)

            Spacer()
            
            Link(destination: URL(string: (setup_link != "" ? setup_link : "https://www.google.com") )!) {
                   
                HStack(alignment: .center) {
                    Spacer()
                    Text("Continue")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                        .padding(.vertical)
                    Spacer()
                }
                .background(Capsule().foregroundColor(Color.blue))
                .padding(.horizontal)
                .padding(.vertical).padding(.vertical)
                
            }
        }
    }
}

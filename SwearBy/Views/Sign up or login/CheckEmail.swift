//
//  CheckEmail.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import Foundation
import SwiftUI

struct CheckEmail: View {
    
    @Binding var startpath: NavigationPath
    @Binding var email: String
    @State var resendIsEnabled: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                //Title
                Text("Confirm your email")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top)
                
                //Subtitle
                Text("We sent \(email) a sign-in link. Tap the link to confirm your email.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.gray"))
                    .padding(.vertical)
                    .padding(.bottom)
                

                Spacer()

                Text("If your email hasn't arrived in 20 seconds, tap the button below to resend.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("text.gray"))
                    .padding(.bottom)
                
                //Resend Link button
                Button {
                    
                    //Auth_EmailVM().requestEmailLink(email: email)
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Resend Link")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(resendIsEnabled ? Color.white : Color("text.gray"))
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor(resendIsEnabled ? Color("UncommonRed") : Color("TextFieldGray")))
                    .padding(.horizontal)
                    .padding(.top).padding(.top)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    
                }.disabled(!resendIsEnabled)
                
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                resendIsEnabled = true
            }
        }
    }
}

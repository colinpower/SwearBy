//
//  EnterEmail.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct EnterEmail: View {
    
    var checkEmailPages: [CheckEmailPage] = [.init(screen: "CheckEmail", content: "")]
    
    @Binding var email: String
    @Binding var startpath: NavigationPath
    
    @FocusState private var keyboardFocused: Bool

    
    @State var textFromFunction = ""                                                      // NOTE: THE CALLABLE FUNCTION IS SET UP HERE
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text("Enter your email")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.top)
                
                //Subtitle
                Text("We'll send you a sign-in link. No passwords needed!")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.gray)
                    .padding(.vertical)
                    .padding(.bottom)
                
                //Email textfield
                TextField("", text: $email)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color.gray))
                    .onSubmit {
                        if !email.isEmpty {
                            
                            //Auth_EmailVM().requestEmailLink(email: email)
                            RequestEmailLinkVM().requestEmailLink(email: email)
                            
                            startpath.append(checkEmailPages[0])
                        }
                    }
                    .focused($keyboardFocused)
                    .submitLabel(.continue)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .padding(.bottom)
                
                Spacer()
                
                //Continue button
                Button {
                    
                    //Auth_EmailVM().requestEmailLink(email: email)
                    
                    RequestEmailLinkVM().requestEmailLink(email: email)
                    
                    
                    startpath.append(checkEmailPages[0])
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Continue")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(email.isEmpty ? Color.gray : Color.white)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor(email.isEmpty ? Color.gray : Color.blue))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }.disabled(email.isEmpty)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationDestination(for: CheckEmailPage.self) { page in
            CheckEmail(startpath: $startpath, email: $email)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                keyboardFocused = true
            }
        }
    }
}



struct CheckEmailPage: Hashable {
    
    let screen: String
    let content: String
    
}





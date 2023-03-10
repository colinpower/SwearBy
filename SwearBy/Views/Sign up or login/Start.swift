//
//  Start.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import SwiftUI


struct Start: View {
    
    var enterEmailPages: [EnterEmailPage] = [.init(screen: "EnterEmail", content: ""),
                                             .init(screen: "EnterEmailAndPassword", content: "")]
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var email: String
    
    @State var startpath = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $startpath) {
            
            ZStack(alignment: .top) {
                
                Color("SwearByGold").ignoresSafeArea()
                
                TabView {
                    Text("First")
                    Text("Second")
                    Text("Third")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                
                VStack(alignment: .center, spacing: 0) {
                    Spacer()

                    NavigationLink(value: enterEmailPages[0]) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Sign In With Email Link")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.white)
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Capsule().foregroundColor(Color.white.opacity(0.1)))
                        .padding(.horizontal).padding(.horizontal)
                    }
                    .padding(.bottom).padding(.bottom)
                    
                    NavigationLink(value: enterEmailPages[1]) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Sign In With Email & Password")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.white)
                                .padding(.vertical)
                            Spacer()
                        }
                        .padding(.horizontal).padding(.horizontal)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    }
                    
                }
            }
            .navigationTitle("")
            .navigationDestination(for: EnterEmailPage.self) { page in
                if page.screen == "EnterEmail" {
                    EnterEmail(email: $email, startpath: $startpath)
                } else {
                    EnterEmailAndPassword(users_vm: users_vm, email: $email, startpath: $startpath)
                }
                
            }   
        }
    }
}



struct EnterEmailPage: Hashable {
    
    let screen: String
    let content: String
    
}





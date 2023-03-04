//
//  Start.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import SwiftUI


struct Start: View {
    
    var enterEmailPages: [EnterEmailPage] = [.init(screen: "EnterEmail", content: "")]
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var email: String
    
    @State var startpath = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $startpath) {
            
            ZStack(alignment: .top) {
                
                Color.red.ignoresSafeArea()
                
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
                            Text("Get Started")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Color("text.black"))
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Capsule().foregroundColor(Color("ShareGray")))
                        .padding(.horizontal).padding(.horizontal)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    }
                }
            }
            .navigationTitle("")
            .navigationDestination(for: EnterEmailPage.self) { page in
                EnterEmail(email: $email, startpath: $startpath)
            }   
        }
    }
}



struct EnterEmailPage: Hashable {
    
    let screen: String
    let content: String
    
}





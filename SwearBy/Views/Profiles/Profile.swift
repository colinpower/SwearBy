//
//  Profile.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var email: String
    @Binding var selectedTab: Int
    
    @State var isShowingAddFriendsPage: Bool = false
    
    var body: some View {
        VStack {
            
            PrimaryHeader(users_vm: users_vm, title: "My Profile", isShowingAddFriendsPage: $isShowingAddFriendsPage)
            
            
            Spacer()
            
            //MARK: Sign Out button
            Button {
                
                let signOutResult = viewModel.signOut(users_vm: users_vm)
                
                email = ""
                
                selectedTab = 0
                
                if !signOutResult {
                    //error signing out here.. handle it somehow?
                }
                
            } label: {
                
                HStack(alignment: .center) {
                    Spacer()
                    Text("Sign Out")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("UncommonRed"))
                    Spacer()
                }
                .frame(height: 50)
                //.background(Capsule().foregroundColor(Color("UncommonRed")))
                .padding(.horizontal)
            }
            
            Spacer()
            
            MyTabView(selectedTab: $selectedTab)
        }.edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $isShowingAddFriendsPage) {
                AddFriends(users_vm: users_vm, isShowingAddFriendsPage: $isShowingAddFriendsPage)
                
            }
        
    }
}


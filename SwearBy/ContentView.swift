//
//  ContentView.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject var users_vm = UsersVM()
    @State var email: String = ""
    
    @State var selectedTab:Int = 0
    
    var body: some View {
        

        let currentSessionUID = viewModel.session?.uid ?? ""
        let currentSessionEmail = viewModel.session?.email ?? ""
        
        Group {
            if (currentSessionUID != "" && currentSessionEmail != "") {
                
                if (users_vm.one_user.phone_verified) {
                    
                    switch selectedTab {
                    case 0:
                        Home(users_vm: users_vm, selectedTab: $selectedTab)
                    case 1:
                        AddPost(users_vm: users_vm, selectedTab: $selectedTab)
                    case 2:
                        Money()
                    case 3:
                        Profile(users_vm: users_vm, email: $email, selectedTab: $selectedTab)
                    default:
                        Profile(users_vm: users_vm, email: $email, selectedTab: $selectedTab)
                    }
                } else {
                 
                    //ThrowawaySheet()
                    EnterName(users_vm: users_vm)
                    
                }
            } else {
                
                Start(users_vm: users_vm, email: $email)
            }
        }
        .onAppear {
            
            viewModel.listen(users_vm: users_vm)
                        
        }
        .onOpenURL { url in
            
            let link = url.absoluteString
            
            if Auth.auth().isSignIn(withEmailLink: link) {
                viewModel.passwordlessSignIn(email: email, link: link) { result in
                    
                    switch result {
                    
                    case let .success(user):
                        viewModel.listen(users_vm: users_vm)
                        
                    case let .failure(error):
                        print("error with result of passwordlessSignIn function")
                        //alertItem = AlertItem(title: "An auth error occurred.", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

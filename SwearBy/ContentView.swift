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
                
                //TabRouter(users_vm: users_vm, email: $email)
                
                
                switch selectedTab {
                case 0:
                    Home(users_vm: users_vm, selectedTab: $selectedTab)
                case 1:
                    TestSheet(selectedTab: $selectedTab)
                case 2:
                    Profile(users_vm: users_vm, email: $email, selectedTab: $selectedTab)
                default:
                    Profile(users_vm: users_vm, email: $email, selectedTab: $selectedTab)
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
                viewModel.passwordlessSignIn(email1: email, link1: link) { result in
                    
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

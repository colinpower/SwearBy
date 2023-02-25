//
//  TabRouter.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import Foundation
import SwiftUI

struct TabRouter: View {
    
    @StateObject var appData: AppDataModel = AppDataModel()
    @ObservedObject var users_vm: UsersVM
    
    var body: some View {
        
        
        TabView(selection: $appData.currentTab) {
            
            
            Home(users_vm: users_vm)
                .tag(Tab.home)
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .ignoresSafeArea(.all)
            
            Profile(users_vm: users_vm)
                .tag(Tab.profile)
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .ignoresSafeArea(.all)
        }
        
    }
}

class AppDataModel: ObservableObject {
    
    @Published var currentTab: Tab = .home
    
}

// Tab enum
enum Tab: String{
    case home = "home"
    case search = "search"
    case profile = "profile"
}

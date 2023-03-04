//
//  MyProfile.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import SwiftUI

struct MyProfile: View {
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("MY_PROFILE")
    }
}



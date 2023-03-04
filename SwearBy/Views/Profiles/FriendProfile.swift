//
//  FriendProfile.swift
//  SwearBy
//
//  Created by Colin Power on 3/3/23.
//

import SwiftUI

struct FriendProfile: View {
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("MY_PROFILE")
    }
}



//
//  AddFriends.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import SwiftUI

struct AddFriends: View {
    
    @Binding var isShowingAddFriendsPage: Bool
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Add some friends here")
            
            Spacer()
            
            Button {
                isShowingAddFriendsPage = false
            } label: {
                Text("X to close")
            }
        }
    }
}

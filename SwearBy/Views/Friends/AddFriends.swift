//
//  AddFriends.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import SwiftUI

struct AddFriends: View {
    
    @Binding var isShowingAddFriendsPage: Bool
    
    
    @State var isShowingContactsList:Bool = false
    @State var selectedContact:[String] = ["", "Your Friend's", "Name", ""]
    
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Add some friends here")
            
            Spacer()
            
            Button {
                isShowingContactsList = true
            } label: {
                
                Text("SHOW CONTACTS LIST")
                
            }
            
            
            Spacer()
            
            
            Button {
                isShowingAddFriendsPage = false
            } label: {
                Text("X to close")
            }
        }
        .sheet(isPresented: $isShowingContactsList) {
            isShowingContactsList = false
        } content: {
            ContactsView(isShowingContactsList: $isShowingContactsList, selectedContact: $selectedContact)
        }
    }
}

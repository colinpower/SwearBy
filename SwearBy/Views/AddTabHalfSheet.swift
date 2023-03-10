//
//  AddTabHalfSheet.swift
//  SwearBy
//
//  Created by Colin Power on 3/9/23.
//

import SwiftUI

struct AddTabHalfSheet: View {

    @ObservedObject var users_vm: UsersVM
    @Binding var selectedTab:Int
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    //@Binding var selectedPage:Int

    var body: some View {
        VStack {

            Spacer()

            Button {
                //self.selectedPage = 1
                fullScreenModalPresented = .add_post

            } label: {
                Text("Add Post")
            }
            
            Spacer()

            Button {
                //self.selectedPage = 2
                fullScreenModalPresented = .add_friends

            } label: {
                Text("add friends")
            }

            //            case .add_friends:
            //                AddFriends(users_vm: users_vm)
            //            case .add_post:
            //                AddPost(users_vm: users_vm)



            Spacer()


        }
//        .onAppear {
//            self.selectedPage = 0
//        }
    }
}

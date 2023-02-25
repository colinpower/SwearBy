//
//  Home.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var users_vm: UsersVM
    
    @State private var presentedSheet: PresentedSheet? = nil
    
    @State private var path = NavigationPath()
    
    var body: some View {
        
        NavigationStack {

            VStack {
                
                
                
                
                
                
            }.edgesIgnoringSafeArea(.top)
            
        }
        
        
    }
    
    
    private var header: some View {
        
        HStack (alignment: .center) {
            
            Text("What I Swear By")
                .font(.system(size: 24))
                .fontWeight(.semibold)
                .foregroundColor(.black)
            Spacer()
            
//            Button {
//
//                presentedSheetOnHome2 = .add
//
//            } label: {
//
//                Image(systemName: "plus.circle.fill")
//                    .font(.system(size: 24))
//
//            }
            
        }.padding(.top, 48)
        .padding()
    }
}

//decide which view to present
enum PresentedSheet: String, Identifiable {
    case purchase
    var id: String {
        return self.rawValue
    }
}

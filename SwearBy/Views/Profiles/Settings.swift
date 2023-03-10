//
//  Settings.swift
//  SwearBy
//
//  Created by Colin Power on 3/9/23.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var viewModel: AppViewModel
    @ObservedObject var users_vm: UsersVM
    @Binding var email: String
    @Binding var selectedTab: Int
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            SettingsHeader(title: "Settings", fullScreenModalPresented: $fullScreenModalPresented)
            
            Spacer()
             
            //MARK: Sign Out button
            Button {
                
                let signOutResult = viewModel.signOut(users_vm: users_vm)
                
                email = ""
                
                selectedTab = 0
                
                fullScreenModalPresented = nil
                
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
        }
        .edgesIgnoringSafeArea(.all)
    }
}


//MARK: PRIMARY HEADER
struct SettingsHeader: View {
    
    var title: String
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    var body: some View {

        HStack (alignment: .center) {
            
            Button {

                fullScreenModalPresented = nil

            } label: {

                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.clear)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                }
            }
            
            Spacer()
            Text(title)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 40)
            Spacer()
            

        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
}

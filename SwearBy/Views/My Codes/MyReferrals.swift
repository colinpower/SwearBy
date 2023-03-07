//
//  Money.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI

struct MyReferrals: View {
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var selectedTab: Int
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    
    @StateObject var preloaded_referral_programs_vm = PreloadedReferralProgramVM()
    @StateObject var referral_codes_vm = ReferralCodesVM()
    
    @State private var path = NavigationPath()
    @State private var selected_preloaded_code:PreloadedReferralPrograms = EmptyVariables().empty_preloaded_referral_program
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            NavigationStack(path: $path) {
                
                VStack(spacing: 0) {

                    PrimaryHeader(users_vm: users_vm, title: "Referral Codes", fullScreenModalPresented: $fullScreenModalPresented)
                    
                    ScrollView(showsIndicators: false) {
                        
                        myShareLink123
                            .padding()
                        
                        if true {
                            addedMe123
                                .padding(.bottom)
                        }
                        
                        Button {
                            fullScreenModalPresented = .add_code
                        } label: {
                            Text("add new referral code")
                                .padding()
                        }
                        
                        Button {
                            fullScreenModalPresented = .add_preloaded_code
                        } label: {
                            Text("add preloaded referral code")
                                .padding()
                        }
 
                    }.padding(.horizontal)
                }
                .edgesIgnoringSafeArea(.all)
                .background(Color("Background"))
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: ReferralCodes.self) { referral_code in
                    //PostView(users_vm: users_vm, post: post, path: $path)
                }
            }
            MyTabView(selectedTab: $selectedTab, fullScreenModalPresented: $fullScreenModalPresented)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            self.referral_codes_vm.getMyReferralCodes(user_id: users_vm.one_user.user_id)
            self.preloaded_referral_programs_vm.getPreloadedReferralPrograms()
            
        }
        .fullScreenCover(item: $fullScreenModalPresented, onDismiss: { fullScreenModalPresented = nil }) { [selected_preloaded_code] sheet in
    
            switch sheet {        //add_friends, add_code, add_preloaded_code
            case .add_friends:
                AddFriends(users_vm: users_vm)
            case .add_code:
                AddNewCode(users_vm: users_vm)
            case .add_preloaded_code:
                AddPreloadedCode(preloaded_referral_program: selected_preloaded_code)
            case .add_post:
                AddPost123(users_vm: users_vm)
            default:
                AddFriends(users_vm: users_vm)
            }
        }
    }
    
    var myShareLink123: some View {
        
        
        ShareLink(item: "Hey, join me on SwearBy app! <insert URL here>", preview: SharePreview(
            "Join me on SwearBy!",
            image: Image("AppIcon"))) {
            
            HStack(alignment: .center, spacing: 0) {
                
                Image("SwearByIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.trailing, 16)
                
                Text("Share your link")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                
                Spacer()
                
                Image(systemName: "message")
                    .foregroundColor(.green)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 8)
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
        }
    }
    
    var addedMe123: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack (spacing: 0) {
                Text("Added Me")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.bottom, 4)
                Spacer()
            }
            
            Group {
                ForEach(users_vm.one_user.friend_requests, id: \.self) { friend_id in
                    
                    if friend_id != "" {
                        AcceptFriendRow(users_vm: users_vm, friend_user_id: friend_id)
                    }
                    
                }
            }
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
        }
    }
}

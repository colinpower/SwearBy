//
//  Money.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct MyReferrals: View {
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var selectedTab: Int
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    
    @StateObject var preloaded_referral_programs_vm = PreloadedReferralProgramVM()
    @StateObject var referral_codes_vm = ReferralCodesVM()
    
    @State private var path = NavigationPath()
    
    @State private var selected_preloaded_program:PreloadedReferralPrograms = EmptyVariables().empty_preloaded_referral_program
    @State private var selected_brand:Brands = EmptyVariables().empty_brand
    
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
                            fullScreenModalPresented = .add_code
                        } label: {
                            Text("add preloaded referral code")
                                .padding()
                        }
                        
                        ForEach(preloaded_referral_programs_vm.preloaded_referral_programs) { program in
                            
                            Button {
                                
                                selected_preloaded_program = program
                                fullScreenModalPresented = .add_code
                                
                            } label: {
                                
                                PreloadedReferralProgramRow(program: program)
                            }
                            
                            
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
        .fullScreenCover(item: $fullScreenModalPresented, onDismiss: { fullScreenModalPresented = nil }) { [$selected_preloaded_program] sheet in
    
            switch sheet {        //add_friends, add_code, add_preloaded_code
            case .add_friends:
                AddFriends(users_vm: users_vm)
            case .add_code:
                AddNewCode(users_vm: users_vm, preloaded_referral_programs_vm: preloaded_referral_programs_vm, preloaded_referral_program: $selected_preloaded_program)
            case .add_post:
                AddPost(users_vm: users_vm)
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


struct PreloadedReferralProgramRow: View {

    @StateObject private var private_brands_vm = BrandsVM()
    
    var program: PreloadedReferralPrograms
    
    @State private var private_brandURL = ""

    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0) {

            if private_brandURL != "" {
                WebImage(url: URL(string: private_brandURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                ZStack(alignment: .center) {
                    Circle().frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    if private_brands_vm.get_brand_by_id.name.count > 0 {
                        Text(private_brands_vm.get_brand_by_id.name.prefix(1))
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    } else {
                        Text("?")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
            

            //The first + last names and the phone number
            VStack(alignment: .leading, spacing: 0) {

                Text(private_brands_vm.get_brand_by_id.name != "" ? private_brands_vm.get_brand_by_id.name : "?")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .padding(.bottom, 6)
                Text(private_brands_vm.get_brand_by_id.website.lowercased())
                    .foregroundColor(Color("text.gray"))
                    .font(.system(size: 16, weight: .regular))
                    .lineLimit(1)
            }.padding(.leading, 16)

            Spacer()

            ZStack(alignment: .center) {
                Circle().frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
            }

        }
        .padding(.vertical, 12)
        .onAppear {
            
            self.private_brands_vm.getBrandById(brand_id: program.brand_id)

            let backgroundPath = "brand/" + program.brand_id + ".png"

            let storage = Storage.storage().reference()

            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_brandURL = "\(url!)"
                }
            }
        }
    }
}

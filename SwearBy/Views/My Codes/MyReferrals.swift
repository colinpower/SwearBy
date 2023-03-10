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
    
    //Received from ContentView
    @ObservedObject var users_vm: UsersVM
    @Binding var selectedTab: Int
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    // Variables used for switching the view
    @State var selectedButton:Int = 1
    
    // Varibles used for adding new referral codes
    @StateObject var preloaded_referral_programs_vm = PreloadedReferralProgramVM()
    @State private var selected_preloaded_program:PreloadedReferralPrograms = EmptyVariables().empty_preloaded_referral_program
    @State private var selected_my_code:ReferralCodes = EmptyVariables().empty_referral_code
    
    // Variables used for finding my referral codes and my friends'
    @StateObject var referral_codes_vm = ReferralCodesVM()
    
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            
            PrimaryHeader(users_vm: users_vm, title: "Referral Codes", fullScreenModalPresented: $fullScreenModalPresented)
                .padding(.bottom)
            
                
            if selectedButton == 1 {
                HStack(alignment: .center, spacing: 12) {
                    ExpandedButton(button_icon: "person.fill", icon_size: 15, button_name: "Mine", width: CGFloat(84), background_color: Color.blue, foreground_color: Color.white)
                    Button { selectedButton = 2 } label: { CompressedButton(button_icon: "person.3.fill", icon_size: 15, width: CGFloat(44), background_color: Color("TextFieldGray"), foreground_color: Color("text.gray")) }
                    Button { selectedButton = 3 } label: { CompressedButton(button_icon: "star.fill", icon_size: 14, width: CGFloat(44), background_color: Color("TextFieldGray"), foreground_color: Color("text.gray")) }
                    StaticPlusButton(fullScreenModalPresented: $fullScreenModalPresented)
                }.padding(.horizontal)
            } else if selectedButton == 2 {
                HStack(alignment: .center, spacing: 12) {
                    Button { selectedButton = 1 } label: { CompressedButton(button_icon: "person.fill", icon_size: 15, width: CGFloat(44), background_color: Color("TextFieldGray"), foreground_color: Color("text.gray")) }
                    ExpandedButton(button_icon: "person.3.fill", icon_size: 15, button_name: "Friends", width: CGFloat(110), background_color: Color.blue, foreground_color: Color.white)
                    Button { selectedButton = 3 } label: { CompressedButton(button_icon: "star.fill", icon_size: 14, width: CGFloat(44), background_color: Color("TextFieldGray"), foreground_color: Color("text.gray")) }
                    StaticPlusButton(fullScreenModalPresented: $fullScreenModalPresented)
                }.padding(.horizontal)
            } else {
                HStack(alignment: .center, spacing: 12) {
                    Button { selectedButton = 1 } label: { CompressedButton(button_icon: "person.fill", icon_size: 15, width: CGFloat(44), background_color: Color("TextFieldGray"), foreground_color: Color("text.gray")) }
                    Button { selectedButton = 2 } label: { CompressedButton(button_icon: "person.3.fill", icon_size: 15, width: CGFloat(44), background_color: Color("TextFieldGray"), foreground_color: Color("text.gray")) }
                    ExpandedButton(button_icon: "star.fill", icon_size: 14, button_name: "Try", width: CGFloat(70), background_color: Color.blue, foreground_color: Color.white)
                    StaticPlusButton(fullScreenModalPresented: $fullScreenModalPresented)
                }.padding(.horizontal)
            }
            
            
            if selectedButton == 1 {
                Text("My Referral Codes")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top, 12).padding(.bottom).padding(.leading)
            } else if selectedButton == 2 {
                Text("Shared With Me")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top, 12).padding(.bottom).padding(.leading)
            } else if selectedButton == 3 {
                Text("Popular Brands")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top, 12).padding(.bottom).padding(.leading)
            }
            
            
            ScrollView(showsIndicators: false) {
                
                // Use this for the quick sharing of the referral codes you have
                //myShareLink123
                    
                VStack(alignment: .center) {
                    
                    if selectedButton == 1 {
                        
                        if referral_codes_vm.my_referral_codes.count == 0 {
                            
//                            ForEach(preloaded_referral_programs_vm.preloaded_referral_programs) { program in
//                                
//                                Button {
//                                    
//                                    selected_preloaded_program = program
//                                    fullScreenModalPresented = .add_code
//                                    
//                                } label: {
//                                    
//                                    PreloadedReferralProgramRow(program: program)
//                                }
//                            }
                            
                        } else {
                            
                            ForEach(referral_codes_vm.my_referral_codes) { my_code in
                                
                                Button {
                                    selected_my_code = my_code
                                    fullScreenModalPresented = .edit_code
                                } label: {
                                    MyReferralCodeRow(my_code: my_code)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    } else if selectedButton == 2 {
                        ForEach(referral_codes_vm.my_friends_referral_codes) { friends_code in
                            
                            FriendsReferralCodeRow(friends_code: friends_code)
                                .foregroundColor(.white)
                            
                        }
                    } else {
                        ForEach(preloaded_referral_programs_vm.preloaded_referral_programs) { program in
                            
                            Button {
                                
                                selected_preloaded_program = program
                                fullScreenModalPresented = .add_code
                                
                            } label: {
                                
                                PreloadedReferralProgramRow(program: program)
                            }
                        }
                    }
                    
                    
                }.padding(.leading, 5)
                .padding(.bottom, 100)

            }.padding(.horizontal)

            
            
            MyTabView(users_vm: users_vm, selectedTab: $selectedTab, fullScreenModalPresented: $fullScreenModalPresented)
            //MyTabView(selectedTab: $selectedTab, fullScreenModalPresented: $fullScreenModalPresented)
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("Background"))
        .onAppear {
            
            self.referral_codes_vm.listenForMyReferralCodes(user_id: users_vm.one_user.user_id)
            
            self.referral_codes_vm.getMyFriendsCodes(users_vm: users_vm)
            
            self.preloaded_referral_programs_vm.getPreloadedReferralPrograms()
            
        }
        .fullScreenCover(item: $fullScreenModalPresented, onDismiss: { fullScreenModalPresented = nil }) { [$selected_preloaded_program, $selected_my_code] sheet in
    
            switch sheet {        //add_friends, add_code, add_preloaded_code
            case .add_friends:
                AddFriends(users_vm: users_vm)
            case .add_code:
                AddNewCode(users_vm: users_vm, preloaded_referral_programs_vm: preloaded_referral_programs_vm, preloaded_referral_program: $selected_preloaded_program)
            case .edit_code:
                EditMyCode(users_vm: users_vm, referral_codes_vm: referral_codes_vm, my_code: $selected_my_code)
            case .add_post:
                AddPost(users_vm: users_vm)
            default:
                AddFriends(users_vm: users_vm)
            }
        }
    }
}

struct MyReferralCodeRow: View {

    var my_code:ReferralCodes
    
    @State private var my_codes_private_brandURL = ""

    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0) {

            if my_codes_private_brandURL != "" {
                WebImage(url: URL(string: my_codes_private_brandURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                ZStack(alignment: .center) {
                    Circle().frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    if my_code.brand_name.count > 0 {
                        Text(my_code.brand_name.prefix(1))
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
                
                let subtitle_arr:[Any] = convertMyReferralCodeSubtitle(commission_type: my_code.commission_type,
                                                                       commission_value: my_code.commission_value,
                                                                       offer_type: my_code.offer_type,
                                                                       offer_value: my_code.offer_value)
                
                let icon:String = subtitle_arr[0] as! String
                let icon_color:Color = subtitle_arr[1] as? Color ?? Color.black
                let commission_string:String = subtitle_arr[2] as! String
                
                //let offer_icon:String = subtitle_arr[3] as! String
                //let offer_icon_color:Color = subtitle_arr[4] as? Color ?? Color.black
                let offer_string:String = subtitle_arr[5] as! String
                
                
                

                Text(my_code.brand_name != "" ? my_code.brand_name : "?")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .padding(.bottom, 6)
                
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: icon)
                        .foregroundColor(icon_color)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .frame(width: 20, alignment: .center)
                        .padding(.trailing, 6)
                    Text(commission_string + ", \(offer_string.lowercased())")
                        .foregroundColor(Color("text.gray"))
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                    Spacer()
                }
                
                
//
//                Text(my_code.offer_type + " " + my_code.commission_type)
//                    .foregroundColor(Color("text.gray"))
//                    .font(.system(size: 16, weight: .regular))
//                    .lineLimit(1)
            }.padding(.leading, 16)

            Spacer()

            ShareLink(item: my_code.imessage_autofill, preview: SharePreview(
                "Sending \(my_code.offer_type) \(my_code.offer_value)",
                image: Image("AppIcon"))) {
                    ZStack(alignment: .center) {
                        Capsule().frame(width: 66, height: 32)
                            .foregroundColor(.green)
                        Text("Send")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.white)
                    }
                }

        }
        .padding(.vertical, 12)
        .onAppear {

            let backgroundPath = "brand/" + my_code.brand_id + ".png"

            let storage = Storage.storage().reference()

            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.my_codes_private_brandURL = "\(url!)"
                }
            }
        }
    }
}

struct FriendsReferralCodeRow: View {

    var friends_code:ReferralCodes
    
    @State private var friends_codes_private_brandURL = ""
    
    @StateObject private var private_users_vm = UsersVM()

    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0) {

            if friends_codes_private_brandURL != "" {
                WebImage(url: URL(string: friends_codes_private_brandURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                ZStack(alignment: .center) {
                    Circle().frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    if friends_code.brand_name.count > 0 {
                        Text(friends_code.brand_name.prefix(1))
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
                
                let subtitle_arr:[Any] = convertMyReferralCodeSubtitle(commission_type: friends_code.commission_type,
                                                                       commission_value: friends_code.commission_value,
                                                                       offer_type: friends_code.offer_type,
                                                                       offer_value: friends_code.offer_value)
                
                let offer_icon:String = subtitle_arr[3] as! String
                let offer_icon_color:Color = subtitle_arr[4] as? Color ?? Color.black
                let offer_string:String = subtitle_arr[5] as! String
                

                Text(friends_code.brand_name != "" ? (friends_code.brand_name + " - Shared by " + private_users_vm.get_user_by_id.name.first) : "Brand name missing. Shared by \(private_users_vm.get_user_by_id.name.first)")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .padding(.bottom, 6)
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: offer_icon)
                        .foregroundColor(offer_icon_color)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .frame(width: 20, alignment: .center)
                        .padding(.trailing, 6)
                    Text(offer_string)
                        .foregroundColor(Color("text.gray"))
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                    Spacer()
                }
//                Text(friends_code.offer_type + " " + friends_code.commission_type)
//                    .foregroundColor(Color("text.gray"))
//                    .font(.system(size: 16, weight: .regular))
//                    .lineLimit(1)
            }.padding(.leading, 16)

            Spacer()

            Button {
                
            } label: {
                ZStack(alignment: .center) {
                    Capsule().frame(width: 66, height: 32)
                        .foregroundColor(.blue)
                    Text("Use")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white)
                }
                
            }

        }
        .padding(.vertical, 12)
        .onAppear {

            self.private_users_vm.getUserByID(user_id: friends_code.user_id)
            
            let backgroundPath = "brand/" + friends_code.brand_id + ".png"

            let storage = Storage.storage().reference()

            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.friends_codes_private_brandURL = "\(url!)"
                }
            }
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
                
                
                let subtitle_arr:[Any] = convertMyReferralCodeSubtitle(commission_type: program.commission_type,
                                                                       commission_value: program.commission_value,
                                                                       offer_type: program.offer_type,
                                                                       offer_value: program.offer_value)
                
                let icon:String = subtitle_arr[0] as! String
                let icon_color:Color = subtitle_arr[1] as? Color ?? Color.black
                let commission_string:String = subtitle_arr[2] as! String
                
                let offer_icon:String = subtitle_arr[3] as! String
                let offer_icon_color:Color = subtitle_arr[4] as? Color ?? Color.black
                let offer_string:String = subtitle_arr[5] as! String
                
                
                Text(private_brands_vm.get_brand_by_id.name != "" ? private_brands_vm.get_brand_by_id.name : "?")
                    .foregroundColor(Color("text.black"))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .padding(.bottom, 6)
                
                if program.commission_type != "" {
                    HStack(alignment: .center, spacing: 0) {
                        Image(systemName: icon)
                            .foregroundColor(icon_color)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .frame(width: 20, alignment: .center)
                            .padding(.trailing, 6)
                        Text(commission_string + ", \(offer_string.lowercased())")
                            .foregroundColor(Color("text.gray"))
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                        Spacer()
                    }
                } else {
                    HStack(alignment: .center, spacing: 0) {
                        Image(systemName: offer_icon)
                            .foregroundColor(offer_icon_color)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .frame(width: 20, alignment: .center)
                            .padding(.trailing, 6)
                        Text(offer_string)
                            .foregroundColor(Color("text.gray"))
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                        Spacer()
                    }
                }
                
            }.padding(.leading, 16)

            Spacer()

            ZStack(alignment: .center) {
                
                Capsule().frame(width: 66, height: 32)
                    .foregroundColor(Color("TextFieldGray"))
                HStack(alignment: .center, spacing: 3) {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                    Text("Add")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                }
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





struct ExpandedButton: View {
    
    var button_icon: String
    var icon_size: CGFloat
    var button_name: String
    var width: CGFloat
    var background_color: Color
    var foreground_color: Color
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            Capsule()
                .foregroundColor(background_color)
                .frame(width: width, height: 32)
            HStack(alignment: .center, spacing: 3) {
                Image(systemName: button_icon)
                    .font(.system(size: icon_size, weight: .semibold, design: .rounded))
                    .foregroundColor(foreground_color)
                Text(button_name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .kerning(-0.4)
                    .foregroundColor(foreground_color)
            }
        }
    }
}

struct CompressedButton: View {
    
    var button_icon: String
    var icon_size: CGFloat
    var width: CGFloat
    var background_color: Color
    var foreground_color: Color
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            Capsule()
                .foregroundColor(background_color)
                .frame(width: width, height: 32)
            Image(systemName: button_icon)
                .font(.system(size: icon_size, weight: .semibold, design: .rounded))
                .foregroundColor(foreground_color)
                
        }
    }
}





struct StaticPlusButton: View {
    
    @Binding var fullScreenModalPresented: FullScreenModalPresented?
    
    var body: some View {
        
        Button {
            fullScreenModalPresented = .add_code
        } label: {
            ZStack(alignment: .center) {
                
                Capsule()
                    .foregroundColor(Color("TextFieldGray"))
                    .frame(width: 110, height: 32)
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                    Text("Add New")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .kerning(-0.4)
                        .foregroundColor(Color("text.gray"))
                }
            }
        }
    }
}

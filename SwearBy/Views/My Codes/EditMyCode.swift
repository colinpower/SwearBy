//
//  EditMyCode.swift
//  SwearBy
//
//  Created by Colin Power on 3/9/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct EditMyCode: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var users_vm: UsersVM
    @ObservedObject var referral_codes_vm: ReferralCodesVM
    @Binding var my_code: ReferralCodes
    
    @State private var path = NavigationPath()
    
    // Regular variables
    @State var referral_code_id:String = ""
    @State var brand_id:String = ""
    @State var brand_name:String = ""
    
    @State private var code_or_link_options:[String] = ["Code", "Link"]
    @State var code_or_link_selected:String = "Code"                                                                        //DETERMINE WHETHER TO FILL IN CODE OR LINK
    @State var code:String = ""                                                                                             //CODE OR LINK
    
    @State private var commission_options:[String] = ["None", "Cash", "Gift Card", "Discount ($)", "Discount (%)", "Points"]
    @State var commission_type:String = "None"
    @State var commission_value:String = ""
    @FocusState private var commission_value_focused: Bool
    
    @State private var offer_options:[String] = ["None", "Cash", "Gift Card", "Discount ($)", "Discount (%)", "Points"]
    @State var offer_type:String = "None"
    @State var offer_value:String = ""
    @FocusState private var offer_value_focused: Bool
    
    @State private var has_expiration:Bool = false
    @State var expiration = Date()
    
    @State var for_new_customers_only:Bool = false
    
    //@State private var minimum_spend_required:[String] = false
    @State private var minimum_spend_options:[String] = ["None", "Minimum"]
    @State private var minimum_spend_type:String = "None"
    @State var minimum_spend:String = ""
    @FocusState private var minimum_spend_focused: Bool
    
    @State private var visibility_options:[String] = ["Private", "Friends"]
    @State private var visibility_type:String = "Private"
    @State private var isPublic = false
    
    @State private var notes = ""
    
    @State private var imessage_autofill = ""
    
    
    // ---------
    @State private var private_mini_brandURL: String = ""
    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                editCodeHeader
                    
                Form {
                    
                    Section {
                        brandAndLogoRow
                    }
                    
                    
                    Section {
                        HStack(alignment: .center, spacing: 0) {
                            TextField("Enter referral code or link", text: $code)
                                .onChange(of: code) {
                                    if String($0).contains(".com") {
                                        self.code_or_link_selected = "Link"
                                    }
                                }
                                .foregroundColor(Color("text.black"))
                                .multilineTextAlignment(.leading)
                                .keyboardType(.default)
                                .submitLabel(.done)
                                .frame(width: UIScreen.main.bounds.width * 0.6)
                            Spacer()
                            Picker("", selection: $code_or_link_selected) {
                                ForEach(code_or_link_options, id: \.self) { option in
                                    Text(option)
                                }
                            }
                        }
                    }
                    
                    


                    Section(header: Text("For You"), footer: (commission_type != "None") ? Text("Your commission is always private.") : nil) {
                        
                        HStack {
                            
                            if commission_type != "None" {
                            
                                ZStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        if (((commission_type == "Cash") || (commission_type == "Gift Card") || (commission_type == "Discount ($)")) && (commission_value != "")) {
                                            Text("$")
                                                .foregroundColor(Color("text.black"))
                                        }
                                        TextField("Enter amount", text: $commission_value)
                                            .formatReferralValue(value: $commission_value)
                                            .foregroundColor(Color("text.black"))
                                            .multilineTextAlignment(.leading)
                                            .focused($commission_value_focused)
                                            .keyboardType(.numbersAndPunctuation)
                                            .submitLabel(.done)
                                            .onSubmit {
                                                commission_value_focused = false
                                            }
                                            .frame(width: UIScreen.main.bounds.width / 3)
                                    }
                                        
                                    if ((commission_type == "Points") && (commission_value != "")) {
                                        HStack(alignment: .center, spacing: 0) {
                                            Text(commission_value)
                                                .foregroundColor(.clear)
                                            Text(" points")
                                                .foregroundColor(Color("text.black"))
                                        }
                                    }
                                    
                                    if ((commission_type == "Discount (%)") && (commission_value != "")) {
                                        HStack(alignment: .center, spacing: 0) {
                                            Text(commission_value)
                                                .foregroundColor(.clear)
                                            Text("%")
                                                .foregroundColor(Color("text.black"))
                                        }
                                    }
                                }
                            
                                Spacer()
                                
                            } else {
                                
                                Text("Commission")
                                Spacer()
                                
                            }
                            
                            Picker("", selection: $commission_type) {
                                ForEach(commission_options, id: \.self) { option in
                                    Text(option)
                                }
                                
                            }
              
                            
                        }
                        
                        
                    }
                    
                    
                    Section(header: Text("For Your Friends"), footer: (offer_type != "None") ? Text("Offer details can be shared with friends.") : nil) {
                        
                        HStack {
                            
                            if offer_type != "None" {
                            
                                ZStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        if (((offer_type == "Cash") || (offer_type == "Gift Card") || (offer_type == "Discount ($)")) && (offer_value != "")) {
                                            Text("$")
                                                .foregroundColor(Color("text.black"))
                                        }
                                        TextField("Enter amount", text: $offer_value)
                                            .formatReferralValue(value: $offer_value)
                                            .foregroundColor(Color("text.black"))
                                            .multilineTextAlignment(.leading)
                                            .focused($offer_value_focused)
                                            .keyboardType(.numbersAndPunctuation)
                                            .submitLabel(.done)
                                            .onSubmit {
                                                offer_value_focused = false
                                            }
                                    }
                                        
                                    if ((offer_type == "Points") && (offer_type != "")) {
                                        HStack(alignment: .center, spacing: 0) {
                                            Text(offer_value)
                                                .foregroundColor(.clear)
                                            Text(" points")
                                                .foregroundColor(Color("text.black"))
                                        }
                                    }
                                    
                                    if ((offer_type == "Discount (%)") && (offer_type != "")) {
                                        HStack(alignment: .center, spacing: 0) {
                                            Text(offer_value)
                                                .foregroundColor(.clear)
                                            Text("%")
                                                .foregroundColor(Color("text.black"))
                                        }
                                    }
                                }
                            
                                
                                
                            } else {
                                
                                Text("Offer")
                                Spacer()
                                
                            }
                            
                            Picker("", selection: $offer_type) {
                                ForEach(offer_options, id: \.self) { option in
                                    Text(option)
                                }
                                
                            }.frame(width: 150)
                 
                        }
                    }
                    
                    Section(header: Text("Offer Details")) {
                        
                        Toggle("Expires", isOn: $has_expiration.animation(.easeInOut))
                            .toggleStyle(SwitchToggleStyle())
                        if has_expiration {
                            DatePicker("Use By", selection: $expiration, displayedComponents: .date)
                        }

                        HStack {

                            if (minimum_spend_type == "Minimum") {

                                ZStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        if (minimum_spend != "") {
                                            Text("$")
                                                .foregroundColor(Color("text.black"))
                                        }
                                        TextField("Enter Minimum ($)", text: $minimum_spend)
                                            .formatReferralValue(value: $minimum_spend)
                                            .foregroundColor(Color("text.black"))
                                            .multilineTextAlignment(.leading)
                                            .focused($minimum_spend_focused)
                                            .keyboardType(.numbersAndPunctuation)
                                            .submitLabel(.done)
                                            .onSubmit {
                                                minimum_spend_focused = false
                                            }
                                            .frame(width: UIScreen.main.bounds.width / 3)
                                    }
                                }


                            } else {

                                Text("Minimum Spend")
                                Spacer()

                            }

                            Picker("", selection: $minimum_spend_type) {
                                ForEach(minimum_spend_options, id: \.self) { option in
                                    Text(option)
                                }

                            }


                        }

                        // New Customers Only?
                        Toggle("New Customers Only", isOn: $for_new_customers_only)
                            .toggleStyle(SwitchToggleStyle())
                          
                    }
                    
                    
                    Section(footer: visibility_type == "Private" ? nil : Text("Your friends can see this code and offer. Your commission is private.")) {
                        
                        Picker("Visibility", selection: $visibility_type) {
                            ForEach(visibility_options, id: \.self) { option in
                                Text(option)
                            }
                        }
                    
                    }
                    
                    Section(header: Text("Default iMessage text"), footer: Text("We never send messages without your permission.")) {
                        TextField(code == "" ? "" : "Hey, use \(code) for a discount ...", text: $imessage_autofill)
                            .foregroundColor(Color("text.black"))
                            .multilineTextAlignment(.leading)
                            .frame(height: 60, alignment: .topLeading)
                            .keyboardType(.default)
                            .submitLabel(.done)
                    }
                    
                    Section {
                        TextField("Notes", text: $notes)
                            .foregroundColor(Color("text.black"))
                            .multilineTextAlignment(.leading)
                            .frame(height: 500, alignment: .topLeading)
                            .keyboardType(.default)
                            .submitLabel(.done)
                    }
                    
                    
                }.scrollContentBackground(.hidden)
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color("Background"))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
                loadMyCodeDetails()
                   
            }
        }
        
    }
    
    var brandAndLogoRow: some View {
        
        HStack(alignment: .center, spacing: 8) {
            
            if private_mini_brandURL != "" {
                WebImage(url: URL(string: private_mini_brandURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            } else {
                ZStack(alignment: .center) {
                    Circle().frame(width: 32, height: 32)
                        .foregroundColor(.blue)
                    
                    if brand_name.count > 0 {
                        Text(brand_name.prefix(1))
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    } else {
                        Text("?")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    }
                }
            }

            Text(brand_name)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(Color("text.black"))
            
            Spacer()
            
            Text("Change")
                .foregroundColor(.blue)
            
        }
        .onAppear {
            let backgroundPath = "brand/" + brand_id + ".png"

            let storage = Storage.storage().reference()

            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_mini_brandURL = "\(url!)"
                }
            }
        }
        .onChange(of: brand_id) { newValue in
            let backgroundPath = "brand/" + brand_id + ".png"

            let storage = Storage.storage().reference()

            storage.child(backgroundPath).downloadURL { url, err in
                if err != nil {
                    print(err?.localizedDescription ?? "Issue showing the right image")
                    return
                } else {
                    self.private_mini_brandURL = "\(url!)"
                }
            }
        }
    }
    
    
    func loadMyCodeDetails() {
        
        self.referral_code_id = my_code.referral_code_id
        self.brand_id = my_code.brand_id
        self.brand_name = my_code.brand_name
        
        self.code_or_link_selected = my_code.link != "" ? "Link" : "Code"
        self.code = my_code.link != "" ? my_code.link : my_code.code
        
        self.commission_type = my_code.commission_type
        self.commission_value = my_code.commission_value

        self.offer_type = my_code.offer_type
        self.offer_value = my_code.offer_value

        self.has_expiration = my_code.expiration > 0
        self.expiration = my_code.expiration > 0 ? Date(timeIntervalSince1970: Double(my_code.expiration)) : Date()

        self.for_new_customers_only = my_code.for_new_customers_only

        self.minimum_spend_type = my_code.minimum_spend != "" ? "Minimum" : "None"
        self.minimum_spend = my_code.minimum_spend
        
        self.visibility_type = my_code.is_public ? "Friends" : "Private"
        self.isPublic = my_code.is_public
        
        self.notes = my_code.notes
        
        self.imessage_autofill = my_code.imessage_autofill
        
    }
    
    func updateMyCode() {
        
        if imessage_autofill == "" {
            if code_or_link_selected == "Link" {
                imessage_autofill = code
            } else {
                imessage_autofill = "Use my code \(code) at \(brand_name)"
            }
        }
        
        if visibility_type == "Friends" {
            isPublic = false
        } else {
            isPublic = true
        }
        
        referral_codes_vm.updateMyReferralCode(brand_id: brand_id, brand_name: brand_name, code: (code_or_link_selected == "Code" ? code : ""), commission_type: commission_type, commission_value: commission_value, expiration: Int(round(expiration.timeIntervalSince1970)), for_new_customers_only: for_new_customers_only, imessage_autofill: imessage_autofill, is_public: isPublic, minimum_spend: minimum_spend, notes: notes, link: (code_or_link_selected == "Link" ? code : ""), offer_type: offer_type, offer_value: offer_value, product_ids: [], referral_code_id: referral_code_id, user_id: users_vm.one_user.user_id)
        
        
    }

    
    
    
    var editCodeHeader: some View {

        HStack (alignment: .center) {
            
            Button {

                updateMyCode()
                dismiss()

            } label: {

                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Background"))
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                }
            }
            
            Spacer()
            Text("\(brand_name)")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.leading, 40)
            Spacer()
            
            
            ShareViaIMessageButton(share_imessage_autofill: imessage_autofill, share_offer_type: offer_type, share_offer_value: offer_value)
            
//            Button {
//
//                updateMyCode()
//                //dismiss the sheet
//                dismiss()
//
//            } label: {
//                ZStack(alignment: .center) {
//
//                    Capsule()
//                        .foregroundColor(canAddCode ? Color.blue : Color.gray)
//                        .frame(width: 80, height: 32)
//                    Text("Update")
//                        .font(.system(size: 16, weight: .semibold, design: .rounded))
//                        .foregroundColor(Color.white)
//                }
//            }.disabled(!canAddCode)
            
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
}


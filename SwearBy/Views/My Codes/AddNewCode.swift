//
//  AddNewCode.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI


enum RewardType: String, CaseIterable, Identifiable {
    case cash, giftcard, discount_percentage, discount, points
    var id: Self { self }
}

enum DiscountType: String, CaseIterable, Identifiable {
    case cash, percentage
    var id: Self { self }
}

// DO IT WITH AN HSTACK INSTEAD!
// https://stackoverflow.com/questions/60427656/add-a-prefix-to-textfield-in-swiftui

struct TextFieldValueModifer: ViewModifier {
    @Binding var value_formatted: String
    @Binding var value: String
    @Binding var value_type: String

    func body(content: Content) -> some View {
        content
            .onReceive(value_formatted.publisher.collect()) {

                print(String($0))
                print(value_formatted)
                print(value)
                
                if (String($0) == "") {
                    value = ""
                    value_formatted = ""
                } else {
                    
                    if (value_type == "Discount (%)") {
                        
                        if String($0).filter("%".contains).count == 0 {
                            let num_only = String($0).filter("0123456789.".contains).count
                            
                            if num_only == 0 {
                                
                                value_formatted = ""
                                value = ""
                                
                            } else {
                                
                                value = String(String($0).filter("0123456789.".contains).prefix(1))
                                value_formatted = String(String($0).filter("0123456789.".contains).prefix(1) + "%")
                            }
                            
                            
                        } else {
                            value = String(String($0).filter("0123456789.".contains))
                            value_formatted = value + "%"
                        }
                        
                    } else if (value_type == "Points") {
                        value_formatted = value + " pts"
                    } else {
                        value_formatted = "$" + value
                    }
                    
                    
                    
                    
                    
                    
//                    let new_length = String($0).count            // LENGTH OF CURRENT STRING GOTTEN FROM TEXTFIELD... 1    1%1   12    12
//                    let old_length = value.count + 1            // RELEVANT ONLY FOR % AND $... OTHERWISE NEEDS TO BE 4
//
//                    if old_length > new_length {
//
//                        let current_number_value = String($0).filter("0123456789.".contains)
//
//                        let new_number_value = current_number_value.prefix(new_length)
//
//                        value = new_number_value.filter("0123456789.".contains)
//
//                        value_formatted = value + "%"
//
//                    } else {
//
//                        value = String($0).filter("0123456789.".contains)
//
//                        if (value_type == "Discount (%)") {
//
//                            value_formatted = value + "%"
//
//                        } else if (value_type == "Points") {
//                            value_formatted = value + " pts"
//                        } else {
//                            value_formatted = "$" + value
//                        }
//                    }
                    
                }
            }
    }
}

extension View {
    func formatValue(value_formatted: Binding<String>, value: Binding<String>, value_type: Binding<String>) -> some View {
        self.modifier(TextFieldValueModifer(value_formatted: value_formatted, value: value, value_type: value_type))
    }
}




struct AddNewCode: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var users_vm: UsersVM
    @ObservedObject var preloaded_referral_programs_vm: PreloadedReferralProgramVM
    @State var addNewCodeSheetPresented: AddNewCodeSheetPresented? = nil
    @State private var path = NavigationPath()
    
    
    // Pass in any of the Preloaded Code Variables if available, or leave them blank
            // selected_brand
            // preloaded_referral_code
            //
    
    @Binding var preloaded_referral_program:PreloadedReferralPrograms  // = EmptyVariables().empty_preloaded_referral_program
    
    // Preloaded code variables
    @State var isPreloadedCode:Bool = false
    @State var setup_link:String = ""
    @State var steps:SetupReferralSteps = SetupReferralSteps(one: "", two: "", three: "")
    
    // Regular variables
    @State var brand_id:String = ""
    @State var brand_name:String = ""
    
    @State private var code_or_link_options:[String] = ["Code", "Link"]
    @State var code_or_link_selected:String = "Code"                                                                        //DETERMINE WHETHER TO FILL IN CODE OR LINK
    @State var code:String = ""                                                                                             //CODE OR LINK
    
    @State private var commission_options:[String] = ["None", "Cash", "Gift Card", "Discount ($)", "Discount (%)", "Points"]
    @State var commission_available:Bool = true
    @State var commission_type:String = "None"
    @State var commission_value:String = ""
    
    @State private var offer_options:[String] = ["None", "Cash", "Gift Card", "Discount ($)", "Discount (%)", "Points"]
    @State var discount_available:Bool = false
    @State var offer_type:String = "Discount (%)"
    @State var offer_value:String = ""
    
    @State var has_expiration:Bool = false
    @State var expiration = Date()
    
    @State var for_new_customers_only:Bool = false
    
    @State var minimum_spend_required:Bool = false
    @State var minimum_spend:String = ""
    
    @State private var isPublic = false
    
    @State private var notes = ""
    
    @State private var imessage_autofill = ""
    
    
    // ---------
    @State private var private_mini_brandURL: String = ""
    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                addNewCodeHeader
                    
                Form {
                    
                    Section {
                        Button {
                            
                            addNewCodeSheetPresented = .add_brand
                            
                                /////////////  --- ------------- ------------------------------------------------------------------------------ NOTE MUST RESET ALL THE VARIABLES WHEN LOOKING FOR A NEW BRAND
                        } label: {
                            
                            if brand_name == "" {
                                Text("Select a brand")
                                    //.font(.system(design: .rounded))
                                    .foregroundColor(Color("text.gray"))
                            } else {
                                brandAndLogoRow
                            }
                        }
                    
                    }
                    
                    
                    Section {
                        TextField("Paste referral code or link", text: $code)
                            .foregroundColor(Color("text.black"))
                            .multilineTextAlignment(.leading)
                            .keyboardType(.default)
                            .submitLabel(.done)
                        Picker("Type", selection: $code_or_link_selected) {
                            ForEach(code_or_link_options, id: \.self) { option in
                                Text(option)
                            }
                        }
                        if setup_link != "" {
                            
                            HowToGetReferralCode(setup_link: $setup_link, steps: $steps, brand_name: brand_name)
                            
//                            Button {
//                                addNewCodeSheetPresented = .follow_setup_steps
//                            } label: {
//                                Text("Find your \(selected_brand.name) code")
//                            }
                        }
                    }


                    Section(header: Text("For You"), footer: (commission_type != "None") ? Text("Your commission is always private.") : Text("")) {
                        
                        Picker("Commission", selection: $commission_type.animation(.easeInOut)) {
                            ForEach(commission_options, id: \.self) { option in
                                Text(option)
                            }
                        }
                        
                        if commission_type != "None" {
                                
                            HStack {
                                Text("Value")
                                
                                HStack(alignment: .center, spacing: 0) {
                            
                                
                                    ZStack(alignment: .trailing) {
                                        TextField("0", text: $commission_value)
                                            .foregroundColor(Color("text.black"))
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.numbersAndPunctuation)
                                            .submitLabel(.done)
                                        if ((commission_type == "Cash") || (commission_type == "Gift Card") || (commission_type == "Discount ($)")) {
                                            HStack(alignment: .center, spacing: 0) {
                                                Text("$")
                                                    .foregroundColor(commission_value == "" ? Color("text.gray").opacity(0.8) : Color("text.black"))
                                                Text(commission_value == "" ? "0" : commission_value)
                                                    .foregroundColor(commission_value == "" ? Color.clear : Color("text.black"))
                                            }
                                        }
                                    }
                                    
                                    if ((commission_type == "Points")) {
                                        Text(" points")
                                            .foregroundColor(Color(commission_value == "" ? "text.gray" : "text.black"))
                                    }
                                    
                                    if ((commission_type == "Discount (%)")) {
                                        Text("%")
                                            .foregroundColor(Color(commission_value == "" ? "text.gray" : "text.black"))
                                    }
                                }
                            }
                        }
                    }
                    
                    if commission_available {
                        
                        Section {
                            
//                            Toggle("NEW Available", isOn: $discount_available.animation(.easeInOut))
//                                .toggleStyle(SwitchToggleStyle())
                            HStack(alignment: .center, spacing: 0) {
                                
                                Text("Select a brand")
                                    //.font(.system(design: .rounded))
                                    .foregroundColor(Color("text.black"))
                                
                                Spacer()
                                
                                Text(brand_name == "" ? "None" : brand_name)
                                    .foregroundColor(brand_name == "" ? Color("text.gray") : Color("text.black"))
                                    .padding(.trailing, 8)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("text.gray"))
                                
                            }
                            
                            
                            Picker("Commission Type", selection: $commission_type) {
                                ForEach(commission_options, id: \.self) { option in
                                    Text(option)
                                }
                            }.onTapGesture {
                                addNewCodeSheetPresented = .add_brand
                            }
                            
                        }
                    }
                    
                    
                    Section(header: Text("Your Friend's Offer"), footer: discount_available ? Text("You can share details of this offer with your friend.") : Text("No offer available")) {
                        Toggle("Offer Available", isOn: $discount_available.animation(.easeInOut))
                            .toggleStyle(SwitchToggleStyle())
                        
                        if discount_available {
                            
                            //Type
                            Picker("Offer Type", selection: $offer_type) {
                                ForEach(offer_options, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            
                            //Value
                            HStack {
                                Text("Offer Value")
                                Spacer()
                                TextField("Amount", text: $offer_value)
                                    .foregroundColor(Color("text.black"))
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numbersAndPunctuation)
                                    .submitLabel(.done)
                            }
                            
                            //Expires
                            Toggle("Offer Expires", isOn: $has_expiration.animation(.easeInOut))
                                .toggleStyle(SwitchToggleStyle())
                            if has_expiration {
                                DatePicker("Expires on", selection: $expiration, displayedComponents: .date)
                            }
                            
                            // Minimum Spend
                            Toggle("Minimum Spend Required", isOn: $minimum_spend_required.animation(.easeInOut))
                                .toggleStyle(SwitchToggleStyle())
                            if minimum_spend_required {
                                TextField("Amount ($)", text: $minimum_spend)
                                    .foregroundColor(Color("text.black"))
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numbersAndPunctuation)
                                    .submitLabel(.done)
                            }
                            
                            // New Customers Only?
                            Toggle("For New Customers Only", isOn: $for_new_customers_only)
                                .toggleStyle(SwitchToggleStyle())
                            
                            
                            
                        }
                    }
                    
                    
                    Section(header: Text("Set Sharing Preferences"), footer: isPublic ? Text("Private. Your friends will not be able to see this discount code until you add it to a post.") : Text("Available to friends. Your friends can look up this code and see their offer. Your commission is private.")) {
                        Toggle("Available to Friends", isOn: $isPublic)
                            .toggleStyle(SwitchToggleStyle())
                        }
                    
                    Section(header: Text("Your pre-filled iMessage text"), footer: Text("We will pre-fill this message for you in iMessage when requested. We never send messages to your friends.")) {
                        TextField("Hey, use \(code) for a discount ...", text: $imessage_autofill)
                            .foregroundColor(Color("text.black"))
                            .multilineTextAlignment(.leading)
                            .frame(height: 60, alignment: .topLeading)
                            .keyboardType(.default)
                            .submitLabel(.done)
                    }
                    
                    Section(header: Text("Additional Notes")) {
                        TextField("Add notes about this offer", text: $notes)
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
            .fullScreenCover(item: $addNewCodeSheetPresented, onDismiss: { addNewCodeSheetPresented = nil }) { [preloaded_referral_program, setup_link, steps] sheet in
                
                switch sheet {        //add_brand, follow_setup_steps
                case .add_brand:
                    SelectBrand(preloaded_referral_programs_vm: preloaded_referral_programs_vm, preloaded_referral_program: $preloaded_referral_program)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                case .follow_setup_steps:
                    SetupSteps(setup_link: $setup_link, steps: $steps)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                default:
                    SelectBrand(preloaded_referral_programs_vm: preloaded_referral_programs_vm, preloaded_referral_program: $preloaded_referral_program)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
//            .sheet(isPresented: $isPreloadedCode, content: {
//                ThrowawaySheet()
//            })
            .onAppear {
                
                if preloaded_referral_program.brand_id != "" {
                    
                    loadVariablesForPreloadedCode()
                    
                }
                   
            }
            .onChange(of: preloaded_referral_program) { new_preloaded_referral_program in
                
                if preloaded_referral_program.brand_id != "" {
                    
                    loadVariablesForPreloadedCode()
                    
                }
                
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
    
    
    func loadVariablesForPreloadedCode() {
        
        // Preloaded code variables
        self.isPreloadedCode = true
        self.setup_link = preloaded_referral_program.link_for_setup
        self.steps = preloaded_referral_program.steps

        self.brand_id = preloaded_referral_program.brand_id
        self.brand_name = preloaded_referral_program.brand_name
        
        self.code_or_link_selected = preloaded_referral_program.link != "" ? "Link" : "Code"
        
        self.commission_available = preloaded_referral_program.commission_type != ""
        self.commission_type = preloaded_referral_program.commission_type
        self.commission_value = preloaded_referral_program.commission_value

        self.discount_available = preloaded_referral_program.offer_type != ""
        self.offer_type = preloaded_referral_program.offer_type
        self.offer_value = preloaded_referral_program.offer_value

        self.has_expiration = preloaded_referral_program.expiration > 0
        self.expiration = preloaded_referral_program.expiration > 0 ? Date(timeIntervalSince1970: Double(preloaded_referral_program.expiration)) : Date()

        self.for_new_customers_only = preloaded_referral_program.for_new_customers_only

        self.minimum_spend_required = preloaded_referral_program.minimum_spend != ""
        self.minimum_spend = preloaded_referral_program.minimum_spend

    }
    
    
    func resetVariablesForPreloadedCode() {
        
        preloaded_referral_program = EmptyVariables().empty_preloaded_referral_program
        
        // Preloaded code variables
        self.isPreloadedCode = false
        self.setup_link = ""
        self.steps = SetupReferralSteps(one: "", two: "", three: "")

        self.brand_id = ""
        self.brand_name = ""
        
        self.code_or_link_selected = "Code"
        
        self.commission_available = true
        self.commission_type = "None"
        self.commission_value = ""

        self.discount_available = false
        self.offer_type = "None"
        self.offer_value = ""

        self.has_expiration = false
        self.expiration = Date()

        self.for_new_customers_only = false

        self.minimum_spend_required = false
        self.minimum_spend = ""

    }
    
    
    
    
    var addNewCodeHeader: some View {

        HStack (alignment: .center) {
            
            Button {

                resetVariablesForPreloadedCode()
                dismiss()

            } label: {

                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Background"))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("text.black"))
                }
            }
            
            Spacer()
            Text("Add New Code")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.leading, 40)
            Spacer()
            
            
            let canAddCode = ((brand_id != "") && (code != ""))
            
            Button {
                
                // upload the new code
                
                if imessage_autofill == "" {
                    if code_or_link_selected == "Link" {
                        imessage_autofill = code
                    } else {
                        imessage_autofill = "Use my code \(code) at \(brand_name)"
                    }
                }
                
                let referral_code_id = UUID().uuidString
                
                ReferralCodesVM().createNewReferralCode(brand_id: brand_id, brand_name: brand_name, code: (code_or_link_selected == "Code" ? code : ""), commission_type: commission_type, commission_value: commission_value, expiration: Int(round(expiration.timeIntervalSince1970)), for_new_customers_only: for_new_customers_only, imessage_autofill: imessage_autofill, is_public: isPublic, minimum_spend: minimum_spend, notes: notes, link: (code_or_link_selected == "Link" ? code : ""), offer_type: offer_type, offer_value: offer_value, product_ids: [], referral_code_id: referral_code_id, user_id: users_vm.one_user.user_id)
                
                // reset the variables
                resetVariablesForPreloadedCode()
                
                //dismiss the sheet
                dismiss()
                
            } label: {
                ZStack(alignment: .center) {
                    
                    Capsule()
                        .foregroundColor(canAddCode ? Color.blue : Color.gray)
                        .frame(width: 80, height: 32)
                    Text("Add")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                }
            }.disabled(!canAddCode)
            
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
}



struct HowToGetReferralCode: View {
    
    @State private var isPresentingModal:Bool = false
    
    @Binding var setup_link: String
    @Binding var steps: SetupReferralSteps
    
    var brand_name: String
    
    var body: some View {
        
        VStack(spacing: 0) {
            Button {
                isPresentingModal = true
            } label: {
                Text(brand_name != "" ? "Find your \(brand_name) code" : "Find your code")
            }
        }
        .sheet(isPresented: $isPresentingModal) {
            SetupSteps(setup_link: $setup_link, steps: $steps)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

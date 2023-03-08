//
//  AddNewCode.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI



enum RewardType: String, CaseIterable, Identifiable {
    case cash, giftcard, discount_percentage, discount, points
    var id: Self { self }
}

enum DiscountType: String, CaseIterable, Identifiable {
    case cash, percentage
    var id: Self { self }
}

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
    @State var addNewCodeSheetPresented: AddNewCodeSheetPresented? = nil
    @State private var path = NavigationPath()
    
    @State var new_referral_code = EmptyVariables().empty_referral_code
    
    // Pass in any of the Preloaded Code Variables if available, or leave them blank
            // selected_brand
            // preloaded_referral_code
            //
    
    // Preloaded code variables
    @State var isPreloadedCode:Bool = false
    @State var setup_link:String = ""
    @State var steps:SetupReferralSteps = SetupReferralSteps(one: "", two: "", three: "")
    
    // Regular variables
    @State var selected_brand:Brands = EmptyVariables().empty_brand                                                         //PRE-FILL OR FILL IN THE BRAND PICKER
    
    @State private var code_or_link_options:[String] = ["Code", "Link"]
    @State var code_or_link_selected:String = "Code"                                                                        //DETERMINE WHETHER TO FILL IN CODE OR LINK
    @State var code:String = ""                                                                                             //CODE OR LINK
    
    @State private var commission_options:[String] = ["Cash", "Gift Card", "Discount ($)", "Discount (%)", "Points"]
    @State var commission_available:Bool = true
    @State var commission_type:String = "Cash"
    @State var commission_value:String = ""
    
    @State private var offer_options:[String] = ["Cash", "Gift Card", "Discount ($)", "Discount (%)", "Points"]
    @State var discount_available:Bool = true
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
                            
                            if selected_brand.name == "" {
                                Text("Select a brand")
                                    //.font(.system(design: .rounded))
                                    .foregroundColor(Color("text.gray"))
                            } else {
                                Text(selected_brand.name)
                                    //.font(.system(design: .rounded))
                                    .foregroundColor(Color("text.black"))
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
                        if isPreloadedCode {
                            Button {
                                addNewCodeSheetPresented = .follow_setup_steps
                            } label: {
                                Text("Find your \(selected_brand.name) code")
                            }
                        }
                    }


                    Section(header: Text("Your Commission"), footer: commission_available ? Text("Add your commission to keep track of your incentives. Your commission is always private.") : Text("No commission available")) {
                        Toggle("Commission Available", isOn: $commission_available.animation(.easeInOut))
                            .toggleStyle(SwitchToggleStyle())
                        
                        if commission_available {
                                
                            Picker("Commission Type", selection: $commission_type) {
                                ForEach(commission_options, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            HStack {
                                Text("Commission Value")
                                Spacer()
                                TextField("Amount", text: $commission_value)
                                    .foregroundColor(Color("text.black"))
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numbersAndPunctuation)
                                    .submitLabel(.done)
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
            .fullScreenCover(item: $addNewCodeSheetPresented, onDismiss: { addNewCodeSheetPresented = nil }) { [selected_brand, setup_link, steps] sheet in
                
                switch sheet {        //add_brand, follow_setup_steps
                case .add_brand:
                    SelectBrand(selected_brand: $selected_brand, isPreloadedCode: $isPreloadedCode)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                case .follow_setup_steps:
                    SetupSteps(setup_link: $setup_link, steps: $steps)
                        .presentationDetents([.medium])
                default:
                    SelectBrand(selected_brand: $selected_brand, isPreloadedCode: $isPreloadedCode)
                }
            }
            .onAppear {
                
                if isPreloadedCode {
                    self.notes = "is preloaded code!!!"
                }
                   
            }
            .onChange(of: isPreloadedCode) { newValue in
                self.imessage_autofill = "CHANGED FROM THE FRONT "
            }
        }
        
    }
    
    var addNewCodeHeader: some View {

        HStack (alignment: .center) {
            
            Button {

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
            
            
            let canAddCode = ((selected_brand.brand_id != "") && (code != ""))
            
            Button {
                
                // upload the new code
                
                
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

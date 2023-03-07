//
//  AddNewCode.swift
//  SwearBy
//
//  Created by Colin Power on 3/7/23.
//

import SwiftUI



enum RewardType: String, CaseIterable, Identifiable {
    case cash, giftcard, discount, points
    var id: Self { self }
}

enum DiscountType: String, CaseIterable, Identifiable {
    case cash, percentage
    var id: Self { self }
}

struct TextFieldValueModifer: ViewModifier {
    @Binding var value: String

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {

                value = String($0).filter("0123456789.".contains)
                
            }
    }
}

extension View {
    func formatValue(value: Binding<String>) -> some View {
        self.modifier(TextFieldValueModifer(value: value))
    }
}




struct AddNewCode: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var users_vm: UsersVM
    @State var addNewCodeSheetPresented: AddNewCodeSheetPresented? = nil
    @State private var path = NavigationPath()
    
    @State private var new_referral_code = EmptyVariables().empty_referral_code
    @State private var selected_brand:Brands = EmptyVariables().empty_brand
    
    @State private var hasCode:Bool = true
    @State private var code:String = ""
    
    @State private var hasLink:Bool = true
    @State private var link:String = ""
    
    @State private var offers_commission:Bool = false
    @State private var commission_value:String = ""
    @State private var commission_type:RewardType = .cash
    @State private var commission_discount_type:DiscountType = .percentage
    @FocusState private var commission_value_focused:Bool
    
    @State private var offers_discount:Bool = false
    @State private var offer_value:String = ""
    @State private var offer_type:RewardType = .discount
    @State private var offer_discount_type:DiscountType = .percentage
    @FocusState private var offer_value_focused:Bool
    
    @State private var expiration = Date()
    @State private var for_new_customers_only:Bool = true
    
    @State private var product_ids:[String] = []
    
    @State private var caption = ""
    @State private var verifiedPurchase = ""
    @State private var sharePublicly = false
    
    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                addNewCodeHeader
                    
                Form {
                    
                    Section {
                        Button {
                            addNewCodeSheetPresented = .add_brand
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
                        TextField("Referral Code", text: $code)
                            .foregroundColor(Color("text.black"))
                            .multilineTextAlignment(.leading)
                            .keyboardType(.default)
                            .submitLabel(.done)
                        TextField("Referral Link", text: $link)
                            .foregroundColor(Color("text.black"))
                            .multilineTextAlignment(.leading)
                            .keyboardType(.default)
                            .submitLabel(.done)
                    }
                    
                    
                    
                    
                    
                    Section(footer: offers_commission ? Text("You'll receive \(commission_value) per referral") : Text("")) {
                        Toggle("Pays Commission", isOn: $offers_commission)
                            .toggleStyle(SwitchToggleStyle())
                        if offers_commission {
                            Picker("Commission Type", selection: $commission_type) {
                                Text("Cash").tag(RewardType.cash)
                                Text("Gift card").tag(RewardType.giftcard)
                                Text("Discount").tag(RewardType.discount)
                                Text("Points").tag(RewardType.points)
                            }
                            if commission_type == .discount {
                                Picker("Discount Type", selection: $commission_discount_type) {
                                    Text("In Dollars").tag(DiscountType.cash)
                                    Text("As a Percentage").tag(DiscountType.percentage)
                                }
                            }
                            HStack {
                                Text("Commission Value")
                                Spacer()
                                TextField("Amount", text: $commission_value)
                                    .formatValue(value: $commission_value)
                                    .foregroundColor(Color("text.black"))
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numbersAndPunctuation)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        commission_value_focused = false
                                    }
                            }
                        }
                    }
                    
                    
                    Section(footer: offers_discount ? Text("They'll receive \(offer_value) on their purchase") : Text("")) {
                        Toggle("Has Offer for Customer", isOn: $offers_discount)
                            .toggleStyle(SwitchToggleStyle())
                        if offers_discount {
                            Picker("Offer Type", selection: $offer_type) {
                                Text("Cash").tag(RewardType.cash)
                                Text("Gift card").tag(RewardType.giftcard)
                                Text("Discount").tag(RewardType.discount)
                                Text("Points").tag(RewardType.points)
                            }
                            if offer_type == .discount {
                                Picker("Offer Type", selection: $offer_discount_type) {
                                    Text("Cash").tag(DiscountType.cash)
                                    Text("Percent").tag(DiscountType.percentage)
                                }
                            }
                            HStack {
                                Text("Offer Value")
                                Spacer()
                                TextField("Amount", text: $offer_value)
                                    .formatValue(value: $offer_value)
                                    .foregroundColor(Color("text.black"))
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numbersAndPunctuation)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        offer_value_focused = false
                                    }
                            }
                        }
                    }
                    
//                    Section(header: Text("Verified Purchase")) {
//                        NavigationLink(destination: ThrowawaySheet()) {
//                            Text("Choose product")
//                        }
//                    }
//
//                    Section(header: Text("Visibility"), footer: sharePublicly ? Text("Everyone will be able to view your post") : Text("Only your followers will be able to see your post")) {
//                        Toggle("Share publicly", isOn: $sharePublicly)
//                            .toggleStyle(SwitchToggleStyle())
//                    }
//
//
//                    TextField("Why do you swear by this?", text: $caption)
//
                    
                    
                }.scrollContentBackground(.hidden)
                
                Spacer()
                    
                
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color("Background"))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $addNewCodeSheetPresented, onDismiss: { addNewCodeSheetPresented = nil }) { [selected_brand] sheet in
                
                switch sheet {        //add_brand, add_product
                case .add_brand:
                    SelectBrand(selected_brand: $selected_brand)
                case .add_product:
                    SelectBrand(selected_brand: $selected_brand)
                default:
                    SelectBrand(selected_brand: $selected_brand)
                }
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
            
            Button {
                
                // upload the new code
                
                //dismiss the sheet
                dismiss()
                
            } label: {
                ZStack(alignment: .center) {
                    
                    Capsule()
                        .foregroundColor(Color.blue)
                        .frame(width: 80, height: 32)
                    Text("Add")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                }
            }
            
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top, 60)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
}


//VStack {
//    Text("THE SELECTED BRAND IS...")
//    Text(selected_brand.name)
//}
//
//Button {
//    addNewCodeSheetPresented = .add_brand
//} label: {
//    Text("show the next sheet")
//}

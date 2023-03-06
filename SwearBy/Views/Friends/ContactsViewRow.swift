//
//  SwiftUIView.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//
import SwiftUI

struct ContactsViewRow: View {
    
    @Binding var isShowingContactsList:Bool
    @Binding var selectedContact:[String]
    
    var contactID:String
    var firstName:String
    var lastName:String
    var phone:String
    var randomColorGenerated:Color
    
    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0) {
            
            //The Circle + Letter for each contact
            ZStack(alignment: .center) {
                Circle().frame(width: 40, height: 40)
                    .foregroundColor(randomColorGenerated)
                Text(firstName.prefix(1))
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
            }
                .padding(.trailing, 16)
            
            //The first + last names and the phone number
            VStack(alignment: .leading, spacing: 0) {
                
                Text(firstName + " " + lastName)
                    .foregroundColor(Color("Dark1"))
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.bottom, 6)
                Text(phone)
                    .foregroundColor(Color("Gray1"))
                    .font(.system(size: 16, weight: .regular))
            }
            
            Spacer()
            
            Button {
                
                selectedContact = [contactID, firstName, lastName, phone]
            
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    isShowingContactsList.toggle()
                }
                
            } label: {
                Text(selectedContact[0] == contactID ? "Chosen" : "Choose")
                    .foregroundColor(selectedContact[0] == contactID ? Color("ThemeLight") : .white)
                    .font(.system(size: 14, weight: selectedContact[0] == contactID ? .semibold : .medium))
                    .frame(width: 80, height: 32)
                    .clipShape(Capsule())
                    .background(Capsule().foregroundColor(selectedContact[0] == contactID ? Color("ReferPurple") : Color("Gray2")))
            }
                                        
        }.padding(.vertical, 12)
        
    }
}


//
//  EnterPhone.swift
//  UncommonApp
//
//  Created by Colin Power on 12/15/22.
//

import Foundation
import SwiftUI


struct TextFieldPhoneNumberModifer: ViewModifier {
    @Binding var value: String

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                
                if value.count == 1 {
                    if String($0) != "(" {
                        value = "(" + String($0)
                    }
                } else if value.count == 5 {
                    if String($0[$0.index($0.startIndex, offsetBy: 4)]) != ")" {
                        value = String($0.prefix(4)) + ")" + String($0[$0.index($0.startIndex, offsetBy: 4)])
                    }
                } else if value.count == 6 {
                    if String($0[$0.index($0.startIndex, offsetBy: 5)]) != " " {
                        value = String($0.prefix(5)) + " " + String($0[$0.index($0.startIndex, offsetBy: 5)])
                    }
                } else if value.count == 10 {
                    if String($0[$0.index($0.startIndex, offsetBy: 9)]) != "-" {
                        value = String($0.prefix(9)) + "-" + String($0[$0.index($0.startIndex, offsetBy: 9)])
                    }
                }
            }
    }
}

extension View {
    func formatPhoneNumber(value: Binding<String>) -> some View {
        self.modifier(TextFieldPhoneNumberModifer(value: value))
    }
}

struct EnterPhone: View {
    
    @ObservedObject var users_vm: UsersVM
    @Binding var setuppath: NavigationPath
    
    @State var phone:String = ""
    @State var formattedPhoneNumber:String = ""
    @State var auth_phone_uuid: String = ""
    @FocusState private var isFocused: Bool
    
    var checkPhonePages: [CheckPhonePage] = [.init(screen: "CheckPhone", content: "")]
    
    var body: some View {
        ZStack(alignment: .top) {
        
            Color("Background").ignoresSafeArea()
        
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text("Enter your phone number")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top)
                
                //Subtitle
                Text("We use your phone number to find your friends and eligible referral programs.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.gray"))
                    .padding(.vertical)
                    .padding(.bottom)
                
                //Phone textfield
                TextField("Enter your phone number", text: $formattedPhoneNumber)
                    .formatPhoneNumber(value: $formattedPhoneNumber)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.black"))
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color("TextFieldGray")))
                    .onSubmit {
                        //usersViewModel.requestVerificationCode(phone: phoneNumber, codeExpiresInSeconds: 180, userID: userID, verificationID: verificationID)
                        //phoneNumber = "+1" + formattedPhoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
                    }
                    .focused($isFocused)
                    .submitLabel(.send)
                    .keyboardType(.numberPad)
                
             
            
                
                Spacer()
                
                //Continue button
                Button {
                    
                    //send verification code
                    auth_phone_uuid = UUID().uuidString
                    
                    phone = "+1" + formattedPhoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
                    
                    Auth_PhoneVM().requestOTP(user: users_vm.one_user, phone: phone, auth_phone_uuid: auth_phone_uuid)
                    
                    setuppath.append(checkPhonePages[0])
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Send Code")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(formattedPhoneNumber.isEmpty ? Color("text.gray") : Color.white)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor(formattedPhoneNumber == "" ? Color("TextFieldGray") : Color("UncommonRed")))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }.disabled(formattedPhoneNumber.isEmpty)
                
                
                //    CheckPhone(phoneNumber: $phoneNumber, newUUID: $newUUID)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationDestination(for: CheckPhonePage.self) { page in
            CheckPhone(users_vm: users_vm, setuppath: $setuppath, phone: $phone, auth_phone_uuid: $auth_phone_uuid)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                isFocused = true
            }
        }
    }
}

struct CheckPhonePage: Hashable {
    
    let screen: String
    let content: String
    
}

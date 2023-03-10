//
//  EnterEmailAndPassword.swift
//  SwearBy
//
//  Created by Colin Power on 3/9/23.
//



//if Auth.auth().isSignIn(withEmailLink: link) {
//    viewModel.passwordlessSignIn(email: email, link: link) { result in
//
//        switch result {
//
//        case let .success(user):
//            viewModel.listen(users_vm: users_vm)
//
//        case let .failure(error):
//            print("error with result of passwordlessSignIn function")
//            //alertItem = AlertItem(title: "An auth error occurred.", message: error.localizedDescription)
//        }
//    }
//}




import Foundation
import SwiftUI
import FirebaseFunctions

struct EnterEmailAndPassword: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @ObservedObject var users_vm: UsersVM
    
    @Binding var email: String
    @Binding var startpath: NavigationPath
    
    @State private var password: String = ""
    
    @FocusState private var emailFocused: Bool
    @FocusState private var passwordFocused: Bool
    
    @State private var tappedSignIn:Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text("Enter your email and password")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.top)
                    .padding(.vertical)
                    .padding(.bottom)
                
                //Email textfield
                TextField("", text: $email)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color.gray))
                    .onSubmit {
                        if !email.isEmpty {
                            
                            emailFocused = false
                            passwordFocused = true
                            
                        }
                    }
                    .focused($emailFocused)
                    .submitLabel(.done)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .padding(.bottom)
                
                
                //Password textfield
                TextField("", text: $password)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color.gray))
                    .onSubmit {
                        if !password.isEmpty {
                            
                            passwordFocused = false
                            
                        }
                    }
                    .focused($passwordFocused)
                    .submitLabel(.done)
                    .keyboardType(.default)
                    .disableAutocorrection(true)
                    .padding(.bottom)
                
                Spacer()
                
                //Continue button
                Button {
                    
                    tappedSignIn = true
                    
                    viewModel.signIn(email: email, password: password) { result in
                        
                        switch result {
                        
                        case let .success(user):
                            viewModel.listen(users_vm: users_vm)
                            
                        case let .failure(error):
                            print("error with result of passwordlessSignIn function")
                            //alertItem = AlertItem(title: "An auth error occurred.", message: error.localizedDescription)
                        }
                        
                    }
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        if tappedSignIn {
                            ProgressView()
                        } else {
                            Text("Sign In")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor((email.isEmpty || password.isEmpty) ? Color.gray : Color.white)
                                .padding(.vertical)
                        }
                        Spacer()
                    }
                    .background(Capsule().foregroundColor((email.isEmpty || password.isEmpty) ? Color.gray : Color.blue))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }.disabled((email.isEmpty || password.isEmpty))
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                emailFocused = true
            }
        }
    }
}

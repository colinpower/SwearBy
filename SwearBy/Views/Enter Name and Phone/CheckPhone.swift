//
//  CheckPhone.swift
//  UncommonApp
//
//  Created by Colin Power on 12/15/22.
//

import SwiftUI

struct CheckPhone: View {
    
    @ObservedObject var users_vm: UsersVM
    @Binding var setuppath: NavigationPath
    @Binding var phone: String
    @Binding var auth_phone_uuid: String
    
    static let codeDigits = 4
    @State
    var codeDict = Dictionary<Int, String>(uniqueKeysWithValues: (0..<codeDigits).map{ ($0, "") })
    // [0:"", 1:"", ..., 5:""]
    
    var code: String {
        codeDict.sorted(by: { $0.key < $1.key }).map(\.value).joined()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
        
            Color("Background").ignoresSafeArea()
        
            VStack(alignment: .leading, spacing: 0) {
                //Title
                Text("Enter One-Time Code")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                    .padding(.top)
                
                //Subtitle
                Text("Enter the code we sent to confirm your phone number.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color("text.gray"))
                    .padding(.vertical)
                    .padding(.bottom)
                
                
                OneTimeCodeBoxes(codeDict: $codeDict,
                                             onCommit: {
                                                print("onCommit", code)
                                             })
                                .onChange(of: codeDict, perform: { _ in })
                                .padding()
                                .padding(.horizontal)
                                .padding(.horizontal)
                                .padding(.horizontal)
             
            
                Spacer()
                
                //Continue button
                Button {
                    
                    Auth_PhoneVM().submitOTP(code: code, auth_phone_uuid: auth_phone_uuid)
                    
                } label: {
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Confirm Code")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(code == "" ? Color("text.gray") : Color.white)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(Capsule().foregroundColor(code == "" ? Color("TextFieldGray") : Color("UncommonRed")))
                    .padding(.horizontal)
                    .padding(.top).padding(.top).padding(.top)
                    
                }.disabled(code == "")
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                isFocused = true
//            }
//        }
    }
}






struct OneTimeCodeBoxes: View {
    
    @Binding var codeDict: [Int: String]
    @State var firstResponderIndex = 0
    var onCommit: (()->Void)?
    
    var body: some View {
        HStack {
            ForEach(0..<codeDict.count) { i in
                let isEmpty = codeDict[i]?.isEmpty == true
                
                OneTimeCodeInput(
                    index: i,
                    codeDict: $codeDict,
                    firstResponderIndex: $firstResponderIndex,
                    onCommit: onCommit
                )
                .aspectRatio(1, contentMode: .fit)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: isEmpty ? 1 : 2)
                            .foregroundColor(isEmpty ? .secondary : .green))
            }
        }
    }
}


struct OneTimeCodeInput: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    let index: Int
    @Binding var codeDict: [Int: String]
    @Binding var firstResponderIndex: Int
    var onCommit: (()->Void)?
    
    // MARK: - Internal Type
    
    class Coordinator: NSObject, UITextFieldDelegate {
        let index: Int
        @Binding var codeDict: [Int: String]
        @Binding var firstResponderIndex: Int
        
        private lazy var codeDigits: Int = codeDict.count
        
        init(index: Int, codeDict: Binding<[Int: String]>, firstResponderIndex: Binding<Int>) {
            self.index = index
            self._codeDict = codeDict
            self._firstResponderIndex = firstResponderIndex
        }
        
        @objc func textFieldEditingChanged(_ textField: UITextField) {
            print("textField.text!", textField.text!)
            
            guard textField.text!.count == codeDigits else { return }
            
            codeDict = textField.text!.enumerated().reduce(into: [Int: String](), { dict, tuple in
                let (index, char) = tuple
                dict.updateValue(String(char), forKey: index)
            })
            
            firstResponderIndex = codeDigits - 1
            
        }
        
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string1: String) -> Bool
        {
            print("replacementString", string1)
            
            // 3. deleting
            if string1.isBackspace {
                codeDict.updateValue("", forKey: index)
                firstResponderIndex = max(0, textField.text == "" ? index - 1 : index)
                return false
            }
            
            // 1. typing
            // 2. pasting
            for i in index..<min(codeDict.count, index + string1.count) {
                codeDict.updateValue(string1.stringAt(index: i - index), forKey: i)
//                print(codeDict)
                firstResponderIndex = min(codeDict.count - 1, index + string1.count)
            }
            
            
            return true
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        .init(index: index, codeDict: $codeDict, firstResponderIndex: $firstResponderIndex)
    }
    
    // MARK: - Required Methods
    
    func makeUIView(context: Context) -> UITextField {
        let tf = BackspaceTextField(onDelete: {
            firstResponderIndex = max(0, index - 1)
        })
        tf.addTarget(context.coordinator, action: #selector(Coordinator.textFieldEditingChanged), for: .editingChanged)
        tf.delegate = context.coordinator
        tf.keyboardType = .numberPad
        tf.textContentType = .oneTimeCode
        tf.font = .preferredFont(forTextStyle: .largeTitle)
        tf.textAlignment = .center
        return tf
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = codeDict[index]
        
        if index == firstResponderIndex {
            uiView.becomeFirstResponder()
        }
        
        if index == firstResponderIndex,
            codeDict.values.filter({ !$0.isEmpty }).count == codeDict.count
        {
            onCommit?()
        }
    }
    
}


// MARK: - Backspace Textfield
extension OneTimeCodeInput {
    
    
    class BackspaceTextField: UITextField {
        
        var onDelete: (()->Void)?
        
        init(onDelete: (()->Void)?) {
            self.onDelete = onDelete
            
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func deleteBackward() {
            super.deleteBackward()
            
            onDelete?()
        }
    }
    
}


extension String {
    
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    /// - returns: a string has only 1 character
    func stringAt(index: Int) -> String {
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[stringIndex])
    }
    
}

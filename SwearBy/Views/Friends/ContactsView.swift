//
//  ContactsView.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//
import Foundation
import SwiftUI

struct ContactsView: View {
    
    @StateObject var contactsVM = ContactsViewModel()
    
    @State var searchQuery = ""
    
    //@ObservedObject var filteredContacts = ContactsViewModel().contacts
    
    @State var filteredContacts: [Contact] = []

    
    @Binding var isShowingContactsList:Bool
    @Binding var selectedContact:[String]
    
    
    
    var body: some View {
        NavigationView {
            
            List {
                
                if searchQuery != "" {
                    
                    ForEach(contactsVM.contacts.filter {
                        ($0.firstName.hasPrefix(searchQuery) || $0.lastName.hasPrefix(searchQuery)) &&
                        ($0.firstName.prefix(1) != "#") &&
                        ($0.firstName.prefix(1) != " ")
                        
                    }) { contact in
                        
                        
                        //MARK: INDIVIDUAL CONTACTS VIEW
                        ContactsViewRow(isShowingContactsList: $isShowingContactsList, selectedContact: $selectedContact, contactID: contact.id, firstName: contact.firstName, lastName: contact.lastName, phone: contact.phone ?? "", randomColorGenerated: Color.randomColor(firstName: contact.firstName, lastName: contact.lastName))
                    }

                } else {
                    
                    ForEach(contactsVM.contacts.filter {
                        ($0.firstName.count > 0 &&
                         $0.lastName.count > 0 &&
                         $0.phone?.count ?? 0 > 0 &&
                         $0.firstName.prefix(1) != "#"
                        )
                        
                        }) { contact in
                        
                        //MARK: INDIVIDUAL CONTACTS VIEW
                        ContactsViewRow(isShowingContactsList: $isShowingContactsList, selectedContact: $selectedContact, contactID: contact.id, firstName: contact.firstName, lastName: contact.lastName, phone: contact.phone ?? "", randomColorGenerated: Color.randomColor(firstName: contact.firstName, lastName: contact.lastName))
                           
                    }
                }
                
                
                    
            }
            .edgesIgnoringSafeArea([.horizontal, .bottom])
            .navigationTitle("Contacts")
        }.searchable(text: $searchQuery, prompt: "Search by first name")
//            .onSubmit(of: .search, {
//                filterContacts()
//                })
        .alert(item: $contactsVM.permissionsError) { _ in
            Alert(
                title: Text("Permission denied"),
                message: Text(contactsVM.permissionsError?.description ?? "unknown error"),
                dismissButton:
                    .default(Text("OK"),
                            action: {contactsVM.openSettings() })
            )
        }
    }
//
//    func filterContacts() {
//      if searchQuery.isEmpty {
//        // 1
//        filteredContacts = contactsVM.contacts
//      } else {
//        // 2
//          filteredContacts = contactsVM.contacts.filter {
//          $0.firstName
//            .localizedCaseInsensitiveContains(searchQuery)
//        }
//      }
//    }

    
    
}


extension Color {
    static func randomColor(firstName: String, lastName: String) -> Color {
        
        let alphabet:String = "abcdefghijklmnopqrstuvwzyz"
        
        var lowercaseFirstName = firstName.lowercased()
        var lowercaseLastName = lastName.lowercased()
        
        if firstName.count < 4 {
            lowercaseFirstName = "colin"
        }
        
        if lastName.count < 4 {
            lowercaseLastName = "power"
        }
        
        let letter1 = lowercaseFirstName[lowercaseFirstName.index(lowercaseFirstName.startIndex, offsetBy: 0)]
        let letter2 = lowercaseFirstName[lowercaseFirstName.index(lowercaseFirstName.startIndex, offsetBy: 2)]
        let letter3 = lowercaseLastName[lowercaseLastName.index(lowercaseLastName.startIndex, offsetBy: 2)]
        
        print(letter1)
        print(letter2)
        print(letter3)
        
        var i1 = 0
        var j1 = 0
        var k1 = 0
        
        
        //MARK: GET INDICES
        if let i = alphabet.firstIndex(of: letter1) {
            i1 = i.utf16Offset(in: alphabet)
            
            //i1 = Double(i.utf16Offset(in: alphabet)) / Double(26)
        }
        
        if let j = alphabet.firstIndex(of: letter2) {
            j1 = j.utf16Offset(in: alphabet)
            
            //j1 = Double(j.utf16Offset(in: alphabet)) / Double(26)
        }
        
        if let k = alphabet.firstIndex(of: letter3) {
            k1 = k.utf16Offset(in: alphabet)
            
            //k1 = Double(k.utf16Offset(in: alphabet)) / Double(26)
        }
        
        
        //MARK: SET UP VARIABLES
        
        var i2 = Double(0.9)
        var j2 = Double(0.1)
        var k2 = Double(0.85)
        
        
        //MARK: SWITCH BASED ON 6 OPTIONS
        
        if j1 < 6 && k1 < 10 {
            i2 = Double(0.95) - (Double(i1) / Double(78))
            j2 = (Double(i1) / Double(78)) + Double(0.05)
            k2 = (Double(i1) / Double(78)) + Double(0.05)
            
        } else if j1 < 6 && k1 >= 10 {
            i2 = Double(0.95) - (Double(i1) / Double(78))
            j2 = Double(0.95) - (Double(i1) / Double(78))
            k2 = (Double(i1) / Double(78)) + Double(0.05)
            
        } else if j1 < 16 && k1 < 10 {
            i2 = (Double(i1) / Double(78)) + Double(0.05)
            j2 = (Double(i1) / Double(78)) + Double(0.05)
            k2 = Double(0.95) - (Double(i1) / Double(78))
            
        } else if j1 < 16 && k1 >= 10 {
            i2 = Double(0.95) - (Double(i1) / Double(78))
            j2 = Double(0.95) - (Double(i1) / Double(78))
            k2 = (Double(i1) / Double(78)) + Double(0.05)
            
        } else if j1 >= 16 && k1 < 10 {
            i2 = Double(0.95) - (Double(i1) / Double(78))
            j2 = (Double(i1) / Double(78)) + Double(0.05)
            k2 = Double(0.95) - (Double(i1) / Double(78))
            
        } else if j1 >= 16 && k1 >= 10 {
            i2 = (Double(i1) / Double(78)) + Double(0.05)
            j2 = Double(0.95) - (Double(i1) / Double(78))
            k2 = Double(0.95) - (Double(i1) / Double(78))
            
        }
                
        print(i2)
        print(j2)
        print(k2)

        return Color (
            red: .random(in: 0..<1),
            green: .random(in: 0..<1),
            blue: .random(in: 0..<1)
        )
        
    }
        
}


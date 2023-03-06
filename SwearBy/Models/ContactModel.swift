//
//  ContactModel.swift
//  SwearBy
//
//  Created by Colin Power on 3/6/23.
//
import Foundation
import Contacts

struct Contact: Identifiable {
    var id: String { contact.identifier}
    var firstName: String { contact.givenName }
    var lastName: String { contact.familyName }
    var phone: String? {contact.phoneNumbers.map(\.value).first?.stringValue }
    let contact: CNContact
    
    static func fetchAll(_ completion: @escaping(Result<[Contact], Error>) -> Void) {
        let containerID = CNContactStore().defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerID)
        let descriptor =
            [
                CNContactIdentifierKey,
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactPhoneNumbersKey
            ]
        as [CNKeyDescriptor]
        do {
            let rawContacts = try CNContactStore().unifiedContacts(matching: predicate, keysToFetch: descriptor)
            completion(.success(rawContacts.map { .init(contact: $0)}))
        } catch {
            completion(.failure(error))
        }
    }
}

enum PermissionsError: Identifiable {
    var id: String { UUID().uuidString }
    
    case userError
    case fetchError(_: Error)
    var description: String {
        switch self {
        case .userError:
            return "Please change permissions in settings."
        case .fetchError(let error):
            return error.localizedDescription
        }
    }
}

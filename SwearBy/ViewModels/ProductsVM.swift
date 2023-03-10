//
//  ProductsVM.swift
//  SwearBy
//
//  Created by Colin Power on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


class ProductsVM: ObservableObject, Identifiable {

    var dm = DataManager()
    private var db = Firestore.firestore()
    
    @Published var get_product_by_id = Products(name: "", link: "https://uncommon.app", brand_id: "", product_id: "")
    @Published var products_for_brand = [Products]()
    
    var products_for_brand_listener: ListenerRegistration!
        
    func getProductById(product_id: String) {
        
        let docRef = db.collection("products").document(product_id)

        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print("Error getting document: \(error)")
            }
            else {
                if let document = document {
                    do {
                        self.get_product_by_id = try document.data(as: Products.self)
                        print(self.get_product_by_id)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    //getAllProductsForBrandListener
    
    func listenForProductsForBrand(brand_id: String) {
    
        self.dm.getAllProductsForBrandListener(brand_id: brand_id, onSuccess: { (products) in

            self.products_for_brand = products

//            print("FOUND PRODUCTS")
//            print(self.products_for_brand)

        }, listener: { (listener) in
            self.products_for_brand_listener = listener
        })
    }

    
    
    func addProduct(brand_id: String, link: String, name: String, product_id: String) {
         
        db.collection("products").document(product_id).setData([
            "brand_id": brand_id,
            "link": link,
            "name": name,
            "product_id": product_id
        ]) { err in
            if let err = err {
                print("Error creating CODE: \(err)")
            } else {
                print("Other kind of error.. idk??")
            }
        }
    }
    
}

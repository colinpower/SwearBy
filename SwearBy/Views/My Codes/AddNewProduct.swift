//
//  AddNewProduct.swift
//  SwearBy
//
//  Created by Colin Power on 3/10/23.
//
import SwiftUI
import PhotosUI
import FirebaseStorage

struct AddNewProduct: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var brand_id: String
    
    @State private var name = ""
    
    @State private var link = ""
    
    @Binding var searchQuery:String
    
    //Properties for uploading image
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {

        VStack(spacing: 0) {
            
            addNewProductHeader
            
            Form {
                Section {
                    
                    Button {
                        showPicker.toggle()
                    } label: {
                        if let croppedImage{
                            HStack {
                                Image(uiImage: croppedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .frame(width: 100, height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.black))
                                Spacer()
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color("text.gray"))
                            }
                        } else {
                            ZStack(alignment: .center) {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color("TextFieldGray"))
                                    .frame(width: 100, height: 100)
                                    .shadow(radius: 4)
                                
                                VStack(alignment: .center, spacing: 0) {
                                    
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 120, height: 32)
                                    
                                    Spacer()
                                    
                                    Text("Add a high-quality product image")
                                        .font(.system(size: 12, weight: .regular, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .foregroundColor(Color("text.gray"))
                                    
                                    Spacer()
                                    Spacer()
                                    
                                    ZStack(alignment: .center) {
                                        
                                        Capsule()
                                            .foregroundColor(.blue)
                                            .frame(width: 120, height: 32)
                                        Text("Tap to add")
                                            .font(.system(size: 15, weight: .medium, design: .rounded))
                                            .foregroundColor(Color.white)
                                        
                                        
                                    }
                                }.padding(.horizontal).padding(.vertical)
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                    
                    
                }
                Section {
                    TextField("Product's name", text: $name)
                        .foregroundColor(Color("text.black"))
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .submitLabel(.done)
                }
                
                Section {
                    TextField("Link to product", text: $link)
                        .foregroundColor(Color("text.black"))
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .submitLabel(.done)
                    
                    Link(destination: URL(string: name != "" ? "https://www.google.com/search?q=" + name.replacingOccurrences(of: " ", with: "") : "https://www.google.com")!) {
                        Text(name != "" ? "Search Google for \(name)" : "Search Google")
                    }
                }
                
            }.scrollContentBackground(.hidden)
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color("Background"))
        .onAppear {
            self.name = searchQuery
        }
        .cropImagePicker(
            options: [.circle,.square,.rectangle,.custom(.init(width: 350, height: 450))],
            show: $showPicker,
            croppedImage: $croppedImage
        )
    }
    
    func uploadPhoto(product_id: String) {
        
        // Make sure that the selected image property isn't nil
        guard croppedImage != nil else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn our image into data
        let imageData = croppedImage!.pngData()
        
        //let imageData = croppedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            print("returned nil.. trying to do it as a png instead")

            return
        }
        
        //Specify the file path and name
        let fileRef = storageRef.child("product/\(product_id).png")             //let fileRef = storageRef.child("images/\(UUID().uuidstring).jpg")
        
        // Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                
                
                print("successfully uploaded")
                // TODO: Save a reference to the file in Firestore DB
                
                //PostViewModel().addPost(post_id: post_id, caption: caption, user_id: user_id)
                
            }
        }
    }
    
    
    
    var addNewProductHeader: some View {

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
            Text("Add New Product")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.leading, 40)
            Spacer()
            
            
            let canAddProduct = ((name != "") && (link != ""))
            
            Button {
                
                // create
                let product_id = UUID().uuidString
                
                // upload the new code
                ProductsVM().addProduct(brand_id: brand_id, link: link, name: name, product_id: product_id)
                
                // upload the image
                uploadPhoto(product_id: product_id)
                
                // add the brand's name to the search query on prior page
                searchQuery = name
                
                //dismiss the sheet
                dismiss()
                
            } label: {
                ZStack(alignment: .center) {
                    
                    Capsule()
                        .foregroundColor(canAddProduct ? Color.blue : Color.gray)
                        .frame(width: 80, height: 32)
                    Text("Add")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                }
            }.disabled(!canAddProduct)
            
        }
        .padding(.bottom, 4)
        .frame(height: 44)
        .padding(.top)
        .padding(.horizontal)
        .padding(.horizontal, 4)
    }
}

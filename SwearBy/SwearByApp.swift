//
//  SwearByApp.swift
//  SwearBy
//
//  Created by Colin Power on 2/23/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct SwearByApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        let viewModel = AppViewModel()
        
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

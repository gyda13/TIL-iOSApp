//
//  TILiOSApp.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import SwiftUI

@main
struct TILiOSApp: App {
    
    @StateObject
    var auth = Auth()
    
    
    var body: some Scene {
        WindowGroup {
          if auth.isLoggedIn {
             TabView {
               AcronymsView()
                 .tabItem {
                   Label("Acronyms", systemImage: "abc")
                 }
               UsersView()
                 .tabItem {
                   Label("Users", systemImage: "person.3.fill")
                 }
               CategoriesView()
                 .tabItem {
                   Label("Categories", systemImage: "tag.fill")
                 }
             }
             .environmentObject(auth)
           } else {
             LoginView().environmentObject(auth)
           }
         }
       }
    }


//
//  CreateUserView.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import SwiftUI

struct CreateUserView: View {
  @State var name = ""
  @State var username = ""
  @State var password = ""
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingUserSaveErrorAlert = false

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Name").textCase(.uppercase)) {
          TextField("Name", text: $name)
        }
        Section(header: Text("Username").textCase(.uppercase)) {
          TextField("Username", text: $username)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
        }
        Section(header: Text("Password").textCase(.uppercase)) {
          SecureField("Password", text: $password)
        }
      }
      .navigationBarTitle("Create User", displayMode: .inline)
      .navigationBarItems(
        leading:
          Button(
            action: {
              presentationMode.wrappedValue.dismiss()
            }, label: {
              Text("Cancel")
                .fontWeight(Font.Weight.regular)
            }),
        trailing:
          Button(action: saveUser) {
            Text("Save")
          }
          .disabled(name.isEmpty || username.isEmpty || password.isEmpty)
      )
    }
    .alert(isPresented: $showingUserSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the user"))
    }
  }

  func saveUser() {
      
      let createUser = CreateUserData(name: name, username: username, password: password)
      ResourceRequest<User>(resourcePath: "users").save(createUser, auth: auth) { result in
          switch result {
          case .failure:
              DispatchQueue.main.async {
                  self.showingUserSaveErrorAlert
              }
          case .success:
              DispatchQueue.main.async {
                  presentationMode.wrappedValue.dismiss()
              }
          }
          
      }
    
  }
}

struct CreateUserView_Previews: PreviewProvider {
  static var previews: some View {
    CreateUserView()
  }
}

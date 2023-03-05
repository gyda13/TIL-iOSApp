//
//  CreateCategoryView.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import SwiftUI

struct CreateCategoryView: View {
  @State var name = ""
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingCategorySaveErrorAlert = false

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Name").textCase(.uppercase)) {
          TextField("Name", text: $name)
        }
      }
      .navigationBarTitle("Create Category", displayMode: .inline)
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
          Button(action: saveCategory) {
            Text("Save")
          }
          .disabled(name.isEmpty)
      )
    }
    .alert(isPresented: $showingCategorySaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the category"))
    }
  }

  func saveCategory() {
  
     let category = Category(name: name)
      ResourceRequest<Category>(resourcePath: "categories").save(category, auth: auth) { result in
          switch result {
          case .failure:
              DispatchQueue.main.async {
                  self.showingCategorySaveErrorAlert
              }
          case .success:
              DispatchQueue.main.async {
                  presentationMode.wrappedValue.dismiss()
              }
          }
          
      }
      
  }
}

struct CreateCategoryView_Previews: PreviewProvider {
  static var previews: some View {
      CreateCategoryView()
  }
}

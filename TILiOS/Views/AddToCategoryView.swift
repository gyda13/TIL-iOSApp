//
//  AddToCategoryView.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import SwiftUI

struct AddToCategoryView: View {
  var acronym: Acronym
  @State var categories: [Category] = []
  @State var selectedCategories: [Category]
  @State private var showingCategoryErrorAlert = false
  @State private var showingAddCategoryToAcronymErrorAlert = false
  @EnvironmentObject var auth: Auth
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    List(categories, id: \.id) { category in
      HStack {
        Text(category.name)
          Spacer()
          if selectedCategories.contains(where: {$0.id == category.id}) {
              Image(systemName: "checkmark")
          }
      }
      .contentShape(Rectangle())
      .onTapGesture {
          guard let acronymID = acronym.id else {
              fatalError("Acronym did not have an id")
          }
          let acronymRequest = AcronymRequest(acronymID: acronymID)
          if !selectedCategories.contains(where: {$0.id == category.id}) {
              acronymRequest.add(category: category, auth: auth) { result in
                  switch result {
                  case .success:
                      DispatchQueue.main.async {
                          presentationMode.wrappedValue.dismiss()
                      }
                  case .failure:
                      DispatchQueue.main.async {
                          self.showingAddCategoryToAcronymErrorAlert = true
                      }
                  }
              }
          }
      }
    }
    .navigationTitle("Add To Category")
    .onAppear(perform: loadData)
    .alert(isPresented: $showingCategoryErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was an error getting the categories"))
    }
    .alert(isPresented: $showingAddCategoryToAcronymErrorAlert) {
      let message = """
        There was an error adding the acronym
        to the category
        """
      return Alert(title: Text("Error"), message: Text(message))
    }
  }

  func loadData() {
    
      let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
      categoriesRequest.getAll { result in
          switch result {
          case .failure:
              DispatchQueue.main.async {
                  self.showingCategoryErrorAlert = true
              }
          case .success(let categories):
              DispatchQueue.main.async {
                  self.categories = categories
              }
          }
          
      }
      
  }
}

struct AddToCategoryView_Previews: PreviewProvider {
  static var previews: some View {
    AddToCategoryView(
      acronym: dummyAcronyms[0],
      categories: dummyCategories,
      selectedCategories: Array(dummyCategories.prefix(1)))
  }
}

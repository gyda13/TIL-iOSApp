//
//  CategoriesView.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import SwiftUI

struct CategoriesView: View {
  @State private var showingSheet = false
  @State private var categories: [Category] = []
  @State private var showingCategoryErrorAlert = false

    let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
    
  var body: some View {
    NavigationView {
      List(categories, id: \.id) { category in
        Text(category.name)
          .font(.title2)
      }
      .navigationTitle("Categories")
      .toolbar {
        Button(
          action: {
            showingSheet.toggle()
          }, label: {
            Image(systemName: "plus")
          })
      }
    }
    .sheet(isPresented: $showingSheet) {
      CreateCategoryView()
        .onDisappear(perform: loadData)
    }
    .onAppear(perform: loadData)
    .alert(isPresented: $showingCategoryErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was an error getting the acronyms"))
    }
  }

  func loadData() {

      categoriesRequest.getAll{
          categoriesResult in
           switch  categoriesResult {
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

struct CategoriesView_Previews: PreviewProvider {
  static var previews: some View {
    CategoriesView()
  }
}

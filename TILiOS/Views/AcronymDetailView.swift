//
//  AcronymDetailView.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import SwiftUI

struct AcronymDetailView: View {
  var acronym: Acronym
  @State private var user: User?
  @State private var categories: [Category] = []
  @State private var short = ""
  @State private var long = ""
  @State private var showingSheet = false
  @State private var isShowingAddToCategoryView = false
  @State private var showingUserErrorAlert = false
  @State private var showingCategoriesErrorAlert = false
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    Form {
      Section(header: Text("Acronym").textCase(.uppercase)) {
        Text(acronym.short)
      }
      Section(header: Text("Meaning").textCase(.uppercase)) {
        Text(acronym.long)
      }
      if let user = user {
        Section(header: Text("User").textCase(.uppercase)) {
          Text(user.name)
        }
      }
      if !categories.isEmpty {
        Section(header: Text("Categories").textCase(.uppercase)) {
          List(categories, id: \.id) { category in
            Text(category.name)
          }
        }
      }
      Section {
        Button("Add To Category") {
          isShowingAddToCategoryView = true
        }
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      Button(
        action: {
          showingSheet.toggle()
        }, label: {
          Text("Edit")
        })
    }
    .sheet(isPresented: $showingSheet) {
      EditAcronymView(acronym: acronym)
    }
      NavigationLink(destination: AddToCategoryView(acronym: acronym, selectedCategories: self.categories), isActive: $isShowingAddToCategoryView) {
          EmptyView()
      }
    .onAppear(perform: getAcronymData)
    .alert(isPresented: $showingUserErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was an error getting the acronym's user"))
    }
    .alert(isPresented: $showingCategoriesErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was an error getting the acronym's categories"))
    }
  }

  func getAcronymData() {
      
      guard let id = acronym.id else {
          return
      }
      let acronymDetailRequester = AcronymRequest(acronymID: id)
      acronymDetailRequester.getUser { result in
          switch result {
          case .success(let user):
              DispatchQueue.main.async {
                  self.user = user
              }
          case .failure:
              DispatchQueue.main.async {
                  self.showingUserErrorAlert = true
              }
          }
      }
      
      acronymDetailRequester.getCategories { result in
          switch result {
          case .success(let categories):
              DispatchQueue.main.async {
                  self.categories = categories
              }
          case .failure:
              DispatchQueue.main.async {
                  self.showingCategoriesErrorAlert = true
              }
          }
      }
    }
  }


struct AcronymDetailView_Previews: PreviewProvider {
  static var previews: some View {
    let acronym = Acronym(short: "OMG", long: "Oh My God", userID: UUID())
    AcronymDetailView(acronym: acronym)
  }
}

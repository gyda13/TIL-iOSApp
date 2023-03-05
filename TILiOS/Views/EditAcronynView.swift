//
//  EditAcronynView.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import SwiftUI

struct EditAcronymView: View {
  var acronym: Acronym
  @State var short: String
  @State var long: String
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingAcronymSaveErrorAlert = false

  init(acronym: Acronym) {
    self.acronym = acronym
    _short = State(initialValue: acronym.short)
    _long = State(initialValue: acronym.long)
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Acronym").textCase(.uppercase)) {
          TextField("Acronym", text: $short)
        }
        Section(header: Text("Meaning").textCase(.uppercase)) {
          TextField("Meaning", text: $long)
        }
      }
      .navigationBarTitle("Edit Acronym", displayMode: .inline)
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
          Button(action: updateAcronym) {
            Text("Save")
          }
          .disabled(short.isEmpty || long.isEmpty)
      )
    }
    .alert(isPresented: $showingAcronymSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the acronym"))
    }
  }

  func updateAcronym() {
    let data = CreateAcronymData(short: self.short, long: self.long)
    guard let id = self.acronym.id else {
      fatalError("Acronym had no ID")
    }
    AcronymRequest(acronymID: id).update(with: data, auth: auth) { result in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self.showingAcronymSaveErrorAlert = true
        }
      case .success(_):
        DispatchQueue.main.async {
          self.acronym.short = self.short
          self.acronym.long = self.long
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

struct EditAcronymView_Previews: PreviewProvider {
  static var previews: some View {
    EditAcronymView(acronym: dummyAcronyms[0])
  }
}

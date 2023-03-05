//
//  CreateAcronymView.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import SwiftUI

struct CreateAcronymView: View {
  @State var short = ""
  @State var long = ""
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingAcronymSaveErrorAlert = false

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Acronym").textCase(.uppercase)) {
          TextField("Acronym", text: $short)
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
        }
        Section(header: Text("Meaning").textCase(.uppercase)) {
          TextField("Meaning", text: $long)
            .autocapitalization(.words)
        }
      }
      .navigationBarTitle("Create Acronym", displayMode: .inline)
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
          Button(action: saveAcronym) {
            Text("Save")
          }
          .disabled(short.isEmpty || long.isEmpty)
      )
    }
    .alert(isPresented: $showingAcronymSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the acronym"))
    }
  }

  func saveAcronym() {
    
      let acronymSaveData = CreateAcronymData(short: short, long: long)
      ResourceRequest<Acronym>(resourcePath: "acronym").save(acronymSaveData, auth: auth) { result in
          switch result {
          case .failure:
              DispatchQueue.main.async {
                  self.showingAcronymSaveErrorAlert
              }
          case .success:
              DispatchQueue.main.async {
                  presentationMode.wrappedValue.dismiss()
              }
          }
          
      }
  }
}

struct CreateAcronymView_Previews: PreviewProvider {
  static var previews: some View {
    CreateAcronymView()
  }
}

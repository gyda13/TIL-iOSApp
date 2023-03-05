//
//  AcronymsView.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import SwiftUI

struct AcronymsView: View {
  @State private var showingSheet = false
  @State private var showingAcronymErrorAlert = false
  @EnvironmentObject var auth: Auth
    @State private var acronyms: [Acronym] = []
    
    let acronymsRequest = ResourceRequest<Acronym>(resourcePath: "acronym")
  var body: some View {
    NavigationView {
      List {
          ForEach(acronyms, id: \.id){
              acronym in
              NavigationLink(destination: AcronymDetailView(acronym: acronym).onDisappear(perform: loadData)) {
                  VStack(alignment: .leading){
                      Text(acronym.short).font(.title2)
                      Text(acronym.long).font(.title2)
                  }
              }
          }
          .onDelete(perform: {IndexSet in
              for index in IndexSet {
                  if let id = acronyms[index].id {
                      let acronymDetailRequester = AcronymRequest(acronymID: id)
                      acronymDetailRequester.delete(auth: auth)
                  }
              }
              acronyms.remove(atOffsets: IndexSet)
          })
                
      }
      .navigationTitle("Acronyms")
      .toolbar {
        Button(
          action: {
            showingSheet.toggle()
          }, label: {
            Image(systemName: "plus")
          })
      }
    }
    .modifier(ResponsiveNavigationStyle())
    .sheet(isPresented: $showingSheet) {
      CreateAcronymView()
        .onDisappear(perform: loadData)
    }
    .onAppear(perform: loadData)
    .alert(isPresented: $showingAcronymErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was an error getting the acronyms"))
    }
  }
  
  func loadData() {
      acronymsRequest.getAll{
          acronymsRequest in
          switch acronymsRequest {
          case .failure:
              DispatchQueue.main.async {
                  self.showingAcronymErrorAlert = true
              }
          case .success(let acronyms):
              DispatchQueue.main.async {
                  self.acronyms = acronyms
              }

          }
      }
  }
}

struct AcronymsView_Previews: PreviewProvider {
  static var previews: some View {
    AcronymsView()
  }
}

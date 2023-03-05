//
//  CreateAcronymData.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import Foundation

struct CreateAcronymData: Codable {
  let short: String
  let long: String
}

extension Acronym {
  func toCreateData() -> CreateAcronymData {
    CreateAcronymData(short: self.short, long: self.long)
  }
}

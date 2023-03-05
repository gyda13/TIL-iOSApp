//
//  Acronym.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Foundation

final class Acronym: Codable {
  var id: UUID?
  var short: String
  var long: String
  var user: AcronymUser

  init(id: UUID? = nil, short: String, long: String, userID: UUID) {
    self.id = id
    self.short = short
    self.long = long
    let user = AcronymUser(id: userID)
    self.user = user
  }
}

final class AcronymUser: Codable {
  var id: UUID

  init(id: UUID) {
    self.id = id
  }
}

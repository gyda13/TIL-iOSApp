//
//  CreateUserData.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Foundation

final class CreateUserData: Codable {
  var id: UUID?
  var name: String
  var username: String
  var password: String?

  init(name: String, username: String, password: String) {
    self.name = name
    self.username = username
    self.password = password
  }
}

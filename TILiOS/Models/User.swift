//
//  User.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import Foundation

final class User: Codable, Identifiable {
  var id: UUID?
  var name: String
  var username: String

  init(id: UUID? = nil, name: String, username: String) {
    self.id = id
    self.name = name
    self.username = username
  }
}

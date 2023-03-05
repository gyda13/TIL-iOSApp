//
//  Category.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Foundation

final class Category: Codable, Identifiable {
  var id: UUID?
  var name: String

  init(id: UUID? = nil, name: String) {
    self.id = id
    self.name = name
  }
}

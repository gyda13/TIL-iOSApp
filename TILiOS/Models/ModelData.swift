//
//  ModelData.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import Foundation

var dummyUsers: [User] = [
  User(name: "Tim", username: "timc"),
  User(name: "Alice", username: "alice"),
  User(name: "Bob", username: "bob")
]

var dummyCategories: [Category] = [
  Category(name: "Teenager"),
  Category(name: "Funny")
]

var dummyAcronyms: [Acronym] = [
  Acronym(short: "OMG", long: "Oh My God", userID: dummyUsers.first?.id ?? UUID()),
  Acronym(short: "IKR", long: "I Know Right", userID: dummyUsers.first?.id ?? UUID())
]

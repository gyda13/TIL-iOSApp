//
//  AcronymRequest.swift
//  TILiOS
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import Foundation

struct AcronymRequest {
  let resource: URL

  init(acronymID: UUID) {
    let resourceString = "http://localhost:8080/api/acronym/\(acronymID)"
    guard let resourceURL = URL(string: resourceString) else {
      fatalError("Unable to createURL")
    }
    self.resource = resourceURL
  }

  func update(
    with updateData: CreateAcronymData,
    auth: Auth,
    completion: @escaping (Result<Acronym, ResourceRequestError>) -> Void
  ) {
    do {
      guard let token = auth.token else {
        auth.logout()
        return
      }
      var urlRequest = URLRequest(url: resource)
      urlRequest.httpMethod = "PUT"
      urlRequest.httpBody = try JSONEncoder().encode(updateData)
      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
      urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
        guard let httpResponse = response as? HTTPURLResponse else {
          completion(.failure(.noData))
          return
        }
        guard
          httpResponse.statusCode == 200,
          let jsonData = data
        else {
          if httpResponse.statusCode == 401 {
            auth.logout()
          }
          completion(.failure(.noData))
          return
        }
        do {
          let acronym = try JSONDecoder().decode(Acronym.self, from: jsonData)
          completion(.success(acronym))
        } catch {
          completion(.failure(.decodingError))
        }
      }
      dataTask.resume()
    } catch {
      completion(.failure(.encodingError))
    }
  }

  func remove(
    category: Category,
    auth: Auth,
    completion: @escaping (Result<Void, CategoryAddError>) -> Void
  ) {
    guard let categoryID = category.id else {
      completion(.failure(.noID))
      return
    }
    guard let token = auth.token else {
      auth.logout()
      return
    }
    let url = resource
      .appendingPathComponent("categories")
      .appendingPathComponent("\(categoryID)")
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "DELETE"
    urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let dataTask = URLSession.shared
      .dataTask(with: urlRequest) { _, response, _ in
        guard let httpResponse = response as? HTTPURLResponse else {
          completion(.failure(.invalidResponse))
          return
        }
        guard httpResponse.statusCode == 204 else {
          if httpResponse.statusCode == 401 {
            auth.logout()
          }
          completion(.failure(.invalidResponse))
          return
        }
        completion(.success(()))
      }
    dataTask.resume()
  }
    
    
    func delete(auth: Auth){
        guard let token = auth.token else {
            auth.logout()
            return
        }
        var urlRequest = URLRequest(url: resource)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        dataTask.resume()
    }
    
    
    func getUser(completion: @escaping (Result<User, ResourceRequestError>) -> Void){
        let url = resource.appendingPathComponent("user")
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: jsonData)
                completion(.success(user))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
    
    
    func getCategories(completion: @escaping (Result<[Category], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("categories")
        let dataTask = URLSession.shared.dataTask(with: url) { data, _ , _ in
            guard let jsonData = data else{
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let categories = try decoder.decode([Category].self, from: jsonData)
                completion(.success(categories))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
    
    
    
    func add(category: Category, auth: Auth, completion: @escaping (Result<Void, CategoryAddError>) -> Void) {
        guard let token = auth.token else {
            auth.logout()
            return
        }
        guard let categoryID = category.id else {
            completion(.failure(.noID))
            return
        }
        
        let url = resource.appendingPathComponent("categories").appendingPathComponent("\(categoryID)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {_, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode == 201 else {
                if httpResponse.statusCode == 401 {
                    auth.logout()
                }
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(()))
        }
        dataTask.resume()
    }
}

//
//  NetworkStone.swift
//  RareStones
//
//  Created by admin1 on 14.08.23.
//

import UIKit

protocol NetworkStone {
    func getStoneById(id: String, complition: @escaping(Result<RockID, Error>) -> Void)
    func getStones(complition: @escaping(Result<Rocks, Error>) -> Void)
    func getStonesByTag(tag: String, complition: @escaping(Result<RockTags, Error>) -> Void)
    func makePostRequestWashList(id: Int)
    func getWashList(complition: @escaping(Result<Wishlist, Error>) -> Void)
    func deleteStoneFromWishlist(stoneID: Int)
}

final class NetworkStoneImpl: NetworkStone {
    private enum API {
        static let rock = "https://my-stone-collection.com/api/rocks/"
        static let token = UserDefaults.standard.string(forKey: R.Strings.KeyUserDefaults.token)!
        static let wishlist = "https://my-stone-collection.com/api/rocks/wishlist/"
        static let rareRock = "https://my-stone-collection.com/api/rocks/?tags=1"
        static let healingRock = "https://my-stone-collection.com/api/rocks/?tags=2"
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func getStoneById(id: String, complition: @escaping (Result<RockID, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/rocks/\(id)/") else { complition(.failure(Errors.invalidURL))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let rock = try jsonDecoder.decode(RockID.self, from: data)
                    complition(.success(rock))
                } catch {
                    complition(.failure(Errors.invalideState))
                }
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
    
    func getStones(complition: @escaping (Result<Rocks, Error>) -> Void) {
        guard let url = URL(string: API.rock) else {
            complition(.failure(Errors.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let rock = try jsonDecoder.decode(Rocks.self, from: data)
                    complition(.success(rock))
                } catch {
                    complition(.failure(Errors.invalideState))
                }
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
    
    func getStonesByTag(tag: String, complition: @escaping (Result<RockTags, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/rocks/?tags=\(tag)") else { complition(.failure(Errors.invalidURL))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let rock = try jsonDecoder.decode(RockTags.self, from: data)
                    complition(.success(rock))
                } catch {
                    complition(.failure(Errors.invalideState))
                }
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
    
    func makePostRequestWashList(id: Int) {
        guard let url = URL(string: API.wishlist) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let jsonData: [String: Any] = ["stone": id]
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonData)
            request.httpBody = requestBody
        } catch {
            print("Error creating JSON data: \(error)")
            return
        }
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
        }
        task.resume()
    }
    
    func getWashList(complition: @escaping (Result<Wishlist, Error>) -> Void) {
        guard let url = URL(string: API.wishlist) else {
            complition(.failure(Errors.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let wishList = try jsonDecoder.decode(Wishlist.self, from: data)
                    complition(.success(wishList))
                } catch {
                    complition(.failure(Errors.invalideState))
                }
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
    
    func deleteStoneFromWishlist(stoneID: Int) {
        let urlString = "https://my-stone-collection.com/api/rocks/\(stoneID)/remove-from-wishlist/"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
        
        var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse {
                    print("Status Code: \(response.statusCode)")
                }
            }
            task.resume()
    }
}

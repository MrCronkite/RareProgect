//
//  registrerUser.swift
//  RareStones
//
//  Created by admin1 on 13.08.23.
//

import Foundation

final class RegistredUser {
    func registerUser(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://my-stone-collection.com/api/auth/sign-up/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let token = json["token"] as? String {
                            completion(.success(token))
                        } else {
                            let error = NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token not found in response"])
                            completion(.failure(error))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "ResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Response data is empty"])
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}


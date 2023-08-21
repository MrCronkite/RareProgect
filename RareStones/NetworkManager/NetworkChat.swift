//
//  NetworkChat.swift
//  RareStones
//
//  Created by admin1 on 20.08.23.
//

import UIKit

protocol NetworkChat {
    func sendMessage(textMessage: String, complition: @escaping(Result<Chat, Error>) -> Void)
    func getMessage(id: String, complition: @escaping(Result<Message, Error>) -> Void)
}

final class NetworkChatImpl: NetworkChat {
    private enum API {
        static let chat = "https://my-stone-collection.com/api/chats/"
        static let history = "https://my-stone-collection.com/api/classification/history/"
        static let token = "07e540b06bd3752865d6a10fe6123fc3403c5831"
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func sendMessage(textMessage: String, complition: @escaping (Result<Chat, Error>) -> Void) {
        guard let url = URL(string: API.chat) else { return }
        
        let messageData: [String: Any] = [
            "message": textMessage,
            "title": "string"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageData, options: [])
            request.httpBody = jsonData
        } catch {
            complition(.failure(Errors.invalideState))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let message = try jsonDecoder.decode(Chat.self, from: data)
                    complition(.success(message))
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
    
    func getMessage(id: String, complition: @escaping (Result<Message, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/chats/\(id)/") else { complition(.failure(Errors.invalidURL))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let message = try jsonDecoder.decode(Message.self, from: data)
                    complition(.success(message))
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
}

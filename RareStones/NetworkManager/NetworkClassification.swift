//
//  NetworkClassification.swift
//  RareStones
//
//  Created by admin1 on 15.08.23.
//

import UIKit

protocol NetworkClassification {
    func sendImageData(image: Data, complition: @escaping (Result<StonePhoto, Error>) -> Void)
    func getClassificationHistory(complition: @escaping(Result<History, Error>) -> Void)
}

final class NetworkClassificationImpl: NetworkClassification {
    private enum API {
        static let classification = "https://my-stone-collection.com/api/classification/"
        static let history = "https://my-stone-collection.com/api/classification/history/"
        static let token = "07e540b06bd3752865d6a10fe6123fc3403c5831"
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func sendImageData(image: Data, complition: @escaping (Result<StonePhoto, Error>) -> Void) {
        guard let url = URL(string: API.classification) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(image)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            print(response)
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let photo = try jsonDecoder.decode(StonePhoto.self, from: data)
                    complition(.success(photo))
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
    
    func getClassificationHistory(complition: @escaping (Result<History, Error>) -> Void) {
        guard let url = URL(string: API.history) else {
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
                    let history = try jsonDecoder.decode(History.self, from: data)
                    complition(.success(history))
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

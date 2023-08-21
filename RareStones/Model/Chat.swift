//
//  Chat.swift
//  RareStones
//
//  Created by admin1 on 20.08.23.
//

import Foundation

// MARK: - Chat
struct Chat: Decodable {
    let id: Int
    let suggestions: [JSONAny]
    let title, createdAt: String
    let lastMessage: JSONNull?
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id, suggestions, title
        case createdAt = "created_at"
        case lastMessage = "last_message"
        case user
    }
}

// MARK: - Message
struct Message: Decodable {
    let id: Int
    let suggestions: [JSONAny]
    let messages: [MessageElement]
    let title, createdAt: String
    let lastMessage: JSONNull?
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id, suggestions, messages, title
        case createdAt = "created_at"
        case lastMessage = "last_message"
        case user
    }
}

// MARK: - MessageElement
struct MessageElement: Decodable {
    let id: Int
    let sender: Int?
    let text, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, sender, text
        case createdAt = "created_at"
    }
}

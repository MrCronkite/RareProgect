//
//  Articles.swift
//  RareStones
//
//  Created by admin1 on 15.08.23.
//

import Foundation

// MARK: - ArticleStone
struct ArticleStone: Decodable {
    let count: Int
    let next, previous: JSONNull?
    let results: [ResultArticle]
}

// MARK: - Result
struct ResultArticle: Decodable {
    let id: Int
    let title: String
    let thumbnail: String
    let pinned: Bool
    let publishedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail, pinned
        case publishedAt = "published_at"
    }
}

// MARK: - ArticlePinned
struct ArticlePinned: Decodable {
    let pinned, other: [Other]
}

// MARK: - Other
struct Other: Decodable {
    let id: Int
    let title: String
    let thumbnail: String
    let pinned: Bool
    let publishedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail, pinned
        case publishedAt = "published_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        pinned = try container.decode(Bool.self, forKey: .pinned)
        
        let dateString = try container.decode(String.self, forKey: .publishedAt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            publishedAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .publishedAt, in: container, debugDescription: "Date string did not match expected format.")
        }
    }
}

// MARK: - ArticleByID
struct ArticleByID: Decodable {
    let id: Int
    let parts: [PartItm]
    let relatedStones: [RelatedStone]
    let title: String
    let thumbnail: String
    let pinned: Bool
    let publishedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, parts
        case relatedStones = "related_stones"
        case title, thumbnail, pinned
        case publishedAt = "published_at"
    }
    
    init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           id = try container.decode(Int.self, forKey: .id)
           parts = try container.decode([PartItm].self, forKey: .parts)
           relatedStones = try container.decode([RelatedStone].self, forKey: .relatedStones)
           title = try container.decode(String.self, forKey: .title)
           thumbnail = try container.decode(String.self, forKey: .thumbnail)
           pinned = try container.decode(Bool.self, forKey: .pinned)
           
           let dateString = try container.decode(String.self, forKey: .publishedAt)
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Формат вашей даты
           if let date = dateFormatter.date(from: dateString) {
               publishedAt = date
           } else {
               throw DecodingError.dataCorruptedError(forKey: .publishedAt, in: container, debugDescription: "Cannot decode date")
           }
       }
   }

// MARK: - Part
struct PartItm: Decodable {
    let title: String?
    let text: String
    let image: String?
    let highlight: Bool
}

// MARK: - RelatedStone
struct RelatedStone: Decodable {
    let id: Int
    let name: String
    let image: String?
}

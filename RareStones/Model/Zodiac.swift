//
//  Zodiac.swift
//  RareStones
//
//  Created by admin1 on 12.08.23.
//

import Foundation

// MARK: - Zodiac
struct Zodiac: Decodable {
    let count: Int
    let next, previous: JSONNull?
    let results: [Results]
}

// MARK: - Result
struct Results: Decodable {
    let id: Int
    let name: String
    let image: String
    let dateRange, planet, element, chakra: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case dateRange = "date_range"
        case planet, element, chakra
    }
}

// MARK: - Encode/decode helpers
class JSONNull: Decodable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

// MARK: - ZodiacID
struct ZodiacID: Decodable {
    let id: Int
    let stones: [StoneElement]
    let name: String
    let image: String
    let dateRange, planet, element, chakra: String

    enum CodingKeys: String, CodingKey {
        case id, stones, name, image
        case dateRange = "date_range"
        case planet, element, chakra
    }
}

// MARK: - StoneElement
struct StoneElement: Decodable {
    let id: Int
    let stone: StoneStone
    let description: String
}

// MARK: - StoneStone
struct StoneStone: Decodable {
    let id: Int
    let name: String
    let image: String
    let photos: [Photo]
}

// MARK: - Photo
struct Photo: Decodable {
    let id: Int
    let image: String
}


struct Wishlist: Decodable {
    let count: Int
    let next, previous: JSONNull?
    let results: [WishlistResult]
}

// MARK: - Result
struct WishlistResult: Decodable {
    let id: Int
    let stone: Stone
}

// MARK: - Stone
struct Stone: Decodable {
    let id: Int
    let name: String
    let image: String
    let pricePerCaratFrom, pricePerCaratTo: String?
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case pricePerCaratFrom = "price_per_carat_from"
        case pricePerCaratTo = "price_per_carat_to"
        case isFavorite = "is_favorite"
    }
}

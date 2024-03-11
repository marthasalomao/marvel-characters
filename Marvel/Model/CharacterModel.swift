import Foundation

struct CharacterResponse: Codable {
    let code: Int
    let status: String
    let data: CharacterDataWrapper
}

struct CharacterDataWrapper: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let description: String?
    let thumbnail: Thumbnail
    let comics: ComicList
}

struct Thumbnail: Codable {
    let path: String
    let fileExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}

struct ComicList: Codable {
    let available: Int
    let collectionURI: String
    let items: [ComicSummary]
}

struct ComicSummary: Codable {
    let resourceURI: String
    let name: String
}

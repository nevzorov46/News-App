//
//  Model.swift
//  News-App
//
//  Created by Иван Карамазов on 25.08.2021.
//

import Foundation

struct APIResponse: Codable {
    let status: String?
    let message: String?
    let articles: [Article]?
}

struct Article: Codable {
    var source: Source?

    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct Source: Codable {
    var id: String?
    var name: String?

}

extension Article {

    var imageURL: URL? {
        urlToImage.flatMap { URL(string: $0) }
    }

    var webURL: URL? {
        guard let url = url.flatMap({ URL(string: $0) }),
              let scheme = url.scheme?.lowercased(), scheme == "http" || scheme == "https" else { return nil }
        return url
    }

    // NewsAPI cuts `content` at 200 characters and ends it with "[+1234 chars]".
    var text: String? {
        let cleaned = content?
            .replacingOccurrences(of: #"\s*\[\+\d+ chars\]\s*$"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
        if let cleaned, !cleaned.isEmpty { return cleaned }
        return description
    }
}

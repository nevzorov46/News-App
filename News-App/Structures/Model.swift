//
//  Model.swift
//  News-App
//
//  Created by Иван Карамазов on 25.08.2021.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    var source: Source

    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String
    var content: String?
}

struct Source: Codable {
    var id: String?
    var name: String

}

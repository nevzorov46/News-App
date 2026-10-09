//
//  NetworkService.swift
//  News-App
//
//  Created by Иван Карамазов on 25.08.2021.
//

import Foundation


enum NetworkError: LocalizedError {
    case api(String)
    case badResponse

    var errorDescription: String? {
        switch self {
        case .api(let message): return message
        case .badResponse: return "The server returned an unexpected response."
        }
    }
}

final class NetworkService: Sendable {


    static let shared = NetworkService()

    private let newsURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us")!
    private let apiKey = "7849e66def6847bba1acef775f537ccd"

    func getNews() async throws -> [Article] {
        var request = URLRequest(url: newsURL)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        let response: APIResponse = try await httpGet(request)
        // NewsAPI leaves stubs titled "[Removed]" in place of withdrawn articles.
        return (response.articles ?? []).filter { $0.title != "[Removed]" }
    }


    private func httpGet<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        // Errors come as JSON too: {"status": "error", "message": "..."}.
        if let failure = try? JSONDecoder().decode(APIResponse.self, from: data),
           failure.status == "error", let message = failure.message {
            throw NetworkError.api(message)
        }
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw NetworkError.badResponse
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.badResponse
        }
    }

    private init() {}
}

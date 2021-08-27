//
//  APICaller.swift
//  News-App
//
//  Created by Иван Карамазов on 25.08.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=7849e66def6847bba1acef775f537ccd")
    
    private init() {}
    public func getNews(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    //print(result)
                    }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

}

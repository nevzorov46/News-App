//
//  NetworkService.swift
//  News-App
//
//  Created by Иван Карамазов on 25.08.2021.
//

import Foundation


class NetworkService {
    
    
    static let shared = NetworkService()
    
    let placesURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=7849e66def6847bba1acef775f537ccd"
    
    func getNews(completionHandler: ((APIResponse?) -> Void)?) {
        httpGet(placesURL, completionHandler: completionHandler)
    }
    
    
    private func httpGet<T: Decodable>(_ url:String, completionHandler : ((T?) -> Void)?)  {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [self]
            (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }
            let news: T? = self.parseJSON(data: data)
            completionHandler?(news)

        })
        task.resume()
    }
    
   private func parseJSON<T: Decodable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let type = T.self
        do {
            return try decoder.decode(type, from: data)
        } catch let error as NSError {
            print(String(describing: error))
        }
        
        return nil
    }
    private init() {}
}


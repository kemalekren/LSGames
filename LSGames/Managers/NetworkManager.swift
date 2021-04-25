//
//  NetworkManager.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import UIKit

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

typealias GameResults = (nextPage: String?, previousPage: String?, gameModel: [GameModel])

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.rawg.io/api/games"
    private let api_Key = "3d52261225734aceb2646d7b2bac4953"
    private let page_size = 10
    private var gameResultsObject: GameResults?
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getGamesWith(query: String, page: Int = 1, completion: @escaping(Result<GameResults, NetworkError>) -> Void) {
        let endpoint = baseURL + "?key=\(api_Key)&page_size=\(page_size)&page=\(page)&search=\(query)"
        guard let url = URL(string: endpoint) else {
            return completion(.failure(.badURL))
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil  else {
                return completion(.failure(.noData))
            }
            
            do {
                let gameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
                let results = GameResults(gameResponse.nextPage, gameResponse.previousPage, gameResponse.results)
                completion(.success(results))

            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    func getNextGamesPage(url: String, completion: @escaping(Result<GameResults, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            return completion(.failure(.badURL))
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil  else {
                return completion(.failure(.noData))
            }
            
            do {
                let gameResponse = try JSONDecoder().decode(GameResponse.self, from: data)
                let results = GameResults(gameResponse.nextPage, gameResponse.previousPage, gameResponse.results)
                completion(.success(results))

            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    
    func downloadImage(from urlString: String, completion: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
}



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
    private var images = NSCache<NSString, NSData>()
    
    let session: URLSession
    
    init() {
      let config = URLSessionConfiguration.default
      session = URLSession(configuration: config)
    }
    
    func getGamesWith(query: String, page: Int = 1, completion: @escaping(Result<GameResults, NetworkError>) -> Void) {
        let endpoint = baseURL + "?key=\(api_Key)&page_size=\(page_size)&page=\(page)&search=\(query)"
        guard let url = URL(string: endpoint) else {
            return completion(.failure(.badURL))
        }

        session.dataTask(with: url) { (data, response, error) in
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

        session.dataTask(with: url) { (data, response, error) in
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
    
    func getGameDetailWith(_ id: String, completion: @escaping (Result<GameDetailModel, NetworkError>) -> Void) {
        let endpoint = baseURL + "/\(id)?key=\(api_Key)"
        guard let url = URL(string: endpoint) else {
            return completion(.failure(.badURL))
        }
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            do {
                let response = try JSONDecoder().decode(GameDetailModel.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
   
    private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
      if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
        print("using cached images")
        completion(imageData as Data, nil)
        return
      }
      
      let task = session.downloadTask(with: imageURL) { localUrl, response, error in
        if let error = error {
          completion(nil, error)
          return
        }
        
        guard let localUrl = localUrl else {
          completion(nil, NetworkError.badURL)
          return
        }
        
        do {
          let data = try Data(contentsOf: localUrl)
          self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
          completion(data, nil)
        } catch let error {
          completion(nil, error)
        }
      }
      
      task.resume()
    }
    
    func imageDownload(imageURL: String?, completion: @escaping (Data?, Error?) -> (Void)) {
        
        if let gameImageURL = imageURL,
           let url = URL(string: gameImageURL) {
            download(imageURL: url, completion: completion)
        }
    }
}



//
//  PersistanceManager.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistanceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys { static let favorites = "favorites" }
    
    
    static func updateWith(favorite: HomePresentation, actionType: PersistenceActionType, completion: @escaping (LSError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(where: {$0.gameId == favorite.gameId}) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.gameId == favorite.gameId }
                }
                
                completion(save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    static func retrieveFavorites(completion: @escaping (Result<[HomePresentation], LSError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([HomePresentation].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func isFavorite(favorite: HomePresentation, completion: @escaping(Bool) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                guard favorites.contains(where: {$0.gameId == favorite.gameId}) else {
                    completion(false)
                    return
                }
                completion(true)
                
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    
    static func save(favorites: [HomePresentation]) -> LSError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

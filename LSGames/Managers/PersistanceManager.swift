//
//  PersistanceManager.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

class PersistanceManager {
    enum Keys: String {
           case favorites
       }
       let userDefaults: UserDefaults
    
       init(userDefaults: UserDefaults = .standard) {
           self.userDefaults = userDefaults
       }
    
    func updateWith(favorite: GameModel, actionType: PersistanceActionType, completion: @escaping (LSError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):

                switch actionType {
                case .add:
                    guard !favorites.contains(where: {$0.id == favorite.id}) else {
                        completion(.alreadyInFavorites)
                        return
                    }

                case .remove:
                    favorites.removeAll(where: {$0.id == favorite.id})
                }

                completion(self.saveToFavorites(model: favorites))

            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func retrieveFavorites(completed: @escaping (Result<[GameModel], LSError>) -> Void) {
        guard let favoritesData = userDefaults.object(forKey: Keys.favorites.rawValue) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([GameModel].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    private func saveToFavorites(model: [GameModel]) -> LSError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(model)
            userDefaults.set(encodedFavorites, forKey: Keys.favorites.rawValue)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

//
//  HomeVM.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import Foundation

class HomeVM: HomeVMProtocol {
    weak var delegate: HomeVMOutputDelegate?
    private var items: [HomePresentation] = []
    private var nextPageUrl: String?

    func load() {
        NetworkManager.shared.getGamesWith(query: "gtav") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                if let url = games.nextPage {
                    self.nextPageUrl = url
                }
                self.items = games.gameModel.map(HomePresentation.init)
                self.delegate?.updateItems(self.items)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadNextPage() {
        guard let url = nextPageUrl else { return }
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.getNextGamesPage(url: url) { [weak self] results in
                guard let self = self else { return }

                switch results {
                case .success(let response):
                    if let url = response.nextPage {
                        self.nextPageUrl = url
                    }
                    
                    self.items = self.items + response.gameModel.map(HomePresentation.init)
                    self.delegate?.updateItems(self.items)

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
      }
}

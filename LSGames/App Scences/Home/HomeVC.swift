//
//  HomeVC.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import UIKit

final class HomeVC: UICollectionViewController {

    private let cellId = "gameCell"
//    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var activiyIndicator: UIActivityIndicatorView!
    
    
    var vm: HomeVM! {
        didSet{
            vm.delegate = self
        }
    }

    private var items: [HomePresentation] = []
    
    private var layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSearchBar()
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater  = self
        searchController.searchBar.placeholder = "Search for the games"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
}

extension HomeVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count == 0 {
                collectionView.setEmptyMessage("No game has been searched.")
            } else {
                collectionView.restore()
            }

            return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GameCell
        let item = items[indexPath.row]
        cell.model = item
        return cell
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            vm.loadNextPage()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = DetailBuilder.makeWith(item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: UIScreen.main.bounds.width / 2  - 5, height: 136)
        } else{
            return CGSize(width: UIScreen.main.bounds.width, height: 136)
        }
    }
}

extension HomeVC: HomeVMOutputDelegate {
    func updateItems(_ items: [HomePresentation]) {
        self.items = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension HomeVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           searchText.count > 3 {
            vm.loadWith(searchText.lowercased())
        }
    }
}


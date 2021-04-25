//
//  HomeVC.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import UIKit

final class HomeVC: UICollectionViewController {
    private let cellId = "gameCell"
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activiyIndicator: UIActivityIndicatorView!
    
    
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
        //        navigationItem.searchController = UISearchController()
        //        collectionView.backgroundColor = .white
        activiyIndicator.startAnimating()
        vm.load()
    }
    
}

extension HomeVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            containerView.alpha = 0.7
            activiyIndicator.startAnimating()
            vm.loadNextPage()
        }
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
            self.containerView.alpha = 0
            self.activiyIndicator.hidesWhenStopped = true
            self.activiyIndicator.stopAnimating()
        }
    }
    
    func showAlert(type: NetworkError) {
        
    }
}


//
//  FavoriteVC.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import UIKit

final class FavoriteVC: UITableViewController {
    private let cellId = "tableGame"
    private var items: [HomePresentation] = []
    
    
    var vm: FavoriteVM! {
        didSet{
            vm.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.load()
    }
}

extension FavoriteVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FavoriteCell
        
        let item = items[indexPath.row]
        cell.model = item
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
                self.tableView.setEmptyMessage("There is no favourites found.")
            } else {
                self.tableView.restore()
            }

            return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = DetailBuilder.makeWith(item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Are you sure want to delete?", message: nil, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (_) in
                guard let self = self else { return }
                let item = self.items[indexPath.row]
                self.vm.deleteFavoriteWith(item)
                self.items.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension FavoriteVC: FavoriteVMOutputDelegate {
    func updateItems(_ items: [HomePresentation]) {
        self.items = items
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showAlert(type: NetworkError) {
        
    }
    
}


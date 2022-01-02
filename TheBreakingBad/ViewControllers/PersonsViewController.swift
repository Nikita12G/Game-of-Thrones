//
//  ViewController.swift
//  IceAndFire
//
//  Created by Никита Гуляев on 29.12.2021.
//

import UIKit

class PersonsViewController: UIViewController {
    

    @IBOutlet weak var personsCollectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private var persons = [PersonElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personsCollectionView.delegate = self
        personsCollectionView.dataSource = self
        networkService()
        refresh()
        title = "The Breaking Bad Сharacters"
    }
    //    MARK: - Private func
    
    private func networkService() {
        Task {
            do {
                persons = try await NetworkService.shared.request()
                personsCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    private func refresh() {
        personsCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(sender: UIRefreshControl) {
        sender.endRefreshing()
        networkService()
        personsCollectionView.reloadData()
    }
}
extension PersonsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonsCollectionViewCell.reuseId, for: indexPath) as! PersonsCollectionViewCell
        cell.personImage.fetchImage(from: persons[indexPath.row].img)
        cell.personName.text = persons[indexPath.row].name
        return cell
    }
    
}

extension PersonsViewController: UICollectionViewDelegate {
    
}

extension PersonsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
          return CGSize(width: 100.0, height: 100.0)
       }
}



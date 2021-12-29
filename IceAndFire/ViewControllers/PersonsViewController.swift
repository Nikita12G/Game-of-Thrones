//
//  ViewController.swift
//  IceAndFire
//
//  Created by Никита Гуляев on 29.12.2021.
//

import UIKit

class PersonsViewController: UIViewController {
    

    @IBOutlet weak var personsCollectionView: UICollectionView!
    
    private var persons = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personsCollectionView.delegate = self
        personsCollectionView.dataSource = self
        networkService()
        
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
    
}

extension PersonsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonsCollectionViewCell.reuseId, for: indexPath) as! PersonsCollectionViewCell
        cell.personImage.fetchImage(from: persons[indexPath.row].imageURL)
        cell.personName.text = persons[indexPath.row].fullName
        cell.backgroundColor = .darkGray
        return cell
    }
    
}

extension PersonsViewController: UICollectionViewDelegate {
    
}

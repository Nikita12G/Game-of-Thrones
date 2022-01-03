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

// MARK: - UICollectionView data source

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

// MARK: - UICollectionView Delegate

extension PersonsViewController: UICollectionViewDelegate {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hero" {
            let indexPaths = self.personsCollectionView!.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            guard let vc = segue.destination as? HeroesViewController else { return }
            vc.urlImage = persons[indexPath.row].img
            vc.status = persons[indexPath.row].status.rawValue
            vc.name = persons[indexPath.row].name
            vc.occupation = persons[indexPath.row].occupation.description
            vc.nickName = persons[indexPath.row].nickname
            vc.birthday = persons[indexPath.row].birthday.rawValue
            
        }
    }
}

// MARK: - UICollectionView Delegate Flow Layout

extension PersonsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100.0, height: 100.0)
    }
}



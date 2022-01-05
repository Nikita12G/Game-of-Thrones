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
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let heroesVS = HeroesViewController()
    private var persons = [PersonElement]()
    private var searchPersons = [PersonElement]()
    
    private var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personsCollectionView.delegate = self
        personsCollectionView.dataSource = self
        networkService()
        setupRefresh()
        setupSearchController()
        personsCollectionView.backgroundColor = .systemGray5
        title = "The Breaking Bad"
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
    
    private func setupRefresh() {
        personsCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func setupSearchController() {
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Search person"
        searchController.loadViewIfNeeded()
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        if searching {
            return searchPersons.count
        } else {
            return persons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonsCollectionViewCell.reuseId, for: indexPath) as! PersonsCollectionViewCell
        
        if searching {
            cell.personImage.fetchImage(from: searchPersons[indexPath.row].img)
            cell.personName.text = searchPersons[indexPath.row].name
        } else {
            cell.personImage.fetchImage(from: persons[indexPath.row].img)
            cell.personName.text = persons[indexPath.row].name
        }
        
        cell.layer.cornerRadius = 15
        cell.personImage.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = personsCollectionView.cellForItem(at: indexPath)
        UIView.animate(
            withDuration: 3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                cell?.backgroundColor = .darkGray
            })
    }
}

// MARK: - UICollectionView Delegate

extension PersonsViewController: UICollectionViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hero" {
            let indexPaths = self.personsCollectionView!.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            guard let vc = segue.destination as? HeroesViewController else { return }
            
            if searching {
                vc.urlImage = searchPersons[indexPath.row].img
                vc.status = searchPersons[indexPath.row].status.rawValue
                vc.name = searchPersons[indexPath.row].name
                vc.occupation = searchPersons[indexPath.row].occupation.description
                vc.nickName = searchPersons[indexPath.row].nickname
                vc.birthday = searchPersons[indexPath.row].birthday.rawValue
            } else {
                vc.urlImage = persons[indexPath.row].img
                vc.status = persons[indexPath.row].status.rawValue
                vc.name = persons[indexPath.row].name
                vc.occupation = persons[indexPath.row].occupation.description
                vc.nickName = persons[indexPath.row].nickname
                vc.birthday = persons[indexPath.row].birthday.rawValue
            }
        }
    }
}

// MARK: - UICollectionView Delegate Flow Layout

extension PersonsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175.0, height: 273.0)
    }
}

// MARK: - UICollectionView Search Results Updating

extension PersonsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if !searchText.isEmpty {
            searching = true
            searchPersons.removeAll()
            for person in persons {
                if person.name.lowercased().contains(searchText.lowercased()) {
                    searchPersons.append(person)
                }
            }
        } else {
            searching = false
            searchPersons.removeAll()
            searchPersons = persons
        }
        personsCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchPersons.removeAll()
        personsCollectionView.reloadData()
    }
    
}


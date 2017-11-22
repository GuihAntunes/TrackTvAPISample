//
//  MoviesCollectionViewController.swift
//  TrackTVSample
//
//  Created by Guilherme Antunes on 21/11/17.
//  Copyright © 2017 Guilherme Antunes. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Freddy

class MoviesCollectionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var moviesCollectionView:UICollectionView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    // MARK: - Properties
    var moviesList : [Movie] = []
    var viewModel : [MovieCellViewModel] = []
    var searchActive : Bool = false
    var searchResults : [MovieCellViewModel] = []
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.fetchMovies()
    }
    
    // MARK: - General Methods
    
    func setup() {
        self.moviesCollectionView.delegate = self
        self.moviesCollectionView.dataSource = self
        self.searchBar.delegate = self
    }
    
    func createViewsModel(withMovies moviesArray : [Movie]) {
        moviesArray.forEach { (movie) in
            let newModel = MovieCellViewModel(movie: movie)
            self.viewModel.append(newModel)
        }
    }
    
    func fetchMovies() {
        
        guard let url = URL(string: baseUrl + "?extended=full") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue(clientId, forHTTPHeaderField: "trakt-api-key")
        
        Alamofire.request(request).response { (response) in
            guard let data = response.data else {
                return
            }
            
            do {
                let json = try JSON(data: data)
                self.moviesList = try json.getArray().map(Movie.init)
                self.createViewsModel(withMovies: self.moviesList)
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            }catch {
                print("Error on parsing!")
            }
        }
        
    }
    
    // MARK: - Actions

}

// MARK: - UICollectionView Data Source

extension MoviesCollectionViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchActive {
            return self.searchResults.count
        }else{
            return self.moviesList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        if self.searchActive {
            cell.movieInfoLabel.text = self.searchResults[indexPath.row].title
        }else{
            cell.movieInfoLabel.text = self.viewModel[indexPath.item].title
        }
        
        cell.movieImageView.image = self.viewModel[indexPath.item].image
        cell.movieInfoLabel.textColor = UIColor.black
        
        cell.backgroundColor = UIColor.cyan
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate

extension MoviesCollectionViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - UICollectionView Delegate FlowLayout

extension MoviesCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}

extension MoviesCollectionViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchResults = self.viewModel.filter({ (model) -> Bool in
            
            let text = model.title as NSString
            let result = text.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return result.location != NSNotFound
            
        })
        
        if self.searchResults.count == 0 {
            self.searchActive = false
        }else{
            self.searchActive = true
        }
        
        self.moviesCollectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
}



















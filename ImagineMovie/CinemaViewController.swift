//
//  CinemaViewController.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import UIKit

class CinemaViewController: UIViewController {

    @IBOutlet weak var theaterCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var popularMovies = [Movie]()
    var moviesInTheaters = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        theaterCollectionView.dataSource = self
        theaterCollectionView.delegate = self
        moviesInTheaters = Array(DataProvider.shared.inTheatresMovies)
        popularMovies = Array(DataProvider.shared.comingSoonMovies)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMoviesInfo), name: .didCompletedMoviesDownload, object: nil)
    }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent 
    }
  
    @objc func updateMoviesInfo(){
        popularMovies = Array(DataProvider.shared.comingSoonMovies)
        moviesInTheaters = Array(DataProvider.shared.inTheatresMovies)
        self.tableView.reloadData()
    }
}
// MARK: - Table View Methods
extension CinemaViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath) as! PopularTableViewCell
        let movie = popularMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155.0
    }
}
//MARK: Collection View
extension CinemaViewController :UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesInTheaters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inTheaterCell", for: indexPath) as!InTheaterCollectionViewCell
        let movie = moviesInTheaters[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 2.5
        let width = (collectionView.bounds.width - layout.minimumLineSpacing)/3
        return CGSize(width: width, height: width)
    }
}

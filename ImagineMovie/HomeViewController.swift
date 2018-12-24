//
//  FirstViewController.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var selectionSegment: UISegmentedControl!
    
    var pageViewController: UIPageViewController?
    var newReleaseMovies = ["img1","img2","img3"]
    var featuredMovies = ["img1"]
    var featuredMoviesPosters = [UIImage]()
    var pendingIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.pageControl.numberOfPages = featuredMovies.count
        createPageViewController()
        collectionView.dataSource = self
        collectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateMoviesInfo), name: .didCompletedMoviesDownload, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func updateMoviesInfo(){
        if isComingSoonSelected{
          let mostRelatedComingSoonMovies = Array(DataProvider.shared.comingSoonMovies)
          if mostRelatedComingSoonMovies.count >= 3{
            featuredMovies = mostRelatedComingSoonMovies[0...2].map({Constants.imageBaseUrl + $0.schedulededFilmId}) //To select most relavant 3 urls
          }
          else{
            featuredMovies = mostRelatedComingSoonMovies.map({Constants.imageBaseUrl + $0.schedulededFilmId})
          }
        }
        else{
          let mostRelatedInTheatersMovies = Array(DataProvider.shared.inTheatresMovies)
          if mostRelatedInTheatersMovies.count >= 3{
            featuredMovies = mostRelatedInTheatersMovies[0...2].map({Constants.imageBaseUrl + $0.schedulededFilmId})//To select most relavant 3 urls
          }
          else{
            featuredMovies = mostRelatedInTheatersMovies.map({Constants.imageBaseUrl + $0.schedulededFilmId})
          }
        }
      
      self.pageControl.numberOfPages = featuredMovies.count
      for posterUrl in featuredMovies{
         WebAPI.shared.getImage(with: posterUrl, completion: {rawImage in
          DispatchQueue.main.async {
            self.featuredMoviesPosters.append(rawImage)
          }
        })
      }
        createPageViewController()
    }

    
    @IBAction func scUserChoice(_ sender: Any) {
        let getIndex = selectionSegment.selectedSegmentIndex
        switch (getIndex) {
        case 0:
            isComingSoonSelected = false
        case 1:
            isComingSoonSelected = true
        default:
            print("No Selection")
        }
        updateMoviesInfo()
    }
}

//MARK: Collection View Methods
extension HomeViewController :UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newReleaseMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! NewReleaseCollectionViewCell
       
        cell.newReleasePoster.image = UIImage(named: newReleaseMovies[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 2.5
        let width = (collectionView.bounds.width - layout.minimumLineSpacing)/2
        return CGSize(width: width, height: width)
    }
}


//MARK: PageVeiw Controller Supportive Methods
extension HomeViewController{
    func getContentViewController(withIndex index: Int)-> ContentViewController? {
        if index < featuredMovies.count {
            let contentVc = self.storyboard?.instantiateViewController(withIdentifier: "contentVC") as! ContentViewController
            contentVc.itemIndex = index
            contentVc.imageName = featuredMovies[index]
            
            return contentVc
        }
        return nil
    }
    
    func createPageViewController(){
        
        let pageVc = self.storyboard?.instantiateViewController(withIdentifier: "pageVC") as! UIPageViewController
        pageVc.dataSource = self
        pageVc.delegate =  self
        if featuredMovies.count > 0 {
            let contentController = getContentViewController(withIndex: 0)!
            let contentControllers = [contentController]
            
            pageVc.setViewControllers(contentControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }
        pageViewController = pageVc
        pageViewController?.view.contentMode = .scaleToFill
        pageViewController?.view.frame = CGRect(x: self.swipeView.frame.origin.x, y: self.swipeView.frame.origin.y, width: self.swipeView.frame.width, height: self.swipeView.frame.height)
        
        self.addChild(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController?.didMove(toParent: self)
        
    }
}
//MARK: PageView Controller Datasource and Delegate methods
extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentViewController
        if contentVC.itemIndex > 0 {
            return getContentViewController(withIndex: contentVC.itemIndex - 1)
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentViewController
        
        if contentVC.itemIndex + 1 < featuredMovies.count {
            return getContentViewController(withIndex: contentVC.itemIndex + 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        pendingIndex = (pendingViewControllers.first as! ContentViewController).itemIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentIndex = pendingIndex
            if let index = currentIndex {
                self.pageControl.currentPage = index
            }
        }
    }
}


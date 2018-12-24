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
    var pendingIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        featuredMovies = [String]()
        if isComingSoonSelected{
            featuredMovies = DataProvider.shared.comingSoonMovies.map({Constants.imageBaseUrl + $0.schedulededFilmId})
        }
        else{
            featuredMovies = DataProvider.shared.inTheatresMovies.map({Constants.imageBaseUrl + $0.schedulededFilmId})
        }
        self.pageControl.numberOfPages = featuredMovies.count
    }

    
    @IBAction func scUserChoice(_ sender: Any) {
        
        featuredMovies = [String]()
        let getIndex = selectionSegment.selectedSegmentIndex
        switch (getIndex) {
        case 0:
            isComingSoonSelected = false
            featuredMovies = DataProvider.shared.comingSoonMovies.map({Constants.imageBaseUrl + $0.schedulededFilmId})
            
        case 1:
            isComingSoonSelected = true
            featuredMovies = DataProvider.shared.inTheatresMovies.map({Constants.imageBaseUrl + $0.schedulededFilmId})
        default:
            print("No Selection")
        }
        self.pageControl.numberOfPages = featuredMovies.count
    }
    
}


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


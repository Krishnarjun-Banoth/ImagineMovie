//
//  ContentViewController.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var itemIndex = 0
    var imageName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
      guard let currentImageUrl = imageName else{
        return
      }
      imageView.cacheImage(urlString: currentImageUrl)
    }

}

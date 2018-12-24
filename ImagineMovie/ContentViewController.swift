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
        
        if let currentImage = imageName {
            if let imgUrl = URL(string: currentImage) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imgUrl)
                    if let data = data {
                        let img = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.imageView.image = img
                        }
                    }
                }
                
            }
        }
    }

}

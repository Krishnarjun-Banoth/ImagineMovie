//
//  InTheaterCollectionViewCell.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import UIKit

class InTheaterCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var inTheaterPoster: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
    }
    
  
    
    
    func configure(with inTheaterMovie: Movie) {
       
        let posterUrl = Constants.imageBaseUrl + inTheaterMovie.schedulededFilmId
        if let imgUrl = URL(string: posterUrl) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imgUrl)
                if let data = data {
                    let img = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.inTheaterPoster.image = img
                    }
                }
            }
            
        }
    }
}

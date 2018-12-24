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
    }
  
    func configure(with inTheaterMovie: Movie) {
      let posterUrl = Constants.imageBaseUrl + inTheaterMovie.schedulededFilmId
      inTheaterPoster.cacheImage(urlString: posterUrl)
    }
}

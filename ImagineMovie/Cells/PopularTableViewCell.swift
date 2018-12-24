//
//  PopularTableViewCell.swift
//  ImagineMovie
//
//  Created by Nandini B on 23/12/18.
//  Copyright © 2018 Tuna. All rights reserved.
//

import UIKit

class PopularTableViewCell: UITableViewCell {

    @IBOutlet weak var popularContentView: UIView!
    @IBOutlet weak var bookNowBtn: UIButton!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bookNowBtn.layer.cornerRadius = 5.0
        self.popularContentView.layer.cornerRadius = 5.0
        self.contentView.layer.cornerRadius = 10.0
        self.moviePoster.layer.cornerRadius = 5.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with popular: Movie) {
        movieName.text = popular.title
        movieDesc.text = popular.synopsis
        
        let posterUrl = Constants.imageBaseUrl + popular.schedulededFilmId
        if let imgUrl = URL(string: posterUrl) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imgUrl)
                if let data = data {
                    let img = UIImage(data: data)
                    DispatchQueue.main.async {
                       self.moviePoster.image = img
                    }
                }
            }
            
        }
    }

}

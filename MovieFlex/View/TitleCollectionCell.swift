//
//  TitleCollectionCell.swift
//  MovieFlex
//
//  Created by Warln on 20/03/22.
//

import UIKit
import SDWebImage

class TitleCollectionCell: UICollectionViewCell {
    static let identifier = "TitleCollectionCell"
    
    private let posterImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImage.frame = bounds
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
        posterImage.sd_setImage(with: url, completed: nil)
    }
    
}

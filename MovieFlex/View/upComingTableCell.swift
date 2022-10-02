//
//  upComingTableCell.swift
//  MovieFlex
//
//  Created by Warln on 20/03/22.
//

import UIKit
import SDWebImage

class upComingTableCell: UITableViewCell {
    
    static let identifier = "upComingTableCell"
    
    private let moviePoster: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .semibold)
        lbl.numberOfLines = 0
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let playBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePoster)
        contentView.addSubview(titleLbl)
        contentView.addSubview(playBtn)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraint() {

        NSLayoutConstraint.activate([
            moviePoster.widthAnchor.constraint(equalToConstant: 100),
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 5),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            playBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playBtn.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: -10),
            playBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playBtn.widthAnchor.constraint(equalToConstant: 40),
            playBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with model: ComingViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster)") else {return}
        moviePoster.sd_setImage(with: url, completed: nil)
        titleLbl.text = model.movieTxt
    }
    
}

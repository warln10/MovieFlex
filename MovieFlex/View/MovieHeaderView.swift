//
//  MovieHeaderView.swift
//  MovieFlex
//
//  Created by Warln on 18/03/22.
//

import UIKit
import SDWebImage

class MovieHeaderView: UIView {
    
    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "DragonBall")
        return image
    }()
    
    private let playBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = .filled()
        btn.configuration?.title = "Play"
        btn.configuration?.image = UIImage(systemName: "play.fill")
        btn.configuration?.imagePlacement = .leading
        btn.configuration?.imagePadding = 5
        btn.configuration?.baseForegroundColor = .systemBackground
        btn.configuration?.baseBackgroundColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let addBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = .plain()
        btn.configuration?.subtitle = "My List"
        btn.configuration?.image = UIImage(systemName: "plus")
        btn.configuration?.imagePlacement = .top
        btn.configuration?.imagePadding = 2
        btn.configuration?.titlePadding = 2
        btn.configuration?.baseForegroundColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let info: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = .plain()
        btn.configuration?.subtitle = "Info"
        btn.configuration?.image = UIImage(systemName: "info.circle")
        btn.configuration?.imagePlacement = .top
        btn.configuration?.imagePadding = 2
        btn.configuration?.titlePadding = 2
        btn.configuration?.baseForegroundColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = NSLayoutConstraint.Axis.horizontal
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.spacing = 15
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(movieImage)
        addGradient()
        addSubview(stack)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImage.frame = bounds
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func setConstraint() {
        self.stack.addArrangedSubview(addBtn)
        self.stack.addArrangedSubview(playBtn)
        self.stack.addArrangedSubview(info)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    public func configure(with model : ComingViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster)") else {return}
        movieImage.sd_setImage(with: url, completed: nil)
    }
    
}

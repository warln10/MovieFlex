//
//  CollectionTableCell.swift
//  MovieFlex
//
//  Created by Warln on 17/03/22.
//

import UIKit

protocol CollectionTableCellDelegate : NSObject{
    func collectionTableCellDidTap(_ cell: CollectionTableCell, with model: PreviewViewModel)
}

class CollectionTableCell: UITableViewCell {
    
    static let indentifier = "collectionTableCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 200)
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.showsHorizontalScrollIndicator = false
        c.register(TitleCollectionCell.self, forCellWithReuseIdentifier: TitleCollectionCell.identifier)
        return c
    }()
    
    private var titles:[Title] = [Title]()
    weak var delegate: CollectionTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self ] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(with indexPath: IndexPath){
        
        DataPersistentManager.shared.downloadTitleWith(with: titles[indexPath.row]) { result in
            switch result {
            case .success():
                print("Download Complete")
                NotificationCenter.default.post(name: NSNotification.Name("Download"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

//MARK: - UICollectionView DataSource

extension CollectionTableCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionCell.identifier, for: indexPath) as? TitleCollectionCell else {
            return UICollectionViewCell()
        }
        guard let poster = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: poster)
        return cell
    }
    
}

//MARK: - UICOllectionView Delegate

extension CollectionTableCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.title else {return}
        APICaller.shared.getYoutube(with: titleName) { [weak self] (result) in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    let model = PreviewViewModel(title: titleName, item: item, overView: title.overview ?? "")
                    guard let strongSelf = self else {return}
                    self?.delegate?.collectionTableCellDidTap(strongSelf, with: model)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { _ in
            let download = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                self?.downloadTitleAt(with: indexPath)
            }
            
            return UIMenu(title: "", subtitle: "", image: nil, identifier: nil, options: .displayInline, children: [download])
        }
        return config
    }
    
}

//
//  SearchViewControler.swift
//  MovieFlex
//
//  Created by Warln on 21/03/22.
//

import UIKit

protocol SearchViewControlerDelegate: NSObject {
    func searchViewControlerDidTap(with model: PreviewViewModel)
}

class SearchViewControler: UIViewController {
    
    public let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: 200)
        layout.minimumInteritemSpacing = 0
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(TitleCollectionCell.self, forCellWithReuseIdentifier: TitleCollectionCell.identifier)
        c.showsVerticalScrollIndicator = false
        return c
    }()
    
    public var titles:[Title] = [Title]()
    weak var delegate: SearchViewControlerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

//MARK: - UICOllectionView DataScource
extension SearchViewControler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionCell.identifier, for: indexPath) as? TitleCollectionCell else {
            return UICollectionViewCell()
        }
        let model = titles[indexPath.row]
        cell.configure(with: model.poster_path ?? "")
        return cell
    }
}

//MARK: - UICollectionView Delegate
extension SearchViewControler: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.title else {return}
        APICaller.shared.getYoutube(with: titleName) { [weak self] (result) in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    let model = PreviewViewModel(title: titleName, item: item, overView: title.overview ?? "")
                    self?.delegate?.searchViewControlerDidTap(with: model)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

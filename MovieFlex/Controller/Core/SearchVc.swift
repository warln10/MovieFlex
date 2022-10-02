//
//  SearchVc.swift
//  MovieFlex
//
//  Created by Warln on 17/03/22.
//

import UIKit

class SearchVc: UIViewController {
    
    private let tableView: UITableView = {
        let t = UITableView()
        t.register(upComingTableCell.self, forCellReuseIdentifier: upComingTableCell.identifier)
        return t
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchViewControler())
        controller.searchBar.placeholder = "Search for a show,movie,genre,etc"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private var titles:[Title] = [Title]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        tableView.dataSource = self
        navigationItem.searchController = searchController
        navigationItem.titleView?.tintColor = .label
        tableView.delegate = self
        fetchDescover()
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func fetchDescover() {
        APICaller.shared.getDiscover { [weak self] (result) in
            switch result {
            case .success(let title):
                self?.titles = title
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}

//MARK: - UITable DataSource
extension SearchVc: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: upComingTableCell.identifier, for: indexPath) as? upComingTableCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = ComingViewModel(poster: title.poster_path ?? "", movieTxt: title.title ?? title.original_title ?? "Unknown", overView: title.overview ?? "")
        cell.configure(with: model)
        return cell
    }
}

//MARK: - UITableView Delegate
extension SearchVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK: - UISearchResultsUpdating
extension SearchVc: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let quary = searchBar.text,
              !quary.trimmingCharacters(in: .whitespaces).isEmpty,
              quary.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchViewControler else {return}
        resultController.delegate = self
        APICaller.shared.getSearch(with: quary) { result in
            switch result{
            case .success(let title):
                DispatchQueue.main.async {
                    resultController.titles = title
                    resultController.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - SearchViewControlerDelegate
extension SearchVc: SearchViewControlerDelegate {
    func searchViewControlerDidTap(with model: PreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = ProgramViewController()
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


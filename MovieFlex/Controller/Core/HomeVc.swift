//
//  HomeVc.swift
//  MovieFlex
//
//  Created by Warln on 17/03/22.
//

import UIKit

enum Sections: Int {
    case trendingMovies = 0
    case trendingTv = 1
    case popular = 2
    case upComing = 3
    case topRated = 4
}

class HomeVc: UIViewController {
    
    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped )
        t.showsVerticalScrollIndicator = false
        t.register(CollectionTableCell.self , forCellReuseIdentifier: CollectionTableCell.indentifier)
        return t
    }()
    
    private var movieHeader = MovieHeaderView()
    let sectionTitle: [String] = ["Trending Movies","Trending Tv","Popular","Upcoming Movies","Top rated"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        movieHeader = MovieHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2))
        tableView.tableHeaderView = movieHeader
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100) )
        tableView.delegate = self
        tableView.dataSource = self
        addNavigationBar()
        fetchHeaderData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func addNavigationBar() {
        var image = UIImage(named: "Akatsuki")
        image = image?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        button.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    func fetchHeaderData() {
        APICaller.shared.getPopular { [weak self] (result) in
            switch result {
            case .success(let title):
                guard let randomMenu = title.randomElement() else {return}
                DispatchQueue.main.async {
                    let model = ComingViewModel(poster: randomMenu.poster_path ?? "", movieTxt: randomMenu.title ?? randomMenu.original_title ?? "Unknown", overView: randomMenu.overview ?? "")
                    self?.movieHeader.configure(with: model)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

//MARK: - UITableView DataSource

extension HomeVc: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableCell.indentifier, for: indexPath) as? CollectionTableCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            APICaller.shared.getTrendingMovie { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.trendingTv.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.upComing.rawValue:
            APICaller.shared.getUpComing { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.topRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.contentInsetAdjustmentBehavior = .never
        let offSet = scrollView.contentOffset.y
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSet))
        if scrollView == tableView {
            let a = scrollView.contentOffset
            if a.y <= 0 {
                scrollView.contentOffset = CGPoint.zero // this is to disable tableview bouncing at top.
            }
        }
        
    }
    
}

//MARK: - UITableView Delegate

extension HomeVc: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalizesFirst()
        header.textLabel?.textColor = .label
    }
    
}

//MARK: - CollectionTableCellDelegate
extension HomeVc: CollectionTableCellDelegate {
    func collectionTableCellDidTap(_ cell: CollectionTableCell, with model: PreviewViewModel) {
        DispatchQueue.main.async {
            let vc = ProgramViewController()
            vc.configure(with: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

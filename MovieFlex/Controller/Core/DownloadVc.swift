//
//  DownloadVc.swift
//  MovieFlex
//
//  Created by Warln on 17/03/22.
//

import UIKit

class DownloadVc: UIViewController {
    
    private let tableView: UITableView = {
        let t = UITableView()
        t.register(upComingTableCell.self, forCellReuseIdentifier: upComingTableCell.identifier)
        t.showsVerticalScrollIndicator = false
        t.alwaysBounceVertical = false
        return t
    }()
    
    private var titles: [TitleItem] = [TitleItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        fetchFromDataBase()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Download"), object: nil, queue: nil) { [weak self] _ in
            self?.fetchFromDataBase()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func fetchFromDataBase() {
        DataPersistentManager.shared.fetchTitlesFromDatabase { [weak self] result in
            switch result{
            case .success(let title):
                DispatchQueue.main.async {
                    self?.titles = title
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

//MARK: - UITableView DataSource
extension DownloadVc: UITableViewDataSource {
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
extension DownloadVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.title else {return}
        APICaller.shared.getYoutube(with: titleName) { [weak self] (result) in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    let model = PreviewViewModel(title: titleName, item: item, overView: title.overview ?? "")
                    let vc = ProgramViewController()
                    vc.configure(with: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistentManager.shared.deleteTitleFromDatabase(with: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Remove successFully")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
}

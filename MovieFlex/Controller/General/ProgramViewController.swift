//
//  ProgramViewController.swift
//  MovieFlex
//
//  Created by Warln on 23/03/22.
//

import UIKit
import WebKit

class ProgramViewController: UIViewController {
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.text = "Harry Potter"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "This movie is best for kids"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let downloadBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = .filled()
        btn.configuration?.title = "Download"
        btn.configuration?.image = UIImage(systemName: "arrow.down.to.line")
        btn.configuration?.imagePlacement = .leading
        btn.configuration?.imagePadding = 5
        btn.configuration?.baseForegroundColor = .systemBackground
        btn.configuration?.baseBackgroundColor = .red
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLbl)
        view.addSubview(overviewLbl)
        view.addSubview(downloadBtn)
        setConstraint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.stopLoading()
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            titleLbl.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overviewLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 10),
            overviewLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overviewLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            downloadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadBtn.topAnchor.constraint(equalTo: overviewLbl.bottomAnchor, constant: 10)
        ])
    }
    
    func configure(with model: PreviewViewModel){
        titleLbl.text = model.title
        overviewLbl.text = model.overView
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.item.id.videoID)") else {return}
        webView.load(URLRequest(url: url))
        
    }
    
    
}


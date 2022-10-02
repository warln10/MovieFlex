//
//  ViewController.swift
//  MovieFlex
//
//  Created by Warln on 17/03/22.
//

import UIKit

class TabBarVc: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        let vc1 = UINavigationController(rootViewController: HomeVc())
        let vc2 = UINavigationController(rootViewController: UpcomingVc())
        let vc3 = UINavigationController(rootViewController: SearchVc())
        let vc4 = UINavigationController(rootViewController: DownloadVc())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Search"
        vc4.title = "Downloads"
        
        tabBar.tintColor = .label
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        
    }


}


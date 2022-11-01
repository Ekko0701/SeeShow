//
//  TabBarController.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import UIKit

class TapBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TapBarController - viewDidLoad()")
        configure()
        
    }
    /// 탭바 설정 함수
    func configure() {
        self.delegate = self
        self.selectedIndex = 0
 
        viewControllers = [
            generateNavController(viewController: MainViewController(), title: "Main",image: UIImage(systemName: "house")),
            generateNavController(viewController: CategoryViewController(), title: "Category", image:UIImage(systemName: "list.bullet.rectangle")),
            generateNavController(viewController: MapViewController(), title: "Map", image: UIImage(systemName: "map")),
        ]
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .black
    }
    
    /// ViewController를 NavigationController로 변환하는 함수
    /// - Parameters:
    ///   - vc: UIViewController
    ///   - title: Navigation Title
    /// - Returns: UINavigationController
    private func generateNavController(viewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        // Set TabBar Item
        //viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        // Set Navigation
        viewController.navigationItem.title = title
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true

        return navController
        
    }
    
    //MARK: - Check Fonts
    /// 폰트 체크하는 함수
    func checkFont() {
        for family in UIFont.familyNames {
            print(family)
            
            for sub in UIFont.fontNames(forFamilyName: family) {
                print("===> \(sub)")
            }
        }
    }
    
}

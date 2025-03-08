//
//  CustomNavigationController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 26/03/24.
//

import UIKit

class CustomNavigationController: UINavigationController{
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        UINavigationBar.appearance().tintColor = .primaryForegroundColor
        UIBarButtonItem.appearance().tintColor = .primaryForegroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? CustomTransitionEnabledVC{
            self.delegate = vc.customTransitionDelegate
        }else{
            self.delegate = nil
        }
        tabBarController?.tabBar.isHidden = viewControllers.count > 1
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        print(viewControllers.count)
        tabBarController?.tabBar.isHidden = viewControllers.count > 1
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        tabBarController?.tabBar.isHidden = false
        return super.popToRootViewController(animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
       
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // Check if the interactive pop gesture was cancelled (user didn't complete the swipe)
       return interactionController
    }
}

class CustomTabBarController: UITabBarController, CustomTransitionEnabledVC{
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    var customTransitionDelegate: TransitioningManager = TransitioningManager() 
}

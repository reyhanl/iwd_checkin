//
//  TransitionManager.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class TransitioningManager: NSObject, UIViewControllerTransitioningDelegate{
    
    weak var interactionController: UIPercentDrivenInteractiveTransition?
    var presentationTransitionType: CustomPresentationTransitionType?
    var dismissalTransitionType: CustomDismissTransitionType?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationHandler(presentationTransitionType: presentationTransitionType)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissalHandler(dismissTransitionType: dismissalTransitionType)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PresentationController(presentedViewController: presented, presenting: presenting)
        controller.transitionType = presentationTransitionType
        return controller
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

extension TransitioningManager: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Check the operation to determine if it's a push or pop transition
        if operation == .push {
            if let transitionType = presentationTransitionType{
                return PresentationHandler(presentationTransitionType: transitionType)
            }else{
                return nil
            }
        } else if operation == .pop {
            if let dismissTransitionType = dismissalTransitionType{
                return DismissalHandler(dismissTransitionType: dismissTransitionType)
            }else{
                return nil
            }
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? CustomTransitionEnabledVC{
            navigationController.delegate = vc.customTransitionDelegate
        }else{
            navigationController.delegate = nil
        }
        print("navigation controller \(navigationController.viewControllers.count)")
        navigationController.tabBarController?.tabBar.isHidden = navigationController.viewControllers.count > 1
        navigationController.tabBarController?.tabBar.isTranslucent = navigationController.viewControllers.count > 1
    }
}


class PresentationController: UIPresentationController {
    
    var transitionType: CustomPresentationTransitionType?
    
    override var shouldRemovePresentersView: Bool {
        switch transitionType {
        case .swipeRight:
            return true
        case .swipeUp:
            return false
        case .loading(_):
            return true
        case nil:
            return true
        }
    }
}


protocol CustomTransitionEnabledVC{
    var interactionController: UIPercentDrivenInteractiveTransition? { get set }
    var customTransitionDelegate: TransitioningManager {get set}
}

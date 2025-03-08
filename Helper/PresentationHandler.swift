//
//  PresentationHandler.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class PresentationHandler: NSObject, UIViewControllerAnimatedTransitioning{
    
    var presentationTransitionType: CustomPresentationTransitionType?
    
    init(presentationTransitionType: CustomPresentationTransitionType? = nil) {
        self.presentationTransitionType = presentationTransitionType
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch presentationTransitionType {
        case .swipeRight:
            handleSwipeRight(using: transitionContext)
        case .swipeUp:
            handleSwipeUp(using: transitionContext)
        case .loading(let loadingView):
            handleLoading(using: transitionContext, loadingView: loadingView)
        case nil:
            break
        }
    }
    
    func handleSwipeUp(using transitionContext: UIViewControllerContextTransitioning){
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        let containerView = transitionContext.containerView
        
        if let toView = toView{
            containerView.addSubview(toView)
        }
        //we are setting the initial position for the ToViewController.view, we are setting it to the left of the screen
        toView?.frame = containerView.frame
        if let subview = toView?.subviews[safe: 1]{
            subview.frame.origin.y += containerView.frame.height
        }
        toView?.subviews.first?.alpha = 0
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            if let subview = toView?.subviews[safe: 1]{
                subview.frame.origin.y -= containerView.frame.height
            }
            toView?.subviews.first?.alpha = 1
        } completion: { _ in
            if transitionContext.transitionWasCancelled{
                toView?.frame.origin.x = -(fromView?.frame.width ?? 0)
                toView?.removeFromSuperview()
                fromView?.frame.origin.x = 0
            }else{
                fromView?.removeFromSuperview()
            }
            if let subview = toView?.subviews[safe: 1]{
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func handleSwipeRight(using transitionContext: UIViewControllerContextTransitioning){
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else{return}
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        //we are setting the initial position for the ToViewController.view, we are setting it to the left of the screen
        toView.frame = fromView.frame
        toView.frame.origin.x = -fromView.frame.width
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            //we are moving the toVC.view to the screen, and moving the fromView to the
            //end of the screen
            toView.frame.origin.x = 0
            fromView.frame.origin.x = fromView.frame.width
        } completion: { _ in
            if transitionContext.transitionWasCancelled{
                toView.frame.origin.x = -fromView.frame.width
                toView.removeFromSuperview()
                fromView.frame.origin.x = 0
            }else{
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func handleLoading(using transitionContext: UIViewControllerContextTransitioning, loadingView: UIView){
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let frame = loadingView.frame
        if let view = toView{
            containerView.addSubview(view)
            view.frame.origin.y = containerView.frame.size.height
            view.alpha = 0
        }
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            toView?.frame.origin.y = 0
            loadingView.transform = loadingView.transform.rotated(by: 1.57)
            toView?.alpha = 1
        } completion: { finish in
            if transitionContext.transitionWasCancelled{
                fromView?.frame.origin.x = 0
            }else{
                fromView?.frame.origin.x = 0
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

enum CustomPresentationTransitionType{
    case swipeRight
    case swipeUp
    case loading(UIView)
}

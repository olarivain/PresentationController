//
//  ViewController.swift
//  PresentationController
//
//  Created by Olivier Larivain on 12/18/19.
//  Copyright © 2019 OpenTable, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSLog("viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("viewDidDisappear")
    }
    
    @IBAction func present(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PresentedController")
        self.otf_present(controller, animated: true, completion: nil)
    }
    
    @IBAction func presentFull(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PresentedController")
        controller.modalPresentationStyle = .fullScreen
        self.otf_present(controller, animated: true, completion: nil)
    }
    
    @IBAction func presentTabBAr(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PresentedController")
        self.tabBarController?.otf_present(controller, animated: true, completion: nil)
    }
}

class PresentedController: UIViewController {
    
    @IBAction func dismissMe(_ sender: Any) {
        self.otf_dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("viewWillAppear - PresentedController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("viewDidAppear - PresentedController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSLog("viewWillDisappear - PresentedController")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("viewDidDisappear - PresentedController")
    }
}

extension UIViewController: UIAdaptivePresentationControllerDelegate {

    public func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        self.beginAppearanceTransition(false, animated: true) // this triggers `viewWillDisappear` for presenting VC
        
    }
    
    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        let coordinator = presentationController.presentingViewController.transitionCoordinator
        coordinator?.notifyWhenInteractionChanges() { context in
            if context.completionVelocity > 0 {
                self.beginAppearanceTransition(true, animated: true) // this triggers `viewWillAppear` for presenting VC
            }
        }
    }
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.endAppearanceTransition() // this triggers `viewDidAppear` for presenting VC
    }
    
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        NSLog("\(String(describing: self)) is presentationControllerDidAttemptToDismiss")
    }
    
}

extension UIViewController {
    func otf_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        
        if (viewControllerToPresent.modalPresentationStyle == .automatic // this may be too conservative. `fullSheet` still leaves homeVC exposed
            || viewControllerToPresent.modalPresentationStyle == .pageSheet),
            let presentationController = viewControllerToPresent.presentationController,
            presentationController.delegate == nil
        {
            presentationController.delegate = self
        }
        
        self.present(viewControllerToPresent, animated: flag, completion: {
            self.endAppearanceTransition() // this triggers `viewDidDisappear` for presenting VC
            completion?()
        })
    }
    
    func otf_dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
        guard self.modalPresentationStyle == .automatic
            || self.modalPresentationStyle == .pageSheet
            else { return self.dismiss(animated: flag, completion: completion) }
        
        self.presentationController?.presentingViewController.beginAppearanceTransition(true, animated: true)
        self.dismiss(animated: flag) {
            completion?()
            self.presentationController?.presentingViewController.endAppearanceTransition()
        }
    }
}

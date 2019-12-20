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
}

extension UIViewController: UIAdaptivePresentationControllerDelegate {

    public func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        self.viewWillDisappear(true)
    }
    
    
    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.viewWillAppear(true)
    }
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.viewDidAppear(true)
    }
    
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        NSLog("\(String(describing: self)) is presentationControllerDidAttemptToDismiss")
    }
    
    
}

extension UIViewController {
    func otf_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if (viewControllerToPresent.modalPresentationStyle == .automatic
            || viewControllerToPresent.modalPresentationStyle == .pageSheet),
            let presentationController = viewControllerToPresent.presentationController,
            presentationController.delegate == nil {
            presentationController.delegate = self
        }
        
        self.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    func otf_dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if self.modalPresentationStyle == .automatic
            || self.modalPresentationStyle == .pageSheet {
            self.presentationController?.presentingViewController.viewWillAppear(true)
        }
        
        
        self.dismiss(animated: flag, completion: completion)
    }
}

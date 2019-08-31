//
//  ViewController.swift
//  SemiModal
//
//  Created by Michael Laurents on 2019/08/31.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import FloatingPanel

class ViewController: UIViewController {
    //var semi: Bool
    
    var floatingPanelController: FloatingPanelController!
    var semi = false
    
    @IBAction func click(_ sender: Any) {
        print("Hello")
        if !semi{
            floatingPanelController.addPanel(toParent: self, belowView: nil, animated: true)
            semi = true
        }else{
            floatingPanelController.removePanelFromParent(animated: true)
            semi = false
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //semi = false
        // Do any additional setup after loading the view.
        floatingPanelController = FloatingPanelController()
        floatingPanelController.surfaceView.cornerRadius = 24.0
        let semiModalViewController = SemiModalViewController()
        floatingPanelController.set(contentViewController: semiModalViewController)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        floatingPanelController.removePanelFromParent(animated: true)
    }


}


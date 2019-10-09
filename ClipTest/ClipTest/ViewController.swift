//
//  ViewController.swift
//  ClipTest
//
//  Created by hiroki moriguchi on 2019/10/08.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import FloatingPanel


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var floatingPanelController: FloatingPanelController!
    let image = UIImage(named: "astronomy.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        floatingPanelController = FloatingPanelController()
        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.isRemovalInteractionEnabled = true
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Test")
        print(image?.size)
        
        let cgImage = image!.cgImage
        let croppedImage = cgImage?.cropping(to: CGRect(x: 1200.0, y: 1600.0, width: 250, height: 500))
        let newImage = UIImage(cgImage: croppedImage!)
        let semiController = SemiViewController(image: newImage)
        
        floatingPanelController.set(contentViewController: semiController)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: true)
        
    }

}


//
//  ViewController.swift
//  RectTest
//
//  Created by Michael Laurents on 2019/10/05.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let image = UIImage(named: "test.jpg")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let imageSize = imageView.image!.size
        let touch = touches.first!
        let position = touch.location(in: self.view)
        let scaled_x = (imageSize.width/self.view.frame.size.width) * position.x
        let scaled_y = (imageSize.height/self.view.frame.size.height) * position.y
        print("location: \(position)")
        
        print("size \(imageSize)")
        print("self size \(self.view.frame.size)")
        
        //let imageSize = self.imageView.image!.size
        let image = imageView.image
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image?.draw(in: CGRect(origin: .zero, size: imageSize))
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.stroke(CGRect(x: scaled_x, y: scaled_y, width: 50.0, height: 50.0))
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.imageView.image = drawnImage
    }

}


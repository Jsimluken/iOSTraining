//
//  ViewController.swift
//  GenerateButton
//
//  Created by hiroki moriguchi on 2019/09/10.
//  Copyright © 2019年 Michael Laurents. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let position = touch.location(in: self.view)
        let btn = UIButton(frame: CGRect(x: position.x-25, y:position.y-25, width:50, height:50))
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(pushed), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    @objc func pushed(sender: UIButton){
        sender.removeFromSuperview()
    }

}


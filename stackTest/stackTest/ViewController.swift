//
//  ViewController.swift
//  stackTest
//
//  Created by hiroki moriguchi on 2019/10/08.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let button = UIButton(type: .infoDark)
        //let button = UIButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        
        
    }
    @IBAction func click(_ sender: Any) {
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        button.titleLabel?.text = "Hyper!!"
        button.backgroundColor = .white
        //button.titleLabel?.text = "Hyper!!"
        stackView.addArrangedSubview(button)
        print(button)
    }
    
}


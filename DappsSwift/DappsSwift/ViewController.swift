//
//  ViewController.swift
//  DappsSwift
//
//  Created by Michael Laurents on 2019/10/03.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fm = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print(documentsPath)
        // Do any additional setup after loading the view.
    }


}


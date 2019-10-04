//
//  ViewController.swift
//  FileTest
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
        print(fm.fileExists(atPath: documentsPath+"/test.txt"))
        let path = Bundle.main.path(forResource: "test", ofType: ".txt")!
        //print(Bundle.main.path(forResource: "test", ofType: ".txt"))
        
        let text = try! NSString( contentsOfFile: path, encoding: String.Encoding.utf8.rawValue )
        print(text)
        /*NSString(contentsOf: Bundle.main.path(forResource: "test", ofType: ".txt")!, encoding: "")*/
        // Do any additional setup after loading the view.
    }


}


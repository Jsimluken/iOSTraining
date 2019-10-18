//
//  ViewController.swift
//  NavigationTest
//
//  Created by hiroki moriguchi on 2019/10/18.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var data:[String] = []

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTable" {
            let nextView = segue.destination as! ViewController2
            nextView.data = data
        }
    }
    
    @IBAction func add(_ sender: Any) {
        if textField.text == "" {
            print("return")
            return
        }
        data.append(textField.text!)
        print()
        textField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


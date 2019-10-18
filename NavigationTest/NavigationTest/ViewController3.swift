//
//  ViewController3.swift
//  NavigationTest
//
//  Created by hiroki moriguchi on 2019/10/18.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    var text = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = text
    }
    
    @IBOutlet weak var label: UILabel!
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DummyController.swift
//  FaceTest
//
//  Created by Michael Laurents on 2019/10/19.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class DummyController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

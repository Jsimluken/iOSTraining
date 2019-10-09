//
//  SemiViewController.swift
//  ClipTest
//
//  Created by hiroki moriguchi on 2019/10/08.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class SemiViewController: UIViewController {

    var image:UIImage
    init(image:UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: image)
        imageView.image = image
        self.view.addSubview(imageView)
        // Do any additional setup after loading the view.
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

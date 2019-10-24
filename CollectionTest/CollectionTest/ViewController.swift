//
//  ViewController.swift
//  CollectionTest
//
//  Created by Michael Laurents on 2019/10/24.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var data = ["test0.png","test1.png","test2.png","test3.png","test4.png","test5.png","test6.png","test7.png"]
    
    
    var image:UIImage? = nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        /*let label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = data[indexPath.row]
        label.textColor = .white
        label.backgroundColor = .darkGray*/
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        let image = UIImage(named: "test\(indexPath.row).png")
        //UIImage(named: <#T##String#>)
        print(image)
        imageView.image = image
        imageView.bounds.size = cell.contentView.bounds.size
        imageView.contentMode = .scaleAspectFill

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontal_margin:CGFloat = 10.0
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontal_margin
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        image = UIImage(named: "test\(indexPath.row).png")
        performSegue(withIdentifier: "segue", sender: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let next = segue.destination as! ImageViewController
            next.image = image
         }
    }


}


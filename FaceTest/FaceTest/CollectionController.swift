//
//  CollectionController.swift
//  FaceTest
//
//  Created by Michael Laurents on 2019/10/19.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class CollectionController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var images:[UIImage] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let imageView = cell.contentView.viewWithTag(1) as? UIImageView{
            print("image!!")
            imageView.image = images[indexPath.row]
            imageView.contentMode = .scaleAspectFill
            print(images)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin:CGFloat = 10
        let size:CGFloat = self.view.bounds.width/2 - margin
        return CGSize(width: size, height: size)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

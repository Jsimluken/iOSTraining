//
//  ImageViewController.swift
//  CollectionTest
//
//  Created by Michael Laurents on 2019/10/24.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ImageViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage? = nil
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: mnist().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            //request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("ciimage\(image?.ciImage)")
        //print("cgimage\(image?.cgImage)")
       
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image!.imageOrientation.rawValue))
        let handler = VNImageRequestHandler(cgImage: (image?.cgImage)!, orientation: orientation!, options: [:])
        //let handler = VNImageRequestHandler(ciImage: (image?.ciImage)!, orientation: CGImagePropertyOrientation.right, options: [:])
       // let handler = VNImageRequestHandler(ciImage: hyperImage, orientation: CGImagePropertyOrientation.right)
        do {
            try handler.perform([self.classificationRequest])
        } catch {
            print("Error!!")
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
             return
         }
        let most_num = results[0] as! VNClassificationObservation
        
        print(most_num.identifier)
        DispatchQueue.main.async {
            self.navItem.title = "\(most_num.identifier)"
        }
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

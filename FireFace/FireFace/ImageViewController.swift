//
//  ImageViewController.swift
//  FireFace
//
//  Created by hiroki moriguchi on 2019/11/08.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ImageViewController: UIViewController {
    
    var image:UIImage?
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: facenet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            //request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
        imageView.image = image
    }
    
    @IBAction func add(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title:"action",
        message: "Who are you!?",
        preferredStyle: UIAlertController.Style.alert)
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                                                        style: UIAlertAction.Style.default,
            handler:{
            (action:UIAlertAction!) -> Void in
                print("OK")
                let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                if textFields != nil {
                    for textField:UITextField in textFields! {
                        //各textにアクセス
                        print(textField.text)
                        let pngImageData = self.image!.pngData()!
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let path = documentsURL.appendingPathComponent("test_\(textField.text!).png")
                        do {
                            try pngImageData.write(to: path, options: .atomic)
                            print("Save!!??")
                            
                        }catch{
                            print(error)
                            print("Hyper Error!!!")
                        }
                    }
                }
        })
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            //print(text.text)
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
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

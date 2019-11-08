//
//  ViewController.swift
//  FireFace
//
//  Created by Michael Laurents on 2019/11/02.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase


class ViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    let session = AVCaptureSession()
    let vision = Vision.vision()
    let cameraPosition = AVCaptureDevice.Position.back
    let metadata = VisionImageMetadata()
    let context = CIContext()
    
    var lastPicture:UIImage? = nil
    
    var faces:[CGRect] = []
    var images:[UIImage] = []
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    lazy var options = { () -> VisionFaceDetectorOptions in 
        let options = VisionFaceDetectorOptions()
        //options.contourMode = .all
        return options
    }()
    
    /*lazy var faceDetector = { () -> VisionFaceDetector in
        let options = VisionFaceDetectorOptions()
        //options.contourMode = .all
        return vision.faceDetector(options: options)
    }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVCaptureOutput()
        setupAVCaptureInput()
        
        //let angle = CGFloat((90.0 * M_PI) / 180.0)
        //imageView.transform = CGAffineTransform(rotationAngle: angle)
        imageView.contentMode = .scaleAspectFill
        session.startRunning()
        //print("faceDetector!!!: ",faceDetector)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        session.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
    }
    
    func setupAVCaptureOutput(){
        let videoDataOutput = AVCaptureVideoDataOutput()
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        
        guard session.canAddOutput(videoDataOutput) else{
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        session.addOutput(videoDataOutput)
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
    }
    
    func setupAVCaptureInput(){
        session.sessionPreset = .vga640x480
        var deviceInput: AVCaptureDeviceInput!
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        //session.beginConfiguration()
        
    }
    
    func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
        ) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        performSegue(withIdentifier: "toCollection", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollection" {
            let next = segue.destination as! CollectionViewController
            
            /*let image = self.lastPicture!
            var cgImage:CGImage? = nil
            if image.cgImage != nil {
                
                cgImage = image.cgImage
                //context.createCGImage(ciImage!, from: ciImage.extent)!
            }else{
                cgImage = context.createCGImage(image.ciImage!, from: image.ciImage!.extent)
            }
            
            var images:[UIImage] = []
            for face in faces {
                images.append(UIImage(cgImage: cgImage!.cropping(to: face)!))
            }*/
            next.images = images
        }else if segue.identifier == "toList" {
            let next = segue.destination as! CollectionViewController
            var files:[String] = try! FileManager.default.contentsOfDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path)
            var images:[UIImage] = []
            for file in files {
                let path = documentURL.appendingPathComponent(file)
                print("file is \(file)!!")
                images.append(UIImage(contentsOfFile: path.path)!)
            }
            next.images = images
        }
    }


}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("could not get a pixel buffer")
            return
        }
        
        let ciImage = CIImage(cvPixelBuffer: buffer)//.oriented(CGImagePropertyOrientation.right)
        
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        //var capturedImage = UIImage(cgImage:cgImage)
        var capturedImage = UIImage(ciImage: ciImage)
        //var capturedImage = UIImage(ciImage: ciImage, scale: 1, orientation: .right)
        
        //lastPicture = capturedImage
       // print("orientation: \(UIDevice.current.orientation == .unknown)")
        /*metadata.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: cameraPosition
        )*/
        //metadata.orientation = .topRight
        metadata.orientation = .leftTop
        let vision_image = VisionImage(buffer: sampleBuffer)
        //let vision_image = VisionImage(image: UIImage(cgImage: cgImage))
        vision_image.metadata = metadata
        //self.lastPicture = capturedImage
        let faceDetector = vision.faceDetector(options: options)
        
        
        faceDetector.process(vision_image) { faces, error in
            guard error == nil, let faces = faces else {
                // ...
              //print("No face!!")
              //self.lastPicture = capturedImage
              return
        
            }
            //var image = self.lastPicture!
            var image = capturedImage
            let imageSize = capturedImage.size
            self.faces = []
            self.images = []
            DispatchQueue.main.async {
                for face in faces {
                    let frame = face.frame
                   // print("frame: \(frame)")
                    self.faces.append(face.frame)
                    self.images.append(UIImage(cgImage: cgImage.cropping(to: face.frame)!).rotatedBy(degree: 90, isCropped: false))
                    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
                    let context = UIGraphicsGetCurrentContext()
                    image.draw(in: CGRect(origin: .zero, size: imageSize))
                    context?.setLineWidth(4.0)
                    //描画する線の色
                    context?.setStrokeColor(UIColor.white.cgColor)
                    context?.stroke(frame)
                    let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    image = drawnImage!
                }
                
                
                //print(image.ciImage)
                self.lastPicture = image
                
                
                if let ciImage = image.ciImage {
                    self.lastPicture = UIImage(ciImage: ciImage.oriented(.right))
                } else if let cgImage = image.cgImage{
                     self.lastPicture = image.rotatedBy(degree: 90, isCropped: false)
                }else{
                    print("fuck")
                }
                
                /*if let ciImage = image.ciImage {
                    self.lastPicture = UIImage(ciImage: ciImage.oriented(.right))
                    print("Yatta!!")
                }else {
                    print("Fuck!!")
                     }*/
                
                
                //let res_ciImage = image.ciImage!.oriented(.right)
                //self.lastPicture = UIImage(ciImage: res_ciImage)
                //self.imageView.image = self.lastPicture
                self.imageView.image = self.lastPicture
            }
        }
        /*DispatchQueue.main.async {
            
        }*/
    }
}



extension UIImage {

    func rotatedBy(degree: CGFloat, isCropped: Bool = true) -> UIImage {
        let radian = -degree * CGFloat.pi / 180
        var rotatedRect = CGRect(origin: .zero, size: self.size)
        if !isCropped {
            rotatedRect = rotatedRect.applying(CGAffineTransform(rotationAngle: radian))
        }
        UIGraphicsBeginImageContext(rotatedRect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: rotatedRect.size.width / 2, y: rotatedRect.size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)

        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }

}



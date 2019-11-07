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
        imageView.contentMode = .scaleAspectFill
        session.startRunning()
        //print("faceDetector!!!: ",faceDetector)
        // Do any additional setup after loading the view.
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
        var capturedImage = UIImage(ciImage:ciImage)
        
        lastPicture = capturedImage
       // print("orientation: \(UIDevice.current.orientation == .unknown)")
        metadata.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: cameraPosition
        )
        //metadata.orientation = .leftTop
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
            var image = self.lastPicture!
            let imageSize = capturedImage.size
            self.faces = []
            DispatchQueue.main.async {
                for face in faces {
                    let frame = face.frame
                    print("frame: \(frame)")
                    self.faces.append(face.frame)
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
                self.lastPicture = image
                //self.imageView.image = self.lastPicture
                self.imageView.image = self.lastPicture
            }
        }
        /*DispatchQueue.main.async {
            
        }*/
    }
}



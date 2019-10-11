//
//  ViewController.swift
//  RecetAngle
//
//  Created by Michael Laurents on 2019/10/10.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let session = AVCaptureSession()
    lazy var request = VNDetectRectanglesRequest{
        (res,error) in
        //print("\(res)")
        var image = self.imageView.image!
        for observation in res.results as! [VNRectangleObservation] {
            print("\(observation)")
            let box = observation.boundingBox
            image = self.drawRect(image: image, box: box)
        }
        self.imageView.image = image
    }
    
    var lastFrame:CIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.contentMode = .scaleAspectFill
        setupAVCaptureOutput()
        setupAVCaptureInput()
        session.startRunning()
    }

    func setupAVCaptureInput(){
        session.sessionPreset = .vga640x480
        var deviceInput: AVCaptureDeviceInput!
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        try! videoDevice!.lockForConfiguration()
        videoDevice!.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: 20) // 20 fps
        videoDevice!.unlockForConfiguration()
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
    
    func detectRectAngle(){
        let handler = VNImageRequestHandler(ciImage: lastFrame!, options: [:])
        //request.maximumObservations = 2
        try? handler.perform([request])
    }

    func drawRect(image:UIImage,box:CGRect) ->(UIImage){
        let imageSize = image.size
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)
        let translate = CGAffineTransform.identity.scaledBy(x: imageSize.width, y: imageSize.height)
        let box = box.applying(translate).applying(transform)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image.draw(in: CGRect(origin: .zero, size: imageSize))
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.stroke(box)
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return drawnImage!
    }


}

extension ViewController:AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("could not get a pixel buffer")
            return
        }
        let image = CIImage(cvPixelBuffer: buffer).oriented(CGImagePropertyOrientation.right)
        DispatchQueue.main.async {
            self.imageView.image = UIImage(ciImage: image)
            self.lastFrame = image
            self.detectRectAngle()
        }
    }
}


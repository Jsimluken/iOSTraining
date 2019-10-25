//
//  ViewController.swift
//  CameraTest2
//
//  Created by hiroki moriguchi on 2019/10/02.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let session = AVCaptureSession()
    
    @IBOutlet weak var imageView: UIImageView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupAVCaptureOutput()
        setupAVCaptureInput()
        imageView.contentMode = .scaleAspectFill
        session.startRunning()
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
    

}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("could not get a pixel buffer")
            return
        }
        
        let image = CIImage(cvPixelBuffer: buffer).oriented(CGImagePropertyOrientation.right)
        let capturedImage = UIImage(ciImage: image)
        DispatchQueue.main.async {
            self.imageView.image = capturedImage
        }
    }
}


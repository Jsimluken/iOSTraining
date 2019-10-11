//
//  ViewController.swift
//  VisionFace
//
//  Created by Michael Laurents on 2019/10/05.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let session = AVCaptureSession()
    var lastFrame:CIImage?
    var lastPicture:UIImage?
    var buttons:[UIButton] = []
    
    lazy var request = VNDetectFaceRectanglesRequest{
        (request,error) in
        var image = self.lastFrame
        for observation in request.results as! [VNFaceObservation] {
            print(observation)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        //imageView.
        // Do any additional setup after loading the view.
        setupAVCaptureOutput()
        setupAVCaptureInput()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let request
        //let cgImage = self.lastFrame! as! CGImage
        //let handler = VNImageRequestHandler(cgImage:cgImage , options: [:])
        //try! handler.perform([request])
        print("origin",imageView.frame.origin)
        print("size",imageView.frame.size)
        print("scale",imageView.image?.scale)
        print("image size",imageView.image?.size)
        print("image factor",imageView.contentScaleFactor)
        faceDetection()
    }
    
    func faceDetection() {
        //顔検出用のリクエスト
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            var image = self.lastPicture!
            //リクエスト結果が返ってくる。（例えば、二つの顔が検出されたら二つの結果が返ってくる。）
            print("Detection!!")
            for sub in self.imageView.subviews {
                sub.removeFromSuperview()
            }
            for observation in request.results as! [VNFaceObservation] {
                //検出結果の表示
                print(observation)
                print(observation.boundingBox)
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.view.frame.height)

                let translate = CGAffineTransform.identity.scaledBy(x: self.view.frame.width, y: self.view.frame.height)
                
                
                let box = observation.boundingBox.applying(translate).applying(transform)
                print()
                
                
                let imageSize = self.lastPicture!.size
                //let image = self.lastPicture!
                UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
                let context = UIGraphicsGetCurrentContext()
                image.draw(in: CGRect(origin: .zero, size: imageSize))
                //描画する線の太さ
                context?.setLineWidth(4.0)
                //描画する線の色
                context?.setStrokeColor(UIColor.green.cgColor)
                //線形を描画
                let transform2 = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)

                let translate2 = CGAffineTransform.identity.scaledBy(x: imageSize.width, y: imageSize.height)
                
                
                let box2 = observation.boundingBox.applying(translate2).applying(transform2)
                context?.stroke(box2)
                let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                image = drawnImage!
                
                let button = UIButton(frame: box)
                button.backgroundColor = .white
                self.buttons.append(button)
                self.imageView.addSubview(button)
                
                
                //検出結果を緑線で描画
                //image = self.drawFaceRectangle(image: image, observation: observation)
            }
            self.imageView.image = image
        }
        
        //Visionが処理できるデータ型に画像を変換
        //print(lastFrame)
        //print(lastFrame!.cgImage)
        /*guard let cgImage = self.lastPicture!.cgImage else{
            print("Fuck!!")
            return
        }*/
        
        let handler = VNImageRequestHandler(ciImage: lastFrame!, options: [:])
        //let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}

extension ViewController:AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print(sampleBuffer)
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("could not get a pixel buffer")
            return
        }
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
        let image = CIImage(cvPixelBuffer: buffer).oriented(CGImagePropertyOrientation.right)
        self.lastFrame = image
        
        //print(lastFrame!)
        let capturedImage = UIImage(ciImage: image)
        
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
        DispatchQueue.main.async(execute: {
            self.imageView.image = capturedImage
            self.lastPicture = capturedImage
            //self.faceDetection()
        })
    }
}

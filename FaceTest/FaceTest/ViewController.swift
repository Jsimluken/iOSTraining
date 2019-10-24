//
//  ViewController.swift
//  FaceTest
//
//  Created by Michael Laurents on 2019/10/19.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController {
    
    let session = AVCaptureSession()
    var lastFrame:CIImage?
    var lastPicture:UIImage?
    var faces:[UIImage] = []
    var flag = true
    
    var face_rects:[CGRect] = []
    var rects:[CGRect] = []
    var face:UIImage? = nil

    @IBOutlet weak var imageView: UIImageView!
    
    lazy var request = VNDetectFaceRectanglesRequest{
        (request,error) in
        //self.faces = []
        var _face_rects:[CGRect] = []
        var ciimage = self.lastFrame!
        var image = self.lastPicture!
        let imageSize = self.lastPicture!.size
        for observation in request.results as! [VNFaceObservation] {
            //print(observation.boundingBox)
            
            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)

            let translate = CGAffineTransform.identity.scaledBy(x: imageSize.width, y: imageSize.height)
            
            let box = observation.boundingBox.applying(translate).applying(transform)
            //let face = ciimage.cropped(to: box)
            //print(box)
            _face_rects.append(box)
            self.rects.append(observation.boundingBox)
            
            
            
            //self.faces.append(UIImage(ciImage: face))
        }
        
        DispatchQueue.main.async {
            self.imageView.image = image
            self.face_rects = _face_rects
        }
        
        if false{
            
            DispatchQueue.main.async {
                print("guten morgen!!")
                self.session.stopRunning()
                
                self.performSegue(withIdentifier: "dummy", sender: nil)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.contentMode = .scaleAspectFill
        setupAVCaptureOutput()
        setupAVCaptureInput()
        session.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        session.stopRunning()
    }
    override func viewDidAppear(_ animated: Bool) {
        session.startRunning()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollection" {
            let next = segue.destination as! CollectionController
            
            var faces:[UIImage] = []
            for rect in face_rects {
                let context = CIContext()
                let cgImage = context.createCGImage(lastFrame!, from: lastFrame!.extent)!
                let face = cgImage.cropping(to: rect)
                let newImage = UIImage(cgImage: face!)
                faces.append(newImage)
            }
            
            
            
            next.images = faces
        }
        if segue.identifier == "dummy" {
            let next = segue.destination as! DummyController
            //next.image = face!
            next.image = face!
            print("dummy")
            imageView.image = face!
        }
    }
    
    func detectFace(){
        let handler = VNImageRequestHandler(ciImage: lastFrame!, options: [:])
        try? handler.perform([request])
        self.draw()
    }
    
    func draw(){
        var image = lastPicture!
        let imageSize = image.size
        for box in face_rects{
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            let context = UIGraphicsGetCurrentContext()
            image.draw(in: CGRect(origin: .zero, size: imageSize))
            context?.setLineWidth(4.0)
            //描画する線の色
            context?.setStrokeColor(UIColor.white.cgColor)
            context?.stroke(box)
            let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            image = drawnImage!
        }
        imageView.image = image
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if face_rects.count > 0{
            //let face = lastFrame!.cropped(to: face_rects[0])
            //let cgImage = lastPicture!.cgImage
            //print(cImage)
            //let face = lastFrame?.cropped(to: face_rects[0])
            //let face = lastFrame?.cropped(to:rects[0])
            //let face = lastFrame?.cropped(to: CGRect(x: 100.0, y: 100.0, width: 100.0, height: 100.0))
            //print("face!!",face?.pixelBuffer)
            //print("cg?",lastFrame?.cgImage)
            let context = CIContext()
            let cgImage = context.createCGImage(lastFrame!, from: lastFrame!.extent)!
            let face = cgImage.cropping(to: face_rects[0])
            let newImage = UIImage(cgImage: face!)
            print(newImage)
            self.face = newImage
            //faces.append(UIImage(ciImage: face))
            
            faces.append(newImage)
            performSegue(withIdentifier: "toCollection", sender: nil)
            
        }
    }
    
    func addFaces(){
        
    }


}

extension ViewController:AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("could not get a pixel buffer")
            return
        }
        
        let image = CIImage(cvPixelBuffer: buffer).oriented(CGImagePropertyOrientation.right)
        
        self.lastFrame = image
        
        let capturedImage = UIImage(ciImage: image)
        
        DispatchQueue.main.async(execute: {
            self.imageView.image = capturedImage
            self.lastPicture = capturedImage
            //self.faceDetection()
            self.detectFace()
            
            
        })
        
    }
}


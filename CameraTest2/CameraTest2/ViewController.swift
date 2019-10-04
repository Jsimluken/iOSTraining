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
    
    var session: AVCaptureSession!
    var device: AVCaptureDevice!
    var output: AVCaptureVideoDataOutput!
    var cameraPosition = AVCaptureDevice.Position.back

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func prepareCamera() {
        // Prepare a video capturing session.
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSession.Preset.vga640x480 // not work in iOS simulator
        self.device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: cameraPosition)
        if (self.device == nil) {
            print("no device")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: self.device)
            self.session.addInput(input)
        } catch {
            print("no device input")
            return
        }
        self.output = AVCaptureVideoDataOutput()
        self.output.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA) ]
        let queue: DispatchQueue = DispatchQueue(label: "videocapturequeue", attributes: [])
        self.output.setSampleBufferDelegate(self, queue: queue)
        self.output.alwaysDiscardsLateVideoFrames = true
        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
        } else {
            print("could not add a session output")
            return
        }
        do {
            try self.device.lockForConfiguration()
            self.device.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 20) // 20 fps
            self.device.unlockForConfiguration()
        } catch {
            print("could not configure a device")
            return
        }
    }

}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        <#code#>
    }
}


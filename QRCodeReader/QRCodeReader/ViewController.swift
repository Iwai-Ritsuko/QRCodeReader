//
//  ViewController.swift
//  QRCodeReader
//
//  Created by Iwai Ritsuko on 2015/7/13.
//  Copyright (c) 2015年 RiccaLokka. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initCapture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initCapture() {
        // create session
        let mySession: AVCaptureSession! = AVCaptureSession()
        
        // add device
        var captureDevice: AVCaptureDevice!
        
        // get devices
        var devices: NSArray = AVCaptureDevice.devices()
        
        // put back camera in to captureDevice
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back {
                captureDevice = device as! AVCaptureDevice
            }
        }
        
        // simulator
        if captureDevice == nil {
            return
        }
        
        // get input from back camera
        let input = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: nil) as! AVCaptureDeviceInput
        
        if mySession.canAddInput(input) {
            mySession.addInput(input)
        }

        // put output into MetaData
        let metaOutput : AVCaptureMetadataOutput! = AVCaptureMetadataOutput()
        if mySession.canAddOutput(metaOutput) {
            mySession.addOutput(metaOutput)
            metaOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metaOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }

        // create layer for display
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as! AVCaptureVideoPreviewLayer
        
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // add layer to view
        self.view.layer.addSublayer(myVideoLayer)
        
        // start session
        mySession.startRunning()
    }

    // MetaData Delegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        for data in metadataObjects {
            if data.type == AVMetadataObjectTypeQRCode {
                // open URL with QRCode stringValue
                var url : NSURL = NSURL(string: data.stringValue)!
                if UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }
}


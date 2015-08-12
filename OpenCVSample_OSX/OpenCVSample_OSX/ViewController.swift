//
//  ViewController.swift
//  OpenCVSample_OSX
//
//  Created by Hiroki Ishiura on 2015/08/12.
//  Copyright (c) 2015年 Hiroki Ishiura. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

	@IBOutlet weak var imageView: NSImageView!
	
	var session: AVCaptureSession!
	var device: AVCaptureDevice!
	var output: AVCaptureVideoDataOutput!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Using NSLayoutPriorityDefaultLow (=250) makes an error. (why?)
		self.imageView.setContentCompressionResistancePriority(250, forOrientation: NSLayoutConstraintOrientation.Horizontal)
		self.imageView.setContentCompressionResistancePriority(250, forOrientation: NSLayoutConstraintOrientation.Vertical)
		
		// Prepare a video capturing session.
		self.session = AVCaptureSession()
		self.session.sessionPreset = AVCaptureSessionPreset640x480
		for device in AVCaptureDevice.devices() {
			// My Mac does not support AVCaptureDevicePosition.Back. (always AVCaptureDevicePosition.Unspecified?)
			// A related implementation for iOS was removed on OSX.
			self.device = device as! AVCaptureDevice
		}
		if (self.device == nil) {
			println("no device")
			return
		}
		if let input = AVCaptureDeviceInput.deviceInputWithDevice(self.device, error: nil) as? AVCaptureDeviceInput {
			self.session.addInput(input)
		} else {
			println("no device input")
			return
		}
		self.output = AVCaptureVideoDataOutput()
		self.output.videoSettings = [ kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA ]
		let queue: dispatch_queue_t = dispatch_queue_create("videocapturequeue", nil)
		self.output.setSampleBufferDelegate(self, queue: queue)
		self.output.alwaysDiscardsLateVideoFrames = true
		if self.session.canAddOutput(self.output) {
			self.session.addOutput(self.output)
		} else {
			println("could not add a session output")
			return
		}
		// My Mac not support activeVideoMinFrameDuration.
		// A related implementation for iOS was removed on OSX.
		
		self.session.startRunning()
	}

	func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
		
		// Convert a captured image buffer to NSImage.
		let buffer: CVPixelBuffer! = CMSampleBufferGetImageBuffer(sampleBuffer)
		CVPixelBufferLockBaseAddress(buffer, 0)
		let imageRep = NSCIImageRep(CIImage: CIImage(CVImageBuffer: buffer))
		let capturedImage = NSImage(size: imageRep.size)
		capturedImage.addRepresentation(imageRep)
		CVPixelBufferUnlockBaseAddress(buffer, 0)

		// This is a filtering sample.
		let resultImage = OpenCV.cvtColorBGR2GRAY(capturedImage)
		
		// Show the result.
		dispatch_async(dispatch_get_main_queue(), {
			self.imageView.image = resultImage;
		})
	}
}


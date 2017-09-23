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
		self.imageView.setContentCompressionResistancePriority(250, for: NSLayoutConstraintOrientation.horizontal)
		self.imageView.setContentCompressionResistancePriority(250, for: NSLayoutConstraintOrientation.vertical)
		
		// Prepare a video capturing session.
		self.session = AVCaptureSession()
		self.session.sessionPreset = AVCaptureSession.Preset.vga640x480
		for device in AVCaptureDevice.devices() {
			// My Mac does not support AVCaptureDevicePosition.Back. (always AVCaptureDevicePosition.Unspecified?)
			// A related implementation for iOS was removed on OSX.
			self.device = device 
		}
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
		self.output.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
		let queue: DispatchQueue = DispatchQueue(label: "videocapturequeue", attributes: [])
		self.output.setSampleBufferDelegate(self, queue: queue)
		self.output.alwaysDiscardsLateVideoFrames = true
		if self.session.canAddOutput(self.output) {
			self.session.addOutput(self.output)
		} else {
			print("could not add a session output")
			return
		}
		// My Mac not support activeVideoMinFrameDuration.
		// A related implementation for iOS was removed on OSX.
		
		self.session.startRunning()
	}

	func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		
		// Convert a captured image buffer to NSImage.
		guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
			print("could not get a pixel buffer")
			return
		}
		CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
		let imageRep = NSCIImageRep(ciImage: CIImage(cvImageBuffer: buffer))
		let capturedImage = NSImage(size: imageRep.size)
		capturedImage.addRepresentation(imageRep)
		CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)

		// This is a filtering sample.
		let resultImage = OpenCV.cvtColorBGR2GRAY(capturedImage)
		
		// Show the result.
		DispatchQueue.main.async(execute: {
			self.imageView.image = resultImage;
		})
	}
}


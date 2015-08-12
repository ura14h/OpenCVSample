//
//  ViewController.swift
//  OpenCVSample_iOS
//
//  Created by Hiroki Ishiura on 2015/08/12.
//  Copyright (c) 2015年 Hiroki Ishiura. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

	@IBOutlet weak var imageView: UIImageView!
	
	var session: AVCaptureSession!
	var device: AVCaptureDevice!
	var output: AVCaptureVideoDataOutput!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Prepare a video capturing session.
		self.session = AVCaptureSession()
		self.session.sessionPreset = AVCaptureSessionPreset640x480
		for device in AVCaptureDevice.devices() {
			if (device.position == AVCaptureDevicePosition.Back) {
				self.device = device as! AVCaptureDevice
			}
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
		if self.device.lockForConfiguration(nil) {
			self.device.activeVideoMinFrameDuration = CMTimeMake(1, 20) // 20 fps
			self.device.unlockForConfiguration()
		} else {
			println("could not configure a device")
			return
		}

		self.session.startRunning()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func shouldAutorotate() -> Bool {
		return false
	}

	func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
		
		// Convert a captured image buffer to UIImage.
		let buffer: CVPixelBuffer! = CMSampleBufferGetImageBuffer(sampleBuffer)
		CVPixelBufferLockBaseAddress(buffer, 0)
		let address = CVPixelBufferGetBaseAddressOfPlane(buffer, 0)
		let bytes = CVPixelBufferGetBytesPerRow(buffer)
		let width = CVPixelBufferGetWidth(buffer)
		let height = CVPixelBufferGetHeight(buffer)
		let color = CGColorSpaceCreateDeviceRGB()
		let bits = 8
		let info = CGBitmapInfo((CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue) as UInt32)
		let context: CGContextRef = CGBitmapContextCreate(address, width, height, bits, bytes, color, info) as CGContextRef
		let imageRef: CGImageRef = CGBitmapContextCreateImage(context)
		let capturedImage = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Right)
		CVPixelBufferUnlockBaseAddress(buffer, 0)
		
		// This is a filtering sample.
		let opencvImage = OpenCV.cvtColorBGR2GRAY(capturedImage)
		let resultImage = UIImage(CGImage: opencvImage.CGImage, scale: 1.0, orientation: capturedImage!.imageOrientation) // Restore an orientation of captured image.

		// Show the result.
		dispatch_async(dispatch_get_main_queue(), {
			self.imageView.image = resultImage;
		})
	}
}


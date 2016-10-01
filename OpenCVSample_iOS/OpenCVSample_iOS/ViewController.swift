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
			if ((device as AnyObject).position == AVCaptureDevicePosition.back) {
				self.device = device as! AVCaptureDevice
			}
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
			try self.device.lockForConfiguration();
			self.device.activeVideoMinFrameDuration = CMTimeMake(1, 20) // 20 fps
			self.device.unlockForConfiguration()
		} catch {
			print("could not configure a device")
			return
		}

		self.session.startRunning()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override var shouldAutorotate : Bool {
		return false
	}

	func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
		
		// Convert a captured image buffer to UIImage.
		let buffer: CVPixelBuffer! = CMSampleBufferGetImageBuffer(sampleBuffer)
		CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
		let address = CVPixelBufferGetBaseAddressOfPlane(buffer, 0)
		let bytes = CVPixelBufferGetBytesPerRow(buffer)
		let width = CVPixelBufferGetWidth(buffer)
		let height = CVPixelBufferGetHeight(buffer)
		let color = CGColorSpaceCreateDeviceRGB()
		let bits = 8
		let info = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
		let context: CGContext? = CGContext(data: address, width: width, height: height, bitsPerComponent: bits, bytesPerRow: bytes, space: color, bitmapInfo: info)
		let image: CGImage? = context?.makeImage()
		let capturedImage = UIImage(cgImage: image!, scale: 1.0, orientation: UIImageOrientation.right)
		CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
		
		// This is a filtering sample.
		let opencvImage = OpenCV.cvtColorBGR2GRAY(capturedImage)
		let resultImage = UIImage(cgImage: (opencvImage?.cgImage!)!, scale: 1.0, orientation: capturedImage.imageOrientation) // Restore an orientation of captured image.

		// Show the result.
		DispatchQueue.main.async(execute: {
			self.imageView.image = resultImage;
		})
	}
}


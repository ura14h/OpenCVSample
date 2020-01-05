//
//  ViewController.swift
//  OpenCVSample_iOS
//
//  Created by Hiroki Ishiura on 2020/01/04.
//  Copyright © 2020 Hiroki Ishiura. All rights reserved.
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
		self.session.sessionPreset = AVCaptureSession.Preset.vga640x480 // not work in iOS simulator
		guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
			print("no device")
			return
		}
		self.device = device
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

		self.session.startRunning()
	}

	override var shouldAutorotate: Bool {
		return false
	}

	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		// Convert a captured image buffer to UIImage.
		guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
			print("could not get a pixel buffer")
			return
		}
		CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
		let image = CIImage(cvPixelBuffer: buffer).oriented(CGImagePropertyOrientation.right)
		let capturedImage = UIImage(ciImage: image)
		CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
		
		// This is a filtering sample.
		let resultImage = OpenCV.cvtColorBGR2GRAY(capturedImage)

		// Show the result.
		DispatchQueue.main.async(execute: {
			self.imageView.image = resultImage
		})
	}
}

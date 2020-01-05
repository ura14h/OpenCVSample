//
//  ViewController.swift
//  OpenCVSample_macOS
//
//  Created by Hiroki Ishiura on 2020/01/04.
//  Copyright © 2020 Hiroki Ishiura. All rights reserved.
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

		// Prepare a video capturing session.
		self.session = AVCaptureSession()
		self.session.sessionPreset = AVCaptureSession.Preset.vga640x480
		guard let device = AVCaptureDevice.default(.externalUnknown, for: .video, position: .unspecified) else {
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
		// A related implementation for iOS was removed on macOS.

		self.session.startRunning()
	}

	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
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
			self.imageView.image = resultImage
		})
	}
}

//
//  OpenCV.m
//  OpenCVSample_OSX
//
//  Created by Hiroki Ishiura on 2015/08/12.
//  Copyright (c) 2015年 Hiroki Ishiura. All rights reserved.
//

// Put OpenCV include files at the top. Otherwise an error happens.
#import <vector>
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc.hpp>

#import <Foundation/Foundation.h>
#import "OpenCV.h"

/// Converts an NSImage to Mat.
static void NSImageToMat(NSImage *image, cv::Mat &mat) {
	
	// Create a pixel buffer.
	NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
	NSInteger width = [bitmapImageRep pixelsWide];
	NSInteger height = [bitmapImageRep pixelsHigh];
	CGImageRef imageRef = [bitmapImageRep CGImage];
	cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef contextRef = CGBitmapContextCreate(mat8uc4.data, mat8uc4.cols, mat8uc4.rows, 8, mat8uc4.step, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
	
	// Draw all pixels to the buffer.
	cv::Mat mat8uc3 = cv::Mat((int)width, (int)height, CV_8UC3);
	cv::cvtColor(mat8uc4, mat8uc3, CV_RGBA2BGR);
	
	mat = mat8uc3;
}

/// Converts a Mat to NSImage.
static NSImage *MatToNSImage(cv::Mat &mat) {
	
	// Create a pixel buffer.
	assert(mat.elemSize() == 1 || mat.elemSize() == 3);
	cv::Mat matrgb;
	if (mat.elemSize() == 1) {
		cv::cvtColor(mat, matrgb, CV_GRAY2RGB);
	} else if (mat.elemSize() == 3) {
		cv::cvtColor(mat, matrgb, CV_BGR2RGB);
	}
	
	// Change a image format.
	NSData *data = [NSData dataWithBytes:matrgb.data length:(matrgb.elemSize() * matrgb.total())];
	CGColorSpaceRef colorSpace;
	if (matrgb.elemSize() == 1) {
		colorSpace = CGColorSpaceCreateDeviceGray();
	} else {
		colorSpace = CGColorSpaceCreateDeviceRGB();
	}
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	CGImageRef imageRef = CGImageCreate(matrgb.cols, matrgb.rows, 8, 8 * matrgb.elemSize(), matrgb.step.p[0], colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
	NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
	NSImage *image = [[NSImage alloc]init];
	[image addRepresentation:bitmapImageRep];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}

@implementation OpenCV

+ (nonnull NSImage *)cvtColorBGR2GRAY:(nonnull NSImage *)image {
	cv::Mat bgrMat;
	NSImageToMat(image, bgrMat);
	cv::Mat grayMat;
	cv::cvtColor(bgrMat, grayMat, CV_BGR2GRAY);
	NSImage *grayImage = MatToNSImage(grayMat);
	return grayImage;
}

@end

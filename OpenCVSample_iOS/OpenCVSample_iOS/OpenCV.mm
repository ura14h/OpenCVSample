//
//  OpenCV.m
//  OpenCVSample_iOS
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

/// Converts an UIImage to Mat.
/// Orientation of UIImage will be lost.
static void UIImageToMat(UIImage *image, cv::Mat &mat) {
	assert(image.size.width > 0 && image.size.height > 0);
	assert(image.CGImage != nil || image.CIImage != nil);

	// Create a pixel buffer.
	NSInteger width = image.size.width;
	NSInteger height = image.size.height;
	cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);

	// Draw all pixels to the buffer.
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (image.CGImage) {
		// Render with using Core Graphics.
		CGContextRef contextRef = CGBitmapContextCreate(mat8uc4.data, mat8uc4.cols, mat8uc4.rows, 8, mat8uc4.step, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
		CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
		CGContextRelease(contextRef);
	} else {
		// Render with using Core Image.
		static CIContext* context = nil; // I do not like this declaration contains 'static'. But it is for performance.
		if (!context) {
			context = [CIContext contextWithOptions:@{ kCIContextUseSoftwareRenderer: @NO }];
		}
		CGRect bounds = CGRectMake(0, 0, width, height);
		[context render:image.CIImage toBitmap:mat8uc4.data rowBytes:mat8uc4.step bounds:bounds format:kCIFormatRGBA8 colorSpace:colorSpace];
	}
	CGColorSpaceRelease(colorSpace);

	// Adjust byte order of pixel.
	cv::Mat mat8uc3 = cv::Mat((int)width, (int)height, CV_8UC3);
	cv::cvtColor(mat8uc4, mat8uc3, cv::COLOR_RGBA2BGR);
	
	mat = mat8uc3;
}

/// Converts a Mat to UIImage.
static UIImage *MatToUIImage(cv::Mat &mat) {
	
	// Create a pixel buffer.
	assert(mat.elemSize() == 1 || mat.elemSize() == 3);
	cv::Mat matrgb;
	if (mat.elemSize() == 1) {
		cv::cvtColor(mat, matrgb, cv::COLOR_GRAY2RGB);
	} else if (mat.elemSize() == 3) {
		cv::cvtColor(mat, matrgb, cv::COLOR_BGR2RGB);
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
	UIImage *image = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}

/// Restore the orientation to image.
static UIImage *RestoreUIImageOrientation(UIImage *processed, UIImage *original) {
	if (processed.imageOrientation == original.imageOrientation) {
		return processed;
	}
	return [UIImage imageWithCGImage:processed.CGImage scale:1.0 orientation:original.imageOrientation];
}

#pragma mark -

@implementation OpenCV

+ (nonnull UIImage *)cvtColorBGR2GRAY:(nonnull UIImage *)image {
	cv::Mat bgrMat;
	UIImageToMat(image, bgrMat);
	cv::Mat grayMat;
	cv::cvtColor(bgrMat, grayMat, cv::COLOR_BGR2GRAY);
	UIImage *grayImage = MatToUIImage(grayMat);
	return RestoreUIImageOrientation(grayImage, image);
}

@end

//
//  OpenCV.h
//  OpenCVSample_OSX
//
//  Created by Hiroki Ishiura on 2015/08/12.
//  Copyright (c) 2015年 Hiroki Ishiura. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OpenCV : NSObject

/// Converts a full color image to grayscale image with using OpenCV.
+ (NSImage *)cvtColorBGR2GRAY:(NSImage *)image;

@end

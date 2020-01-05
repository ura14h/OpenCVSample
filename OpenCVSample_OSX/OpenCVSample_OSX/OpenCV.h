//
//  OpenCV.h
//  OpenCVSample_OSX
//
//  Created by Hiroki Ishiura on 2020/01/04.
//  Copyright © 2020 Hiroki Ishiura. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCV : NSObject

/// Converts a full color image to grayscale image with using OpenCV.
+ (NSImage *)cvtColorBGR2GRAY:(NSImage *)image;

@end

NS_ASSUME_NONNULL_END

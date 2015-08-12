//
//  OpenCV.h
//  OpenCVSample_iOS
//
//  Created by Hiroki Ishiura on 2015/08/12.
//  Copyright (c) 2015年 Hiroki Ishiura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCV : NSObject

/// Converts a full color image to grayscale image with using OpenCV.
+ (UIImage *)cvtColorBGR2GRAY:(UIImage *)image;

@end

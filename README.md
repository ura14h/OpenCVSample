# OpenCVSample

Sample programs for OpenCV and Swift and iOS and macOS.

![Screenshot on iOS](Screenshot_ios.jpg)


## OpenCV

Those projects uses OpenCV version 3.4.1.
However, OpenCV binary isn't include in those projects.
You can get OpenCV binary by following steps.

### OpenCV for iOS

A binary version is available as it is.

1. Download `opencv-3.4.1-ios-framework.zip` from [https://github.com/opencv/opencv/releases/download/3.4.1/opencv-3.4.1-ios-framework.zip](https://github.com/opencv/opencv/releases/download/3.4.1/opencv-3.4.1-ios-framework.zip).
2. Unpack the file.
3. Copy `opencv2.framework` into `OpenCVSample_iOS` directory.

### OpenCV for macOS

No binary version, so you need to build a source version.

1. Prepare CMake. (e.g. `port install cmake`)
2. Download `opencv-3.4.1.zip` from [https://github.com/opencv/opencv/archive/3.4.1.zip](https://github.com/opencv/opencv/archive/3.4.1.zip).
3. Prepare a working directory. (e.g. `mkdir ~/foo`)
4. Unpack the file into the working directory.
5. Open terminal at the working directory. (e.g. `cd ~/foo`)
6. Run a build script by python 2. `python opencv-3.4.1/platforms/osx/build_framework.py osx`
7. Copy `osx/opencv2.framework` into `OpenCVSample_OSX` directory.


## Requirements

* macOS 10.14
* iOS 12.0
* Xcode 10.0
* Swift 4.2


## License

Please read [this file](LICENSE).

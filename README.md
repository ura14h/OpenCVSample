# OpenCVSample

Sample programs for OpenCV and Swift and iOS and macOS.

![Screenshot on iOS](Screenshot_ios.jpg)


## OpenCV

Those projects uses OpenCV version 4.0.1.
However, OpenCV binary isn't include in those projects.
You can get OpenCV binary by following steps.

### OpenCV for iOS

A binary version is available as it is.

1. Download `opencv-4.0.1-ios-framework.zip` from [https://github.com/opencv/opencv/releases/download/4.0.1/opencv-4.0.1-ios-framework.zip](https://github.com/opencv/opencv/releases/download/4.0.1/opencv-4.0.1-ios-framework.zip).
2. Unpack the file.
3. Copy `opencv2.framework` into `OpenCVSample_iOS` directory.

### OpenCV for macOS

No binary version, so you need to build a source version.

1. Prepare CMake. (e.g. `brew install cmake`)
2. Download `opencv-4.0.1.zip` from [https://github.com/opencv/opencv/archive/4.0.1.zip](https://github.com/opencv/opencv/archive/4.0.1.zip).
3. Prepare a working directory. (e.g. `mkdir ~/foo`)
4. Unpack the file into the working directory.
5. Open terminal at the working directory. (e.g. `cd ~/foo`)
6. *Oh! Xcode 10.2 cannot build OpenCV 4.0.1. You have to patch a build script in OpenCV.*
   1. Open `opencv-4.0.1/platforms/osx/build_framework.py` with text editor such as Xcode, vi or Emacs.
   2. Increase the number of `MACOSX_DEPLOYMENT_TARGET` from `10.9` to `10.12`.
   3. Save the file.
   > If you want to know detail of the issue, See also [https://github.com/opencv/opencv/issues/13759](https://github.com/opencv/opencv/issues/13759)
7. Run a build script by python 2. `python opencv-4.0.1/platforms/osx/build_framework.py osx`
8. Copy `osx/opencv2.framework` into `OpenCVSample_OSX` directory.


## Requirements

* macOS 10.14
* iOS 12.2
* Xcode 10.2
* Swift 5


## License

Please read [this file](LICENSE).

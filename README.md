# OpenCVSample

Sample programs for OpenCV and Swift and iOS and macOS.


## OpenCV

Those projects uses OpenCV version 3.3.0.
However, OpenCV binary isn't include in thorse projects.
You can get OpenCV binary by following steps.

### OpenCV for iOS

1. Download `opencv-3.3.0-ios-framework.zip` from [https://github.com/opencv/opencv/releases/download/3.3.0/opencv-3.3.0-ios-framework.zip](https://github.com/opencv/opencv/releases/download/3.3.0/opencv-3.3.0-ios-framework.zip).
2. Unpack the file.
3. Copy `opencv2.framework` into `OpenCVSample_iOS` directory.

> If using above the binary, the linker may report many warnings such 'direct access in function '`___cxx_global_var_init' from file...`' on build. :-(

### OpenCV for macOS

1. Prepare CMake. (e.g. `port install cmake`)
2. Download `opencv-3.3.0.zip` from [https://github.com/opencv/opencv/archive/3.3.0.zip](https://github.com/opencv/opencv/archive/3.3.0.zip).
3. Prepare a working directory. (e.g. `mkdir ~/foo`)
4. Unpack the file into the working directory.
5. Open terminal at the working directory. (e.g. `cd ~/foo`)
6. Run a build script. ``python opencv-3.3.0/platforms/osx/build_framework.py osx``
7. Copy `osx/opencv2.framework` into `OpenCVSample_OSX` directory.


## Requirements

* macOS 10.12.6 (Recommended)
* iOS 11.0 (Recommended)
* Xcode 9.0
* Swift 4.0


## License

Please read [this file](LICENSE).

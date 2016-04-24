# OpenCVSample

Sample programs for OpenCV and Swift and iOS and OS X.


## OpenCV

Those projects uses OpenCV version 3.1.0.
However, OpenCV binary isn't include in thorse projects.
You can get OpenCV binary by following steps.

### OpenCV for iOS

  1. Download `opencv2.framework.zip` from [http://sourceforge.net/projects/opencvlibrary/files/opencv-ios/3.1.0/](http://sourceforge.net/projects/opencvlibrary/files/opencv-ios/3.1.0/).
  2. Unpack the file.
  3. Copy `opencv2.framework` into `OpenCVSample_iOS` directory.

### OpenCV for OS X

  1. Prepare CMake. (e.g. `port install cmake`)
  2. Download `opencv-3.1.0.zip` from [https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.1.0/](https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.1.0/).
  3. Prepare a working directory. (e.g. `mkdir ~/foo`)
  4. Unpack the file into the working directory.
  5. Open terminal at the working directory. (e.g. `cd ~/foo`)
  6. Run a build script. ``python opencv-3.1.0/platforms/osx/build_framework.py osx``
  7. Copy `osx/opencv2.framework` into `OpenCVSample_OSX` directory.


## Requirements

* Mac OS X 10.11
* iOS 8.0
* Xcode 7.3
* Swift 2.2


## License

Please read [this file](LICENSE).

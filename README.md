XLRemoteImageView
=================

UIImageView categories that show a progress indicator while the image is being downloaded. It uses the same NSCache and NSOperation objects used in UIImageView+AFNetworking category. It looks like Instagram loading indicator. It has been tested on ios 5 & 6.

Installation
--------

The easiest way to integrate XLRemoteImageView in your projects is via [CocoaPods](http://cocoapods.org). 

1. Add the following line in the project's Podfile file.

`pod 'XLRemoteImageView'`

2. Run the command `pod install` from the Podfile folder directory.

You can also install XLRemoteImage manually. We don't recommend this approach.
The source files you will need are in XLRemoteImageView/XLRemoteImageView/XL folder. 


Example
--------

Take a look at `ViewController.m` in the example project for details on how to use this component. In short, though:


```objc
// show a circle progress indicator
[self.imageView setImageWithProgressIndicatorAndURL:[NSURL URLWithString:url]];
```

UIImageView+XLProgressIndicator.h adds other helper methods:

```objc
// same behaviour as previous method showing a placeholder image while the download is in progress.
-(void)setImageWithProgressIndicatorAndURL:(NSURL *)url
                          placeholderImage:(UIImage *)placeholderImage
```

and

```objc
-(void)setImageWithProgressIndicatorAndURL:(NSURL *)url
                          placeholderImage:(UIImage *)placeholderImage
                       imageDidAppearBlock:(void (^)(UIImageView *))imageDidAppearBlock
```

The above methods use UIImageView+XLNetworking category, that let you know the image download progress.

```objc
- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
         downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock;
```


![Screenshot](https://raw.github.com/xmartlabs/XLRemoteImageView/master/screenshot.png)


Appearance customization
--------

```objc

// progress color, yellow color in the example image.
[[XLCircleProgressIndicator appearance] setStrokeProgressColor:[UIColor colorWithHex:COLOR_PROGRESSBAR_PROGRESS]];

// remaining color, gray color in the example image
[[XLCircleProgressIndicator appearance] setStrokeRemainingColor:[UIColor colorWithHex:COLOR_PROGRESSBAR_BACKGROUND]];

//In order to set up the circle stroke's width you can choose between these 2 ways.
[[XLCircleProgressIndicator appearance] setStrokeWidth:3.0f];

//or 

//the width of the circle stroke gets calculated based on the UIImageView size,
//[[XLCircleProgressIndicator appearance] setStrokeWidthRatio:0.15f];

```


XLRemoteImageView files
--------

1. `UIImageView+XLNetworking.h`. UIImageView category that allow us to know the download progress of an image using NSCache and NSOperation used by AFNetworking.
2. `UIImageView+XLProgressIndicator.h`. UIImageView category that allow us to show an circle progress view indicator on a UIImageView while its UIImage is being downloaded.
3. `XLCircleProgressIndicator.h`. UIView that shows a circle progress view. This source code is based on: https://github.com/swissmanu/MACircleProgressIndicator.

License
--------
XLRemoteImageView is distributed under MIT license, please feel free to use it and contribute.

Contact
--------

If you are using XLRemoteImageView in your project and have any suggestion or question:

Martin Barreto, <martin@xmartlabs.com>

[@Xmartlabs](http://www.xmartlabs.com)
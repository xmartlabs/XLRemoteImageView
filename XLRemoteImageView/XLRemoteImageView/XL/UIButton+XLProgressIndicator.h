//
//  UIButton+XLProgressIndicator.h
//  XLRemoteImageView
//
//  Created by Martin Barreto on 9/4/13.
//  Modified by Tobias Hagemann on 9/1/14.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCircleProgressIndicator.h"

@interface UIButton (XLProgressIndicator)

@property (nonatomic, readonly) XLCircleProgressIndicator * progressIndicatorView;

/**
 Creates and enqueues an image request operation, which asynchronously downloads the image from the specified URL, and sets it the request is finished. Any previous image request for the receiver will be cancelled. If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished. A progress indicator will appear if the image has to be fetched from a server.
 
 By default, URL requests have a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 
 @param state The control state.
 @param url The URL used for the image request.
 */
-(void)setImageForState:(UIControlState)state withProgressIndicatorAndURL:(NSURL *)url;

/**
 Creates and enqueues an image request operation, which asynchronously downloads the image from the specified URL, and sets it the request is finished. Any previous image request for the receiver will be cancelled. If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished. A progress indicator will appear if the image has to be fetched from a server.
 
 By default, URL requests have a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 
 @param state The control state.
 @param url The URL used for the image request.
 @param indicatorCenter The center point of indicator view.
 */
-(void)setImageForState:(UIControlState)state withProgressIndicatorAndURL:(NSURL *)url indicatorCenter:(CGPoint)indicatorCenter;

/**
 Creates and enqueues an image request operation, which asynchronously downloads the image from the specified URL. Any previous image request for the receiver will be cancelled. If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished. A progress indicator will appear if the image has to be fetched from a server.
 
 By default, URL requests have a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 
 @param state The control state.
 @param url The URL used for the image request.
 @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
 */
-(void)setImageForState:(UIControlState)state withProgressIndicatorAndURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

/**
 Creates and enqueues an image request operation, which asynchronously downloads the image from the specified URL. Any previous image request for the receiver will be cancelled. If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished. A progress indicator will appear if the image has to be fetched from a server.
 
 By default, URL requests have a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 
 @param state The control state.
 @param url The URL used for the image request.
 @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
 @param imageDidAppearBlock A block to be executed when the image download finishes successfully, This block has no return value and takes one arguments: the UIButton loaded. For example, you can use this parameter for show a play button after the download  finishes.
 */
-(void)setImageForState:(UIControlState)state withProgressIndicatorAndURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage imageDidAppearBlock:(void(^)(UIButton * imageView))imageDidAppearBlock;

/**
 Creates and enqueues an image request operation, which asynchronously downloads the image from the specified URL. Any previous image request for the receiver will be cancelled. If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished. A progress indicator will appear if the image has to be fetched from a server.
 
 By default, URL requests have a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 
 @param state The control state.
 @param url The URL used for the image request.
 @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
 @param imageDidAppearBlock A block to be executed when the image download finishes successfully, This block has no return value and takes one arguments: the UIButton loaded. For example, you can use this parameter for show a play button after the download  finishes.
 @param indicatorCenter The center point of indicator view.
 */
-(void)setImageForState:(UIControlState)state withProgressIndicatorAndURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage imageDidAppearBlock:(void (^)(UIButton *))imageDidAppearBlock progressIndicatorCenterPoint:(CGPoint)indicatorCenter;


@end

//
//  UIImageView+XLNetworking.m
//  XLRemoteImageView
//
//  Created by Martin Barreto on 9/3/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "UIImageView+XLNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "XLCircleProgressIndicator.h"
#import <objc/message.h>


@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

@interface UIImageView (_XLNetworking)

@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;

@end

@implementation UIImageView (_XLNetworking)

@dynamic af_imageRequestOperation;

@end



@implementation UIImageView (XLNetworking)



- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
         downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock

{
    [self cancelImageRequestOperation];
    // get AFNetworking UIImageView cache
    AFImageCache * cache =  (AFImageCache *)objc_msgSend([self class], @selector(af_sharedImageCache));
    // try to get the image from cache
    UIImage * cachedImage = [cache cachedImageForRequest:urlRequest];
//    UIImage* cachedImage = objc_msgSend(cache, @selector(cachedImageForRequest:), urlRequest);
    if (cachedImage) {
        self.af_imageRequestOperation = nil;
        
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        
        AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
		
#ifdef _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_
		requestOperation.allowsInvalidSSLCertificate = YES;
#endif
		
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }
                
                if (success) {
                    success(operation.request, operation.response, responseObject);
                } else if (responseObject) {
                    self.image = responseObject;
                }
            }
            // cache the image recently fetched.
            [cache cacheImage:responseObject forRequest:urlRequest];
//            objc_msgSend(cache, @selector(cacheImage:forRequest:), responseObject, urlRequest);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }
                
                if (failure) {
                    failure(operation.request, operation.response, error);
                }
            }
        }];
        
        if (downloadProgressBlock){
            [requestOperation setDownloadProgressBlock:downloadProgressBlock];
        }
        self.af_imageRequestOperation = requestOperation;
        // get the NSOperation associated to UIImageViewClass
        NSOperationQueue * operationQueue =  (NSOperationQueue *)objc_msgSend([self class], @selector(af_sharedImageRequestOperationQueue));
        [operationQueue addOperation:self.af_imageRequestOperation];
    }
}


@end

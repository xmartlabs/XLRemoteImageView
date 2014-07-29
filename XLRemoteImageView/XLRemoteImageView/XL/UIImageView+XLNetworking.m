//
//  UIImageView+XLNetworking.m
//  XLRemoteImageView
//
//  Created by Martin Barreto on 9/3/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "UIImageView+XLNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "XLCircleProgressIndicator.h"
#import <objc/message.h>


@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

@interface UIImageView (_XLNetworking)

@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFHTTPRequestOperation *af_imageRequestOperation;

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
    AFImageCache * cache =  (AFImageCache *)objc_msgSend([self class], @selector(sharedImageCache));
    // try to get the image from cache
    UIImage * cachedImage = [cache cachedImageForRequest:urlRequest];
    if (cachedImage) {
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
        
        self.af_imageRequestOperation = nil;
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        
        __weak __typeof(self) weakSelf = self;
        self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        self.af_imageRequestOperation.responseSerializer = self.imageResponseSerializer;
        [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if ([[urlRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
                if (success) {
                    success(urlRequest, operation.response, responseObject);
                } else if (responseObject) {
                    strongSelf.image = responseObject;
                }
                
                if (operation == strongSelf.af_imageRequestOperation){
                    strongSelf.af_imageRequestOperation = nil;
                }
            }
            // cache the image recently fetched.
            [cache cacheImage:responseObject forRequest:urlRequest];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([[urlRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
                if (failure) {
                    failure(urlRequest, operation.response, error);
                }
                
                if (operation == strongSelf.af_imageRequestOperation){
                    strongSelf.af_imageRequestOperation = nil;
                }
            }
        }];
        
        if (downloadProgressBlock){
            [self.af_imageRequestOperation setDownloadProgressBlock:downloadProgressBlock];
        }
        // get the NSoperationQueue associated With UIImageView class
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        NSOperationQueue * operationQueue =  (NSOperationQueue *)objc_msgSend([self class], @selector(af_sharedImageRequestOperationQueue));
        #pragma clang diagnostic pop
        [operationQueue addOperation:self.af_imageRequestOperation];
    }
}


@end

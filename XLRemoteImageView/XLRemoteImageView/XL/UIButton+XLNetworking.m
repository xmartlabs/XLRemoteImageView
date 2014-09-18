//
//  UIButton+XLNetworking.m
//  XLRemoteImageView
//
//  Created by Martin Barreto on 9/3/13.
//  Modified by Tobias Hagemann on 9/1/14.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "UIButton+XLNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIButton+AFNetworking.h>
#import "XLCircleProgressIndicator.h"
#import <objc/message.h>


@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

@interface UIButton (_XLNetworking)

@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFHTTPRequestOperation *af_imageRequestOperation;

@end

@implementation UIButton (_XLNetworking)

@dynamic af_imageRequestOperation;

@end



@implementation UIButton (XLNetworking)



- (void)setImageForState:(UIControlState)state
          withURLRequest:(NSURLRequest *)urlRequest
        placeholderImage:(UIImage *)placeholderImage
                 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
   downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock

{
    [self cancelImageRequestOperationForState:state];
    
    if (placeholderImage) {
        [self setImage:placeholderImage forState:state];
    }
    
    __weak __typeof(self) weakSelf = self;
    self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    self.af_imageRequestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([[urlRequest URL] isEqual:[strongSelf.af_imageRequestOperation.request URL]]) {
            if (success) {
                success(urlRequest, operation.response, responseObject);
            } else if (responseObject) {
                [strongSelf setImage:responseObject forState:state];
            }
            
            if (operation == strongSelf.af_imageRequestOperation){
                strongSelf.af_imageRequestOperation = nil;
            }
        }
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
    // get the NSoperationQueue associated With UIButton class
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    NSOperationQueue * operationQueue =  (NSOperationQueue *)objc_msgSend([self class], @selector(af_sharedImageRequestOperationQueue));
    #pragma clang diagnostic pop
    [operationQueue addOperation:self.af_imageRequestOperation];
}


@end

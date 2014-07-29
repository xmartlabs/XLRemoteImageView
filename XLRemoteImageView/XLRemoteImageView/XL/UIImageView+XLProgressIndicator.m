//
//  UIImageView+XLProgressIndicator.m
//  XLRemoteImageView
//
//  Created by Martin Barreto on 9/4/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "UIImageView+XLProgressIndicator.h"
#import "UIImageView+XLNetworking.h"
#import "XLCircleProgressIndicator.h"
#import <objc/runtime.h>

static char kXLImageProgressIndicatorKey;

@interface UIImageView (_XLProgressIndicator)

@property (readwrite, nonatomic, strong, setter = xl_setProgressIndicatorView:) XLCircleProgressIndicator *xl_progressIndicatorView;

@end

@implementation UIImageView (_XLProgressIndicator)

@dynamic xl_progressIndicatorView;

@end

@implementation UIImageView (XLProgressIndicator)

-(XLCircleProgressIndicator *)progressIndicatorView
{
    return [self xl_progressIndicatorView];
}


-(void)xl_setProgressIndicatorView:(XLCircleProgressIndicator *)xl_progressIndicatorView
{
    objc_setAssociatedObject(self, &kXLImageProgressIndicatorKey, xl_progressIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(XLCircleProgressIndicator *)xl_progressIndicatorView
{
    XLCircleProgressIndicator * progressIndicator = (XLCircleProgressIndicator *)objc_getAssociatedObject(self, &kXLImageProgressIndicatorKey);
    if (progressIndicator) return progressIndicator;
    progressIndicator = [[XLCircleProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    progressIndicator.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    progressIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self xl_setProgressIndicatorView:progressIndicator];
    return progressIndicator;
}


-(void)setImageWithProgressIndicatorAndURL:(NSURL *)url
{
    [self setImageWithProgressIndicatorAndURL:url placeholderImage:nil];
}

-(void)setImageWithProgressIndicatorAndURL:(NSURL *)url indicatorCenter:(CGPoint)indicatorCenter
{
    [self setImageWithProgressIndicatorAndURL:url placeholderImage:Nil imageDidAppearBlock:nil progressIndicatorCenterPoint:indicatorCenter];
}

-(void)setImageWithProgressIndicatorAndURL:(NSURL *)url
                          placeholderImage:(UIImage *)placeholderImage
{
    [self setImageWithProgressIndicatorAndURL:url placeholderImage:placeholderImage imageDidAppearBlock:nil progressIndicatorCenterPoint:self.center];
}

- (void)setImageWithProgressIndicatorAndURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
                        imageDidAppearBlock:(void (^)(UIImageView *))imageDidAppearBlock
{
    [self setImageWithProgressIndicatorAndURL:url
                             placeholderImage:placeholderImage
                          imageDidAppearBlock:imageDidAppearBlock
                 progressIndicatorCenterPoint:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2)];
}

-(void)setImageWithProgressIndicatorAndURL:(NSURL *)url
                          placeholderImage:(UIImage *)placeholderImage
                       imageDidAppearBlock:(void (^)(UIImageView *))imageDidAppearBlock
              progressIndicatorCenterPoint:(CGPoint)indicatorCenter
{
    [self setImage:nil];
    [self.xl_progressIndicatorView setProgressValue:0.0f];
    if (![self.xl_progressIndicatorView superview]){
        [self addSubview:self.xl_progressIndicatorView];
    }
    //self.xl_progressIndicatorView.center = indicatorCenter;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __typeof__(self) __weak weakSelf = self;
    [self setImageWithURLRequest:request
                placeholderImage:placeholderImage
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             [weakSelf.xl_progressIndicatorView removeFromSuperview];
                             weakSelf.image = image;
                             if (imageDidAppearBlock){
                                 imageDidAppearBlock(weakSelf);
                             }
                         }
                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                             [weakSelf.xl_progressIndicatorView setProgressValue:0.0f];
                         }
           downloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
               float newValue = ((float)totalBytesRead / totalBytesExpectedToRead);
               [weakSelf.xl_progressIndicatorView setProgressValue:newValue];
           }];
}

@end

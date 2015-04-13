//
//  UIButton+XLProgressIndicator.m
//  XLRemoteImageView
//
//  Created by Martin Barreto on 9/4/13.
//  Modified by Tobias Hagemann on 9/1/14.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "UIButton+XLProgressIndicator.h"
#import "UIButton+XLNetworking.h"
#import "XLCircleProgressIndicator.h"
#import <objc/runtime.h>

static char kXLImageProgressIndicatorKey;

@interface UIButton (_XLProgressIndicator)

@property (readwrite, nonatomic, strong, setter = xl_setProgressIndicatorView:) XLCircleProgressIndicator *xl_progressIndicatorView;

@end

@implementation UIButton (_XLProgressIndicator)

@dynamic xl_progressIndicatorView;

@end

@implementation UIButton (XLProgressIndicator)

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


-(void)setImageWithProgressIndicatorForState:(UIControlState)state withURL:(NSURL *)url
{
    [self setImageWithProgressIndicatorForState:state withURL:url placeholderImage:nil];
}

-(void)setImageWithProgressIndicatorForState:(UIControlState)state withURL:(NSURL *)url indicatorCenter:(CGPoint)indicatorCenter
{
    [self setImageWithProgressIndicatorForState:state withURL:url placeholderImage:Nil imageDidAppearBlock:nil progressIndicatorCenterPoint:indicatorCenter];
}

-(void)setImageWithProgressIndicatorForState:(UIControlState)state withURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
    [self setImageWithProgressIndicatorForState:state withURL:url placeholderImage:placeholderImage imageDidAppearBlock:nil progressIndicatorCenterPoint:self.center];
}

- (void)setImageWithProgressIndicatorForState:(UIControlState)state withURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
                          imageDidAppearBlock:(void (^)(UIButton *))imageDidAppearBlock
{
    [self setImageWithProgressIndicatorForState:state
                                        withURL:url
                               placeholderImage:placeholderImage
                            imageDidAppearBlock:imageDidAppearBlock
                   progressIndicatorCenterPoint:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2)];
}

-(void)setImageWithProgressIndicatorForState:(UIControlState)state
                                     withURL:(NSURL *)url
                            placeholderImage:(UIImage *)placeholderImage
                         imageDidAppearBlock:(void (^)(UIButton *))imageDidAppearBlock
                progressIndicatorCenterPoint:(CGPoint)indicatorCenter
{
    [self setImage:nil forState:state];
    [self.xl_progressIndicatorView setProgressValue:0.0f];
    if (![self.xl_progressIndicatorView superview]){
        [self addSubview:self.xl_progressIndicatorView];
    }
    //self.xl_progressIndicatorView.center = indicatorCenter;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __typeof__(self) __weak weakSelf = self;
    [self setImageForState:state
            withURLRequest:request
          placeholderImage:placeholderImage
                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                       [weakSelf.xl_progressIndicatorView removeFromSuperview];
                       [weakSelf setImage:image forState:state];
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

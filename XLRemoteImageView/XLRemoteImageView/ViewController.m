//
//  ViewController.m
//  XLRemoteImageView
//
//  Created by Martin Barreto on 9/2/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+XLNetworking.h"
#import "UIImageView+XLProgressIndicator.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController ()

@property (nonatomic) UIImageView *imageView;
@property int countRefresh;


@end

@implementation ViewController

@synthesize imageView = _imageView;
@synthesize countRefresh = _countRefresh;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor: [UIColor whiteColor]];
    [self.view addSubview:self.imageView];
    [self refreshImage:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - properties

-(UIImageView *)imageView{
    if (_imageView) return _imageView;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.bounds.size.width, 320)];
    [_imageView setBackgroundColor:[UIColor colorWithRed:0.84 green:0.85 blue:0.86 alpha:0.9f]];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    return _imageView;
}


#pragma mark - example

- (IBAction)refreshImage:(UIBarButtonItem *)sender {
    // use another url to prevent cache usage
    NSString * url = [NSString stringWithFormat:@"https://raw.githubusercontent.com/xmartlabs/XLRemoteImageView/master/screenshot.png?countRefresh=%i", self.countRefresh];
    self.countRefresh += 1;
    
    [self.imageView setImageWithProgressIndicatorAndURL:[NSURL URLWithString:url]];
}



@end

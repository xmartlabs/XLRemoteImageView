/**
/ Source based on https://github.com/swissmanu/MACircleProgressIndicator
*/

#import "XLCircleProgressIndicator.h"

#define kXLCircleProgressIndicatorDefaultStrokeProgressColor      [UIColor redColor]
#define kXLCircleProgressIndicatorDefaultStrokeRemainingColor     [[UIColor redColor] colorWithAlphaComponent:0.1f]
#define kXLCircleProgressIndicatorDefaultStrokeWidthRatio         0.10

@interface XLCircleProgressIndicator ()
@end

@implementation XLCircleProgressIndicator

@synthesize strokeWidth          = _strokeWidth;
@synthesize strokeProgressColor  = _strokeProgressColor;
@synthesize strokeRemainingColor = _strokeRemainingColor;
@synthesize strokeWidthRatio     = _strokeWidthRatio;
@synthesize progressValue        = _progressValue;


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

-(void)setDefaultValues {
    self.backgroundColor    = [UIColor clearColor];
    _strokeProgressColor    = kXLCircleProgressIndicatorDefaultStrokeProgressColor;
    _strokeRemainingColor   = kXLCircleProgressIndicatorDefaultStrokeRemainingColor;
    _strokeWidthRatio       = kXLCircleProgressIndicatorDefaultStrokeWidthRatio;
}


#pragma mark - Properties

-(void)setProgressValue:(float)progressValue {
    if (progressValue < 0.0) progressValue = 0.0;
    if (progressValue > 1.0) progressValue = 1.0;
    _progressValue = progressValue;
    [self setNeedsDisplay];
}

-(void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidthRatio = -1.0;
    _strokeWidth = strokeWidth;
    [self setNeedsDisplay];
}

-(void)setStrokeWidthRatio:(CGFloat)strokeWidthRatio {
    _strokeWidth = -1.0;
    _strokeWidthRatio = strokeWidthRatio;
    [self setNeedsDisplay];
}

-(void)setStrokeProgressColor:(UIColor *)strokeProgressColor{
    _strokeProgressColor = strokeProgressColor;
    [self setNeedsDisplay];
}

-(void)setStrokeRemainingColor:(UIColor *)strokeRemainingColor{
    _strokeRemainingColor = strokeRemainingColor;
    [self setNeedsDisplay];
}


#pragma mark - draw progress indicator view

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    float minSize =  MIN(rect.size.width, rect.size.height);
    float lineWidth = _strokeWidth;
    if(lineWidth == -1.0) lineWidth = minSize * _strokeWidthRatio;
    float radius = (minSize - lineWidth) / 2.0;
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextRotateCTM(context, -M_PI * 0.5);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextBeginPath(context);
    CGContextAddArc(context, 0, 0, radius, 0, 2 * M_PI, 0);
    CGContextSetStrokeColorWithColor(context, _strokeRemainingColor.CGColor);
    CGContextStrokePath(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, 0, 0, radius, 0, M_PI * (_progressValue * 2), 0);
    CGContextSetStrokeColorWithColor(context, _strokeProgressColor  .CGColor);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end

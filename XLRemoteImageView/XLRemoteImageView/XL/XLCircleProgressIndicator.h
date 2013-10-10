/**
 / Source based on https://github.com/swissmanu/MACircleProgressIndicator
 */


#import <UIKit/UIKit.h>

@interface XLCircleProgressIndicator : UIView

/**
 Progress value. Pass a float number between 0.0 and 1.0 to update the progress indicator
 */
@property (nonatomic) float progressValue;

/**
 The color used to show the progress.
 */
@property (nonatomic) UIColor * strokeProgressColor UI_APPEARANCE_SELECTOR;

/**
 The color used to show the remaining porcentage to complete the load.
 */
@property (nonatomic) UIColor * strokeRemainingColor UI_APPEARANCE_SELECTOR;

/**
 If you set this property the stroke width is calculated using the actual size of the progress indicator view instead of strokeWidth property.
 */
@property (nonatomic) CGFloat strokeWidthRatio UI_APPEARANCE_SELECTOR;

/**
 Configure the stroke widht of the progress indicator circle explicitly. When configured, strokeWidthRatio is ignored.
 */
@property (nonatomic) CGFloat strokeWidth UI_APPEARANCE_SELECTOR;

/**
 Configure size of CircleProgressIndicator by default 100 */

@property (nonatomic) CGFloat minimumSize UI_APPEARANCE_SELECTOR;

@end

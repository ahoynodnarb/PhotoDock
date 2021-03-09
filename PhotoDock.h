#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
@interface SBDockView : UIView
@property(nonatomic, retain) UIView *backgroundView;
@end
BOOL isEnabled = YES;
BOOL blurEnabled = NO;
float blurIntensity = 1.0f;
UIImage *dockImage;
static UIImageView *dockImageView;
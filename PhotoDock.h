#import <UIKit/UIKit.h>
@interface SBDockView : UIView
@property(nonatomic, retain) UIView *backgroundView;
@end
static BOOL isEnabled = YES;
static BOOL blurEnabled = NO;
static int blurType = 0;
static float blurIntensity = 0.0f;
static UIImage *dockImage;
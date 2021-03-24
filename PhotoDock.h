#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
@interface UIView ()
@property(assign, setter=_setCornerRadius:, nonatomic) double _cornerRadius;
@property(nonatomic, retain) UIView *backgroundView;
@end
@interface SBDockView : UIView
@end
@interface SBFloatingDockPlatterView : UIView
@end
BOOL isEnabled = YES;
BOOL blurEnabled = NO;
float blurIntensity = 1.0f;
UIImage *dockImage;
int blurType = 0;
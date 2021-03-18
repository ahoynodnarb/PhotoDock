#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
@interface UIView ()
@property(assign, setter=_setCornerRadius:, nonatomic) double _cornerRadius;
@end
@interface SBDockView : UIView
@property(nonatomic, retain) UIView *backgroundView;
@end
@interface SBFloatingDockPlatterView : UIView
@property(nonatomic, retain) UIView *backgroundView;
@end
BOOL isEnabled = YES;
BOOL blurEnabled = NO;
float blurIntensity = 1.0f;
UIImage *dockImage;
int blurType = 0;
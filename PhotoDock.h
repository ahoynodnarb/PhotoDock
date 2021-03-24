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
UIImage *dockImage;
BOOL blurEnabled = NO;
int blurType = 0;
float blurIntensity = 1.0f;
BOOL customRadiusEnabled = NO;
float customRadius = 35.0f; //default
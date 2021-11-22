@interface SBDockView : UIView
@property (nonatomic, strong) UIImageView *dockImageView;
@property (nonatomic, strong) UIView *backgroundView;
- (void)updateBackgroundView;
@end
@interface SBFloatingDockView : UIView
@property (nonatomic, strong) UIImageView *dockImageView;
@property (nonatomic, strong) UIView *backgroundView;
- (void)updateBackgroundView;
@end
BOOL isEnabled;
UIImage *dockImage;
BOOL blurEnabled;
int blurType;
float blurIntensity;
BOOL customRadiusEnabled;
float customRadius;
@interface SBDockView : UIView
@property (nonatomic, strong) UIImageView *dockImageView;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) UIView *backgroundView;
- (void)updateBackgroundView;
- (void)updateDockImageView;
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
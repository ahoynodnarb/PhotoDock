@interface SBDockView : UIView
@property (nonatomic, strong) UIImageView *dockImageView;
@property(nonatomic, retain) UIView *backgroundView;
- (void)updateBackgroundView:(UIView *)backgroundView;
@end
@interface SBFloatingDockView : UIView
@property (nonatomic, strong) UIImageView *dockImageView;
@property(nonatomic, retain) UIView *backgroundView;
- (void)updateBackgroundView:(UIView *)backgroundView;
@end
BOOL isEnabled;
UIImage *dockImage;
BOOL blurEnabled;
int blurType;
float blurIntensity;
BOOL customRadiusEnabled;
float customRadius;
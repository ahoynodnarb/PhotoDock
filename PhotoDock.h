#import <UIKit/UIKit.h>
@interface UIView ()
@property(assign, setter=_setCornerRadius:, nonatomic) double _cornerRadius;
@property(nonatomic, retain) UIView *backgroundView;
@end
@interface SBDockView : UIView
@end
@interface SBFloatingDockView : UIView
@end
BOOL isEnabled = YES;
UIImage *dockImage;
BOOL blurEnabled = NO;
int blurType = 0;
float blurIntensity = 1.0f;
BOOL customRadiusEnabled = NO;
float customRadius = 35.0f; //default
UIImageView *dockImageView;

void setDockBGImage(UIView *targetView) {
    if (isEnabled && dockImage) {
        dockImageView = [[UIImageView alloc] initWithImage:dockImage];
        [dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [dockImageView setClipsToBounds:YES];
        [dockImageView setContentMode:UIViewContentModeScaleAspectFill];
        if (blurEnabled) {
            long validBlurs[3] = {4, 2, 1};
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:validBlurs[blurType]]];
            [blurEffectView setFrame:dockImageView.bounds];
            [blurEffectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [blurEffectView setContentMode:UIViewContentModeScaleAspectFill];
            [blurEffectView setClipsToBounds:YES];
            blurEffectView.alpha = blurIntensity;
            [dockImageView addSubview:blurEffectView];
        }
        if (customRadiusEnabled) {
            dockImageView._cornerRadius = customRadius;
        }
        if(targetView) {
            targetView.backgroundView = dockImageView;
        }
    }
}
void refreshPrefs() {
    NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.popsicletreehouse.photodockprefs"];
    isEnabled = [bundleDefaults objectForKey:@"isEnabled"] ? [[bundleDefaults objectForKey:@"isEnabled"] boolValue] : YES;
    dockImage = [UIImage imageWithData:[bundleDefaults valueForKey:@"dockImage"]];
    blurEnabled = [bundleDefaults objectForKey:@"isBlurEnabled"] ? [[bundleDefaults objectForKey:@"isBlurEnabled"] boolValue] : NO;
    blurType = [bundleDefaults objectForKey:@"blurType"] ? [[bundleDefaults objectForKey:@"blurType"] intValue] : 0;
    blurIntensity = [bundleDefaults objectForKey:@"blurAlpha"] ? [[bundleDefaults objectForKey:@"blurAlpha"] floatValue] : 1.0f;
    customRadiusEnabled = [bundleDefaults objectForKey:@"customRadiusEnabled"] ? [[bundleDefaults objectForKey:@"customRadiusEnabled"] boolValue] : NO;
    customRadius = [bundleDefaults objectForKey:@"customRadius"] ? [[bundleDefaults objectForKey:@"customRadius"] floatValue] : 35.0f;
}

void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    refreshPrefs();
    setDockBGImage(nil);
}
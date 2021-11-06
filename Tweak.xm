#import "PhotoDock.h"

void refreshPrefs() {
    NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.popsicletreehouse.photodockprefs"];
    isEnabled = [bundleDefaults objectForKey:@"isEnabled"] ? [[bundleDefaults objectForKey:@"isEnabled"] boolValue] : YES;
    dockImage = [UIImage imageWithData:[bundleDefaults valueForKey:@"dockImage"]];
    blurEnabled = [bundleDefaults objectForKey:@"isBlurEnabled"] ? [[bundleDefaults objectForKey:@"isBlurEnabled"] boolValue] : NO;
    blurType = [bundleDefaults objectForKey:@"blurType"] ? [[bundleDefaults objectForKey:@"blurType"] intValue] : 0;
    blurIntensity = [bundleDefaults objectForKey:@"blurAlpha"] ? [[bundleDefaults objectForKey:@"blurAlpha"] floatValue] : 1.0f;
    customRadiusEnabled = [bundleDefaults objectForKey:@"customRadiusEnabled"] ? [[bundleDefaults objectForKey:@"customRadiusEnabled"] boolValue] : NO;
    customRadius = [bundleDefaults objectForKey:@"customRadius"] ? [[bundleDefaults objectForKey:@"customRadius"] floatValue] : 34.5f;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBackgroundView" object:nil];
}

void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    refreshPrefs();
}

%hook SBDockView
%property (nonatomic, strong) UIImageView *dockImageView;
%new
- (void)updateBackgroundView:(UIView *)backgroundView {
    if (isEnabled && dockImage) {
        [backgroundView setClipsToBounds:YES];
        [self.dockImageView removeFromSuperview];
        self.dockImageView = [[UIImageView alloc] initWithImage:dockImage];
        self.dockImageView.frame = backgroundView.bounds;
        [self.dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.dockImageView setContentMode:UIViewContentModeScaleAspectFill];
        if (blurEnabled) {
            long validBlurs[3] = {4, 2, 1};
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:validBlurs[blurType]]];
            [blurEffectView setFrame:self.dockImageView.bounds];
            [blurEffectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [blurEffectView setContentMode:UIViewContentModeScaleAspectFill];
            [blurEffectView setClipsToBounds:YES];
            blurEffectView.alpha = blurIntensity;
            [self.dockImageView addSubview:blurEffectView];
        }
        if (customRadiusEnabled) [backgroundView.layer setCornerRadius:customRadius];
        else [backgroundView.layer setCornerRadius:34.5f];
        [backgroundView addSubview:self.dockImageView];
    }
}
- (UIView *)backgroundView {
    [self updateBackgroundView:%orig];
    return %orig;
}
- (id)initWithDockListView:(id)arg1 forSnapshot:(BOOL)arg2 {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"updateBackgroundView" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
        [self updateBackgroundView:self.backgroundView];
    }];
    return %orig;
}
%end

%hook SBFloatingDockView
%property (nonatomic, strong) UIImageView *dockImageView;
%new
- (void)updateBackgroundView:(UIView *)backgroundView {
    if (isEnabled && dockImage) {
        [backgroundView setClipsToBounds:YES];
        [self.dockImageView removeFromSuperview];
        self.dockImageView = [[UIImageView alloc] initWithImage:dockImage];
        self.dockImageView.frame = backgroundView.bounds;
        [self.dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.dockImageView setContentMode:UIViewContentModeScaleAspectFill];
        if (blurEnabled) {
            long validBlurs[3] = {4, 2, 1};
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:validBlurs[blurType]]];
            [blurEffectView setFrame:self.dockImageView.bounds];
            [blurEffectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [blurEffectView setContentMode:UIViewContentModeScaleAspectFill];
            [blurEffectView setClipsToBounds:YES];
            blurEffectView.alpha = blurIntensity;
            [self.dockImageView addSubview:blurEffectView];
        }
        if (customRadiusEnabled) [backgroundView.layer setCornerRadius:customRadius];
        else [backgroundView.layer setCornerRadius:34.5f];
        [backgroundView addSubview:self.dockImageView];
    }
}
- (UIView *)backgroundView {
    [self updateBackgroundView:%orig];
    return %orig;
}
- (void)layoutSubviews {
    %orig;
    [self updateBackgroundView:self.backgroundView];
}
- (id)initWithFrame:(CGRect)arg1 {
    [self updateBackgroundView:self.backgroundView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"updateBackgroundView" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
        [self updateBackgroundView:self.backgroundView];
    }];
    return %orig;
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
}

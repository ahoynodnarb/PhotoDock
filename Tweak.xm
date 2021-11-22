#import "PhotoDock.h"

static void refreshPrefs() {
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

%hook SBDockView
%property (nonatomic, strong) UIImageView *dockImageView;
%new
- (void)updateBackgroundView {
    if (isEnabled && dockImage) {
        [self.dockImageView removeFromSuperview];
        self.dockImageView = [[UIImageView alloc] initWithImage:dockImage];
        self.dockImageView.frame = self.backgroundView.bounds;
        [self.dockImageView setClipsToBounds:YES];
        [self.dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.dockImageView setContentMode:UIViewContentModeScaleAspectFill];
        if (blurEnabled) {
            long validBlurs[3] = {4, 2, 1};
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:validBlurs[blurType]]];
            [blurEffectView setFrame:self.dockImageView.bounds];
            [blurEffectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [blurEffectView setContentMode:UIViewContentModeScaleAspectFill];
            blurEffectView.alpha = blurIntensity;
            [self.dockImageView addSubview:blurEffectView];
        }
        if (customRadiusEnabled) {
            [self.backgroundView.layer setCornerRadius:customRadius];
            [self.dockImageView.layer setCornerRadius:customRadius];
        }
        else {
            [self.backgroundView.layer setCornerRadius:34.5f];
            [self.dockImageView.layer setCornerRadius:34.5f];
        }
        [self.backgroundView addSubview:self.dockImageView];
    }
}
- (void)layoutSubviews {
    %orig;
    [self updateBackgroundView];
}
- (id)initWithDockListView:(id)arg1 forSnapshot:(BOOL)arg2 {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBackgroundView) name:@"updateBackgroundView" object:nil];
    return %orig;
}
%end

%hook SBFloatingDockView
%property (nonatomic, strong) UIImageView *dockImageView;
%new
- (void)updateBackgroundView {
    if (isEnabled && dockImage) {
        [self.dockImageView removeFromSuperview];
        self.dockImageView = [[UIImageView alloc] initWithImage:dockImage];
        self.dockImageView.frame = self.backgroundView.bounds;
        [self.dockImageView setClipsToBounds:YES];
        [self.dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.dockImageView setContentMode:UIViewContentModeScaleAspectFill];
        if (blurEnabled) {
            long validBlurs[3] = {4, 2, 1};
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:validBlurs[blurType]]];
            [blurEffectView setFrame:self.dockImageView.bounds];
            [blurEffectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [blurEffectView setContentMode:UIViewContentModeScaleAspectFill];
            blurEffectView.alpha = blurIntensity;
            [self.dockImageView addSubview:blurEffectView];
        }
        if (customRadiusEnabled) {
            [self.backgroundView.layer setCornerRadius:customRadius];
            [self.dockImageView.layer setCornerRadius:customRadius];
        }
        else {
            [self.backgroundView.layer setCornerRadius:34.5f];
            [self.dockImageView.layer setCornerRadius:34.5f];
        }
        [self.backgroundView addSubview:self.dockImageView];
    }
}
- (void)layoutSubviews {
    %orig;
    [self updateBackgroundView];
}
- (id)initWithFrame:(CGRect)arg1 {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBackgroundView) name:@"updateBackgroundView" object:nil];
    return %orig;
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) refreshPrefs, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
}

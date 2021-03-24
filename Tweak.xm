#import "PhotoDock.h"

static void refreshPrefs() {
	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.popsicletreehouse.photodockprefs"];
	isEnabled = [bundleDefaults objectForKey:@"isEnabled"] ? [[bundleDefaults objectForKey:@"isEnabled"]boolValue] : YES;
	dockImage = [UIImage imageWithData:[bundleDefaults valueForKey:@"dockImage"]];
	blurEnabled = [bundleDefaults objectForKey:@"isBlurEnabled"] ? [[bundleDefaults objectForKey:@"isBlurEnabled"]boolValue] : NO;
	blurIntensity = [bundleDefaults objectForKey:@"blurAlpha"] ? [[bundleDefaults objectForKey:@"blurAlpha"]floatValue] : 1.0f;
	blurType = [bundleDefaults objectForKey:@"blurType"] ? [[bundleDefaults objectForKey:@"blurType"]intValue] : 0;
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    refreshPrefs();
}
static void setDockBGImage(UIView *dockView) {
	if(isEnabled && dockImage) {
		UIImageView *dockImageView = [[UIImageView alloc] initWithImage:dockImage];
		[dockImageView setFrame: dockView.backgroundView.bounds];
		[dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[dockImageView setClipsToBounds: YES];
		dockImageView._cornerRadius = dockView.backgroundView._cornerRadius;
		[dockImageView setContentMode:UIViewContentModeScaleAspectFill];
		if(blurEnabled) {
			int validBlurs[3] = {4, 2, 1};
			UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(long)validBlurs[blurType]]];
			[blurEffectView setFrame: dockImageView.bounds];
			[blurEffectView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[blurEffectView setContentMode:UIViewContentModeScaleAspectFill];
			[blurEffectView setClipsToBounds: YES];
			blurEffectView.alpha = blurIntensity;
			[dockImageView addSubview: blurEffectView];
		}
		dockView.backgroundView = dockImageView;
	}
}
%group iPhone
%hook SBDockView
-(void)layoutSubviews {
	setDockBGImage(self);
	%orig;
}
%end
%end

%group iPad
%hook SBFloatingDockPlatterView
-(void)layoutSubviews {
	setDockBGImage(self);
	%orig;
}
%end
%end

%ctor {
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		%init(iPad);
	else
		%init(iPhone);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
}
#import "PhotoDock.h"

static void refreshPrefs() {
	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.popsicletreehouse.photodockprefs"];
	isEnabled = [bundleDefaults objectForKey:@"isEnabled"] ? [[bundleDefaults objectForKey:@"isEnabled"]boolValue] : YES;
	dockImage = [UIImage imageWithData:[bundleDefaults valueForKey:@"dockImage"]];
	blurEnabled = [bundleDefaults objectForKey:@"isBlurEnabled"] ? [[bundleDefaults objectForKey:@"isBlurEnabled"]boolValue] : NO;
	blurType = [bundleDefaults objectForKey:@"blurType"] ? [[bundleDefaults objectForKey:@"blurType"]intValue] : 0;
	blurIntensity = [bundleDefaults objectForKey:@"blurAlpha"] ? [[bundleDefaults objectForKey:@"blurAlpha"]floatValue] : 1.0f;
	customRadiusEnabled = [bundleDefaults objectForKey:@"customRadiusEnabled"] ? [[bundleDefaults objectForKey:@"customRadiusEnabled"]boolValue] : NO;
	customRadius = [bundleDefaults objectForKey:@"customRadius"] ? [[bundleDefaults objectForKey:@"customRadius"]floatValue] : 35.0f;
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    refreshPrefs();
}
static void setDockBGImage() {
	if(isEnabled && dockImage) {
		[dockImageView removeFromSuperview];
		dockImageView = [[UIImageView alloc] initWithImage:dockImage];
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
		if(customRadiusEnabled) {
			dockImageView.layer.cornerRadius = customRadius;
		}
		[dockView.backgroundView addSubview: dockImageView];
	}
}

%hook SBDockView
-(void)layoutSubviews {
	dockView = self;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) setDockBGImage, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	if(![dockImageView isDescendantOfView:self]) {
		setDockBGImage();
	}
	%orig;
}
%end

%hook SBFloatingDockView
-(void)layoutSubviews {
	self.backgroundView._cornerRadius = self.maximumDockContinuousCornerRadius; 
	dockView = self;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) setDockBGImage, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	if(![dockImageView isDescendantOfView:self]) {
		setDockBGImage();
	}
	%orig;
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
}

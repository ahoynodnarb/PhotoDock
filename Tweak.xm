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

%hook SBDockView
// called right after layoutsubiews
-(void)drawRect:(CGRect)arg1 {
	%orig;
	if(isEnabled) {
		UIImageView *dockImageView = [[UIImageView alloc] initWithImage:dockImage];
		[dockImageView setFrame: self.backgroundView.bounds];
		[dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[dockImageView setClipsToBounds: YES];
		dockImageView._cornerRadius = self.backgroundView._cornerRadius;
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
		self.backgroundView = dockImageView;
	}
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
}
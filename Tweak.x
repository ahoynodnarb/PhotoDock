#import "PhotoDock.h"

static void refreshPrefs() {
	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.popsicletreehouse.photodockprefs"];
	isEnabled = [bundleDefaults objectForKey:@"isEnabled"] ? [[bundleDefaults objectForKey:@"isEnabled"]boolValue] : YES;
	dockImage = [UIImage imageWithData:[bundleDefaults valueForKey:@"dockImage"]];
	blurEnabled = [bundleDefaults objectForKey:@"isBlurEnabled"] ? [[bundleDefaults objectForKey:@"isBlurEnabled"]boolValue] : NO;
	blurIntensity = [[bundleDefaults objectForKey:@"blurAlpha"]floatValue];
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    refreshPrefs();
}

%hook SBDockView
-(void)layoutSubviews {
	%orig;
	if(isEnabled) {
		dockImageView = [[UIImageView alloc] initWithImage:dockImage];
		[dockImageView setFrame: self.backgroundView.bounds];
		[dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		if(dockImage.size.height < self.backgroundView.frame.size.height) {
			[dockImageView setContentMode:UIViewContentModeScaleAspectFill];
		}
		else {
			[dockImageView setContentMode:UIViewContentModeCenter];
		}
		if(blurEnabled) {
			UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
			[blurEffectView setFrame: dockImageView.bounds];
			[blurEffectView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[blurEffectView setContentMode:UIViewContentModeCenter];
			blurEffectView.alpha = blurIntensity;
			[dockImageView addSubview: blurEffectView];
		}
		// backgroundView changed multiple times: lays subviews.
		// we want the last one since it has the correct frame
		if(self.backgroundView.subviews.count != 0) {
			for(UIView *view in self.backgroundView.subviews) {
				[view removeFromSuperview];
			}
			NSLog(@"photodock count: %lu", (unsigned long)self.backgroundView.subviews.count);
		}
		[self.backgroundView addSubview: dockImageView];
	}
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
}
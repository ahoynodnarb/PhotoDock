#import "PhotoDock.h"

static void refreshPrefs() {
	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.popsicletreehouse.photodockprefs"];
	isEnabled = [[bundleDefaults objectForKey:@"isEnabled"]boolValue];
	dockImage = [[UIImage alloc] initWithData:[bundleDefaults valueForKey:@"dockImage"]];
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    refreshPrefs();
}

%hook SBDockView
-(void)layoutSubviews {
	%orig;
	NSLog(@"isEnabled: %d", isEnabled);
	if(dockImage && isEnabled) {
		UIImageView *dockImageView = [[UIImageView alloc] initWithImage:dockImage];
		dockImageView.frame = self.backgroundView.bounds;
		[dockImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[dockImageView setContentMode:UIViewContentModeScaleAspectFill];
		[dockImageView setClipsToBounds:YES];
		[self.backgroundView addSubview: dockImageView];
	}
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
}
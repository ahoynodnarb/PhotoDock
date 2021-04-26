#import "PhotoDock.h"
%hook SBDockView
-(void)layoutSubviews {
	// if(![dockImageView isDescendantOfView:self]) {
	// %orig;
	// if(self.backgroundView != dockImageView && isEnabled && dockImage) {
	// 	setDockBGImage(self);
	// 	// [dockImageView setFrame: self.backgroundView.bounds];
	// 	// dockImageView._cornerRadius = self.backgroundView._cornerRadius;
	// 	// self.backgroundView = dockImageView;
	// }
	%orig;
	if(self.backgroundView != dockImageView && isEnabled && dockImage) {
		setDockBGImage(self);
	}
}
%end

%hook SBFloatingDockView
-(void)layoutSubviews {
	// if(![dockImageView isDescendantOfView:self]) {
	%orig;
	if(self.backgroundView != dockImageView && isEnabled && dockImage) {
		setDockBGImage(self);
	}
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.popsicletreehouse.photodock.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
}
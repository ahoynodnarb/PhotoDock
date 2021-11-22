export PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PhotoDockPrefs

PhotoDockPrefs_FILES = PDPRootListController.m
PhotoDockPrefs_INSTALL_PATH = /Library/PreferenceBundles
PhotoDockPrefs_FRAMEWORKS = UIKit
PhotoDockPrefs_PRIVATE_FRAMEWORKS = Preferences
PhotoDockPrefs_CFLAGS = -fobjc-arc
PhotoDockPrefs_LIBRARIES = imagepicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PhotoDockPrefs.plist$(ECHO_END)

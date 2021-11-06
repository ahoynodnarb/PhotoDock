TARGET := iphone:clang:14.4

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PhotoDock

PhotoDock_FILES = Tweak.xm
PhotoDock_CFLAGS = -fobjc-arc
PhotoDock_LIBRARIES = imagepicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += photodockprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

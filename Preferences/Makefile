BUNDLE_NAME = HeartlinesPreferences
$(BUNDLE_NAME)_FILES = $(wildcard Controllers/*.m Cells/*.m)
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
$(BUNDLE_NAME)_LIBRARIES = gcuniversal

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
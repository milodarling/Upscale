ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

BUNDLE_NAME = Upscale
Upscale_FILES = Upscale.mm
Upscale_INSTALL_PATH = /Library/PreferenceBundles
Upscale_FRAMEWORKS = UIKit
Upscale_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Upscale.plist$(ECHO_END)

after-stage::
	find $(FW_STAGING_DIR) -iname '*.png' -exec pincrush-osx -i {} \;
	find $(FW_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;
	ssh iphone killall -9 MobileCydia || exit 0

after-install::
	install.exec "killall -9 Preferences || exit 0"
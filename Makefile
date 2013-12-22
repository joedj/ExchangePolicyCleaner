TARGET := iphone:clang
ARCHS := armv6 arm64
THEOS_PLATFORM_SDK_ROOT_armv6 := /Applications/Xcode4.4.1.app/Contents/Developer
SDKVERSION_armv6 := 5.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 4.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 := 7.0

ifdef CCC_ANALYZER_OUTPUT_FORMAT
  TARGET_CXX = $(CXX)
  TARGET_LD = $(TARGET_CXX)
endif

ADDITIONAL_CFLAGS += -g -fvisibility=hidden
ADDITIONAL_LDFLAGS += -Wl,-map,$@.map -g -x c /dev/null -x none

TWEAK_NAME = ExchangePolicyCleaner
ExchangePolicyCleaner_FILES = Tweak.x

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-stage::
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) \( -iname '*.plist' -or -iname '*.strings' \) -exec plutil -convert binary1 {} \;$(ECHO_END)

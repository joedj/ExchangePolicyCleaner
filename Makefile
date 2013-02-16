TARGET := iphone:clang::4.0
ARCHS := armv6 armv7

ifdef CCC_ANALYZER_OUTPUT_FORMAT
  TARGET_CXX = $(CXX)
  TARGET_LD = $(TARGET_CXX)
endif

ADDITIONAL_CFLAGS += -g -fvisibility=hidden
ADDITIONAL_LDFLAGS += -g -x c /dev/null -x none

TWEAK_NAME = ExchangePolicyCleaner
ExchangePolicyCleaner_FILES = Tweak.xm

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-stage::
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) \( -iname '*.plist' -or -iname '*.strings' \) -exec plutil -convert binary1 {} \;$(ECHO_END)

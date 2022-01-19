ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest # 14.5
INSTALL_TARGET_PROCESSES = Aurora

APPLICATION_NAME = Aurora

Aurora_FILES = $(wildcard Core/*.swift) $(wildcard Helpers/*.swift) $(wildcard Models/*.swift) $(wildcard Views/*.swift)

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/application.mk

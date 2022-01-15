ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = Cora

APPLICATION_NAME = Cora

Cora_FILES = $(wildcard Core/*.m) $(wildcard Controllers/*.m) $(wildcard Managers/*.m)
Cora_CFLAGS = -fobjc-arc
Cora_FRAMEWORKS = UIKit CoreGraphics
Cora_CODESIGN_FLAGS = -Sentitlements.plist

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/application.mk

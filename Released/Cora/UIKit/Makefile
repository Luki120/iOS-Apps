ARCHS = arm64
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Cora
APPLICATION_NAME = Cora

Cora_FILES = $(wildcard **/*.swift)
Cora_FRAMEWORKS = CoreGraphics UIKit
Cora_CODESIGN_FLAGS = -Sentitlements.plist
Cora_SWIFT_BRIDGING_HEADER = Bridging-Headers/Cora-Bridging-Header.h

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/application.mk

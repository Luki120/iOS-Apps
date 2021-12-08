ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = Cora

APPLICATION_NAME = Cora

Cora_FILES = Core/Cora.swift Managers/ColorManager.swift Managers/TaskManager.swift Views/ContentView.swift
Cora_FRAMEWORKS = CoreGraphics UIKit
Cora_CODESIGN_FLAGS = -Sentitlements.plist
Cora_SWIFT_BRIDGING_HEADER = Bridging-Headers/Cora-Bridging-Header.h

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/application.mk

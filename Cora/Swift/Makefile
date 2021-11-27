ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = Cora

APPLICATION_NAME = Cora

Cora_FILES = Core/AppDelegate.swift Controllers/SettingsVC.swift Controllers/UPTRootVC.swift Managers/ColorManager.swift Managers/GlobalManager.swift Managers/UserDefaultsManager.swift Managers/TaskManager.swift
Cora_FRAMEWORKS = UIKit CoreGraphics
Cora_CODESIGN_FLAGS = -Sentitlements.plist
Cora_SWIFT_BRIDGING_HEADER = Bridging-Headers/Cora-Bridging-Header.h

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/application.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

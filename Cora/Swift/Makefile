ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = CoraSwift

APPLICATION_NAME = CoraSwift

CoraSwift_FILES = Core/AppDelegate.swift Controllers/SettingsVC.swift Controllers/UPTRootVC.swift Managers/ColorManager.swift Managers/GlobalManager.swift Managers/UserDefaultsManager.swift Managers/TaskManager.swift
CoraSwift_FRAMEWORKS = UIKit CoreGraphics
CoraSwift_CODESIGN_FLAGS = -Sentitlements.plist
CoraSwift_SWIFT_BRIDGING_HEADER = Bridging-Headers/CoraSwift-Bridging-Header.h

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/application.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

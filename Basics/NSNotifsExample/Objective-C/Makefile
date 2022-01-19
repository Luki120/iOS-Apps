ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = NSNotifsExample

APPLICATION_NAME = NSNotifsExample

NSNotifsExample_FILES = Categories/UIColor+Random.m Core/NSAppDelegate.m Core/main.m Controllers/FirstVC.m Controllers/SecondVC.m Controllers/NSRootVC.m
NSNotifsExample_CFLAGS = -fobjc-arc
NSNotifsExample_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/application.mk

export THEOS_DEVICE_IP = 192.168.1.2
export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 6.0
export ARCHS = armv7 armv7s arm64
export TARGET := iphone:9.3:6.0
include theos/makefiles/common.mk

TOOL_NAME = captured
captured_FILES = main.mm DaemonDelegate.m
captured_FRAMEWORKS = UIKit Foundation AVFoundation
captured_LDFLAGS += -Wl,-segalign,4000, -lsqlite3
ADDITIONAL_OBJCFLAGS = -fobjc-arc
captured_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tool.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/LaunchDaemons$(ECHO_END)
	$(ECHO_NOTHING)cp com.apple.captured.plist $(THEOS_STAGING_DIR)/Library/LaunchDaemons$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)

after-install::
	install.exec "chown root:wheel /Library/LaunchDaemons/com.apple.captured.plist; chmod 644 /Library/LaunchDaemons/com.apple.captured.plist; /bin/launchctl unload -w /Library/LaunchDaemons/com.apple.captured.plist; /bin/launchctl load -w /Library/LaunchDaemons/com.apple.captured.plist;"
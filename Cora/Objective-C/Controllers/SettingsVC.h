@import UIKit;
#import "UPTRootVC.h"
#import "Managers/ColorManager.h"
#import "Managers/UserDefaultsManager.h"
#import <SafariServices/SafariServices.h>


@class UPTRootVC;

#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark

// Global

UISwitch *commandSwitch;


@interface SettingsVC : UIViewController <SFSafariViewControllerDelegate, UIColorPickerViewControllerDelegate>
@property (nonatomic, strong) UPTRootVC *rootVC;
@end

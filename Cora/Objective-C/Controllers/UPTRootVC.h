@import UIKit;
#import "SettingsVC.h"
#import "Managers/ColorManager.h"
#import "Managers/TaskManager.h"
#import "Managers/UserDefaultsManager.h"


@class SettingsVC;


@interface UPTRootVC : UIViewController
@property (nonatomic, strong) UILabel *darwinLabel;
@property (nonatomic, strong) UILabel *uptimeLabel;
@property (nonatomic, strong) SettingsVC *settingsVC;
@property (nonatomic, strong) UIButton *settingsButton;
@end

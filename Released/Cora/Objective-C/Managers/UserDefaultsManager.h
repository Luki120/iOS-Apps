@import Foundation;
#import "ColorManager.h"
#import "Controllers/SettingsVC.h"


@interface UserDefaultsManager : NSObject
+ (UserDefaultsManager *)sharedInstance;
- (void)setSwitchState;
- (void)loadSwitchState;
- (void)saveSwitchState;
- (void)loadAccentColor;
- (void)saveAccentColor;
@property (assign, nonatomic) BOOL switchState;
@end

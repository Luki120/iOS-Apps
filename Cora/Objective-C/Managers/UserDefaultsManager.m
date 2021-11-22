#import "UserDefaultsManager.h"


@implementation UserDefaultsManager


+ (UserDefaultsManager *)sharedInstance {

	static UserDefaultsManager *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{

		sharedInstance = [self new];

	});

	return sharedInstance;

}


- (void)loadSwitchState {

	self.switchState = [NSUserDefaults.standardUserDefaults boolForKey:@"switchState"];

}


- (void)setSwitchState {

	[commandSwitch setOn:[NSUserDefaults.standardUserDefaults boolForKey:@"switchState"]];

}


- (void)saveSwitchState {

	[NSUserDefaults.standardUserDefaults setBool:commandSwitch.isOn forKey:@"switchState"];

}


- (void)loadAccentColor {

	NSData *decodedData = [NSUserDefaults.standardUserDefaults objectForKey:@"accentColor"];
	[ColorManager sharedInstance].accentColor = [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:decodedData error:nil];

}


- (void)saveAccentColor {

	NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject: [ColorManager sharedInstance].accentColor requiringSecureCoding:NO error:nil];
	[NSUserDefaults.standardUserDefaults setObject:encodedData forKey:@"accentColor"];

}


@end

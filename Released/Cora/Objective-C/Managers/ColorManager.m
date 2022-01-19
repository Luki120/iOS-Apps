#import "ColorManager.h"


@implementation ColorManager


+ (ColorManager *)sharedInstance {

	static ColorManager *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });

	return sharedInstance;

}


- (void)loadInitialAccentColor {

	self.accentColor = UIColor.greenColor;

	NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject: self.accentColor requiringSecureCoding:NO error:nil];
	NSDictionary *defaultAccentColor = [NSDictionary dictionaryWithObject: encodedData forKey:@"accentColor"];
	[NSUserDefaults.standardUserDefaults registerDefaults:defaultAccentColor];

}


@end

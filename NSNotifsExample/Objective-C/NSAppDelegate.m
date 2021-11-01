#import "NSAppDelegate.h"
#import "NSRootVC.h"


@implementation NSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	_window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	_window.rootViewController = [NSRootVC new];
	[_window makeKeyAndVisible];

	return YES;

}


@end

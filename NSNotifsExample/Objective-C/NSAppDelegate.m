#import "NSAppDelegate.h"
#import "NSRootVC.h"


@implementation NSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	_window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	_rootViewController = [[UINavigationController alloc] initWithRootViewController:[[NSRootVC alloc] init]];
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];

	return YES;

}


@end

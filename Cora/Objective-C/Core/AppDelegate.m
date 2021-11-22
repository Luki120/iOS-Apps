#import "AppDelegate.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	_window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	_rootViewController = [[UINavigationController alloc] initWithRootViewController:[UPTRootVC new]];
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];

	[[ColorManager sharedInstance] loadInitialAccentColor];

	UIImage *image = [UIImage new];
	UINavigationBar.appearance.shadowImage = image;
	[UINavigationBar.appearance setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

	return YES;

}


@end

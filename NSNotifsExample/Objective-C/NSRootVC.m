#import "NSRootVC.h"


@implementation NSRootVC


- (id)init {

	self = [super init];

	if(self) {

		FirstVC *firstVC = [FirstVC new];
		SecondVC *secondVC = [SecondVC new];

		firstVC.title = @"Home";
		secondVC.title = @"Not Home";

		UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstVC];
		UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondVC];

		firstNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage systemImageNamed:@"bolt.horizontal.fill"] tag:0];
		secondNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Not Home" image:[UIImage systemImageNamed:@"bonjour"] tag:1];

		NSArray *tabBarControllers = @[firstNav, secondNav];
		self.viewControllers = tabBarControllers;

	}

	return self;

}


- (void)viewDidLoad {

	[super viewDidLoad];

	// customization

	UINavigationBar.appearance.translucent = NO;
	UINavigationBar.appearance.shadowImage = [UIImage new];
	UINavigationBar.appearance.barTintColor = UIColor.blackColor;

	self.tabBar.tintColor = UIColor.systemPurpleColor;
	self.tabBar.translucent = NO;
	self.tabBar.barTintColor = UIColor.blackColor;

	self.tabBar.clipsToBounds = YES;
	self.tabBar.layer.borderWidth = 0;

}


@end

#import "NSRootVC.h"


@implementation NSRootVC


- (id)initWithNibName:(NSString *)aNib bundle:(NSBundle *)aBundle {
	
	self = [super initWithNibName:aNib bundle:aBundle];
	
	if(self) {
		
		// Custom initialization

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

	// Do any additional setup after loading the view, typically from a nib.

	UIImage *image = [UIImage new];
	UINavigationBar.appearance.shadowImage = image;
	[UINavigationBar.appearance setBackgroundImage: image forBarMetrics: UIBarMetricsDefault];

	self.tabBar.tintColor = UIColor.systemPurpleColor;
	self.tabBar.translucent = NO;
	self.tabBar.barTintColor = UIColor.systemBackgroundColor;

	self.tabBar.clipsToBounds = YES;
	self.tabBar.layer.borderWidth = 0;

}


@end

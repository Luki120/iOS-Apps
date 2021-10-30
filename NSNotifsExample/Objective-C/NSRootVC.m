#import "NSRootVC.h"


@interface NSRootVC ()
@end


@implementation NSRootVC


- (id)init {

	self = [super init];

	if(self) {

		FirstVC *firstVC = [FirstVC new];
		SecondVC *secondVC = [SecondVC new];
		NSArray *tabBarControllers = @[firstVC, secondVC];
		self.selectedIndex = 0;
		self.viewControllers = tabBarControllers;

		firstVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage systemImageNamed:@"bolt.horizontal.fill"] tag:0];
		secondVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Not Home" image:[UIImage systemImageNamed:@"bonjour"] tag:1];

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

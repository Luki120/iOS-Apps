#import "FirstVC.h"


@implementation FirstVC {

	UIButton *magicButton;

}


- (id)initWithNibName:(NSString *)aNib bundle:(NSBundle *)aBundle {

	self = [super initWithNibName:aNib bundle:aBundle];

	if(self) [self setupUI];

	return self;

}


- (void)viewDidLoad {

	[super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.

	self.view.backgroundColor = UIColor.systemBackgroundColor;

}


- (void)viewDidLayoutSubviews {

	[super viewDidLayoutSubviews];

	[self layoutUI];

}

- (void)setupUI {

	magicButton = [UIButton new];
	magicButton.titleLabel.font = [UIFont systemFontOfSize:15];
	magicButton.translatesAutoresizingMaskIntoConstraints = NO;
	[magicButton setTitle : @"Tap me and switch tabs to see magic" forState: UIControlStateNormal];
	[magicButton addTarget : self action:@selector(didTapMagicButton) forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview:magicButton];

	UIColor *firstColor = [UIColor colorWithRed:0.74 green:0.78 blue:0.98 alpha:1.0];
	UIColor *secondColor = [UIColor colorWithRed:0.77 green:0.69 blue:0.91 alpha:1.0];
	NSArray *gradientColors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];

	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = CGRectMake(0,0,260,40);
	gradient.colors = gradientColors;
	gradient.startPoint = CGPointMake(0,0); // upper left
	gradient.endPoint = CGPointMake(1,1); // lower right
	gradient.cornerCurve = kCACornerCurveContinuous;
	gradient.cornerRadius = 20;
	[magicButton.layer insertSublayer:gradient atIndex:0];

}


- (void)layoutUI {

	NSDictionary *views = @{

		@"magicButton": magicButton,
		@"superview": self.view

	};

	NSString *formatCenterX = @"V:[magicButton]-(<=1)-[superview]";
	NSString *formatCenterY = @"H:[magicButton]-(<=1)-[superview]";
	NSString *formatWidth = @"H:[magicButton(==260)]";
	NSString *formatHeight = @"V:[magicButton(==40)]";

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatCenterX options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatCenterY options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatWidth options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatHeight options:0 metrics:nil views:views]];

}


- (void)didTapMagicButton {

	[NSNotificationCenter.defaultCenter postNotificationName:@"fireNotificationDone" object:nil];

}


@end

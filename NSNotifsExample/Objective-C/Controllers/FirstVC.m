#import "FirstVC.h"


@implementation FirstVC {

	UIButton *magicButton;

}


- (id)initWithNibName:(NSString *)aNib bundle:(NSBundle *)aBundle {

	self = [super initWithNibName:aNib bundle:aBundle];

	if(self) {

		// Custom initialization

		[self setupUI];

	}

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
	magicButton.backgroundColor = UIColor.systemIndigoColor;
	magicButton.layer.cornerCurve = kCACornerCurveContinuous;
	magicButton.layer.cornerRadius = 20;
	magicButton.translatesAutoresizingMaskIntoConstraints = NO;
	[magicButton setTitle : @"Tap me and switch tabs to see magic" forState:UIControlStateNormal];
	[magicButton addTarget : self action:@selector(notificationSender:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:magicButton];

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


- (void)notificationSender:(id)sender {

	[NSNotificationCenter.defaultCenter postNotificationName:@"fireNotificationDone" object:nil];

}


@end

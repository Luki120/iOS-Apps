#import "SecondVC.h"


@implementation SecondVC {

	NSInteger counter;
	UILabel *counterLabel;
	UILabel *hiddenLabel;

}


- (id)initWithNibName:(NSString *)aNib bundle:(NSBundle *)aBundle {

	self = [super initWithNibName:aNib bundle:aBundle];

	if(self) {

		// Custom initialization

		[self setupUI];

		/*--- create notifications observers, aka the magic :fr:
		observers are listeners, they'll be waiting and listening in this case
		for the notification called "fireNotificationDone". Once a notification with that name
		fires, the observers will tell self to call the receiveNotification function
		where our fancy code will get executed ---*/

		/*--- we remove ourselves as the observer to prevent further
		notifications from being sent after the object gets deallocated ---*/

		counter = 0;

		[NSNotificationCenter.defaultCenter removeObserver:self];
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(receiveNotification) name:@"fireNotificationDone" object:nil];

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

	[self layoutShit];

}


- (void)setupUI {

	counterLabel = [UILabel new];
	counterLabel.text = [NSString stringWithFormat:@"%ld", counter];
	counterLabel.backgroundColor = [UIColor randomColor];
	counterLabel.layer.cornerCurve = kCACornerCurveContinuous;
	counterLabel.layer.cornerRadius = 20;
	counterLabel.layer.masksToBounds = YES;
	counterLabel.textAlignment = NSTextAlignmentCenter;
	counterLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview: counterLabel];

	hiddenLabel = [UILabel new];
	hiddenLabel.text = @"The power of Notifications :fr: Learn them, embrace them, and use them to make awesome stuff";
	hiddenLabel.font = [UIFont systemFontOfSize:18];
	hiddenLabel.alpha = 0;
	hiddenLabel.textColor = UIColor.systemPurpleColor;
	hiddenLabel.textAlignment = NSTextAlignmentCenter;
	hiddenLabel.numberOfLines = 0; // infinite
	hiddenLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview: hiddenLabel];

}


- (void)layoutShit {

	/*--- even though this is just a basic example to show their usage, we still want
	to be chads and do UI layout properly, so no stinky frames and cursed math calculations ---*/

	int safeInsetsBottom = self.view.safeAreaInsets.bottom + 15;

	NSDictionary *views = @{

		@"counterLabel": counterLabel, 
		@"hiddenLabel": hiddenLabel,
		@"superview": self.view

	};

	NSString *formatCounterLabelCenterX = @"V:[counterLabel]-(<=1)-[superview]";
	NSString *formatCounterLabelCenterY = @"H:[counterLabel]-(<=1)-[superview]";
	NSString *formatCounterLabelWidth = @"H:[counterLabel(==150)]";
	NSString *formatCounterLabelHeight = @"V:[counterLabel(==40)]";

	NSString *formatLabelBottom = [NSString stringWithFormat:@"V:[hiddenLabel]-%d-|", safeInsetsBottom];
	NSString *formatLabelCenterX = @"V:[hiddenLabel]-(<=1)-[superview]";
	NSString *formatLabelLeadingTrailing = @"H:|-10-[hiddenLabel]-10-|";

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatCounterLabelCenterX options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatCounterLabelCenterY options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatCounterLabelWidth options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatCounterLabelHeight options:0 metrics:nil views:views]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatLabelBottom options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatLabelCenterX options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatLabelLeadingTrailing options:0 metrics:nil views:views]];

}


- (void)receiveNotification {

	counter++;

	counterLabel.text = [NSString stringWithFormat:@"%ld", counter];
	counterLabel.backgroundColor = [UIColor randomColor];

	/*--- start one second timers when the conditions are met to wait 
	and then start cross dissolving the labels' alpha from 0 to 1 and viceversa ---*/

	if(counter == 14)

		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeIn) userInfo:nil repeats:NO];

	else if(counter == 15)

		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeOut) userInfo:nil repeats:NO];

}


- (void)fadeIn { // we do a little playing with UIKit

	[UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		hiddenLabel.alpha = 1;

	} completion:nil];

}


- (void)fadeOut {

	[UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		hiddenLabel.alpha = 0;

	} completion:^(BOOL finished) { // we don't want the label reappearing when switching tabs

		hiddenLabel.hidden = YES;

	}];

}


@end

#import "SecondVC.h"


@implementation SecondVC {

	int counter;

}


- (void)viewDidLoad {

	[super viewDidLoad];

	counter = 0;

	self.textField = [UITextField new];
	self.textField.enabled = NO;
	self.textField.placeholder = @":peek:";
	self.textField.textAlignment = NSTextAlignmentCenter;
	self.textField.layer.cornerCurve = kCACornerCurveContinuous;
	self.textField.layer.cornerRadius = 20;
	self.textField.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.textField];

	self.hiddenLabel = [UILabel new];
	self.hiddenLabel.text = @"The power of Notifications :fr: Learn them, embrace them, and use them to make awesome stuff";
	self.hiddenLabel.font = [UIFont systemFontOfSize:18];
	self.hiddenLabel.alpha = 0;
	self.hiddenLabel.textColor = UIColor.systemPurpleColor;
	self.hiddenLabel.textAlignment = NSTextAlignmentCenter;
	self.hiddenLabel.numberOfLines = 0; // infinite
	self.hiddenLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.hiddenLabel];

	[self layoutShit];

	/*--- create notifications observers, aka the magic :fr:
	this observers are listeners, they'll be waiting and listening in this case
	for the notification called "fireNotificationDone". Once a notification with that name
	fires, the observers will tell self to call the receiveNotification function
	where our fancy code will get executed ---*/

	/*--- we remove ourselves as the observer to prevent further
	notifications from being sent after the object gets deallocated ---*/

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(receiveNotification) name:@"fireNotificationDone" object:nil];

}


- (void)layoutShit {

	/*--- even though this is just a basic example to show their usage, we still want
	to be chads and do UI layout properly, so no stinky frames and cursed math calculations ---*/

	[self.textField.centerXAnchor constraintEqualToAnchor : self.view.centerXAnchor].active = YES;
	[self.textField.centerYAnchor constraintEqualToAnchor : self.view.centerYAnchor].active = YES;
	[self.textField.widthAnchor constraintEqualToConstant : 150].active = YES;
	[self.textField.heightAnchor constraintEqualToConstant : 40].active = YES;

	[self.hiddenLabel.centerXAnchor constraintEqualToAnchor : self.view.centerXAnchor].active = YES;
	[self.hiddenLabel.bottomAnchor constraintEqualToAnchor : self.view.safeAreaLayoutGuide.bottomAnchor constant : -15].active = YES;
	[self.hiddenLabel.leadingAnchor constraintEqualToAnchor : self.view.leadingAnchor constant : 10].active = YES;
	[self.hiddenLabel.trailingAnchor constraintEqualToAnchor : self.view.trailingAnchor constant : -10].active = YES;

}


- (void)receiveNotification {

	counter++;

	// https://stackoverflow.com/questions/21130433/generate-a-random-uicolor

	CGFloat redVal = arc4random()%255;
	CGFloat greenVal = arc4random()%255;
	CGFloat blueVal = arc4random()%255;

	self.textField.text = [NSString stringWithFormat:@"%d", counter];
	self.textField.backgroundColor = [UIColor colorWithRed:redVal/255.0f green:greenVal/255.0f blue:blueVal/255.0f alpha:1.0f];

	/*--- start one second timers when the conditions are met to wait 
	and then start cross dissolving the labels' alpha from 0 to 1 and viceversa ---*/

	if(counter == 14)

		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeIn) userInfo:nil repeats:NO];

	else if(counter == 15)

		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeOut) userInfo:nil repeats:NO];

}


- (void)fadeIn { // we do a little playing with UIKit

	[UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		self.hiddenLabel.alpha = 1;

	} completion:nil];

}


- (void)fadeOut {

	[UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		self.hiddenLabel.alpha = 0;

	} completion:^(BOOL finished) { // we don't want the label reappearing when switching tabs

		self.hiddenLabel.hidden = YES;

	}];

}


@end

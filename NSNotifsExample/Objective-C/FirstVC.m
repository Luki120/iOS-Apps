#import "FirstVC.h"


@implementation FirstVC


- (void)viewDidLoad {

	[super viewDidLoad];

	self.magicButton = [UIButton new];
	self.magicButton.titleLabel.font = [UIFont systemFontOfSize:15];
	self.magicButton.backgroundColor = UIColor.systemIndigoColor;
	self.magicButton.layer.cornerCurve = kCACornerCurveContinuous;
	self.magicButton.layer.cornerRadius = 20;
	self.magicButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.magicButton setTitle : @"Tap me and switch tabs to see magic" forState:UIControlStateNormal];
	[self.magicButton addTarget : self action:@selector(notificationSender:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.magicButton];

	[self.magicButton.centerXAnchor constraintEqualToAnchor : self.view.centerXAnchor].active = YES;
	[self.magicButton.centerYAnchor constraintEqualToAnchor : self.view.centerYAnchor].active = YES;
	[self.magicButton.widthAnchor constraintEqualToConstant : 260].active = YES;
	[self.magicButton.heightAnchor constraintEqualToConstant : 40].active = YES;

}


- (void)notificationSender:(id)sender {

	[NSNotificationCenter.defaultCenter postNotificationName:@"fireNotificationDone" object:nil];

}


@end

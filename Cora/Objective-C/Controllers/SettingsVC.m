#import "SettingsVC.h"


@implementation SettingsVC {

	UILabel *darwinLabel;
	UIButton *accentButton;
	UIView *indicatorView;
	CAShapeLayer *indicatorShapeLayer;
	UIStackView *stackView;
	UIButton *sourceCodeButton;
	UILabel *copyrightLabel;
	UILayoutGuide *containerGuide;
	UILayoutGuide *buttonContainerGuide;
	UIColorPickerViewController *pickerController;

}


- (id)initWithNibName:(NSString *)aNib bundle:(NSBundle *)aBundle {

	self = [super initWithNibName:aNib bundle:aBundle];

	if(self) {

		[[UserDefaultsManager sharedInstance] loadAccentColor];

		[self setupUI];
		[self setupPicker];

	}

	return self;

}


- (void)viewDidLayoutSubviews {

	[super viewDidLayoutSubviews];

	[self layoutUI];

}


- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	[[UserDefaultsManager sharedInstance] setSwitchState];

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {

	[super traitCollectionDidChange:previousTraitCollection];

	/*--- for some reason systemBackgroundColor is gray when presenting
	the view controller, and I want black so I do it here manually with
	both dark and light mode support :skull: ---*/

	self.view.backgroundColor = kUserInterfaceStyle ? UIColor.blackColor : UIColor.whiteColor;

}


- (void)setupUI {

	/*--- a table view clearly makes more sense here, but the switch state
		wouldn't be saved when the app is killed and re-opened. I figured it out
		eventually, but that was after I made all of this :skull:
		also I was picky and wanted to use layout guides. In the Swift version
		I used a table view ---*/

	containerGuide = [UILayoutGuide new];
	[self.view addLayoutGuide:containerGuide];

	buttonContainerGuide = [UILayoutGuide new];
	[self.view addLayoutGuide:buttonContainerGuide];

	darwinLabel = [UILabel new];
	darwinLabel.font = [UIFont fontWithName:@"Courier" size:15.5];
	darwinLabel.text = @"Print Darwin Information";
	darwinLabel.textColor = [ColorManager sharedInstance].accentColor;
	darwinLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:darwinLabel];

	commandSwitch = [UISwitch new];
	commandSwitch.onTintColor = [ColorManager sharedInstance].accentColor;
	commandSwitch.translatesAutoresizingMaskIntoConstraints = NO;
	[commandSwitch addTarget : self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:commandSwitch];

	accentButton = [UIButton new];
	accentButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:15.5];
	accentButton.translatesAutoresizingMaskIntoConstraints = NO;
	[accentButton setTitle : @"Change Accent Color" forState:UIControlStateNormal];
	[accentButton setTitleColor : [ColorManager sharedInstance].accentColor forState:UIControlStateNormal];
	[accentButton addTarget : self action:@selector(presentColorPickerController) forControlEvents:UIControlEventTouchUpInside];		
	[self.view addSubview:accentButton];

	indicatorView = [UIView new];
	indicatorView.clipsToBounds = YES;
	indicatorView.layer.borderColor = UIColor.whiteColor.CGColor;
	indicatorView.layer.borderWidth = 2;
	indicatorView.layer.cornerRadius = 15;
	indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:indicatorView];

	indicatorShapeLayer = [CAShapeLayer new];
	indicatorShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,30,30)].CGPath;
	indicatorShapeLayer.fillColor = [ColorManager sharedInstance].accentColor.CGColor;
	[indicatorView.layer addSublayer:indicatorShapeLayer];

	stackView = [UIStackView new];
	stackView.axis = UILayoutConstraintAxisVertical;
	stackView.spacing = 10;
	stackView.alignment = UIStackViewAlignmentCenter;
	stackView.distribution = UIStackViewDistributionFill;
	stackView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:stackView];

	sourceCodeButton = [UIButton new];
	sourceCodeButton.alpha = 0.5;
	sourceCodeButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:15.5];
	[sourceCodeButton setTitle : @"Source Code" forState:UIControlStateNormal];
	[sourceCodeButton setTitleColor : [ColorManager sharedInstance].accentColor forState:UIControlStateNormal];
	[sourceCodeButton addTarget : self action:@selector(didTapSourceCodeButton) forControlEvents:UIControlEventTouchUpInside];		
	[stackView addArrangedSubview:sourceCodeButton];

	copyrightLabel = [UILabel new];
	copyrightLabel.font = [UIFont fontWithName:@"Courier" size:10];
	copyrightLabel.text = @"2021 © Luki120";
	copyrightLabel.alpha = 0.5;
	copyrightLabel.textColor = [ColorManager sharedInstance].accentColor;
	copyrightLabel.textAlignment = NSTextAlignmentCenter;
	[stackView addArrangedSubview:copyrightLabel];

}


- (void)setupPicker {

	pickerController = [UIColorPickerViewController new];
	pickerController.delegate = self;
	pickerController.selectedColor = [ColorManager sharedInstance].accentColor;
	pickerController.modalPresentationStyle = UIModalPresentationPopover;

}


- (void)layoutUI {

	UILayoutGuide *guide = self.view.safeAreaLayoutGuide;

	[containerGuide.topAnchor constraintEqualToAnchor : self.view.topAnchor].active = YES;
	[containerGuide.leadingAnchor constraintEqualToAnchor : guide.leadingAnchor].active = YES;
	[containerGuide.trailingAnchor constraintEqualToAnchor : guide.trailingAnchor].active = YES;
	[containerGuide.heightAnchor constraintEqualToConstant : 44].active = YES;

	[buttonContainerGuide.topAnchor constraintEqualToAnchor : containerGuide.bottomAnchor constant : 30].active = YES;
	[buttonContainerGuide.leadingAnchor constraintEqualToAnchor : guide.leadingAnchor].active = YES;
	[buttonContainerGuide.trailingAnchor constraintEqualToAnchor : guide.trailingAnchor].active = YES;
	[buttonContainerGuide.heightAnchor constraintEqualToConstant : 44].active = YES;

	[darwinLabel.centerYAnchor constraintEqualToAnchor : commandSwitch.centerYAnchor].active = YES;
	[darwinLabel.leadingAnchor constraintEqualToAnchor : containerGuide.leadingAnchor constant : 20].active = YES;

	[commandSwitch.topAnchor constraintEqualToAnchor : containerGuide.topAnchor constant : 30].active = YES;
	[commandSwitch.trailingAnchor constraintEqualToAnchor : containerGuide.trailingAnchor constant : -20].active = YES;

	[accentButton.centerYAnchor constraintEqualToAnchor : indicatorView.centerYAnchor].active = YES;
	[accentButton.leadingAnchor constraintEqualToAnchor : buttonContainerGuide.leadingAnchor constant : 20].active = YES;

	[indicatorView.centerYAnchor constraintEqualToAnchor : buttonContainerGuide.centerYAnchor].active = YES;
	[indicatorView.trailingAnchor constraintEqualToAnchor : buttonContainerGuide.trailingAnchor constant: -28].active = YES;
	[indicatorView.widthAnchor constraintEqualToConstant : 30].active = YES;
	[indicatorView.heightAnchor constraintEqualToConstant : 30].active = YES;

	[stackView.centerXAnchor constraintEqualToAnchor : self.view.centerXAnchor].active = YES;
	[stackView.topAnchor constraintEqualToAnchor : buttonContainerGuide.bottomAnchor constant : 50].active = YES;

}


- (void)switchChanged:(UISwitch *)sender {

	[[UserDefaultsManager sharedInstance] saveSwitchState];

	[NSNotificationCenter.defaultCenter postNotificationName:@"launchChosenTask" object:nil];

}


- (void)presentColorPickerController {

	[self presentViewController:pickerController animated:YES completion:nil];

}


- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)colorPicker {

	[ColorManager sharedInstance].accentColor = colorPicker.selectedColor;

	darwinLabel.textColor = [ColorManager sharedInstance].accentColor;
	commandSwitch.onTintColor = [ColorManager sharedInstance].accentColor;

	[accentButton setTitleColor : [ColorManager sharedInstance].accentColor forState:UIControlStateNormal];
	indicatorShapeLayer.fillColor = [ColorManager sharedInstance].accentColor.CGColor;

	[sourceCodeButton setTitleColor : [ColorManager sharedInstance].accentColor forState:UIControlStateNormal];
	copyrightLabel.textColor = [ColorManager sharedInstance].accentColor;

	self.rootVC.darwinLabel.textColor = [ColorManager sharedInstance].accentColor;
	self.rootVC.uptimeLabel.textColor = [ColorManager sharedInstance].accentColor;
	self.rootVC.settingsButton.tintColor = [ColorManager sharedInstance].accentColor;

	[[UserDefaultsManager sharedInstance] saveAccentColor];

}


- (void)didTapSourceCodeButton {

	NSURL *url = [NSURL URLWithString:@"https://github.com/Luki120/iOS-Apps/tree/main/Cora"];

	SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
	safariViewController.delegate = self;
	[self presentViewController:safariViewController animated:YES completion:nil];

}


@end

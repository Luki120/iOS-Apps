#import "UPTRootVC.h"


@implementation UPTRootVC


- (id)initWithNibName:(NSString *)aNib bundle:(NSBundle *)aBundle {

	self = [super initWithNibName:aNib bundle:aBundle];

	if(self) {

		[self setupDefaults];
		[self setupUI];
		[self setupObservers];

		[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateUptimeText) userInfo:nil repeats:YES];

	}

	return self;

}


- (void)setupDefaults {

	[[UserDefaultsManager sharedInstance] loadAccentColor];
	[[UserDefaultsManager sharedInstance] loadSwitchState];

	BOOL state = [UserDefaultsManager sharedInstance].switchState;

	if(state) [self setDarwinText];

}


- (void)setupObservers {

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setDarwinText) name:@"launchChosenTask" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateAccentColors) name:@"updateAccentColors" object:nil];

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

	self.darwinLabel = [UILabel new];
	self.darwinLabel.font = [UIFont fontWithName:@"Courier" size:12];
	self.darwinLabel.text = [TaskManager sharedInstance].outputString;
	self.darwinLabel.textColor = [ColorManager sharedInstance].accentColor;
	self.darwinLabel.numberOfLines = 0;
	self.darwinLabel.textAlignment = NSTextAlignmentCenter;
	self.darwinLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.darwinLabel];

	self.uptimeLabel = [UILabel new];
	self.uptimeLabel.font = [UIFont fontWithName:@"Courier" size:16];
	self.uptimeLabel.text = [self setUptimeText];
	self.uptimeLabel.textColor = [ColorManager sharedInstance].accentColor;
	self.uptimeLabel.numberOfLines = 0;
	self.uptimeLabel.textAlignment = NSTextAlignmentCenter;
	self.uptimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.uptimeLabel];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

		[self animateLabel:[TaskManager sharedInstance].outputString withCharacterDelay:0.008];

	});

	self.settingsButton = [UIButton new];
	self.settingsButton.tintColor = [ColorManager sharedInstance].accentColor;
	[self.settingsButton setImage : [UIImage systemImageNamed:@"gear"] forState: UIControlStateNormal];
	[self.settingsButton addTarget : self action:@selector(didTapSettingsButton) forControlEvents: UIControlEventTouchUpInside];

	UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithCustomView: self.settingsButton];
	self.navigationItem.rightBarButtonItem = settingsButtonItem;

	[self updateAccentColors];

}


- (void)layoutUI {

	int safeInsetBottom = self.view.safeAreaInsets.bottom;

	NSDictionary *views = @{

		@"darwinLabel": self.darwinLabel, 
		@"uptimeLabel": self.uptimeLabel,
		@"superview": self.view

	};

	NSString *formatUptimeCenterX = @"V:[superview]-(<=1)-[uptimeLabel]";
	NSString *formatUptimeCenterY = @"H:[superview]-(<=1)-[uptimeLabel]";
	NSString *formatUptimeLeadingTrailing = @"H:|-10-[uptimeLabel]-10-|";

	NSString *formatDarwinBottom = [NSString stringWithFormat:@"V:[darwinLabel]-%d-|", safeInsetBottom];
	NSString *formatDarwinCenterX = @"V:[superview]-(<=1)-[darwinLabel]";
	NSString *formatDarwinLeadingTrailing = @"H:|-10-[darwinLabel]-10-|";

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatUptimeCenterX options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatUptimeCenterY options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatUptimeLeadingTrailing options:0 metrics:nil views:views]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatDarwinBottom options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatDarwinCenterX options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatDarwinLeadingTrailing options:0 metrics:nil views:views]];

}


- (void)didTapSettingsButton {

	SettingsVC *settingsVC = [SettingsVC new];
	[self presentViewController:settingsVC animated:YES completion:nil];	

}


- (void)animateLabel:(NSString *)newText withCharacterDelay:(NSTimeInterval)delay {

	// https://stackoverflow.com/questions/11686642/letter-by-letter-animation-for-uilabel

	self.uptimeLabel.text = @"";

	for(int i = 0; i < newText.length; i++) {

		dispatch_async(dispatch_get_main_queue(), ^{

			self.uptimeLabel.text = [NSString stringWithFormat:@"%@%C", self.uptimeLabel.text, [newText characterAtIndex:i]];

		});

		[NSThread sleepForTimeInterval:delay];

	}

}


- (NSString *)setUptimeText {

	[[TaskManager sharedInstance] launchTaskWithArguments:@[@"-c", @"uptime"]];

	NSString *uptimeString = [TaskManager sharedInstance].outputString;

	return uptimeString;

}


// MARK: - NSNotificationCenter

- (void)setDarwinText {

	[[UserDefaultsManager sharedInstance] loadSwitchState];

	BOOL state = [UserDefaultsManager sharedInstance].switchState;

	if(!state) {

		self.darwinLabel.text = nil;
		return;

	}

	[[TaskManager sharedInstance] launchTaskWithArguments:@[@"-c", @"uname -a"]];

	NSString *darwinString = [TaskManager sharedInstance].outputString;

	self.darwinLabel.text = darwinString;

}


- (void)updateAccentColors {

	self.darwinLabel.textColor = [ColorManager sharedInstance].accentColor;
	self.uptimeLabel.textColor = [ColorManager sharedInstance].accentColor;
	self.settingsButton.tintColor = [ColorManager sharedInstance].accentColor;

}


// MARK: - NSTimer

- (void)updateUptimeText {

	self.uptimeLabel.text = [self setUptimeText];

}


@end

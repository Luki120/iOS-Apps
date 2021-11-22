#import "TaskManager.h"


@implementation TaskManager


+ (TaskManager *)sharedInstance {

	static TaskManager *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{

		sharedInstance = [self new];

	});

	return sharedInstance;

}


- (void)launchDarwinTask {

	[[UserDefaultsManager sharedInstance] loadSwitchState];

	if(![UserDefaultsManager sharedInstance].switchState) return;

	NSTask *task = [NSTask new];
	[task setLaunchPath:@"/bin/sh"];
	[task setArguments:@[@"-c", @"uname -a"]];

	NSPipe *outputPipe = [NSPipe pipe];
	task.standardOutput = outputPipe;
	[task launchAndReturnError:nil];

	NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
	self.darwinString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];

}


- (void)launchUptimeTask {

	[[UserDefaultsManager sharedInstance] loadSwitchState];

	NSTask *task = [NSTask new];
	[task setLaunchPath:@"/bin/sh"];
	[task setArguments:@[@"-c", @"uptime"]];

	NSPipe *outputPipe = [NSPipe pipe];
	task.standardOutput = outputPipe;
	[task launchAndReturnError:nil];

	NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
	self.uptimeString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];

}


@end

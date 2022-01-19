#import "TaskManager.h"


@implementation TaskManager


+ (TaskManager *)sharedInstance {

	static TaskManager *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });

	return sharedInstance;

}


- (void)launchTaskWithArguments:(NSArray *)arguments {

	NSTask *task = [NSTask new];
	NSPipe *outputPipe = [NSPipe pipe];

	[task setLaunchPath:@"/bin/sh"];
	[task setArguments:arguments];
	task.standardOutput = outputPipe;
	[task launchAndReturnError:nil];

	NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
	self.outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];

}


@end

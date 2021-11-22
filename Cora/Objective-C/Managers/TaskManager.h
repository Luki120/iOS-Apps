@import Foundation;
#import "UserDefaultsManager.h"


@interface TaskManager : NSObject
+ (TaskManager *)sharedInstance;
- (void)launchDarwinTask;
- (void)launchUptimeTask;
@property (copy, nonatomic) NSString *darwinString;
@property (copy, nonatomic) NSString *uptimeString;
@end


@interface NSTask : NSObject
@property (strong) id standardOutput;
@property (copy) NSString *launchPath;
@property (copy) NSArray<NSString *> *arguments;
- (BOOL)launchAndReturnError:(NSError *)error;
@end
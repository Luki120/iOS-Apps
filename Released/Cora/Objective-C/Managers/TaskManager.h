@import Foundation;
#import "UserDefaultsManager.h"


@interface TaskManager : NSObject
@property (copy, nonatomic) NSString *outputString;
+ (TaskManager *)sharedInstance;
- (void)launchTaskWithArguments:(NSArray *)arguments;
@end


@interface NSTask : NSObject
@property (strong) id standardOutput;
@property (copy) NSString *launchPath;
@property (copy) NSArray<NSString *> *arguments;
- (BOOL)launchAndReturnError:(NSError *)error;
@end

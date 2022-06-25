@import Foundation;


@interface NSTask : NSObject
@property (strong) id standardOutput;
@property (copy) NSString *launchPath;
@property (copy) NSArray<NSString *> *arguments;
- (void)launch;
@end

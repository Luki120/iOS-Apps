@import Foundation;


@interface ColorManager : NSObject
@property (nonatomic, strong) UIColor *accentColor;
+ (ColorManager *)sharedInstance;
- (void)loadInitialAccentColor;
@end

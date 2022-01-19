#import "UIColor+Random.h"


@implementation UIColor (Random)


+ (UIColor *)randomColor {

    CGFloat r = arc4random()%255;
    CGFloat g = arc4random()%255;
    CGFloat b = arc4random()%255;

    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

}


@end

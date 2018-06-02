#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@class Color;

@interface MSCColorGenerator : NSObject

@property (nonatomic, readonly) int kCountOfColorAreas;
@property (nonatomic, strong) NSArray<Color *> *rainbow;

- (void)generateColorWithMinValue:(double)minValue
                        maxValue:(double)maxValue;

- (SCNVector3)getColorForU:(double)u;
- (NSArray *)getColorForValues: (NSArray *)values;


@end

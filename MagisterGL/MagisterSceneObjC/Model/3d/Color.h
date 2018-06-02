#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface Color : NSObject

@property (nonatomic) double red;
@property (nonatomic) double green;
@property (nonatomic) double blue;
@property (nonatomic) double value;

@property (nonatomic, strong, readonly, getter=getColor) UIColor *color;
@property (nonatomic, readonly, getter=getColorVector) SCNVector3 colorVector;

- (UIColor *)getColor;
- (SCNVector3)getColorVector;


@end
